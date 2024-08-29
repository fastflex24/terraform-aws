# Create S3 Buckets
resource "aws_s3_bucket" "images" {
  bucket_prefix = "images"
}

resource "aws_s3_bucket" "logs" {
  bucket_prefix = "logs"
}

# Create folders and set lifecycle policies
resource "aws_s3_bucket_object" "archive" {
  bucket = aws_s3_bucket.images.id
  key    = "archive/"
}

resource "aws_s3_bucket_lifecycle_configuration" "images_lifecycle" {
  bucket = aws_s3_bucket.images.id

  rule {
    id     = "move-to-glacier"
    status = "Enabled"

    filter {
      prefix = "Memes/"
    }

    transitions {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "move-active-to-glacier"
    status = "Enabled"

    filter {
      prefix = "Active/"
    }

    transitions {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  rule {
    id     = "delete-inactive"
    status = "Enabled"

    filter {
      prefix = "Inactive/"
    }

    expiration {
      days = 90
    }
  }
}