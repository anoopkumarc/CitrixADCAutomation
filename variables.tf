variable "lbdetails" {
  type        = list(object({ lbname = string, priority = number, backend =  list(string), context = string, rewrites = list(string) }))
  default     = []
  description = "The ContentSwitching Loadbalancer Rewrite rules that will be created" 
}
variable  "vip" {}