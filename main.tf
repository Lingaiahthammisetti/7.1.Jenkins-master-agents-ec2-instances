module "jenkins_master" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "tf-jenkins-master"
  instance_type          = "t3.small"
  vpc_security_group_ids = [var.allow_everything] #replace your SG
  ami                    = data.aws_ami.ami_info.id
  #vpc_security_group_ids = ["sg-0fea5e49e962e81c9"]
  user_data              = file("${path.module}/install_jenkins_master.sh")
  tags = {
    Name   = "Jenkins-Master"
  }
  # Define the root volume size and type
  root_block_device = [
    {
      volume_size = 50       # Size of the root volume in GB
      volume_type = "gp3"    # General Purpose SSD (you can change it if needed)
      delete_on_termination = true  # Automatically delete the volume when the instance is terminated
    }
  ]

}
module "jenkins_agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "tf-jenkins-agent"
  instance_type          = "t3.small"
  vpc_security_group_ids = [var.allow_everything] #replace your SG
  ami                    = data.aws_ami.ami_info.id
    #vpc_security_group_ids = ["sg-0fea5e49e962e81c9"]
  user_data               = file("${path.module}/install_jenkins_agent.sh")

  tags = {
    Name   = "Jenkins-Agent"
  }
  # Define the root volume size and type
  root_block_device = [
    {
      volume_size = 50       # Size of the root volume in GB
      volume_type = "gp3"    # General Purpose SSD (you can change it if needed)
      delete_on_termination = true  # Automatically delete the volume when the instance is terminated
    }
  ]
}
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"
  zone_name = var.zone_name

records = [
      {
        name = "jenkins_master"
        type = "A"
        ttl  = 1
        records = [
          module.jenkins_master.public_ip
        ]
         allow_overwrite = true
      },
      {
        name = "jenkins_agent"
        type = "A"
        ttl  = 1
        records = [
          module.jenkins_agent.public_ip
        ]
         allow_overwrite = true
       }
   ]
}
