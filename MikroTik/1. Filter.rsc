0    ;;; ga1
      chain=forward action=accept connection-state=established,related protocol=udp dst-address-list=mylan_ip in-interface=1-wan out-interface=2-mylan packet-mark=ga_src_mark src-port=27015-27110 log=no log-prefix="" 

 1    chain=forward action=accept protocol=udp src-address-list=mylan_ip in-interface=2-mylan out-interface=1-wan packet-mark=ga_dst_mark dst-port=27015-27110 log=no log-prefix="" 

 2    ;;; ga2
      chain=forward action=accept connection-state=established,related protocol=tcp dst-address-list=mylan_ip in-interface=1-wan out-interface=2-mylan packet-mark=ga_src_mark src-port=6112 log=no log-prefix="" 

 3    chain=forward action=accept protocol=tcp src-address-list=mylan_ip in-interface=2-mylan out-interface=1-wan packet-mark=ga_dst_mark dst-port=6112 log=no log-prefix="" 

 4    ;;; sip
      chain=forward action=accept connection-state=established,related protocol=udp src-address-list=SIP_IP dst-address-list=mylan_ip in-interface=1-wan out-interface=2-mylan packet-mark=sip_dst_mark log=no log-prefix="" 

 5    chain=forward action=accept connection-state=established,related protocol=udp src-address-list=mylan_ip dst-address-list=SIP_IP in-interface=2-mylan out-interface=1-wan packet-mark=sip_src_mark log=no log-prefix="" 

 6    ;;; dns
      chain=output action=accept protocol=udp src-address-list=dns_interface dst-address-list=local_ip out-interface-list=lan+wifi packet-mark=dns1_output_mark src-port=53 log=no log-prefix="" 

 7    chain=output action=accept protocol=udp src-address-list=my_statik_ip dst-address-list=dns out-interface=1-wan packet-mark=dns2_output_mark dst-port=53 log=no log-prefix="" 

 8    chain=input action=accept protocol=udp src-address-list=dns dst-address-list=my_statik_ip in-interface=1-wan packet-mark=dns1_input_mark src-port=53 log=no log-prefix="" 

 9    chain=input action=accept protocol=udp src-address-list=local_ip dst-address-list=dns_interface in-interface-list=lan+wifi packet-mark=dns2_input_mark dst-port=53 log=no log-prefix="" 

10    ;;; or QOS all work traffik to mylan
      chain=forward action=accept tcp-flags="" connection-state=new src-address-list=mylan_ip dst-address-list=mywork_ip in-interface=2-mylan out-interface=1-wan packet-mark=mywork1_dst_mark log=no log-prefix="" 

11    chain=forward action=accept tcp-flags="" connection-state=established,related src-address-list=mylan_ip dst-address-list=mywork_ip in-interface=2-mylan out-interface=1-wan packet-mark=mywork2_dst_mark log=no log-prefix="" 

12    chain=forward action=accept tcp-flags="" connection-state=established,related src-address-list=mywork_ip dst-address-list=mylan_ip in-interface=1-wan out-interface=2-mylan packet-mark=mywork_src_mark log=no log-prefix="" 

13    ;;; messangers
      chain=forward action=accept connection-state=new src-address-list=local_ip dst-address-list=messangers_ip out-interface=1-wan in-interface-list=lan+wifi packet-mark=messangers_traffik_dst log=no log-prefix="" 

14    chain=forward action=accept connection-state=established,related src-address-list=local_ip dst-address-list=messangers_ip out-interface=1-wan in-interface-list=lan+wifi packet-mark=messangers_traffik_dst log=no log-prefix="" 

15    chain=forward action=accept connection-state=established,related src-address-list=local_ip dst-address-list=messangers_ip out-interface=1-wan in-interface-list=lan+wifi packet-mark=messangers_traffik_dst log=no log-prefix="" 

16    ;;; for QOS TCP handshake + all legal traffik to local devices
      chain=forward action=accept tcp-flags=syn connection-state=new protocol=tcp src-address-list=local_ip out-interface=1-wan in-interface-list=lan+wifi packet-mark=tcp1_syn_dst_mark dst-port=80,443 log=no log-prefix="" 

17    chain=forward action=accept tcp-flags=syn,ack connection-state=established,related protocol=tcp dst-address-list=local_ip in-interface=1-wan out-interface-list=lan+wifi packet-mark=tcp1_syn_ack_src_mark src-port=80,443 log=no log-prefix="" 

18    chain=forward action=accept tcp-flags=rst connection-state=established,related protocol=tcp dst-address-list=local_ip in-interface=1-wan out-interface-list=lan+wifi packet-mark=tcp2_rst_dst_mark src-port=80,443 log=no log-prefix="" 

19    chain=forward action=accept tcp-flags=ack connection-state=established,related protocol=tcp src-address-list=local_ip out-interface=1-wan in-interface-list=lan+wifi packet-mark=tcp3_ack_dst_mark dst-port=80,443 log=no log-prefix="" 

20    chain=forward action=accept tcp-flags=ack connection-state=established,related protocol=tcp dst-address-list=local_ip in-interface=1-wan out-interface-list=lan+wifi packet-mark=tcp2_ack_src_mark src-port=80,443 log=no log-prefix="" 

21    chain=forward action=accept connection-state=established,related protocol=tcp src-address-list=local_ip out-interface=1-wan in-interface-list=lan+wifi packet-mark=tcp4_dst_mark dst-port=80,443 log=no log-prefix="" 

22    chain=forward action=accept connection-state=established,related protocol=tcp dst-address-list=local_ip in-interface=1-wan out-interface-list=lan+wifi packet-mark=tcp3_src_mark src-port=80,443 log=no log-prefix="" 

23    chain=forward action=accept connection-state=established,related dst-address-list=local_ip in-interface=1-wan out-interface-list=lan+wifi packet-mark=legal_src_mark log=no log-prefix="" 

24    chain=forward action=accept connection-state=established,related src-address-list=local_ip out-interface=1-wan in-interface-list=lan+wifi packet-mark=legal_dst_mark log=no log-prefix="" 

25    ;;; ntp
      chain=input action=accept protocol=udp src-address-list=ntp dst-address-list=my_statik_ip in-interface=1-wan packet-mark=ntp_accept src-port=123 dst-port=123 log=no log-prefix="" 

26    chain=output action=accept protocol=udp src-address-list=my_statik_ip dst-address-list=ntp out-interface=1-wan packet-mark=ntp_accept src-port=123 dst-port=123 log=no log-prefix="" 

27    ;;; drops traffik to not wan
      chain=forward action=drop src-address-list=mylan_ip in-interface=!1-wan out-interface-list=lan+wifi log=no log-prefix="" 

28    chain=forward action=drop src-address-list=wifi_ip out-interface=!1-wan in-interface-list=lan+wifi log=no log-prefix="" 

29    chain=output action=drop src-address-list=local_ip out-interface=!1-wan log=no log-prefix="" 

30    ;;; drop bad packets
      chain=input action=tarpit protocol=tcp src-address-list=z_BLOCKLIST_WORLD in-interface=1-wan log=no log-prefix="" 

31    chain=input action=drop packet-mark=drop_packets log=no log-prefix="" 

32    chain=forward action=drop packet-mark=drop_packets log=no log-prefix="" 

33    chain=output action=drop packet-mark=drop_packets log=no log-prefix="" 

