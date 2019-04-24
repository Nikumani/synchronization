# ======================================================================
# Define options
# ======================================================================
set val(chan)           Channel/WirelessChannel    ;
set val(prop)           Propagation/TwoRayGround   ;
set val(netif)          Phy/WirelessPhy/802_15_4
set val(mac)            Mac/802_15_4
set val(ifq)            Queue/DropTail/PriQueue    ;
set val(ll)             LL                         ;
set val(ant)            Antenna/OmniAntenna        ;
set val(ifqlen)         150                        ;
set val(nn)             16                         ;
set val(rp)             AODV                       ;
set val(x)		50
set val(y)		50
set val(energymodel)    EnergyModel             ;
set val(initialenergy)  1                   ;


set val(nam)		SDS.nam
set val(traffic)	cbr ;


set appTime1            0;
set appTime2            8;
set appTime3            1;
set appTime4            9;
set appTime5            2;
set appTime6            10;
set appTime7            2;
set appTime8            10;
set appTime9            0;
set appTime10            8;
set appTime11            1;
set appTime12            9;
set appTime13            2;
set appTime14            10;
set appTime15            3;
set appTime16            10;
set appTime17            4;
set appTime18            10;
set appTime19            5;
set appTime20            10;
set appTime21            0;
set appTime22            8;
set appTime23            1;
set appTime24            9;
set appTime25            0;
set appTime26            8;
set appTime27            1;
set appTime28            9;
set appTime29            3;
set appTime30            10;
set appTime31            3;
set appTime32            10;
set appTime33            0;
set appTime34            8;
set appTime35            1;
set appTime36            9;
set appTime37            2;
set appTime38            10;
set appTime39            3;
set appTime40            10;
set appTime41            0;
set appTime42            8;
set appTime43            1;
set appTime44            9;
set appTime45            0;
set appTime46            8;
set appTime47            1;
set appTime48            9;
set appTime49            0;
set appTime50            8;
set appTime51            1;
set appTime52            9;
set appTime53            0;
set appTime54            8;
set appTime55            1;
set appTime56            9;


set stopTime            300	;# in seconds


# Initialize Global Variables
set ns_		[new Simulator]
#$ns_ use-newtrace             ;
set tracefd     [open ./SDS.tr w]
$ns_ trace-all $tracefd
if { "$val(nam)" == "SDS.nam" } {
        set namtrace     [open ./$val(nam) w]
        $ns_ namtrace-all-wireless $namtrace $val(x) $val(y)
}


