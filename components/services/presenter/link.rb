class Services::Presenter::Link
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      id: @dto.uuid,
      title: @dto.title,
      long_url: @dto.redirect_link,
      tiny_url: "#{@dto.host_url}#{@dto.redirect_key}",
      clicks: @dto.clicks,
      click_time: @dto.click_time,
      locations: @dto.locations,
      tags: @dto.tags,
      variable: @dto.redirect_key,
      external_ref_id: @dto.external_ref_id,
      trace_id: @dto.trace_id
    }
  end
end
