
# resource "aws_s3_bucket" "my_bucket" {
#     # Name must be [a-z,0-9,.-] and must be between 3 and 63 characters long
#     bucket = "msllc-opentofu-workshop-0725-0001"
# }

# resource "aws_s3_bucket_object" "object" {
#   bucket = aws_s3_bucket.my_bucket.bucket
#   key    = "my_user.txt"
#   source = local_file.my_user.filename
# }

data "aws_caller_identity" "current" {

}

resource "local_file" "account" {
  content = data.aws_caller_identity.current.arn
  filename = "account.txt"
}

# locals  {

#     char_list = split("", local_file.forwards.content)
#     reversed_char_list = reverse(local.char_list)
#     reversed_string = join("", local.reversed_char_list)
# }

# resource "local_file" "backwards" {
#   content = local.reversed_string
#   filename = "account-backwards.txt"
# }

