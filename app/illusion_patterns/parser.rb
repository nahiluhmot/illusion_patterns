module IllusionPatterns
  # Parses .oxs files: https://www.ursasoftware.com/OXSFormat/
  module Parser
    module_function

    PALETTE_ITEM_NUMBER_ATTRIBUTES = Set.new([:index]).freeze
    STITCH_NUMBER_ATTRIBUTES = Set.new([:palindex, :x, :y]).freeze
    PART_STITCH_NUMBER_ATTRIBUTES = Set.new([:palindex1, :palindex2, :x, :y]).freeze
    BACK_STITCH_NUMBER_ATTRIBUTES = Set.new([:palindex, :x1, :x2, :y1, :y2]).freeze

    def parse(io_or_string)
      xml = Nokogiri::XML(io_or_string)
      chart = lookup_one(xml, "//chart")

      parse_chart(chart)
    end

    def parse_chart(chart)
      {
        format: parse_format(lookup_one(chart, "//format")),
        properties: parse_properties(lookup_one(chart, "//properties")),
        palette: parse_palette(lookup_one(chart, "//palette")),
        full_stitches: parse_full_stitches(lookup_one(chart, "//fullstitches")),
        part_stitches: parse_part_stitches(lookup_one(chart, "//partstitches")),
        back_stitches: parse_back_stitches(lookup_one(chart, "//backstitches")),
        ornaments: parse_ornaments(lookup_one(chart, "//ornaments_inc_knots_and_beads")),
        comment_boxes: parse_comment_boxes(lookup_one(chart, "//commentboxes"))
      }
    end

    def parse_format(format)
      build_attributes_hash(format)
    end

    def parse_properties(properties)
      build_attributes_hash(properties)
    end

    def parse_palette(palette)
      parse_each_attributes(palette, "//palette_item", number_attributes: PALETTE_ITEM_NUMBER_ATTRIBUTES)
    end

    def parse_full_stitches(full_stitches)
      parse_each_attributes(full_stitches, "//stitch", number_attributes: STITCH_NUMBER_ATTRIBUTES)
    end

    def parse_part_stitches(part_stitches)
      parse_each_attributes(part_stitches, "//partstitch", number_attributes: PART_STITCH_NUMBER_ATTRIBUTES)
    end

    def parse_back_stitches(part_stitches)
      parse_each_attributes(part_stitches, "//backstitch", number_attributes: BACK_STITCH_NUMBER_ATTRIBUTES)
    end

    def parse_ornaments(ornaments)
      parse_each_attributes(ornaments, "//object")
    end

    def parse_comment_boxes(comment_boxes)
      parse_each_attributes(comment_boxes, "//commentbox")
    end

    def lookup_one(xml, xpath_query)
      results = xml.xpath(xpath_query)

      raise ParseError, "Expected exactly one match for xpath query: #{xpath_query}" if results.length != 1

      results.first
    end

    def parse_each_attributes(xml, xpath_query, number_attributes: nil)
      eles = xml.xpath(xpath_query)

      eles.map do |ele|
        build_attributes_hash(ele, number_attributes:)
      end
    end

    def build_attributes_hash(xml, number_attributes: nil)
      attrs = xml.attributes

      attrs.to_h do |name, attr|
        key = name.to_sym
        value = attr.value

        value = value.to_i if number_attributes&.member?(key)

        [key, value]
      end
    end
  end
end
