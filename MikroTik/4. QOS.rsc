0   name="src" parent=global packet-mark="" limit-at=89M queue=pcq-upload priority=8 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

 1   name="dst" parent=global packet-mark="" limit-at=89M queue=pcq-download priority=8 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

 2   name="dst-02" parent=dst packet-mark=ga_dst_mark limit-at=89M queue=pcq-download priority=1 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

 3   name="src-02" parent=src packet-mark=ga_src_mark limit-at=89M queue=pcq-upload priority=1 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

 4   name="dst-1000" parent=dst packet-mark=no-mark limit-at=89M queue=pcq-download priority=8 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

 5   name="src-1000" parent=src packet-mark=no-mark limit-at=89M queue=pcq-upload priority=8 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

 6   name="src-01" parent=src packet-mark=sip_src_mark limit-at=89M queue=pcq-upload priority=1 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

 7   name="dst-01" parent=dst packet-mark=sip_dst_mark limit-at=89M queue=pcq-download priority=1 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

 8   name="dst-04" parent=dst packet-mark=dns1_output_mark limit-at=89M queue=pcq-download priority=2 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

 9   name="dst-05" parent=dst packet-mark=dns2_output_mark limit-at=89M queue=pcq-download priority=3 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

10   name="src-04" parent=src packet-mark=dns1_input_mark limit-at=89M queue=pcq-upload priority=3 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

11   name="dst-09" parent=dst packet-mark=tcp1_syn_dst_mark limit-at=89M queue=pcq-download priority=5 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

12   name="dst-10" parent=dst packet-mark=tcp2_rst_dst_mark limit-at=89M queue=pcq-download priority=8 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

13   name="dst-11" parent=dst packet-mark=tcp3_ack_dst_mark limit-at=89M queue=pcq-download priority=6 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

14   name="src-08" parent=src packet-mark=tcp1_syn_ack_src_mark limit-at=89M queue=pcq-upload priority=5 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

15   name="src-10" parent=src packet-mark=tcp2_ack_src_mark limit-at=89M queue=pcq-upload priority=6 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

16   name="dst-12" parent=dst packet-mark=legal_dst_mark limit-at=89M queue=pcq-download priority=7 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

17   name="src-11" parent=src packet-mark=legal_src_mark limit-at=89M queue=pcq-upload priority=7 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

18   name="src-06" parent=src packet-mark=mywork_src_mark limit-at=89M queue=pcq-upload priority=3 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

19   name="dst-06" parent=dst packet-mark=mywork1_dst_mark limit-at=89M queue=pcq-download priority=2 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

20   name="dst-07" parent=dst packet-mark=mywork2_dst_mark limit-at=89M queue=pcq-download priority=3 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

21   name="dst-03" parent=dst packet-mark=messangers_traffik_dst limit-at=89M queue=pcq-download priority=2 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

22   name="src-03" parent=src packet-mark=messangers_traffik_src limit-at=89M queue=pcq-upload priority=2 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

23   name="dst-08" parent=dst packet-mark=legal_traffik_dst limit-at=89M queue=pcq-download priority=3 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

24   name="src-07" parent=src packet-mark=legal_src_mark limit-at=89M queue=pcq-upload priority=3 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1 

25   name="src-05" parent=src packet-mark=dns2_input_mark limit-at=89M queue=pcq-upload priority=3 max-limit=89M burst-limit=0 burst-threshold=0 burst-time=0s bucket-size=0.1
