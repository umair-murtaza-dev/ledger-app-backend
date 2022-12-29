class Nextgen::SenderIds::SenderIdService
  include Common::Helpers::PaginationHelper
  def initialize(account_id:)
    @account_id = account_id
  end

  def filter(criteria: {}, per_page: 1000, page: 1)
    offset = (page <= 0 ? 0 : page-1)*per_page
    params = {}
    params["Status"] = criteria[:status].upcase if criteria[:status].present?
    params["VerificationStatus"] = criteria[:verification_status].upcase if criteria[:verification_status].present?
    sender_ids = Nextgen::Transciever.new.get_all_sender_ids(account_id: @account_id, limit: per_page, offset: offset, params: params)
    paginated_dtos(collection: sender_ids, page: page, per_page: per_page) do |sender_id|
      create_dto(sender_id)
    end
  end

  def all_approved
    filter(criteria: {status: 'active', verification_status: 'approved'})
  end

  private

  def create_dto(sender_id)
    return unless sender_id
    Nextgen::SenderIds::SenderIdDto.new(
      id: sender_id['ID'],
      account_id: sender_id['AccountID'],
      account_uuid: sender_id['AccountUUID'],
      sender_id: sender_id['SenderName'],
      created_at: (Time.parse(sender_id['CreatedAt']) rescue nil),
      description: sender_id['Description'],
      status: sender_id['Status'],
      verification_status: sender_id['VerificationStatus'],
      is_default: sender_id['IsDefault'],
      last_use: sender_id['LastUse'],
      uuid: sender_id['UUID'],
      account_name: sender_id['AccountName'],
      country: sender_id['Country'],
      reject_reason: sender_id['RejectReason'],
      type: sender_id['Type'],
      resource_type: sender_id['ResourceType'],
      owner: sender_id['Owner'],
      owner_uuid: sender_id['OwnerUUID'],
      shared_by: sender_id['SharedBy'],
      shared_by_uuid: sender_id['SharedByUUID'],
      shared_with: sender_id['SharedWith'],
      shared_with_uuid: sender_id['SharedWithUUID'],
      confirmation_document: sender_id['ConfirmationDocument'],
      legacy_id: sender_id['LegacyID'],
      is_generic_sender_id: false
    )
  end
end
