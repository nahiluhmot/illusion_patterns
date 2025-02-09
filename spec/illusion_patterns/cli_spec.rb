RSpec.describe IllusionPatterns::CLI do
  subject { described_class.new(program_name:, illusion_patterns:, error:, output:) }
  let(:program_name) { "./bin/illusion_patterns" }
  let(:illusion_patterns) { double(IllusionPatterns) }
  let(:error) { StringIO.new }
  let(:output) { StringIO.new }

  describe "#run" do
    let(:argv) { [filename, pal_index_1, pal_index_2, direction] }
    let(:filename) { fixture_path("piggies.oxs") }
    let(:pal_index_1) { "1" }
    let(:pal_index_2) { "3" }
    let(:direction) { "down" }

    shared_examples_for :cli_error do |error_message:|
      it "returns a failure exit code" do
        expect(subject.run(argv)).to(eq(1))
      end

      it "prints the error and usage to the error output" do
        subject.run(argv)

        expect(error.string).to(
          eq(
            <<~EOS
              #{error_message}

              USAGE: ./bin/illusion_patterns FILE PALINDEX1 PALINDEX2 DIRECTION

              Transforms a standard pattern stored in a .oxs FILE into an shadow knit pattern.
              PALINDEX1 and PALINDEX2 denote the palette colors which will be used for striping; these
              must be integers.
              DIRECTION must be one of "left", "right", "up", and "down", and denotes the viewing angle
              at which the pattern may be perceived.
              The resulting .oxs pattern will be printed to STDOUT.
              Redirect to a file to persist the output.

              Example: ./bin/illusion_patterns ./pattern.oxs 1 12 left > shadow-pattern.oxs
            EOS
          )
        )
      end

      it "does not write anything to the standard output" do
        subject.run(argv)

        expect(output.string).to(be_empty)
      end
    end

    context "given the wrong number of args" do
      let(:argv) { [filename] }

      include_examples(:cli_error, error_message: "Invoke with exactly 4 arguments")
    end

    context "given an invalid filename" do
      let(:filename) { "nonsense.txt" }

      include_examples(:cli_error, error_message: "No such file: nonsense.txt")
    end

    context "given an invalid palindex1" do
      let(:pal_index_1) { "one" }

      include_examples(:cli_error, error_message: "Palette indicies must be integers, got: one")
    end

    context "given an invalid palindex2" do
      let(:pal_index_1) { "2.2" }

      include_examples(:cli_error, error_message: "Palette indicies must be integers, got: 2.2")
    end

    context "given an invalid direction" do
      let(:direction) { "sideways" }

      include_examples(:cli_error, error_message: "Invalid direction: sideways")
    end

    context "when there is an error parsing the file" do
      before do
        allow(illusion_patterns)
          .to(receive(:parse))
          .with(instance_of(File))
          .and_raise(IllusionPatterns::ParseError, "Expected a top-level <chart> tag")
      end

      it "returns a failure exit code" do
        expect(subject.run(argv)).to(eq(2))
      end

      it "prints the error and usage to the error output" do
        subject.run(argv)

        expect(error.string.chomp).to(eq("Unable to parse file"))
      end

      it "does not write anything to the standard output" do
        subject.run(argv)

        expect(output.string).to(be_empty)
      end
    end

    context "when the file can be successfully parsed" do
      let(:chart) { double(:chart) }

      before do
        allow(illusion_patterns)
          .to(receive(:parse))
          .with(instance_of(File))
          .and_return(chart)
      end

      context "when an unexpected error occurs" do
        before do
          allow(illusion_patterns)
            .to(receive(:render))
            .with(chart)
            .and_raise(RuntimeError, "Something really bad happened")
        end

        it "returns a failure exit code" do
          expect(subject.run(argv)).to(eq(3))
        end

        it "prints the error and usage to the error output" do
          subject.run(argv)

          expect(error.string).to(
            eq(
              <<~EOS
                An unexpected error occurred
                RuntimeError: Something really bad happened
              EOS
            )
          )
        end

        it "does not write anything to the standard output" do
          subject.run(argv)

          expect(output.string).to(be_empty)
        end
      end

      context "when the file can be rendered successfully" do
        let(:rendered_output) do
          <<~XML
            <?xml version="1.0"?>
            <chart />
          XML
        end

        before do
          allow(illusion_patterns)
            .to(receive(:render))
            .with(chart)
            .and_return(rendered_output)
        end
        it "returns a success exit code" do
          expect(subject.run(argv)).to(eq(0))
        end

        it "prints nothing to the error output" do
          subject.run(argv)

          expect(error.string).to(be_empty)
        end

        it "does not write anything to the standard output" do
          subject.run(argv)

          expect(output.string).to(eq(rendered_output))
        end
      end
    end
  end
end
