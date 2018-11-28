require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

# CarrierWave.configure do |config|
#   config.storage = :fog
#   config.fog_credentials = {
#     provider: 'AWS',
#     aws_access_key_id: ENV['ACCESS_KEY_ID'],
#     aws_secret_access_key: ENV['SECRET_ACCESS_KEY'],
#     region: 'us-east-1'
#   }

#     case Rails.env
#     when 'development'
#         config.fog_directory  = 'otask'
#         config.asset_host = 'https://s3.amazonaws.com/otask'
#     when 'production'
#         config.fog_directory  = 'otask'
#         config.asset_host = 'https://s3.amazonaws.com/otask'
#     end
# end
CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws' # 追加
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY'],
    aws_secret_access_key: ENV['AWS_SECRET_KEY'],
    region: 'us-east-2'#リージョンをUS以外にしたかたはそのリージョンに変更
  }

    case Rails.env
    when 'development'
        config.fog_directory  = 'otask'
        config.asset_host = 'https://s3-us-east-2.amazonaws.com/otask'
    when 'production'
        config.fog_directory  = 'otask'
        config.asset_host = 'https://s3-us-east-2.amazonaws.com/otask'
    end
end