variable "region" {default = "eu-central-1"}
variable "website_dns" {default = "apidocs.d2di.net"}
variable "r53_zone_id" {default = "Z7BYWKOFY7ZDI"}
variable "swagger_ui_version" {default = "v2.2.8"}

provider "aws" {
    region = "${var.region}"
}

resource "aws_s3_bucket" "main" {
    region = "${var.region}"
    bucket = "${var.website_dns}"
    acl = "public-read"

    website {
        index_document = "index.html"
        error_document = "index.html"
    }
}

resource "aws_route53_record" "main" {
    name = "${var.website_dns}"
    type = "A"
    zone_id = "${var.r53_zone_id}"

    alias {
        name = "${aws_s3_bucket.main.website_domain}"
        zone_id = "${aws_s3_bucket.main.hosted_zone_id}"
        evaluate_target_health = false
    }
}

data "template_file" "main" {
  template = <<EOF
curl -L https://github.com/swagger-api/swagger-ui/archive/${var.swagger_ui_version}.tar.gz -o /tmp/swagger-ui.tar.gz
mkdir -p /tmp/swagger-ui
tar --strip-components 1 -C /tmp/swagger-ui -xf /tmp/swagger-ui.tar.gz

aws s3 sync --region ${var.region} --acl public-read /tmp/swagger-ui/dist s3://${aws_s3_bucket.main.bucket} --delete
rm -rf /tmp/swagger-ui
EOF
}

resource "null_resource" "main" {
    triggers {
        rendered_template = "${data.template_file.main.rendered}"
        version = "${var.swagger_ui_version}"
    }

    provisioner "local-exec" {
        command = "${data.template_file.main.rendered}"
    }
}
