class Tags::TagService
  include Common::Helpers::ServiceIdHelper
  include Common::Helpers::PaginationHelper
  include Common::Helpers::TranslationHelper

  def create(attributes:)
    tag = Tags::Tag.new(attributes)
    return create_dto(tag) if tag.save
    tag.errors.full_messages.join(',')
  end

  def update(id:, attributes:)
    tag = Tags::Tag.find_by(id: id)
    return nil unless tag
    tag.assign_attributes(attributes)
    return create_dto(tag) if tag.save
    tag.errors.full_messages.join(',')
  end

  def filter(criteria: {}, page: 1, per_page: 50, sort_by: :id, sort_direction: 'desc')
    tags = Tags::Tag.where(nil)
    tags = tags.by_title(criteria[:title]) if criteria[:title].present?
    tags = tags.order(sort_by => sort_direction) if sort_by
    paginated_dtos(collection: tags, page: page, per_page: per_page) do |tag|
      create_dto(tag)
    end
  end

  def find_or_create(title:)
    tag = Tags::Tag.find_or_create_by(title: title)
    create_dto(tag)
  end

  def destroy(id:)
    tag = Tags::Tag.find_by(id: id)
    tag.destroy
    create_dto(tag)
  end

  private

  def create_dto(tag)
    Tags::TagDto.new(
      id: tag.id,
      title: tag.title,
      created_at: tag.created_at,
      updated_at: tag.updated_at
    )
  end
end
