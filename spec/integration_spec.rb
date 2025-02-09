RSpec.describe "Integration" do
  let(:executable) { File.join(repository_root, "bin", "illusion_patterns") }

  context "when invoked with an invalid filename" do
    let(:filename) { "madeup.oxs" }

    it "returns an error" do
      stdout, stderr, status = Open3.capture3("#{executable} #{filename} 0 2 up")

      expect(stdout).to(be_empty)
      expect(stderr).to(match(/No such file/))
      expect(status).to_not(be_success)
    end
  end

  context "when invoked with valid arguments" do
    let(:filename) { fixture_path("piggies.oxs") }

    it "generates a new .oxs pattern" do
      stdout, stderr, status = Open3.capture3("#{executable} #{filename} 0 2 up")

      expect(stdout).to(match(/<chart>/))
      expect(stderr).to(be_empty)
      expect(status).to(be_success)
    end
  end
end
