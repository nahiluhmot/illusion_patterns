module IllusionPatterns
  # Helpers for interacting with spec fixtures.
  module FixtureHelpers
    module_function

    def repository_root
      File.expand_path("../../..", __dir__)
    end

    def fixture_path(filename)
      relative_path = File.join("spec", "fixtures", filename)

      File.expand_path(relative_path, repository_root)
    end

    def open_fixture(filename, &block)
      path = fixture_path(filename)

      File.open(path, &block)
    end
  end
end
