require 'aws-sdk-s3'

class Common::S3Service
  def initialize
    @s3 = Aws::S3::Resource.new(region: ENV['ledger_aws_region'], credentials: Aws::Credentials.new(ENV['ledger_aws_access_key_id'], ENV['ledger_aws_secret_access_key']))
  end

  def file_upload(file, file_path, file_name)
    bucket = @s3.bucket(ENV['ledger_aws_bucket'])
    file_obj = bucket.object(file_path)
    file_obj.upload_file(file)

    bucket.object(file_path).presigned_url(:get, expires_in: 600000, response_content_disposition: "attachment; filename=#{file_name}")
  end

  def get_file_url(file_path)
    bucket = @s3.bucket(ENV['ledger_aws_bucket'])
    bucket.object(file_path).presigned_url(:get, expires_in: 3600)
  end
end
