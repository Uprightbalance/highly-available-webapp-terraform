resource "aws_launch_template" "web" {
  image_id      = "ami-0fc5d935ebf8bc3bc" # Ubuntu 22.04
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(<<EOF
#!/bin/bash
set -xe

apt update -y
apt install -y apache2 git

systemctl start apache2
systemctl enable apache2

cd /tmp
git clone https://github.com/Uprightbalance/jobapp-index.git
cp /tmp/jobapp-index/index.html /var/www/html/index.html

chown www-data:www-data /var/www/html/index.html
chmod 644 /var/www/html/index.html
EOF
)

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}

