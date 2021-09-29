terraform {
  required_providers {
    citrixadc = {
      source = "citrix/citrixadc"
      version = "1.6.0"
    }
  }
}
resource "citrixadc_lbvserver" "tf_lbvserver" { 
  name        = var.lbvserver_name
  servicetype = "HTTP"
}

resource "citrixadc_lbmonitor" "tfmonitor" {
  monitorname = "${var.lbvserver_name}_tf-monitor"
  type        = "HTTP"
  httprequest =  "HEAD /status"
}

resource "citrixadc_servicegroup" "tf_servicegroup" {
  servicegroupname = "${var.lbvserver_name}_servicegroup"
  lbvservers       = [citrixadc_lbvserver.tf_lbvserver.name]
  servicetype      = "HTTP"
  servicegroupmembers = var.backend_servers
}

resource "citrixadc_servicegroup_lbmonitor_binding" "bind1" {
    servicegroupname = citrixadc_servicegroup.tf_servicegroup.servicegroupname
    monitorname = citrixadc_lbmonitor.tfmonitor.monitorname
    weight = 80
}

resource "citrixadc_rewriteaction" "tf_rewrite_action" {
    name              = "${var.lbvserver_name}_rewrite_action"
    bypasssafetycheck = "YES"
    target            = "HTTP.REQ.URL"
    type              = "replace"
    stringbuilderexpr = "http.REQ.URL.PATH.BEFORE_STR(\"/${var.rewrites[0]}\")+http.REQ.URL.PATH_AND_QUERY.AFTER_STR(\"/${var.rewrites[1]}\")"
}

resource "citrixadc_rewritepolicy" "tf_rewrite_policy" {
  name   = "${var.lbvserver_name}_rewrite_policy"
  action = "${var.lbvserver_name}_rewrite_action"
  rule   = "HTTP.REQ.URL.PATH.CONTAINS(\"/${var.rewrites[0]}/\")"
}

resource "citrixadc_lbvserver_rewritepolicy_binding" "tf_bind" {
    name = citrixadc_lbvserver.tf_lbvserver.name
    policyname = citrixadc_rewritepolicy.tf_rewrite_policy.name
    priority = var.priority
    bindpoint = "REQUEST"
}

resource "citrixadc_csaction" "tf_csaction" {
  name            = "${var.lbvserver_name}_test_csaction2"
  targetlbvserver = citrixadc_lbvserver.tf_lbvserver.name
  comment         = "Forwards requests to the ${var.lbvserver_name}"
}

resource "citrixadc_cspolicy" "foo_cspolicy" {
  csvserver       = var.csvserver_name
  targetlbvserver = citrixadc_lbvserver.tf_lbvserver.name
  policyname      = "${var.lbvserver_name}_test_policy"
  rule            = "HTTP.REQ.URL.PATH.CONTAINS(\"${var.context}\")"
  priority        = var.priority

  forcenew_id_set = [
    citrixadc_lbvserver.tf_lbvserver.id,
    var.csvserver_id,
  ]
}