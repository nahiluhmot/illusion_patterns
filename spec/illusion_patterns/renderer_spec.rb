RSpec.describe IllusionPatterns::Renderer do
  describe ".render" do
    let(:chart) { open_fixture("piggies.oxs", &IllusionPatterns::Parser.method(:parse)) }
    let(:rendered_chart) { Nokogiri::XML(described_class.render(chart)) }

    it "encodes as UTF-8" do
      expect(rendered_chart.encoding).to(eq("UTF-8"))
    end

    it "renders the chart" do
      expect(rendered_chart.xpath("//chart").length)
        .to(eq(1))
    end

    it "renders the format" do
      expect(rendered_chart.xpath("//chart/format/@comments13").map(&:value))
        .to(eq(["element and attribute names are always lowercase"]))
    end

    it "renders the properties" do
      expect(rendered_chart.xpath("//chart/properties/@copyright").map(&:value))
        .to(eq(["by Ursa Software"]))
    end

    it "renders the palette" do
      expect(rendered_chart.xpath("//chart/palette/palette_item/@number").last.value)
        .to(eq("DMC    367"))
    end

    it "renders the full stitches" do
      expect(rendered_chart.xpath("//chart/fullstitches/stitch/@y")[20].value)
        .to(eq("46"))
    end

    it "renders the part stitches" do
      expect(rendered_chart.xpath("//chart/partstitches/partstitch/@direction")[10].value)
        .to(eq("2"))
    end

    it "renders the back stitches" do
      expect(rendered_chart.xpath("//chart/backstitches/backstitch/@objecttype")[10].value)
        .to(eq("backstitch"))
    end

    it "renders the ornaments" do
      expect(rendered_chart.xpath("//chart/ornaments_inc_knots_and_beads/object/@objecttype")[6].value)
        .to(eq("bead3mm"))
    end

    it "renders the comment boxes" do
      expect(rendered_chart.xpath("//chart/ornaments_inc_knots_and_beads/object/@objecttype")[6].value)
        .to(eq("bead3mm"))
    end

    it "renders the comment boxes" do
      expect(rendered_chart.xpath("//chart/commentboxes/commentbox/@boxwords")[0].value)
        .to(eq("This is a comment"))
    end
  end
end
