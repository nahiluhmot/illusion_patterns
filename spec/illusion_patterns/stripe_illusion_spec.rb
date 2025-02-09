RSpec.describe IllusionPatterns::StripeIllusion do
  describe ".transform" do
    subject { described_class }

    let(:chart) do
      {
        full_stitches: [
          {x: 0, y: 0, palindex: 0},
          {x: 1, y: 0, palindex: 0},
          {x: 2, y: 0, palindex: 0},
          {x: 3, y: 0, palindex: 0},
          {x: 4, y: 0, palindex: 0},

          {x: 0, y: 1, palindex: 0},
          {x: 1, y: 1, palindex: 2},
          {x: 2, y: 1, palindex: 2},
          {x: 3, y: 1, palindex: 2},
          {x: 4, y: 1, palindex: 0},

          {x: 0, y: 2, palindex: 0},
          {x: 1, y: 2, palindex: 2},
          {x: 2, y: 2, palindex: 0},
          {x: 3, y: 2, palindex: 2},
          {x: 4, y: 2, palindex: 0},

          {x: 0, y: 3, palindex: 0},
          {x: 1, y: 3, palindex: 2},
          {x: 2, y: 3, palindex: 2},
          {x: 3, y: 3, palindex: 2},
          {x: 4, y: 3, palindex: 0},

          {x: 0, y: 4, palindex: 0},
          {x: 1, y: 4, palindex: 0},
          {x: 2, y: 4, palindex: 0},
          {x: 3, y: 4, palindex: 0},
          {x: 4, y: 4, palindex: 0}
        ]
      }
    end
    let(:light_palindex) { 0 }
    let(:dark_palindex) { 1 }

    it "transforms the chart" do
      transformed_chart = subject.transform(chart:, light_palindex:, dark_palindex:)

      expect(transformed_chart[:full_stitches]).to(
        eq(
          [
            {x: 0, y: 0, palindex: 1},
            {x: 1, y: 0, palindex: 0},
            {x: 2, y: 0, palindex: 0},
            {x: 3, y: 0, palindex: 0},
            {x: 4, y: 0, palindex: 1},

            {x: 0, y: 1, palindex: 0},
            {x: 1, y: 1, palindex: 2},
            {x: 2, y: 1, palindex: 2},
            {x: 3, y: 1, palindex: 2},
            {x: 4, y: 1, palindex: 0},

            {x: 0, y: 2, palindex: 1},
            {x: 1, y: 2, palindex: 0},
            {x: 2, y: 2, palindex: 0},
            {x: 3, y: 2, palindex: 0},
            {x: 4, y: 2, palindex: 1},

            {x: 0, y: 3, palindex: 0},
            {x: 1, y: 3, palindex: 2},
            {x: 2, y: 3, palindex: 2},
            {x: 3, y: 3, palindex: 2},
            {x: 4, y: 3, palindex: 0},

            {x: 0, y: 4, palindex: 1},
            {x: 1, y: 4, palindex: 1},
            {x: 2, y: 4, palindex: 1},
            {x: 3, y: 4, palindex: 1},
            {x: 4, y: 4, palindex: 1}
          ]
        )
      )
    end
  end
end
