RSpec.describe "integration" do
  let(:executable) { File.join(IllusionPatterns.root, "bin", "illusion_patterns") }
  let(:filename) { fixture_path("piggies.oxs") }

  it "generates a new .oxs pattern" do
    stdout, stderr, exit_code = Open3.capture3("#{executable} #{filename} 0 2 up")

    expect(stdout).to(match(/<chart>/))
    expect(stderr).to(be_empty)
    expect(exit_code).to(be_success)
  end
end
