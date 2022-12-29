class Sso::Presenter::AppSid
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      id: @dto.id,
      description: @dto.description,
      encrypted_app_sid: @dto.encrypted_app_sid,
      display_name: get_display_name,
      uuid: @dto.uuid,
      name: @dto.name,
      default_sender_id: @dto.default_sender_id
    }
  end

  def get_display_name
    if @dto.name.present?
      "#{@dto.name} (#{@dto.encrypted_app_sid})"
    else
      @dto.encrypted_app_sid
    end
  end
end
