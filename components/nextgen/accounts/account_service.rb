class Nextgen::Accounts::AccountService
  include Common::Helpers::PaginationHelper
  def initialize
  end

  def filter(criteria: {}, per_page: 1000, page: 1)
    offset = (page <= 0 ? 0 : page-1)*per_page
    params = {}
    accounts = Nextgen::Transciever.new.accounts(limit: per_page, offset: offset, params: params)
    paginated_dtos(collection: accounts, page: page, per_page: per_page) do |account|
      create_dto(account)
    end
  end

  private

  def create_dto(account)
    return unless account
    Nextgen::Accounts::AccountDto.new(
      id: account["ID"],
    	username: account["UserName"],
    	created_at: account["CreatedAt"],
    	dlr_enabled: account["DlrEnabled"],
      dictionary_id: account["DictionaryID"],
      tenancy_id: account["TenancyID"],
      product_id: account["ProductID"],
      throttle_limit: account["ThrottleLimit"],
      duplicate_timeout: account["DuplicatesTimeout"],
      duplicate_sender_id: account["DefaultSenderID"],
      status: account["Status"],
      account_name: account["AccountName"],
      category: account["Category"],
    	type: account["Type"],
      product_id: account["ProductID"],
    	crm_id: account["CrmID"],
    	account_manager_email: account["AccountManagerEmail"],
    	account_manager_name: account["AccountManagerName"],
    	country: account["Country"],
      charging_account_id: account["ChargingAccountID"],
    	legacy_account_id: account["LegacyAccountID"],
      charging_master_account_id: account["ChargingMasterAccountID"],
      activity_rating_plan: account["ActiveRatingPlan"],
      account_id: account["UUID"],
      parent_account_id: account["ParentAccountID"],
      two_factor_authentication: account["TwoFactorAuthentication"],
      has_sub_account: account["HasSubaccounts"]
    )
  end
end
