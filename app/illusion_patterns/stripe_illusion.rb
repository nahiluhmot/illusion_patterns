module IllusionPatterns
  # Adds a stripe illusion to a chart.
  # http://www.illusionknitting.woollythoughts.com/mapleleaf2.html
  module StripeIllusion
    module_function

    def transform(chart:, light_palindex:, dark_palindex:, direction:)
      full_stitches = transform_full_stitches(
        full_stitches: chart[:full_stitches],
        light_palindex:,
        dark_palindex:,
        direction:
      )

      chart.merge(full_stitches:)
    end

    def transform_full_stitches(full_stitches:, light_palindex:, dark_palindex:, direction:)
      full_stitches_by_coordinates = full_stitches
        .group_by { |stitch| stitch[:x] }
        .transform_values { |row| index_by(row) { |stitch| stitch[:y] } }

      full_stitches.map do |stitch|
        x, y = stitch.values_at(:x, :y)

        next stitch if use_orignial_pattern?(x:, y:, direction:)

        reference_coordinates = find_reference_coordinates(x:, y:, direction:)
        next_row_color = full_stitches_by_coordinates.dig(*reference_coordinates, :palindex)

        palindex =
          if next_row_color.nil? || (next_row_color == light_palindex)
            dark_palindex
          else
            light_palindex
          end

        {x:, y:, palindex:}
      end
    end

    def use_orignial_pattern?(x:, y:, direction:)
      case direction
      when :up
        y.odd?
      when :down
        y.even?
      when :left
        x.odd?
      when :right
        x.even?
      end
    end

    def find_reference_coordinates(x:, y:, direction:)
      case direction
      when :up
        [x, y + 1]
      when :down
        [x, y - 1]
      when :left
        [x + 1, y]
      when :right
        [x - 1, y]
      end
    end

    def index_by(ary)
      ary.each_with_object({}) do |ele, hash|
        key = yield ele

        hash[key] = ele
      end
    end
  end
end
