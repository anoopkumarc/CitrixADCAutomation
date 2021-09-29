lbdetails = [
   {
      lbname = "my_vserver1"
      priority = 1
      backend =["192.168.0.1:7001:1","192.168.0.2:7001:2"]
      context = "/abc/xyz/abcService"
      rewrites  = ["abc", "xyz"]
   },
   {
      lbname = "my_vserver2"
      priority = 2
      backend =["192.168.0.1:7002:1"]
      context = "/xyz/abc/xyzService"
      rewrites  = ["xyz","abc"]
   },
   {
      lbname = "my_vserver3"
      priority = 3
      backend =["192.168.0.1:7003:1","192.168.0.2:7003:2"]
      context = "/abc/rgbService"
      rewrites  = ["abc", "/"]
   }
]
vip = "168.0.0.1"