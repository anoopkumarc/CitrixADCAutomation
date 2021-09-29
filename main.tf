terraform {
  required_providers {
    citrixadc = {
      source = "citrix/citrixadc"
      version = "1.6.0"
    }
  }
}

provider "citrixadc" {
  endpoint = "https://<CitrixADC-HostName>"
  username = "<username>"
  password = "<password>"
  
  insecure_skip_verify = true
}

resource "citrixadc_csvserver" "tf_csvserver" {
  ipv46       = var.vip
  name        = "tf_csvserver"
  port        = 80
  servicetype = "HTTP"
  comment     = "New CSV server"
}

module "ek_rules"{
   source = "./contentswitch-rewrite"  
   for_each = { for lbdetail in var.lbdetails : lbdetail.lbname => lbdetail }

   csvserver_name   = citrixadc_csvserver.tf_csvserver.name
   csvserver_id     = citrixadc_csvserver.tf_csvserver.id 
   lbvserver_name   = "${each.value.lbname}"
   backend_servers  = "${each.value.backend}"
   priority         = "${each.value.priority}"
   rewrites         = "${each.value.rewrites}"
   context          = "${each.value.context}"
}