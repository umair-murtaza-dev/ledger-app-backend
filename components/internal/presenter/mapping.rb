class Internal::Presenter::Mapping
  include Common::Helpers::TranslationHelper
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      campaign_id: "CAMPAIGN1",
      long_url: "",
      reference_id: "ref1",
      tags: ["tag1", "tag2"],
      short_url: "",
      id: "123",
      clicks: 1,
      location: "USA",
    }
  end
end
