provider "digitalocean" {
}

module "spaces" {
  source        = "./../../"
  name          = "digitalocean-spaces"
  environment   = "test"
  acl           = "private"
  force_destroy = false
  region        = "nyc3"

}
