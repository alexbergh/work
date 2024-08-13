0    ;;; block mywork IP to input:
      chain=input action=mark-packet new-packet-mark=drop_packets passthrough=no src-address-list=mywork_ip in-interface=1-wan log=yes log-prefix="Mangle 0: " 

 1    ;;; drop all from WAN not DSTNATed
      chain=prerouting action=add-src-to-address-list connection-state=new connection-nat-state=!dstnat address-list=z_BLOCKLIST_WORLD address-list-timeout=35w2d23h59m59s in-interface=1-wan log=no log-prefix="" 

 2    chain=prerouting action=mark-packet new-packet-mark=drop_packets passthrough=no connection-state=new connection-nat-state=!dstnat in-interface=1-wan log=no log-prefix="" 

 3    ;;; drop not valid traffik
      chain=prerouting action=add-src-to-address-list connection-state=invalid address-list=z_BLOCKLIST_WORLD address-list-timeout=35w2d23h59m59s in-interface=1-wan log=no log-prefix="Mangle 3: " 

 4    ;;; dns
      chain=output action=mark-packet new-packet-mark=dns1_output_mark passthrough=no protocol=udp src-address-list=dns_interface dst-address-list=local_ip out-interface-list=lan+wifi src-port=53 log=no log-prefix="" 

 5    chain=output action=mark-packet new-packet-mark=dns2_output_mark passthrough=no protocol=udp src-address-list=my_statik_ip dst-address-list=dns out-interface=1-wan dst-port=53 log=no log-prefix="" 

 6    chain=output action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp packet-mark=!dns_output_mark port=53 log=yes log-prefix="Mangle 7: " 

 7    chain=input action=mark-packet new-packet-mark=dns1_input_mark passthrough=no protocol=udp src-address-list=dns dst-address-list=my_statik_ip in-interface=1-wan src-port=53 log=no log-prefix="" 

 8    chain=input action=mark-packet new-packet-mark=dns2_input_mark passthrough=no protocol=udp src-address-list=local_ip dst-address-list=dns_interface in-interface-list=lan+wifi dst-port=53 log=no log-prefix="" 

 9    ;;; ntp
      chain=output action=mark-packet new-packet-mark=ntp_accept passthrough=no protocol=udp src-address-list=my_statik_ip dst-address-list=ntp out-interface=1-wan src-port=123 dst-port=123 log=no log-prefix="" 

10    chain=input action=mark-packet new-packet-mark=ntp_accept passthrough=no protocol=udp src-address-list=ntp dst-address-list=my_statik_ip in-interface=1-wan src-port=123 dst-port=123 log=no log-prefix="" 

11    chain=output action=mark-packet new-packet-mark=ntp_accept passthrough=no protocol=udp packet-mark=!ntp_accept port=123 log=no log-prefix="" 

12    ;;; SYN Flood protect
      chain=input action=add-src-to-address-list tcp-flags=syn connection-state=new protocol=tcp address-list=z_BLOCKLIST_WORLD address-list-timeout=23h59m59s in-interface=1-wan limit=!400,5:packet log=yes log-prefix="Mangle 12: " 

13    ;;; Port scanners to list 
      chain=input action=add-src-to-address-list protocol=tcp psd=21,3s,3,1 src-address-list=!z_BLOCKLIST_WORLD address-list=z_BLOCKLIST_WORLD address-list-timeout=2w in-interface=1-wan log=yes log-prefix="Mangle 13: " 

14    ;;; Port scanners to list 
      chain=input action=add-src-to-address-list protocol=tcp psd=21,3s,3,1 src-address-list=!z_BLOCKLIST_WORLD address-list=z_BLOCKLIST_WORLD address-list-timeout=2w in-interface=1-wan log=yes log-prefix="Mangle 14: " 

15    ;;; NMAP FIN Stealth scan
      chain=input action=add-src-to-address-list tcp-flags=fin,!syn,!rst,!psh,!ack,!urg protocol=tcp src-address-list=!z_BLOCKLIST_WORLD address-list=z_BLOCKLIST_WORLD address-list-timeout=2w in-interface=1-wan log=yes log-prefix="Mangle 15: " 

