module IllusionPatterns
  # Renders Charts back into .oxs files.
  module Renderer
    module_function

    def render(chart)
      builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
        xml.root do
          xml.chart do
            xml.format(chart[:format])
            xml.properties(chart[:properties])

            xml.palette do
              chart[:palette].each do |palette_item|
                xml.palette_item(palette_item)
              end
            end

            xml.fullstitches do
              chart[:full_stitches].each do |stitch|
                xml.stitch(stitch)
              end
            end

            xml.partstitches do
              chart[:part_stitches].each do |stitch|
                xml.partstitch(stitch)
              end
            end

            xml.backstitches do
              chart[:back_stitches].each do |stitch|
                xml.backstitch(stitch)
              end
            end

            xml.ornaments_inc_knots_and_beads do
              chart[:ornaments].each do |object|
                xml.object(object)
              end
            end

            xml.commentboxes do
              chart[:comment_boxes].each do |comment_box|
                xml.commentbox(comment_box)
              end
            end
          end
        end
      end

      builder.to_xml
    end
  end
end
