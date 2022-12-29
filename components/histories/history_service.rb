class Histories::HistoryService
  include Common::Helpers::ServiceIdHelper
  include Common::Helpers::PaginationHelper
  include Common::Helpers::TranslationHelper


  def create(attributes:)
    history = Histories::History.new(attributes)
    return create_dto(history) if history.save
    history.errors.full_messages.join(', ')
  end

  def filter(criteria: {}, page: 1, per_page: 50, sort_by: :id, sort_direction: 'desc')
    histories = Histories::History.where(nil)
    histories = histories.by_id(criteria[:id]) if criteria[:title].present?

    histories = histories.order(sort_by => sort_direction) if sort_by
    paginated_dtos(collection: histories, page: page, per_page: per_page) do |history|
      create_dto(history)
    end
  end

  def update(id:, attributes:)
    history = Histories::History.find_by(id: id)
    return nil unless history
    history.assign_attributes(attributes)
    return create_dto(history) if history.save
    history.errors.full_messages.join(',')
  end

  private

  def create_dto(history)
    Histories::HistoryDto.new(
      id: history.id,
      url_mapping_id: history.url_mapping_id,
      location: history.country,
      user_agent: history.user_agent,
      created_at: history.created_at
    )
  end
end