16    ;;; SYN/FIN scan
      chain=input action=add-src-to-address-list tcp-flags=fin,syn protocol=tcp src-address-list=!z_BLOCKLIST_WORLD address-list=z_BLOCKLIST_WORLD address-list-timeout=2w in-interface=1-wan log=yes log-prefix="Mangle 16: " 

17    ;;; SYN/RST scan
      chain=input action=add-src-to-address-list tcp-flags=syn,rst protocol=tcp src-address-list=!z_BLOCKLIST_WORLD address-list=z_BLOCKLIST_WORLD address-list-timeout=2w in-interface=1-wan log=yes log-prefix="Mangle 17: " 

18    ;;; FIN/PSH/URG scan
      chain=input action=add-src-to-address-list tcp-flags=fin,psh,urg,!syn,!rst,!ack protocol=tcp src-address-list=!z_BLOCKLIST_WORLD address-list=z_BLOCKLIST_WORLD address-list-timeout=2w in-interface=1-wan log=yes log-prefix="Mangle 18: " 

19    ;;; ALL/ALL scan
      chain=input action=add-src-to-address-list tcp-flags=fin,syn,rst,psh,ack,urg protocol=tcp src-address-list=!z_BLOCKLIST_WORLD address-list=z_BLOCKLIST_WORLD address-list-timeout=2w in-interface=1-wan log=yes log-prefix="Mangle 19: " 

20    ;;; NMAP NULL scan
      chain=input action=add-src-to-address-list tcp-flags=!fin,!syn,!rst,!psh,!ack,!urg protocol=tcp src-address-list=!z_BLOCKLIST_WORLD address-list=z_BLOCKLIST_WORLD address-list-timeout=2w in-interface=1-wan log=yes log-prefix="Mangle 20: " 

21    ;;; drops input / output
      chain=input action=mark-packet new-packet-mark=drop_packets passthrough=no src-address-list=z_BLOCKLIST_WORLD in-interface=1-wan log=no log-prefix="" 

22    chain=input action=mark-packet new-packet-mark=drop_packets passthrough=no log=no log-prefix="" 

23    chain=output action=mark-packet new-packet-mark=drop_packets passthrough=no log=no log-prefix="" 

24    ;;; ga
      chain=forward action=mark-packet new-packet-mark=ga_src_mark passthrough=no connection-state=established,related protocol=udp dst-address-list=mylan_ip in-interface=1-wan out-interface=2-mylan src-port=27015-27110 log=no log-prefix="" 

25    chain=forward action=mark-packet new-packet-mark=ga_dst_mark passthrough=no protocol=udp src-address-list=mylan_ip in-interface=2-mylan out-interface=1-wan dst-port=27015-27110 log=no log-prefix="" 

26    chain=forward action=mark-packet new-packet-mark=ga_src_mark passthrough=no connection-state=established,related protocol=tcp dst-address-list=mylan_ip in-interface=1-wan out-interface=2-mylan src-port=6112 log=no log-prefix="" 

27    chain=forward action=mark-packet new-packet-mark=ga_dst_mark passthrough=no protocol=tcp src-address-list=mylan_ip in-interface=2-mylan out-interface=1-wan dst-port=6112 log=no log-prefix="" 

28    ;;; for QOS sip
      chain=forward action=mark-packet new-packet-mark=sip_dst_mark passthrough=no connection-state=established,related protocol=udp src-address-list=SIP_IP dst-address-list=mylan_ip in-interface=1-wan out-interface=2-mylan log=no log-prefix="" 

29    chain=forward action=mark-packet new-packet-mark=sip_src_mark passthrough=no connection-state=established,related protocol=udp src-address-list=mylan_ip dst-address-list=SIP_IP in-interface=2-mylan out-interface=1-wan log=no log-prefix="" 

30    ;;; messangers ip 
      chain=forward action=mark-packet new-packet-mark=messangers_traffik_dst passthrough=no tcp-flags="" connection-state=new src-address-list=local_ip dst-address-list=messangers_ip out-interface=1-wan in-interface-list=lan+wifi log=no 
      log-prefix="" 

