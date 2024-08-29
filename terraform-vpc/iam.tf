# Create IAM Role for Auto Scaling Group
resource "aws_iam_role" "asg_role" {
  name = "asg-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policy to allow reading from S3 bucket
resource "aws_iam_policy" "read_s3_policy" {
  name        = "read-s3-policy"
  description = "Policy to allow reading from images bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:GetObject"
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.images.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "asg_read_s3" {
  role       = aws_iam_role.asg_role.name
  policy_arn = aws_iam_policy.read_s3_policy.arn
}

# Create IAM Role for EC2 instances to write logs
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policy to allow writing to S3 logs bucket
resource "aws_iam_policy" "write_logs_policy" {
  name        = "write-logs-policy"
  description = "Policy to allow writing to logs bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:PutObject"
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.logs.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_write_logs" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.write_logs_policy.arn
}