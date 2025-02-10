module IllusionPatterns
  # Command Line Interface for the application.
  class CLI
    SUCCESS_EXIT_CODE = 0
    CLI_ERROR_EXIT_CODE = 1
    PARSE_ERROR_EXIT_CODE = 2
    UNEXPECTED_ERROR_EXIT_CODE = 3
    ALL_NUMBERS_REGEXP = /\A\d+\z/
    VALID_DIRECTIONS = Set.new([:up, :down]).freeze

    def initialize(program_name: $PROGRAM_NAME, illusion_patterns: IllusionPatterns, error: $stderr, output: $stdout)
      @program_name = program_name
      @illusion_patterns = illusion_patterns
      @error = error
      @output = output
    end

    def run(argv)
      with_exit_code_error_handling do
        filename, light_palindex, dark_palindex, direction = parse_args(argv)

        rendered = File.open(filename) do |file|
          @illusion_patterns.transform(file, light_palindex:, dark_palindex:, direction:)
        end

        @output.puts(rendered)
      end
    end

    def with_exit_code_error_handling
      yield

      SUCCESS_EXIT_CODE
    rescue CLIError => ex
      @error.puts(ex.message)
      @error.puts
      @error.puts(build_usage_message)

      CLI_ERROR_EXIT_CODE
    rescue ParseError
      @error.puts("Unable to parse file")

      PARSE_ERROR_EXIT_CODE
    rescue => ex
      @error.puts("An unexpected error occurred")
      @error.puts("#{ex.class.name}: #{ex.message}")

      UNEXPECTED_ERROR_EXIT_CODE
    end

    def parse_args(argv)
      raise CLIError, "Invoke with exactly 4 arguments" if argv.length != 4

      filename, light_palindex, dark_palindex, direction = argv

      [
        parse_filename(filename),
        parse_pal_index(light_palindex),
        parse_pal_index(dark_palindex),
        parse_direction(direction)
      ]
    end

    def parse_filename(filename)
      raise CLIError, "No such file: #{filename}" unless File.file?(filename)

      filename
    end

    def parse_pal_index(index)
      raise CLIError, "Palette indicies must be positive integers, got: #{index}" unless ALL_NUMBERS_REGEXP.match?(index)

      index.to_i
    end

    def parse_direction(direction)
      dir = direction.to_sym

      raise CLIError, "Invalid direction: #{dir}" unless VALID_DIRECTIONS.member?(dir)

      dir
    end

    def build_usage_message
      <<~EOS
        USAGE: #{@program_name} FILE LIGHT_PALINDEX DARK_PALINDEX DIRECTION

        Transforms a standard pattern stored in a .oxs FILE into an shadow knit pattern.

        LIGHT_PALINDEX and DARK_PALINDEX denote the palette colors which will be used for striping.
        These must be integers.
        LIGHT_PALINDEX should match the "background" color of the original pattern.
        DARK_PALINDEX should ideally be a color not present in the original pattern (but it should be in the palette).

        DIRECTION must be either "up" or "down", and denotes the viewing angle at which the pattern may be perceived.

        The resulting .oxs pattern will be printed to STDOUT.
        Redirect to a file to persist the output.

        Example: #{@program_name} ./pattern.oxs 1 12 up > shadow-pattern.oxs
      EOS
    end
  end
end
