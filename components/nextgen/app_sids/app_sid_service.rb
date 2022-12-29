class Nextgen::AppSids::AppSidService
  include Common::Helpers::PaginationHelper
  def initialize(account_id: nil)
    @account_id = account_id
  end

  def filter(criteria: {}, per_page: 1000, page: 1)
    return "Select account id" if @account_id.blank?
    offset = (page <= 0 ? 0 : page-1)*per_page
    params = {}
    params["Status"] = criteria[:status].upcase if criteria[:status].present?
    params["VerificationStatus"] = criteria[:verification_status].upcase if criteria[:verification_status].present?
    app_sids = Nextgen::Transciever.new.app_sid(account_id: @account_id, limit: per_page, offset: offset, params: params)
    paginated_dtos(collection: app_sids, page: page, per_page: per_page) do |app_sid|
      create_dto(app_sid)
    end
  end

  def all_approved
    filter(criteria: {status: 'active', verification_status: 'approved'})
  end

  def get_encrypted_app_sid(app_sid_value)
    return if app_sid_value.blank?
    sid = app_sid_value
    showable_length = sid.length > 10 ? 3 : ((sid.length - 5) < 0 ? 0 : (sid.length - 5)/2)
    sid.gsub(app_sid_value[showable_length..-(showable_length+1)], "************")
  end

  private

  def create_dto(app_sid)
    return unless app_sid
    Nextgen::AppSids::AppSidDto.new(
      id: app_sid['ID'],
      app_sid: app_sid['AppSid'],
      encrypted_app_sid: get_encrypted_app_sid(app_sid['AppSid']),
      name: app_sid['Name'],
      description: app_sid['Description'],
      created_at: (Time.parse(app_sid['CreatedAt']) rescue nil),
      default_sender_id: app_sid['DefaultSenderName'],
      status: app_sid['Status'],
      verification_status: app_sid['VerificationStatus'],
      default_sender_pid: app_sid['DefaultSenderID'],
      default_sender_uuid: app_sid['DefaultSenderUUID'],
      dlr_enabled: app_sid['DlrEnabled'],
      throttle_limit: app_sid['ThrottleLimit'],
      tenancy_id: app_sid['TenancyID'],
      dictionary_id: app_sid['DictionaryID'],
      product_id: app_sid['ProductID'],
      duplicates_timeout: app_sid['DuplicatesTimeout'],
      account_id: app_sid['AccountID'],
      account_uuid: app_sid['AccountUUID'],
      uuid: app_sid['UUID'],
      channel_type: app_sid['ChannelType']
    )
  end
end
