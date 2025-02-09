module IllusionPatterns
  # Adds a stripe illusion to a chart.
  # http://www.illusionknitting.woollythoughts.com/mapleleaf2.html
  module StripeIllusion
    module_function

    def transform(chart:, light_palindex:, dark_palindex:)
      full_stitches = transform_full_stitches(
        full_stitches: chart[:full_stitches],
        light_palindex:,
        dark_palindex:
      )

      chart.merge(full_stitches:)
    end

    def transform_full_stitches(full_stitches:, light_palindex:, dark_palindex:)
      full_stitches_by_coordinates = full_stitches
        .group_by { |stitch| stitch[:x] }
        .transform_values { |row| index_by(row) { |stitch| stitch[:y] } }

      full_stitches.map do |stitch|
        x, y = stitch.values_at(:x, :y)

        next stitch if y.odd?

        next_row_color = full_stitches_by_coordinates.dig(x, y + 1, :palindex)

        palindex =
          if next_row_color.nil? || (next_row_color == light_palindex)
            dark_palindex
          else
            light_palindex
          end

        {x:, y:, palindex:}
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
