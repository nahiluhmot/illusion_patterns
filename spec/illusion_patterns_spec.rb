RSpec.describe IllusionPatterns do
  describe ".transform" do
    let(:input) { open_fixture("piggies.oxs") }
    let(:light_palindex) { 0 }
    let(:dark_palindex) { 1 }
    let(:direction) { :down }

    after { input.close }

    it "transforms the input" do
      expect(subject.transform(input, light_palindex:, dark_palindex:, direction:))
        .to(match(/<chart>/))
    end
  end

  describe ".run_cli" do
    let(:argv) { [] }
    let(:output) { StringIO.new }
    let(:error) { StringIO.new }

    it "runs the CLI" do
      subject.run_cli(argv, output:, error:)

      expect(output.string).to(be_empty)
      expect(error.string).to(start_with("Invoke with exactly 4 arguments"))
    end
  end
end
