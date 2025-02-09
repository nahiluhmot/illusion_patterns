RSpec.describe IllusionPatterns do
  describe ".root" do
    its(:root) do
      is_expected.to(eq(File.expand_path("..", __dir__)))
    end
  end
end