31    chain=forward action=mark-packet new-packet-mark=messangers_traffik_dst passthrough=no connection-state=established,related src-address-list=local_ip dst-address-list=messangers_ip out-interface=1-wan in-interface-list=lan+wifi log=no 
      log-prefix="" 

32    chain=forward action=mark-packet new-packet-mark=messangers_traffik_dst passthrough=no connection-state=established,related src-address-list=local_ip dst-address-list=messangers_ip out-interface=1-wan in-interface-list=lan+wifi log=no 
      log-prefix="" 

33    ;;; or QOS all work traffik to mylan Part1
      chain=forward action=mark-packet new-packet-mark=mywork1_dst_mark passthrough=no connection-state=new src-address-list=mylan_ip dst-address-list=mywork_ip in-interface=2-mylan out-interface=1-wan log=no log-prefix="" 

34    ;;; for QOS TCP handshake
      chain=forward action=mark-packet new-packet-mark=tcp1_syn_dst_mark passthrough=no tcp-flags=syn connection-state=new protocol=tcp src-address-list=local_ip out-interface=1-wan in-interface-list=lan+wifi dst-port=80,443 log=no log-prefix="" 

35    chain=forward action=mark-packet new-packet-mark=tcp1_syn_ack_src_mark passthrough=no tcp-flags=syn,ack connection-state=established,related protocol=tcp dst-address-list=local_ip in-interface=1-wan out-interface-list=lan+wifi src-port=80,443 
      log=no log-prefix="" 

36    chain=forward action=mark-packet new-packet-mark=tcp2_rst_dst_mark passthrough=no tcp-flags=rst connection-state=established,related protocol=tcp dst-address-list=local_ip in-interface=1-wan out-interface-list=lan+wifi src-port=80,443 log=no 
      log-prefix="" 

37    chain=forward action=mark-packet new-packet-mark=tcp3_ack_dst_mark passthrough=no tcp-flags=ack connection-state=established,related protocol=tcp src-address-list=local_ip out-interface=1-wan in-interface-list=lan+wifi dst-port=80,443 log=no 
      log-prefix="" 

38    chain=forward action=mark-packet new-packet-mark=tcp2_ack_src_mark passthrough=no tcp-flags=ack connection-state=established,related protocol=tcp dst-address-list=local_ip in-interface=1-wan out-interface-list=lan+wifi src-port=80,443 log=no 
      log-prefix="" 

39    chain=forward action=mark-packet new-packet-mark=tcp4_dst_mark passthrough=no connection-state=established,related protocol=tcp src-address-list=local_ip out-interface=1-wan in-interface-list=lan+wifi dst-port=80,443 log=no log-prefix="" 

40    chain=forward action=mark-packet new-packet-mark=tcp3_src_mark passthrough=no connection-state=established,related protocol=tcp dst-address-list=local_ip in-interface=1-wan out-interface-list=lan+wifi src-port=80,443 log=no log-prefix="" 

41    ;;; mikrotik dangers ports
      chain=forward action=add-src-to-address-list protocol=tcp address-list=internal_provider_lan_input address-list-timeout=35w2d23h59m59s in-interface=1-wan dst-port=20-23,67-68,161,179,500,546,547,646,1080,1081,1698 log=yes 
      log-prefix="Mangle 109: " 

42    chain=forward action=add-src-to-address-list protocol=udp address-list=internal_provider_lan_input address-list-timeout=35w2d23h59m59s in-interface=1-wan dst-port=20-23,67-68,161,179,500,546,547,646,1080,1081,1698 log=yes 
      log-prefix="Mangle 111: " 

43    chain=forward action=add-src-to-address-list protocol=tcp address-list=internal_provider_lan_input address-list-timeout=35w2d23h59m59s in-interface=1-wan dst-port=1701,1723,1900,1966,2828,2000,5246,5247,5678,6343,8080,8081,8291,8728,8729 log=ye>
      log-prefix="Mangle 113: " 

