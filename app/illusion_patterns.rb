require "nokogiri"

# Top-level module.
module IllusionPatterns
  # Base class for errors raised by the application.
  Error = Class.new(StandardError)

  # Raised when an error occurs parsing a pattern.
  ParseError = Class.new(Error)

  # Raised when an error occurs in the command-line interface.
  CLIError = Class.new(Error)

  module_function

  def transform(input, light_palindex:, dark_palindex:, direction:)
    chart = Parser.parse(input)
    transformed_chart = StripeIllusion.transform(chart:, light_palindex:, dark_palindex:, direction:)

    Renderer.render(transformed_chart)
  end

  def run_cli(argv, **opts)
    CLI.new(**opts).run(argv)
  end
end

require "illusion_patterns/cli"
require "illusion_patterns/parser"
require "illusion_patterns/renderer"
require "illusion_patterns/stripe_illusion"
