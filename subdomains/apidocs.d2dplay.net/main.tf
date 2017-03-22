module "swagger-bucket" {
  source      = "../../modules/aws/swagger-bucket"
  domain_name = "${var.domain_name}"
  website_dns = "${var.website_dns}"
  region      = "${var.aws_region}"
  aws_profile = "${var.aws_profile}"
}