44    chain=forward action=add-src-to-address-list protocol=udp address-list=internal_provider_lan_input address-list-timeout=35w2d23h59m59s in-interface=1-wan dst-port=1701,1723,1900,1966,2828,2000,5246,5247,5678,6343,8080,8081,8291,8728,8729 log=ye>
      log-prefix="Mangle 115: " 

45    ;;; block danger ports
      chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=1,2,15,20-25,30-31,39,41,48,50,53,58,59,123 log=no log-prefix="" 

46    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=1,2,15,20-25,30-31,39,41,48,50,53,58,59,123 log=no log-prefix="" 

47    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=67-70,79,81,90,99,110,113,119,121,133,137-139,142,146 log=no log-prefix="" 

48    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=67-70,79,81,90,99,110,113,119,121,133,137-139,142,146 log=no log-prefix="" 

49    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=148,161,166,170,171,179,334,411,420,421,455,456,500,511 log=no log-prefix="" 

50    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=148,161,166,170,171,179,334,411,420,421,455,456,500,511 log=no log-prefix="" 

51    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=513-515,531,546,547,555,600,605,646,661,666-669,692,777,808 log=no log-prefix="" 

52    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=513-515,531,546,547,555,600,605,646,661,666-669,692,777,808 log=no log-prefix="" 

53    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=901,902,911,999,1000,1001,1005,1008,1010-1012,1015,1016,1020,1024,1025 log=no log-prefix="" 

54    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=901,902,911,999,1000,1001,1005,1008,1010-1012,1015,1016,1020,1024,1025 log=no log-prefix="" 

55    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=1031-1035,1042,1045,1049,1050,1053,1054,1080,1081-1083,1090,1095,1097,1098 log=no log-prefix="" 

56    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=1031-1035,1042,1045,1049,1050,1053,1054,1080,1081-1083,1090,1095,1097,1098 log=no log-prefix="" 

57    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=1099,1104,1130,1150,1151,1170,1174,1180,1200,1201,1207,1208,1212,1234,1243 log=no log-prefix="" 

58    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=1099,1104,1130,1150,1151,1170,1174,1180,1200,1201,1207,1208,1212,1234,1243 log=no log-prefix="" 

59    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=1245,1255,1256,1269,1272,1313,1337,1338,1349,1386,1394,1441,1466,1480,1492 log=no log-prefix="" 

60    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=1245,1255,1256,1269,1272,1313,1337,1338,1349,1386,1394,1441,1466,1480,1492 log=no log-prefix="" 

61    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=1722,1777,1784,1807,1826,1966,1967,1969,1981,1900,1966,1991,1999,2000-2005 log=no log-prefix="" 

62    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=1722,1777,1784,1807,1826,1966,1967,1969,1981,1900,1966,1991,1999,2000-2005 log=no log-prefix="" 

63    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=2023,2040,2828,2080,2115,2130,2140,2155,2255,2283,2300,2311,2330-2339,2345 log=no log-prefix="" 

64    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=2023,2040,2828,2080,2115,2130,2140,2155,2255,2283,2300,2311,2330-2339,2345 log=no log-prefix="" 

65    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=2400,2555,2565,2583,2589,2600,2702,2716,2773,2774,2801,2929,2989,3000,3024 log=no log-prefix="" 

66    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=2400,2555,2565,2583,2589,2600,2702,2716,2773,2774,2801,2929,2989,3000,3024 log=no log-prefix="" 

67    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=3028,3031,3033,3128,3129,3131,3150,3212,3332,3333,3456,3459,3586,3700,3777 log=no log-prefix="" 

68    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=3028,3031,3033,3128,3129,3131,3150,3212,3332,3333,3456,3459,3586,3700,3777 log=no log-prefix="" 

69    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=3791,3800,3801,4000,4092,4100,4201,4242,4321,4444,4488,4523,4545,4567,4590 log=no log-prefix="" 

70    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=3791,3800,3801,4000,4092,4100,4201,4242,4321,4444,4488,4523,4545,4567,4590 log=no log-prefix="" 