$ns_ puts-nam-traceall {# nam4wpan #}		;# inform nam that this is a trace file for wpan (special handling needed)

Mac/802_15_4 wpanCmd verbose on		;
Mac/802_15_4 wpanNam namStatus on		;


# For model 'TwoRayGround'
set dist(5m)  7.69113e-06
set dist(9m)  2.37381e-06
set dist(10m) 1.92278e-06
set dist(11m) 1.58908e-06
set dist(12m) 1.33527e-06
set dist(13m) 1.13774e-06
set dist(14m) 9.81011e-07
set dist(15m) 8.54570e-07
set dist(20m) 8.91754e-6
set dist(22m) 6.0908e-6
set dist(30m) 1.7615e-6
set dist(40m) 1.20174e-07
set dist(60m) 1.1009e-7
set dist(120m) 	6.8808e-9
Phy/WirelessPhy set CSThresh_ $dist(40m)
Phy/WirelessPhy set RXThresh_ $dist(40m)


# set up topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)


# Create God
set god_ [create-god $val(nn)]

set chan_1_ [new $val(chan)]


# configure node
$ns_ node-config -adhocRouting $val(rp) \
               -llType $val(ll) \
               -macType $val(mac) \
               -ifqType $val(ifq) \
               -ifqLen $val(ifqlen) \
               -antType $val(ant) \
               -propType $val(prop) \
               -phyType $val(netif) \
               -topoInstance $topo \
               -agentTrace ON \
               -routerTrace ON \
               -macTrace ON \
               -movementTrace ON \
               -energyModel $val(energymodel) \
               -initialEnergy $val(initialenergy) \
               -rxPower 0.003 \
               -txPower 0.006 \
               -channel $chan_1_ 


for {set i 0} {$i < $val(nn) } {incr i} {
            set node_($i) [$ns_ node]
            $node_($i) random-motion 0		;
}


source ./SDS.scn

$ns_ at 0.0	"$node_(0) NodeLabel PAN Coor"
$ns_ at 0.0	"$node_(0) sscs startPANCoord 1 8 2 "		;
$ns_ at 0.062 	"$node_(1) sscs startDevice  1 8 2 "		;
$ns_ at 0.124 	"$node_(2) sscs startDevice  1 8 2 "		;
$ns_ at 0.186 	"$node_(3) sscs startDevice  1 8 2 "		;
$ns_ at 0.248 	"$node_(4) sscs startDevice  1 8 2 "		;
$ns_ at 0.310 	"$node_(5) sscs startDevice  1 8 2 "		;
$ns_ at 0.372 	"$node_(6) sscs startDevice  1 8 2 "		;
$ns_ at 0.434 	"$node_(7) sscs startDevice  1 8 2 "		;
$ns_ at 0.496 	"$node_(8) sscs startDevice  1 8 2 "		;
$ns_ at 5.6 	"$node_(9) sscs startDevice  1 8 2 "		;
$ns_ at 0.6 	"$node_(10) sscs startDevice  0 "		;
$ns_ at 0.6 	"$node_(11) sscs startDevice  0 "		;
$ns_ at 0.6 	"$node_(12) sscs startDevice  0 "		;
$ns_ at 0.6 	"$node_(13) sscs startDevice  0 "		;
$ns_ at 0.6 	"$node_(14) sscs startDevice  0 "		;
$ns_ at 0.6 	"$node_(15) sscs startDevice  0 "		;




# Setup traffic flow between nodes
if { ("$val(traffic)" == "cbr") } {
	puts "Traffic: $val(traffic)"
	puts [format "Acknowledgement for data: " [Mac/802_15_4 wpanCmd ack4data]]
	#Communication1
	set udp1 [new Agent/UDP]
	set sink1 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp1
	$ns_ attach-agent $node_(5) $sink1
	$ns_ connect $udp1 $sink1
	set cbr1 [new Application/Traffic/CBR]
	$cbr1 attach-agent $udp1
	$cbr1 set packetSize_ 100
	$cbr1 set rate_ 25000
        $cbr1 set interval_ 10 
	$cbr1 set random_ 0
	$ns_ at 0 "$cbr1 start "
	$ns_ at 8 "$cbr1 stop "


	#Communication2
	set udp2 [new Agent/UDP]
	set sink2 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp2
	$ns_ attach-agent $node_(0) $sink2
	$ns_ connect $udp2 $sink2
	set cbr2 [new Application/Traffic/CBR]
	$cbr2 attach-agent $udp2
        $cbr2 set packetSize_ 100
	$cbr2 set rate_ 25000
	$cbr2 set interval_ 10 
	$cbr2 set random_ 0
	$ns_ at 1 "$cbr2 start "
	$ns_ at 9 "$cbr2 stop "


	#Communication3
	set udp3 [new Agent/UDP]
	set sink3 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp3
	$ns_ attach-agent $node_(5) $sink3
	$ns_ connect $udp3 $sink3
	set cbr3 [new Application/Traffic/CBR]
	$cbr3 attach-agent $udp3
	$cbr3 set packetSize_ 100
	$cbr3 set rate_ 25000	
	$cbr3 set interval_ 10 
	$cbr3 set random_ 0
	$ns_ at 2 "$cbr3 start "
	$ns_ at 10 "$cbr3 stop "


	#Communication4
	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp4
	$ns_ attach-agent $node_(7) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 100
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 2 "$cbr4 start "
	$ns_ at 10 "$cbr4 stop "


	#Communication5
	set udp5 [new Agent/UDP]
	set sink5 [new Agent/Null]
	$ns_ attach-agent $node_(8) $udp5
	$ns_ attach-agent $node_(7) $sink5
	$ns_ connect $udp5 $sink5
	set cbr5 [new Application/Traffic/CBR]
	$cbr5 attach-agent $udp5
	$cbr5 set packetSize_ 100
	$cbr5 set rate_ 25000	
	$cbr5 set interval_ 10 
	$cbr5 set random_ 0
	$ns_ at 0 "$cbr5 start "
	$ns_ at 8 "$cbr5 stop "


	#Communication6
	set udp6 [new Agent/UDP]
	set sink6 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp6
	$ns_ attach-agent $node_(5) $sink6
	$ns_ connect $udp6 $sink6
	set cbr6 [new Application/Traffic/CBR]
	$cbr6 attach-agent $udp6
	$cbr6 set packetSize_ 100
	$cbr6 set rate_ 25000
	$cbr6 set interval_ 10 
	$cbr6 set random_ 0
	$ns_ at 1 "$cbr6 start "
	$ns_ at 9 "$cbr6 stop "


	#Communication7
	set udp7 [new Agent/UDP]
	set sink7 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp7
	$ns_ attach-agent $node_(0) $sink7
	$ns_ connect $udp7 $sink7
	set cbr7 [new Application/Traffic/CBR]
	$cbr7 attach-agent $udp7
	$cbr7 set packetSize_ 100
	$cbr7 set rate_ 25000
	$cbr7 set interval_ 10 
	$cbr7 set random_ 0
	$ns_ at 2 "$cbr7 start "
	$ns_ at 10 "$cbr7 stop "


	#Communication8
	set udp8 [new Agent/UDP]
	set sink8 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp8
	$ns_ attach-agent $node_(5) $sink8
	$ns_ connect $udp8 $sink8
	set cbr8 [new Application/Traffic/CBR]
	$cbr8 attach-agent $udp8
	$cbr8 set packetSize_ 100
	$cbr8 set rate_ 25000
	$cbr8 set interval_ 10 
	$cbr8 set random_ 0
	$ns_ at 3 "$cbr8 start "
	$ns_ at 10 "$cbr8 stop "


	#Communication9
	set udp9 [new Agent/UDP]
	set sink9 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp9
	$ns_ attach-agent $node_(7) $sink9
	$ns_ connect $udp9 $sink9
	set cbr9 [new Application/Traffic/CBR]
	$cbr9 attach-agent $udp9
	$cbr9 set packetSize_ 100
	$cbr9 set rate_ 25000
	$cbr9 set interval_ 10 
	$cbr9 set random_ 0
	$ns_ at 4 "$cbr9 start "
	$ns_ at 10 "$cbr9 stop "


	#Communication10
	set udp10 [new Agent/UDP]
	set sink10 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp10
	$ns_ attach-agent $node_(8) $sink10
	$ns_ connect $udp10 $sink10
	set cbr10 [new Application/Traffic/CBR]
	$cbr10 attach-agent $udp10
	$cbr10 set packetSize_ 100
	$cbr10 set rate_ 25000
	$cbr10 set interval_ 10 
	$cbr10 set random_ 0
	$ns_ at 5 "$cbr10 start "
	$ns_ at 10 "$cbr10 stop "


	#Communication11
	set udp11 [new Agent/UDP]
	set sink11 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp11
	$ns_ attach-agent $node_(0) $sink11
	$ns_ connect $udp11 $sink11
	set cbr11 [new Application/Traffic/CBR]
	$cbr11 attach-agent $udp11
	$cbr11 set packetSize_ 100
	$cbr11 set rate_ 25000
	$cbr11 set interval_ 10 
	$cbr11 set random_ 0
	$ns_ at 0 "$cbr11 start "
	$ns_ at 8 "$cbr11 stop "


	#Communication12
	set udp12 [new Agent/UDP]
	set sink12 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp12
	$ns_ attach-agent $node_(5) $sink12
	$ns_ connect $udp12 $sink12
	set cbr12 [new Application/Traffic/CBR]
	$cbr12 attach-agent $udp12
	$cbr12 set packetSize_ 100
	$cbr12 set rate_ 25000
	$cbr12 set interval_ 10 
	$cbr12 set random_ 0
	$ns_ at 1 "$cbr12 start "
	$ns_ at 9 "$cbr12 stop "


	#Communication13
	set udp13 [new Agent/UDP]
	set sink13 [new Agent/Null]
	$ns_ attach-agent $node_(6) $udp13
	$ns_ attach-agent $node_(5) $sink13
	$ns_ connect $udp13 $sink13
	set cbr13 [new Application/Traffic/CBR]
	$cbr13 attach-agent $udp13
	$cbr13 set packetSize_ 100
	$cbr13 set rate_ 25000
	$cbr13 set interval_ 10 
	$cbr13 set random_ 0
	$ns_ at 0 "$cbr13 start "
	$ns_ at 8 "$cbr13 stop "


	#Communication14
	set udp14 [new Agent/UDP]
	set sink14 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp14
	$ns_ attach-agent $node_(0) $sink14
	$ns_ connect $udp14 $sink14
	set cbr14 [new Application/Traffic/CBR]
	$cbr14 attach-agent $udp14
	$cbr14 set packetSize_ 100
	$cbr14 set rate_ 25000
	$cbr14 set interval_ 10 
	$cbr14 set random_ 0
	$ns_ at 1 "$cbr14 start "
	$ns_ at 9 "$cbr14 stop "


	#Communication15
	set udp15 [new Agent/UDP]
	set sink15 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp15
	$ns_ attach-agent $node_(5) $sink15
	$ns_ connect $udp15 $sink15
	set cbr15 [new Application/Traffic/CBR]
	$cbr15 attach-agent $udp15
	$cbr15 set packetSize_ 100
	$cbr15 set rate_ 25000
	$cbr15 set interval_ 10 
	$cbr15 set random_ 0
	$ns_ at 3 "$cbr15 start "
	$ns_ at 10 "$cbr15 stop "


	#Communication16
	set udp16 [new Agent/UDP]
	set sink16 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp16
	$ns_ attach-agent $node_(6) $sink16
	$ns_ connect $udp16 $sink16
	set cbr16 [new Application/Traffic/CBR]
	$cbr16 attach-agent $udp16
	$cbr16 set packetSize_ 100
	$cbr16 set rate_ 25000
	$cbr16 set interval_ 10 
	$cbr16 set random_ 0
	$ns_ at 3 "$cbr16 start "
	$ns_ at 10 "$cbr16 stop "


	#Communication17
	set udp17 [new Agent/UDP]
	set sink17 [new Agent/Null]
	$ns_ attach-agent $node_(9) $udp17
	$ns_ attach-agent $node_(4) $sink17
	$ns_ connect $udp17 $sink17
	set cbr17 [new Application/Traffic/CBR]
	$cbr17 attach-agent $udp17
	$cbr17 set packetSize_ 100
	$cbr17 set rate_ 25000
	$cbr17 set interval_ 10 
	$cbr17 set random_ 0
	$ns_ at 0 "$cbr17 start "
	$ns_ at 8 "$cbr17 stop "


	#Communication18
	set udp18 [new Agent/UDP]
	set sink18 [new Agent/Null]
	$ns_ attach-agent $node_(4) $udp18
	$ns_ attach-agent $node_(0) $sink18
	$ns_ connect $udp18 $sink18
	set cbr18 [new Application/Traffic/CBR]
	$cbr18 attach-agent $udp18
	$cbr18 set packetSize_ 100
	$cbr18 set rate_ 25000
	$cbr18 set interval_ 10 
	$cbr18 set random_ 0
	$ns_ at 1 "$cbr18 start "
	$ns_ at 9 "$cbr18 stop "


	#Communication19
	set udp19 [new Agent/UDP]
	set sink19 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp19
	$ns_ attach-agent $node_(4) $sink19
	$ns_ connect $udp19 $sink19
	set cbr19 [new Application/Traffic/CBR]
	$cbr19 attach-agent $udp19
	$cbr19 set packetSize_ 100
	$cbr19 set rate_ 25000
	$cbr19 set interval_ 10 
	$cbr19 set random_ 0
	$ns_ at 2 "$cbr19 start "
	$ns_ at 10 "$cbr19 stop "


	#Communication20
	set udp20 [new Agent/UDP]
	set sink20 [new Agent/Null]
	$ns_ attach-agent $node_(4) $udp20
	$ns_ attach-agent $node_(9) $sink20
	$ns_ connect $udp20 $sink20
	set cbr20 [new Application/Traffic/CBR]
	$cbr20 attach-agent $udp20
	$cbr20 set packetSize_ 100
	$cbr20 set rate_ 25000
	$cbr20 set interval_ 10 
	$cbr20 set random_ 0
	$ns_ at 3 "$cbr20 start "
	$ns_ at 10 "$cbr20 stop "


	#Communication21
	set udp21 [new Agent/UDP]
	set sink21 [new Agent/Null]
	$ns_ attach-agent $node_(4) $udp21
	$ns_ attach-agent $node_(0) $sink21
	$ns_ connect $udp21 $sink21
	set cbr21 [new Application/Traffic/CBR]
	$cbr21 attach-agent $udp21
	$cbr21 set packetSize_ 100
	$cbr21 set rate_ 25000
	$cbr21 set interval_ 10 
	$cbr21 set random_ 0
	$ns_ at 0 "$cbr21 start "
	$ns_ at 8 "$cbr21 stop "


	#Communication22
	set udp22 [new Agent/UDP]
	set sink22 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp22
	$ns_ attach-agent $node_(4) $sink22
	$ns_ connect $udp22 $sink22
	set cbr22 [new Application/Traffic/CBR]
	$cbr22 attach-agent $udp22
	$cbr22 set packetSize_ 100
	$cbr22 set rate_ 25000
	$cbr22 set interval_ 10 
	$cbr22 set random_ 0
	$ns_ at 1 "$cbr22 start "
	$ns_ at 9 "$cbr22 stop "


	#Communication23
	set udp23 [new Agent/UDP]
	set sink23 [new Agent/Null]
	$ns_ attach-agent $node_(3) $udp23
	$ns_ attach-agent $node_(0) $sink23
	$ns_ connect $udp23 $sink23
	set cbr23 [new Application/Traffic/CBR]
	$cbr23 attach-agent $udp23
	$cbr23 set packetSize_ 100
	$cbr23 set rate_ 25000
	$cbr23 set interval_ 10 
	$cbr23 set random_ 0
	$ns_ at 0 "$cbr23 start "
	$ns_ at 8 "$cbr23 stop "


	#Communication24
	set udp24 [new Agent/UDP]
	set sink24 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp24
	$ns_ attach-agent $node_(3) $sink24
	$ns_ connect $udp24 $sink24
	set cbr24 [new Application/Traffic/CBR]
	$cbr24 attach-agent $udp24
	$cbr24 set packetSize_ 100
	$cbr24 set rate_ 25000
	$cbr24 set interval_ 10 
	$cbr24 set random_ 0
	$ns_ at 1 "$cbr24 start "
	$ns_ at 9 "$cbr24 stop "


	#Communication25
	set udp25 [new Agent/UDP]
	set sink25 [new Agent/Null]
	$ns_ attach-agent $node_(2) $udp25
	$ns_ attach-agent $node_(0) $sink25
	$ns_ connect $udp25 $sink25
	set cbr25 [new Application/Traffic/CBR]
	$cbr25 attach-agent $udp25
	$cbr25 set packetSize_ 100
	$cbr25 set rate_ 25000
	$cbr25 set interval_ 10 
	$cbr25 set random_ 0
	$ns_ at 0 "$cbr25 start "
	$ns_ at 8 "$cbr25 stop "


	#Communication26
	set udp26 [new Agent/UDP]
	set sink26 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp26
	$ns_ attach-agent $node_(2) $sink26
	$ns_ connect $udp26 $sink26
	set cbr26 [new Application/Traffic/CBR]
	$cbr26 attach-agent $udp26
	$cbr26 set packetSize_ 100
	$cbr26 set rate_ 25000
	$cbr26 set interval_ 10 
	$cbr26 set random_ 0
	$ns_ at 1 "$cbr26 start "
	$ns_ at 9 "$cbr26 stop "


	#Communication27
	set udp27 [new Agent/UDP]
	set sink27 [new Agent/Null]
	$ns_ attach-agent $node_(1) $udp27
	$ns_ attach-agent $node_(0) $sink27
	$ns_ connect $udp27 $sink27
	set cbr27 [new Application/Traffic/CBR]
	$cbr27 attach-agent $udp27
	$cbr27 set packetSize_ 100
	$cbr27 set rate_ 25000
	$cbr27 set interval_ 10 
	$cbr27 set random_ 0
	$ns_ at 0 "$cbr27 start "
	$ns_ at 8 "$cbr27 stop "


	#Communication28
	set udp28 [new Agent/UDP]
	set sink28 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp28
	$ns_ attach-agent $node_(1) $sink28
	$ns_ connect $udp28 $sink28
	set cbr28 [new Application/Traffic/CBR]
	$cbr28 attach-agent $udp28
	$cbr28 set packetSize_ 100
	$cbr28 set rate_ 25000
	$cbr28 set interval_ 10 
	$cbr28 set random_ 0
	$ns_ at 1 "$cbr28 start "
	$ns_ at 9 "$cbr28 stop "


	Mac/802_15_4 wpanNam FlowClr -p AODV -c tomato
	Mac/802_15_4 wpanNam FlowClr -p ARP -c green
	Mac/802_15_4 wpanNam FlowClr -p MAC -s 0 -d -1 -c navy
	if { "$val(traffic)" == "cbr" } {
		set pktType cbr
	} else {
		set pktType exp
	}


	$ns_ at $appTime1 "$ns_ trace-annotate \"(at $appTime1) $val(traffic) traffic from node 7 to node 5\" "
	Mac/802_15_4 wpanNam FlowClr -p $pktType -s 7 -d 5 -c blue
	$ns_ at $appTime3 "$ns_ trace-annotate \"(at $appTime3) $val(traffic) traffic from node 5 to node 0\" "
	Mac/802_15_4 wpanNam FlowClr -p $pktType -s 5 -d 0 -c green4
	$ns_ at $appTime5 "$ns_ trace-annotate \"(at $appTime5) $val(traffic) traffic from node 0 to node 5\" "
	Mac/802_15_4 wpanNam FlowClr -p $pktType -s 0 -d 5 -c cyan4
	$ns_ at $appTime7 "$ns_ trace-annotate \"(at $appTime7) $val(traffic) traffic from node 5 to node 7\" "
	Mac/802_15_4 wpanNam FlowClr -p $pktType -s 5 -d 7 -c red
	$ns_ at $appTime9 "$ns_ trace-annotate \"(at $appTime9) $val(traffic) traffic from node 8 to node 7\" "
	$ns_ at $appTime11 "$ns_ trace-annotate \"(at $appTime11) $val(traffic) traffic from node 7 to node 5\" "
	$ns_ at $appTime13 "$ns_ trace-annotate \"(at $appTime13) $val(traffic) traffic from node 5 to node 0\" "
	$ns_ at $appTime15 "$ns_ trace-annotate \"(at $appTime15) $val(traffic) traffic from node 0 to node 5\" "
	$ns_ at $appTime17 "$ns_ trace-annotate \"(at $appTime17) $val(traffic) traffic from node 5 to node 7\" "
	$ns_ at $appTime19 "$ns_ trace-annotate \"(at $appTime19) $val(traffic) traffic from node 7 to node 8\" "
	$ns_ at $appTime21 "$ns_ trace-annotate \"(at $appTime21) $val(traffic) traffic from node 5 to node 0\" "
	$ns_ at $appTime23 "$ns_ trace-annotate \"(at $appTime23) $val(traffic) traffic from node 0 to node 5\" "
	$ns_ at $appTime25 "$ns_ trace-annotate \"(at $appTime25) $val(traffic) traffic from node 6 to node 5\" "
	$ns_ at $appTime27 "$ns_ trace-annotate \"(at $appTime27) $val(traffic) traffic from node 5 to node 0\" "
	$ns_ at $appTime29 "$ns_ trace-annotate \"(at $appTime29) $val(traffic) traffic from node 0 to node 5\" "
	$ns_ at $appTime31 "$ns_ trace-annotate \"(at $appTime31) $val(traffic) traffic from node 5 to node 6\" "
	$ns_ at $appTime33 "$ns_ trace-annotate \"(at $appTime33) $val(traffic) traffic from node 9 to node 4\" "
	$ns_ at $appTime35 "$ns_ trace-annotate \"(at $appTime35) $val(traffic) traffic from node 4 to node 0\" "
	$ns_ at $appTime37 "$ns_ trace-annotate \"(at $appTime37) $val(traffic) traffic from node 0 to node 4\" "
	$ns_ at $appTime39 "$ns_ trace-annotate \"(at $appTime39) $val(traffic) traffic from node 4 to node 9\" "
	$ns_ at $appTime41 "$ns_ trace-annotate \"(at $appTime41) $val(traffic) traffic from node 4 to node 0\" "
	$ns_ at $appTime43 "$ns_ trace-annotate \"(at $appTime43) $val(traffic) traffic from node 0 to node 4\" "
	$ns_ at $appTime45 "$ns_ trace-annotate \"(at $appTime45) $val(traffic) traffic from node 3 to node 0\" "
	$ns_ at $appTime47 "$ns_ trace-annotate \"(at $appTime47) $val(traffic) traffic from node 0 to node 3\" "
	$ns_ at $appTime49 "$ns_ trace-annotate \"(at $appTime49) $val(traffic) traffic from node 2 to node 0\" "
	$ns_ at $appTime51 "$ns_ trace-annotate \"(at $appTime51) $val(traffic) traffic from node 0 to node 2\" "
	$ns_ at $appTime53 "$ns_ trace-annotate \"(at $appTime53) $val(traffic) traffic from node 1 to node 0\" "
	$ns_ at $appTime55 "$ns_ trace-annotate \"(at $appTime55) $val(traffic) traffic from node 0 to node 1\" "
}




# defines the node size in nam
for {set i 0} {$i < $val(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 2 
}

# Tell nodes when the simulation ends
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at $stopTime "$node_($i) reset";
}

$ns_ at $stopTime "stop"
$ns_ at $stopTime "puts \"\nNS EXITING...\""
$ns_ at $stopTime "$ns_ halt"

proc stop {} {

	global ns_ tracefd val env 

	$ns_ flush-trace
	close $tracefd
	set hasDISPLAY 0

	foreach index [array names env] {
		#puts "$index: $env($index)"
		if { ("$index" == "DISPLAY") && ("$env($index)" != "") } {
			set hasDISPLAY 1
		}
	}

	if { ("$val(nam)" == "SDS.nam") && ("$hasDISPLAY" == "1") } {
		exec nam SDS.nam &
	}

	exit 0

}

puts "\nStarting Simulation..."
$ns_ run
