class Sso::Api::V1::NextgenController < Sso::Api::V1::ApplicationController
  def sender_ids
    return forbidden unless can?('CC', 'SENDER_NAME', ['SEE_OWN', 'SEE_ALL'])
    sender_ids = get_sender_sids(true)
    render json: page_meta(sender_ids).merge({ data: sender_ids.map{|sender_id| Sso::Presenter::SenderId.new(dto: sender_id).present }})
  end

  def app_sids
    return forbidden unless can?('CC', 'APPS_ID', ['SEE_OWN', 'SEE_ALL'])
    app_sids = Nextgen::AppSids::AppSidService.new(account_id: current_account.id).all_approved
    render json: page_meta(app_sids).merge({ data: app_sids.map{|app_sid| Sso::Presenter::AppSid.new(dto: app_sid).present }})
  end

  def accounts
    accounts = Nextgen::Accounts::AccountService.new.filter(criteria: {}, per_page: params[:per_page] ? params[:per_page].to_i : 1000, page: params[:page] ? params[:page].to_i : 1)
    render json: page_meta(accounts).merge({ data: accounts.map{|account| Sso::Presenter::Account.new(dto: account).present }})
  end
end
