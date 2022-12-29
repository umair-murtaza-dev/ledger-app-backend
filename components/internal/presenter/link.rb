class Internal::Presenter::Link
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
        trace_id: @dto.trace_id
      }
    end
end
  