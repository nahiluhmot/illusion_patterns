module IllusionPatterns
  # Parses .oxs files: https://www.ursasoftware.com/OXSFormat/
  module Parser
    module_function

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
      parse_each_attributes(palette, "//palette_item")
    end

    def parse_full_stitches(full_stitches)
      parse_each_attributes(full_stitches, "//stitch")
    end

    def parse_part_stitches(part_stitches)
      parse_each_attributes(part_stitches, "//partstitch")
    end

    def parse_back_stitches(part_stitches)
      parse_each_attributes(part_stitches, "//backstitch")
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

    def parse_each_attributes(xml, xpath_query)
      xml.xpath(xpath_query).map(&method(:build_attributes_hash))
    end

    def build_attributes_hash(xml)
      xml.attributes.transform_keys(&:to_sym).transform_values(&:value)
    end
  end
end
