resource "aws_iam_policy" "s3_policy" {
  name        = var.env_code
  path        = "/"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_role" "main" {
  name                = var.env_code
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"]

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
resource "aws_iam_instance_profile" "main" {
  name = var.env_code
  role = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.s3Role.name
  policy_arn = aws_iam_policy.s3-FullAcess-policy.arn
}


