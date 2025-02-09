RSpec.describe IllusionPatterns::Parser do
  describe ".parse" do
    subject { described_class }

    context "given malformed XML" do
      let(:malformed_xml) { "not even close to xml" }

      it "raises an error" do
        expect { subject.parse(malformed_xml) }
          .to(raise_error(IllusionPatterns::ParseError))
      end
    end

    context "given well-formed, blank XML" do
      let(:blank_xml) do
        <<~XML
          <?xml version="1.0" encoding="UTF-8"?>
          <chart/>
        XML
      end

      it "raises an error" do
        expect { subject.parse(blank_xml) }
          .to(raise_error(IllusionPatterns::ParseError))
      end
    end

    context "given a well-formed .oxs file" do
      let(:data) do
        File.read(
          File.expand_path(
            "spec/fixtures/piggies.oxs",
            IllusionPatterns.root
          )
        )
      end

      let(:chart) { subject.parse(data) }

      it "parses the chart" do
        expect(chart).to(be_a(Hash))
      end

      it "parses the format" do
        expect(chart.dig(:format, :comments09)).to(eq("Colors are expressed in hex RGB format."))
      end

      it "parses the properties" do
        expect(chart.dig(:properties, :copyright)).to(eq("by Ursa Software"))
      end

      it "parses the palette" do
        expect(chart.dig(:palette, 3)).to(
          eq(
            blendcolor: "nil",
            bscolor: "000000",
            bsstrands: "2",
            color: "000000",
            comments: "",
            dashpattern: "",
            index: "3",
            misc1: "",
            name: "Black",
            number: "DMC    310",
            printcolor: "000000",
            strands: "2",
            symbol: "100"
          )
        )
      end

      it "parses the full stitches" do
        expect(chart.dig(:full_stitches, 42)).to(
          eq(
            palindex: "5",
            x: "8",
            y: "45"
          )
        )
      end

      it "parses the part stitches" do
        expect(chart.dig(:back_stitches, 2)).to(
          eq(
            objecttype: "backstitch",
            palindex: "3",
            sequence: "0",
            x1: "3",
            x2: "3",
            y1: "40",
            y2: "41"
          )
        )
      end

      it "parses the ornaments" do
        expect(chart.dig(:ornaments, 7)).to(
          eq(
            objecttype: "bead3mm",
            palindex: "6",
            x1: "29.4375",
            y1: "27.8125"
          )
        )
      end

      it "parses the comment boxes" do
        expect(chart.dig(:comment_boxes, 0)).to(
          eq(
            boxheight: "2",
            boxleft: "18",
            boxtop: "3",
            boxwidth: "34",
            boxwords: "This is a comment"
          )
        )
      end
    end
  end
end
