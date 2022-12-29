class Sso::Presenter::Account
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      id: @dto.id,
    	username: @dto.username,
    	created_at: @dto.created_at,
    	dlr_enabled: @dto.dlr_enabled,
      dictionary_id: @dto.dictionary_id,
      tenancy_id: @dto.tenancy_id,
      product_id: @dto.product_id,
      throttle_limit: @dto.throttle_limit,
      duplicate_timeout: @dto.duplicate_timeout,
      duplicate_sender_id: @dto.duplicate_sender_id,
      status: @dto.status,
      account_name: @dto.account_name,
      category: @dto.category,
    	type: @dto.type,
      product_id: @dto.product_id,
    	crm_id: @dto.crm_id,
    	account_manager_email: @dto.account_manager_email,
    	account_manager_name: @dto.account_manager_name,
    	country: @dto.country,
      charging_account_id: @dto.charging_account_id,
    	legacy_account_id: @dto.legacy_account_id,
      charging_master_account_id: @dto.charging_master_account_id,
      activity_rating_plan: @dto.activity_rating_plan,
      account_id: @dto.account_id,
      parent_account_id: @dto.parent_account_id,
      two_factor_authentication: @dto.two_factor_authentication,
      has_sub_account: @dto.has_sub_account
    }
  end
end
