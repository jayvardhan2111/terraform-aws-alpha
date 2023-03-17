
data "terraform_remote_state" "level1" {

  backend = "s3"

  config = {
    bucket = "terraform-remote-state-230223"
    key    = "key/level1.tfstate"
    region = "ap-south-1"


  }
}


