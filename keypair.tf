resource "aws_key_pair" "jobapp_key" {
  key_name   = "jobapp-key"
  public_key = file("${path.module}/jobapp-key.pub")
}

