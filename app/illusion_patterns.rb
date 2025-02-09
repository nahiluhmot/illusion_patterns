require "nokogiri"

# Top-level module.
module IllusionPatterns
  # Base class for errors raised by the application.
  Error = Class.new(StandardError)

  # Raised when an error occurs parsing a pattern.
  ParseError = Class.new(Error)

  module_function

  def root
    @root ||= File.expand_path("..", __dir__)
  end

  def parse(*)
    Parser.parse(*)
  end

  def render(*)
    Renderer.render(*)
  end
end

require "illusion_patterns/parser"
require "illusion_patterns/renderer"
