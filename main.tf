data "archive_file" "example_zip" {
    type        = "zip"
    source_dir  = "${path.module}/functions"
    output_path = "${path.module}/example_lambda.zip"
}

resource "aws_lambda_function" "example_lambda" {
    function_name     = "example-lambda"
    handler           = "main.handler"
    runtime           = "python3.10"
    filename          = data.archive_file.example_zip.output_path
    source_code_hash  = filebase64sha256(data.archive_file.example_zip.output_path)
    role              = aws_iam_role.lambda_role.arn
}

resource "aws_iam_role" "lambda_role" {
    name = "example-lambda-role"
    assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
   ]
}
EOF
}
