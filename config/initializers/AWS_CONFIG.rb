AWS_CONFIG = {
  'access_key_id' => ENV['AWS_ACCESS_KEY_ID'],
  'secret_access_key' => ENV['AWS_SECRET_ACCESS_KEY'],
  'bucket' => ENV['S3_BUCKET_NAME'],
  'acl' => 'public-read',
  'key_start' => 'uploads/',
  'region' => 's3-ca-central-1' # For other regions than us-east-1, use s3-region. E.g.: s3-eu-west-1
}