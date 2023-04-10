resource "aws_wafv2_ip_set" "ip_set" {
  name               = "${local.app_name}-ip-set"
  description        = "Whitelist IP set for app ${local.app_name}"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = var.allowed_ips
}

resource "aws_wafv2_web_acl" "web_acl" {
  name        = "${local.app_name}-web-acl"
  description = "Web ACL with IP whitelist for app ${local.app_name}"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "whitelist"
    priority = 0

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_set.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${local.app_name}-metric"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${local.app_name}-metric"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "web_acl_association" {
  web_acl_arn = aws_wafv2_web_acl.web_acl.arn
  resource_arn = aws_lb.this.arn
}