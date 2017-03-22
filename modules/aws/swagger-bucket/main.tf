resource "aws_s3_bucket" "main" {
    region = "${var.region}"
    bucket = "${var.website_dns}"
    acl    = "public-read"

    website {
        index_document = "index.html"
        error_document = "index.html"
    }
}

data "aws_route53_zone" "dns_zone" {
    name = "${var.domain_name}."
}

resource "aws_route53_record" "main" {
    name    = "${var.website_dns}"
    type    = "A"
    zone_id = "${data.aws_route53_zone.dns_zone.zone_id}"

    alias {
        name                   = "${aws_s3_bucket.main.website_domain}"
        zone_id                = "${aws_s3_bucket.main.hosted_zone_id}"
        evaluate_target_health = false
    }
}

data "template_file" "main" {
  template = <<EOF
curl -L https://github.com/swagger-api/swagger-ui/archive/${var.swagger_ui_version}.tar.gz -o /tmp/swagger-ui.tar.gz
mkdir -p /tmp/swagger-ui
tar --strip-components 1 -C /tmp/swagger-ui -xf /tmp/swagger-ui.tar.gz

aws s3 sync /tmp/swagger-ui/dist s3://${aws_s3_bucket.main.bucket} --region ${var.region} --acl public-read --delete --profile ${var.aws_profile}
rm -rf /tmp/swagger-ui
EOF
}

resource "null_resource" "main" {
    triggers {
        rendered_template = "${data.template_file.main.rendered}"
        version           = "${var.swagger_ui_version}"
    }

    provisioner "local-exec" {
        command = "${data.template_file.main.rendered}"
    }
}
