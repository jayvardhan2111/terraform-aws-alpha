resource "aws_iam_policy" "s3-FullAcess-policy" {
  name        = var.env_code
  description = "Allow full access to s3"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "s3Role" {
  name = "s3-Role"

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

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.s3Role.name
  policy_arn = aws_iam_policy.s3-FullAcess-policy.arn
}

resource "aws_iam_instance_profile" "my-inst-profile" {
  name = var.env_code
  role = aws_iam_role.s3Role.name
}


