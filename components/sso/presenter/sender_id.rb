class Sso::Presenter::SenderId
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      id: @dto.id,
      sender_id: @dto.sender_id,
      description: @dto.description,
      uuid: @dto.uuid,
      country: @dto.country,
      type: @dto.type,
      resource_type: @dto.resource_type,
      is_generic_sender_id: @dto.is_generic_sender_id
    }
  end
end