71    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=4653,4666,4950,5000-5002,5005,5010,5011,5025,5031-5033,5246-5247,5321,5333 log=no log-prefix="" 

72    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=4653,4666,4950,5000-5002,5005,5010,5011,5025,5031-5033,5246-5247,5321,5333 log=no log-prefix="" 

73    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=5343,5400-5402,5512,5534,5550,5555-5557,5569,5637,5638,5678,5714,5741,5742 log=no log-prefix="" 

74    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=5343,5400-5402,5512,5534,5550,5555-5557,5569,5637,5638,5678,5714,5741,5742 log=no log-prefix="" 

75    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=5760,5802,5810,5858,5873,5880-5890,6000,6006,6272,6343,6400,6661,6666-6670 log=no log-prefix="" 

76    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=5760,5802,5810,5858,5873,5880-5890,6000,6006,6272,6343,6400,6661,6666-6670 log=no log-prefix="" 

77    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=6711-6713,6723,6767,6771,6776,6789,6838,6883,6912,6939,6969,6970,7000,7001 log=no log-prefix="" 

78    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=6711-6713,6723,6767,6771,6776,6789,6838,6883,6912,6939,6969,6970,7000,7001 log=no log-prefix="" 

79    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=7028,7158,7215,7300,7301,7306,7307,7308,7410,7424,7511,7597,7626,7718,7777 log=no log-prefix="" 

80    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=7028,7158,7215,7300,7301,7306,7307,7308,7410,7424,7511,7597,7626,7718,7777 log=no log-prefix="" 

81    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=7788,7789,7826,7891,7983,8012,8080,8081,8685,8720,8728,8729,8812,8787,8812 log=no log-prefix="" 

82    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=7788,7789,7826,7891,7983,8012,8080,8081,8685,8720,8728,8729,8812,8787,8812 log=no log-prefix="" 

83    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=8899,8988,8989,9000,9325,9400,9697,9870-9878,9989,9999,10000,10005,10008,10013 log=no log-prefix="" 

84    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=8899,8988,8989,9000,9325,9400,9697,9870-9878,9989,9999,10000,10005,10008,10013 log=no log-prefix="" 

85    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=10067,10085,10086,10100,10101,10167,10498,10520,10528,10607,10666,11000,11011,11050,11051 log=no log-prefix="" 

86    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=10067,10085,10086,10100,10101,10167,10498,10520,10528,10607,10666,11000,11011,11050,11051 log=no log-prefix="" 

87    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=11223,11225,11306,11831,12076,12223,12310,12345-12349,12361-12363,12624,12631,12701,12754 log=no log-prefix="" 

88    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=11223,11225,11306,11831,12076,12223,12310,12345-12349,12361-12363,12624,12631,12701,12754 log=no log-prefix="" 

89    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=13000,13010,13013,13014,13223,13473,13700,14286,14500-14504,15000,15092,15104,15382,15858 log=no log-prefix="" 

90    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=13000,13010,13013,13014,13223,13473,13700,14286,14500-14504,15000,15092,15104,15382,15858 log=no log-prefix="" 

91    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=16484,16660,16772,16959,16969,16982,17166,17300,17449,17500,17569,17593,17777,18667,18753 log=no log-prefix="" 

92    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=16484,16660,16772,16959,16969,16982,17166,17300,17449,17500,17569,17593,17777,18667,18753 log=no log-prefix="" 

93    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=19864,20000-20005,20023,20034,20203,20331,20332,20432,20561,20433,21212,21544,21579,21684 log=no log-prefix="" 

94    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=19864,20000-20005,20023,20034,20203,20331,20332,20432,20561,20433,21212,21544,21579,21684 log=no log-prefix="" 

95    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=21957,22068,22222,22456,22845,22847,23005,23006,23023,23032,23321,23432,23456,23476,23477 log=no log-prefix="" 

96    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=21957,22068,22222,22456,22845,22847,23005,23006,23023,23032,23321,23432,23456,23476,23477 log=no log-prefix="" 

97    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=23777,24000,24289,25123,25386,25555,25685,25686,25982,26274,26681,27160,27374,27444,27573 log=no log-prefix="" 

