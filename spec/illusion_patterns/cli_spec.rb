RSpec.describe IllusionPatterns::CLI do
  subject { described_class.new(program_name:, illusion_patterns:, error:, output:) }

  let(:program_name) { "./bin/illusion_patterns" }
  let(:illusion_patterns) { double(IllusionPatterns) }
  let(:error) { StringIO.new }
  let(:output) { StringIO.new }

  describe "#run" do
    let(:argv) { [filename, light_palindex, dark_palindex, direction] }
    let(:filename) { fixture_path("piggies.oxs") }
    let(:light_palindex) { "1" }
    let(:dark_palindex) { "3" }
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

              USAGE: ./bin/illusion_patterns FILE LIGHT_PALINDEX DARK_PALINDEX DIRECTION

              Transforms a standard pattern stored in a .oxs FILE into an shadow knit pattern.

              LIGHT_PALINDEX and DARK_PALINDEX denote the palette colors which will be used for striping.
              These must be integers.
              LIGHT_PALINDEX should match the "background" color of the original pattern.
              DARK_PALINDEX should ideally be a color not present in the original pattern (but it should be in the palette).

              DIRECTION must be either "up" or "down", and denotes the viewing angle at which the pattern may be perceived.

              The resulting .oxs pattern will be printed to STDOUT.
              Redirect to a file to persist the output.

              Example: ./bin/illusion_patterns ./pattern.oxs 1 12 up > shadow-pattern.oxs
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

    context "given an invalid light palindex" do
      let(:light_palindex) { "one" }

      include_examples(:cli_error, error_message: "Palette indicies must be positive integers, got: one")
    end

    context "given an invalid dark palindex" do
      let(:dark_palindex) { "2.2" }

      include_examples(:cli_error, error_message: "Palette indicies must be positive integers, got: 2.2")
    end

    context "given an invalid direction" do
      let(:direction) { "sideways" }

      include_examples(:cli_error, error_message: "Invalid direction: sideways")
    end

    context "when there is an error parsing the file" do
      before do
        allow(illusion_patterns)
          .to(receive(:transform))
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

    context "when an unexpected error occurs" do
      before do
        allow(illusion_patterns)
          .to(receive(:transform))
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
          .to(receive(:transform))
          .with(
            instance_of(File),
            light_palindex: light_palindex.to_i,
            dark_palindex: dark_palindex.to_i,
            direction: direction.to_sym
          )
          .and_return(rendered_output)
      end

      it "returns a success exit code" do
        expect(subject.run(argv)).to(eq(0))
      end

      it "prints nothing to the error output" do
        subject.run(argv)

        expect(error.string).to(be_empty)
      end

      it "writes the rendered chart to the output" do
        subject.run(argv)

        expect(output.string).to(eq(rendered_output))
      end
    end
  end
end
