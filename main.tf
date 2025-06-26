resource "random_id" "bucket_id" {
  byte_length = 4
}
resource "aws_s3_bucket" "mybucket_25" {
  bucket = "my-unique-bucket-${random_id.bucket_id.hex}"

}
resource "aws_s3_bucket_ownership_controls" "mybucket_25" {
  bucket = aws_s3_bucket.mybucket_25.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_public_access_block" "mybucket_25" {
  bucket = aws_s3_bucket.mybucket_25.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_acl" "mybucket_25" {
  depends_on = [ 
    aws_s3_bucket_ownership_controls.mybucket_25,
    aws_s3_bucket_public_access_block.mybucket_25,
  ]
  bucket = aws_s3_bucket.mybucket_25.id
  acl    = "public-read"
}
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket_25.id
  key="index.html"
  source="index.html"
  acl="public-read"
  content_type="text/html"
}
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket_25.id
  key="error.html"
  source="error.html"
  acl="public-read"
  content_type="text/html"
}
resource "aws_s3_bucket_website_configuration" "website" {
  bucket=aws_s3_bucket.mybucket_25.id
  index_document {
    suffix="index.html"
  }
  error_document {
   key="error.html"  
  }
  depends_on=[aws_s3_bucket_acl.mybucket_25]
}