98    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=23777,24000,24289,25123,25386,25555,25685,25686,25982,26274,26681,27160,27374,27444,27573 log=no log-prefix="" 

99    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=27665,28429-28436,28678,29104,29292,29369,29559,29891,30000-30005,30029,30100,30101-30103 log=no log-prefix="" 

100    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=27665,28429-28436,28678,29104,29292,29369,29559,29891,30000-30005,30029,30100,30101-30103 log=no log-prefix="" 

101    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=30133,30303,30700,30947,30999,31221,31320,31335-31339,31557,31666,31745,31785-31792,32001 log=no log-prefix="" 

102    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=30133,30303,30700,30947,30999,31221,31320,31335-31339,31557,31666,31745,31785-31792,32001 log=no log-prefix="" 

103    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=32100,32418,32791,33270,33333,33567,33568,33577,33777,33900,33911,34324,34444,34555,35555 log=no log-prefix="" 

104    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=32100,32418,32791,33270,33333,33567,33568,33577,33777,33900,33911,34324,34444,34555,35555 log=no log-prefix="" 

105    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=36794,37237,37266,37651,38741,39507,40412,40421-40426,40999,41337,41666,43210,44444,44575 log=no log-prefix="" 

106    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=36794,37237,37266,37651,38741,39507,40412,40421-40426,40999,41337,41666,43210,44444,44575 log=no log-prefix="" 

107    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=44767,45559,45673,47017,47252,47262,48004,48006,49000,49301,49683,50000,50130,50505,50766 log=no log-prefix="" 

108    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=44767,45559,45673,47017,47252,47262,48004,48006,49000,49301,49683,50000,50130,50505,50766 log=no log-prefix="" 

109    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=50767,51966,52317,53001,54283,54320,54321,55165,55166,57341,57922,58008,58009,58339,60000 log=no log-prefix="" 

110    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=50767,51966,52317,53001,54283,54320,54321,55165,55166,57341,57922,58008,58009,58339,60000 log=no log-prefix="" 

111    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=tcp in-interface=1-wan src-port=60001,60008,60068,60411,61348,61466,61603,63485,63536,64101,65000,65390,65421 log=no log-prefix="" 

112    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no protocol=udp in-interface=1-wan src-port=60001,60008,60068,60411,61348,61466,61603,63485,63536,64101,65000,65390,65421 log=no log-prefix="" 

113    ;;; or QOS all work traffik to mylan Part 2
      chain=forward action=mark-packet new-packet-mark=mywork2_dst_mark passthrough=no connection-state=established,related src-address-list=mylan_ip dst-address-list=mywork_ip in-interface=2-mylan out-interface=1-wan log=no log-prefix="" 

114    chain=forward action=mark-packet new-packet-mark=mywork_src_mark passthrough=no connection-state=established,related src-address-list=mywork_ip dst-address-list=mylan_ip in-interface=1-wan out-interface=2-mylan log=no log-prefix="" 

115    ;;; drop all from WAN not DSTNATed
      chain=forward action=add-src-to-address-list connection-state=new connection-nat-state=!dstnat src-address-list=!internal_provider_lan_forw address-list=internal_provider_lan_forw address-list-timeout=35w2d23h59m59s in-interface=1-wan log=no 
      log-prefix="" 

116    chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no src-address-list=internal_provider_lan_forw in-interface=1-wan log=no log-prefix="" 

117    ;;; or QOS all legal traffik to local devices
      chain=forward action=mark-packet new-packet-mark=legal_src_mark passthrough=no connection-state=established,related dst-address-list=local_ip in-interface=1-wan out-interface-list=lan+wifi log=no log-prefix="" 

118    chain=forward action=mark-packet new-packet-mark=legal_dst_mark passthrough=no connection-state=established,related src-address-list=local_ip out-interface=1-wan in-interface-list=lan+wifi log=no log-prefix="" 

119    ;;; drops
      chain=forward action=mark-packet new-packet-mark=drop_packets passthrough=no log=no log-prefix=""
