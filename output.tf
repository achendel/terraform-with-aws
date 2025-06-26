output "website"{
    value=aws_s3_bucket.mybucket_25.website_endpoint
    description = "The public IP of the EC2 instance"
   # value =aws_s3_bucket.mybucket_25.public_ip
}