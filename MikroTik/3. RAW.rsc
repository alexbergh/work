0    ;;; dns drops in 53
      chain=prerouting action=add-src-to-address-list in-interface=1-wan dst-port=53 log=yes log-prefix="RAW 0: " protocol=tcp src-address-list=!z_BLOCKLIST_WORLD address-list=z_BLOCKLIST_WORLD address-list-timeout=35w2d23h59m59s 

 1    chain=prerouting action=jump jump-target=dns_udp_chain in-interface=1-wan dst-port=53 log=no log-prefix="" protocol=udp src-address-list=!z_BLOCKLIST_WORLD 

 2    chain=dns_udp_chain action=add-src-to-address-list in-interface=1-wan dst-port=53 log=yes log-prefix="RAW 2: " protocol=udp src-address-list=!dns address-list=z_BLOCKLIST_WORLD address-list-timeout=35w2d23h59m59s 

 3    ;;; ntp illegal
      chain=prerouting action=add-src-to-address-list in-interface=1-wan dst-port=123 log=no log-prefix="" protocol=tcp address-list=z_BLOCKLIST_WORLD address-list-timeout=35w2d23h59m59s 

 4    chain=prerouting action=add-src-to-address-list in-interface=1-wan dst-port=123 log=yes log-prefix="RAW 4: " protocol=udp src-address-list=!ntp address-list=z_BLOCKLIST_WORLD address-list-timeout=35w2d23h59m59s 

 5    ;;; droplist
      chain=prerouting action=jump jump-target=droplist1 in-interface=!1-wan log=no log-prefix="" dst-address=!255.255.255.255 src-address-list=!wifi_ip dst-address-list=z_BLOCKLIST_WORLD 

 6    chain=prerouting action=jump jump-target=droplist2 in-interface=1-wan log=no log-prefix="" src-address-list=z_BLOCKLIST_WORLD dst-address-list=!wifi_ip 

 7    chain=droplist1 action=jump jump-target=droplist3 in-interface=!1-wan log=no log-prefix="" src-address-list=!wifi_ip dst-address-list=!messangers_ip 

 8    chain=droplist2 action=jump jump-target=droplist3 in-interface=1-wan log=no log-prefix="" src-address-list=!messangers_ip dst-address-list=!wifi_ip 

 9    chain=droplist3 action=drop log=no log-prefix="" src-address-list=!SIP_IP dst-address-list=!SIP_IP 

10    ;;; drop traffik to mikrotik
      chain=prerouting action=drop log=no log-prefix="" dst-address=255.255.255.255 

11    ;;; drop traffik to mikrotik ports
      chain=prerouting action=add-src-to-address-list in-interface=1-wan dst-port=23,8080,8081 log=no log-prefix="" protocol=tcp src-address-list=!z_BLOCKLIST_WORLD address-list=z_BLOCKLIST_WORLD address-list-timeout=35w2d23h59m59s 

12    chain=prerouting action=drop port=23,8080,8081 log=no log-prefix="" protocol=tcp 

13    chain=prerouting action=add-src-to-address-list in-interface=1-wan dst-port=20-23,67-68,161,179,500,546,547,646,1080,1081,1698 log=yes log-prefix="RAW 13: " protocol=tcp src-address-list=!z_BLOCKLIST_WORLD address-list=z_BLOCKLIST_WORLD 
      address-list-timeout=35w2d23h59m59s 

14    chain=prerouting action=drop port=20-23,67-68,161,179,500,546,547,646,1080,1081,1698 log=no log-prefix="" protocol=tcp 

15    chain=prerouting action=add-src-to-address-list in-interface=1-wan dst-port=1701,1723,1900,1966,2828,2000,5246,5247,5678,6343,8080,8081,8728,8729,20561 log=yes log-prefix="RAW 15: " protocol=tcp src-address-list=!z_BLOCKLIST_WORLD 
      address-list=z_BLOCKLIST_WORLD address-list-timeout=35w2d23h59m59s 

16    chain=prerouting action=drop port=1701,1723,1900,1966,2828,2000,5246,5247,5678,6343,8080,8081,8728,8729 log=no log-prefix="" protocol=tcp 

17    chain=output action=drop port=20-23,67-68,161,179,500,546,547,646,1080,1081,1698 log=no log-prefix="" protocol=tcp 

18    chain=output action=drop port=1701,1723,1900,1966,2828,2000,5246,5247,5678,6343,8728,8729 log=no log-prefix="" protocol=tcp 

19    ;;; drop traffik to mikrotik ports
      chain=prerouting action=add-src-to-address-list in-interface=1-wan dst-port=20-23,67-68,161,179,500,546,547,646,1080,1081,1698 log=yes log-prefix="RAW 19: " protocol=udp src-address-list=!z_BLOCKLIST_WORLD address-list=z_BLOCKLIST_WORLD 
      address-list-timeout=35w2d23h59m59s 

20    chain=prerouting action=drop port=20-23,67-68,161,179,500,546,547,646,1080,1081,1698 log=no log-prefix="" protocol=udp 

21    chain=prerouting action=add-src-to-address-list in-interface=1-wan dst-port=1701,1723,1900,1966,2828,2000,5246,5247,5678,6343,8080,8081,8728,8729,20561 log=yes log-prefix="RAW 21: " protocol=udp src-address-list=!z_BLOCKLIST_WORLD 
      address-list=z_BLOCKLIST_WORLD address-list-timeout=35w2d23h59m59s 

22    chain=prerouting action=drop port=1701,1723,1900,1966,2828,2000,5246,5247,5678,6343,8080,8081,8728,8729 log=no log-prefix="" protocol=udp 

23    chain=output action=drop port=20-23,67-68,161,179,500,546,547,646,1080,1081,1698 log=no log-prefix="" protocol=udp 

24    chain=output action=drop port=1701,1723,1900,1966,2828,2000,5246,5247,5678,6343,8728,8729 log=no log-prefix="" protocol=udp 

25    ;;; drop non tcp and udp traffik
      chain=prerouting action=drop log=no log-prefix="" protocol=icmp 

26    chain=output action=drop log=no log-prefix="" protocol=icmp 

27    chain=prerouting action=drop log=no log-prefix="" protocol=igmp 

28    chain=output action=drop log=no log-prefix="" protocol=igmp 

29    chain=prerouting action=jump jump-target=drop_non_udp_and_tcp log=no log-prefix="" protocol=!tcp 

30    chain=output action=jump jump-target=drop_non_udp_and_tcp log=no log-prefix="" protocol=!tcp 

31    chain=drop_non_udp_and_tcp action=drop log=yes log-prefix="RAW 31: " protocol=!udp

