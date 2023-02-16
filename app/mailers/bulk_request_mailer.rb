class BulkRequestMailer < ApplicationMailer
  default from: 'admin@unifonic.com'

  # BulkRequestMailer.send_csv
  def send_csv(bulk_request_id)
    @bulk_request = BulkRequests::BulkRequest.find(bulk_request_id)
    mail(to: @bulk_request.email, subject: 'CSV of Tiny URLs')
  end
end
