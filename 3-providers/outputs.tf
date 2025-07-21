output "current_user_arn" {
    value = data.aws_caller_identity.current.arn
  
}

output "current_user" {
    value = data.aws_caller_identity.current
  
}