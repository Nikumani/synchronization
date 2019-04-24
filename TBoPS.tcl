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


set val(nam)		TBoPS.nam
set val(traffic)	cbr ;


set appTime1            0;
set appTime2            60;
set appTime3            0;
set appTime4            60;
set appTime5            0;
set appTime6            60;
set appTime7            0;
set appTime8            60;
set appTime9            0;
set appTime10            60;
set appTime11            0;
set appTime12            60;
set appTime13            0;
set appTime14            60;
set appTime15            0;
set appTime16            60;
set appTime17            0;
set appTime18            60;
set appTime19            0;
set appTime20            60;
set appTime21            0;
set appTime22            60;
set appTime23            0;
set appTime24            60;
set appTime25            0;
set appTime26            60;
set appTime27            0;
set appTime28            60;
set appTime29            0;
set appTime30            60;
set appTime31            0;
set appTime32            60;
set appTime33            0;
set appTime34            60;
set appTime35            0;
set appTime36            60;


set stopTime            300	;# in seconds


# Initialize Global Variables
set ns_		[new Simulator]
#$ns_ use-newtrace             ;
set tracefd     [open ./TBoPS.tr w]
$ns_ trace-all $tracefd
if { "$val(nam)" == "TBoPS.nam" } {
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
set dist(50m) 2.28288901e-7
Phy/WirelessPhy set CSThresh_ $dist(50m)
Phy/WirelessPhy set RXThresh_ $dist(50m)


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


source ./TBoPS.scn

$ns_ at 0.0	"$node_(0) NodeLabel PAN Coor"
$ns_ at 0.0	"$node_(0) sscs startPANCoord 1 8 2 "		;
$ns_ at 0.0 	"$node_(1) sscs startDevice  1 8 2 "		;
$ns_ at 0.0 	"$node_(2) sscs startDevice  1 8 2 "		;
$ns_ at 0.0 	"$node_(3) sscs startDevice  1 8 2 "		;
$ns_ at 0.0 	"$node_(4) sscs startDevice  1 8 2 "		;
$ns_ at 0.0 	"$node_(5) sscs startDevice  1 8 2 "		;
$ns_ at 0.0 	"$node_(6) sscs startDevice  1 8 2 "		;
$ns_ at 0.0 	"$node_(7) sscs startDevice  1 8 2 "		;
$ns_ at 0.0 	"$node_(8) sscs startDevice  1 8 2 "		;
$ns_ at 0.0 	"$node_(9) sscs startDevice  1 8 2 "		;
$ns_ at 0.0 	"$node_(10) sscs startDevice  0 "		;
$ns_ at 0.0 	"$node_(11) sscs startDevice  0 "		;
$ns_ at 0.0 	"$node_(12) sscs startDevice  0 "		;
$ns_ at 0.0 	"$node_(13) sscs startDevice  0 "		;
$ns_ at 0.0 	"$node_(14) sscs startDevice  0 "		;
$ns_ at 0.0 	"$node_(15) sscs startDevice  0 "		;




# Setup traffic flow between nodes
if { ("$val(traffic)" == "cbr") } {
	puts "Traffic: $val(traffic)"
	puts [format "Acknowledgement for data: " [Mac/802_15_4 wpanCmd ack4data]]
	#Communication1
	set udp1 [new Agent/UDP]
	set sink1 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp1
	$ns_ attach-agent $node_(1) $sink1
	$ns_ connect $udp1 $sink1
	set cbr1 [new Application/Traffic/CBR]
	$cbr1 attach-agent $udp1
	$cbr1 set packetSize_ 30
	$cbr1 set interval_ 30 
	$cbr1 set random_ 0
	$ns_ at 0 "$cbr1 start "
	$ns_ at 60 "$cbr1 stop "


	#Communication2
	set udp2 [new Agent/UDP]
	set sink2 [new Agent/Null]
	$ns_ attach-agent $node_(1) $udp2
	$ns_ attach-agent $node_(0) $sink2
	$ns_ connect $udp2 $sink2
	set cbr2 [new Application/Traffic/CBR]
	$cbr2 attach-agent $udp2
	$cbr2 set packetSize_ 30
	$cbr2 set interval_ 30 
	$cbr2 set random_ 0
	$ns_ at 0 "$cbr2 start "
	$ns_ at 60 "$cbr2 stop "


	#Communication3
	set udp3 [new Agent/UDP]
	set sink3 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp3
	$ns_ attach-agent $node_(2) $sink3
	$ns_ connect $udp3 $sink3
	set cbr3 [new Application/Traffic/CBR]
	$cbr3 attach-agent $udp3
	$cbr3 set packetSize_ 30
	$cbr3 set interval_ 30 
	$cbr3 set random_ 0
	$ns_ at 0 "$cbr3 start "
	$ns_ at 60 "$cbr3 stop "


	#Communication4
	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(2) $udp4
	$ns_ attach-agent $node_(0) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 30
	$cbr4 set interval_ 30 
	$cbr4 set random_ 0
	$ns_ at 0 "$cbr4 start "
	$ns_ at 60 "$cbr4 stop "


	#Communication5
	set udp5 [new Agent/UDP]
	set sink5 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp5
	$ns_ attach-agent $node_(3) $sink5
	$ns_ connect $udp5 $sink5
	set cbr5 [new Application/Traffic/CBR]
	$cbr5 attach-agent $udp5
	$cbr5 set packetSize_ 30
	$cbr5 set interval_ 30 
	$cbr5 set random_ 0
	$ns_ at 0 "$cbr5 start "
	$ns_ at 60 "$cbr5 stop "


	#Communication6
	set udp6 [new Agent/UDP]
	set sink6 [new Agent/Null]
	$ns_ attach-agent $node_(3) $udp6
	$ns_ attach-agent $node_(0) $sink6
	$ns_ connect $udp6 $sink6
	set cbr6 [new Application/Traffic/CBR]
	$cbr6 attach-agent $udp6
	$cbr6 set packetSize_ 30
	$cbr6 set interval_ 30 
	$cbr6 set random_ 0
	$ns_ at 0 "$cbr6 start "
	$ns_ at 60 "$cbr6 stop "


	#Communication7
	set udp7 [new Agent/UDP]
	set sink7 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp7
	$ns_ attach-agent $node_(4) $sink7
	$ns_ connect $udp7 $sink7
	set cbr7 [new Application/Traffic/CBR]
	$cbr7 attach-agent $udp7
	$cbr7 set packetSize_ 30
	$cbr7 set interval_ 30 
	$cbr7 set random_ 0
	$ns_ at 0 "$cbr7 start "
	$ns_ at 60 "$cbr7 stop "


	#Communication8
	set udp8 [new Agent/UDP]
	set sink8 [new Agent/Null]
	$ns_ attach-agent $node_(4) $udp8
	$ns_ attach-agent $node_(0) $sink8
	$ns_ connect $udp8 $sink8
	set cbr8 [new Application/Traffic/CBR]
	$cbr8 attach-agent $udp8
	$cbr8 set packetSize_ 30
	$cbr8 set interval_ 30 
	$cbr8 set random_ 0
	$ns_ at 0 "$cbr8 start "
	$ns_ at 60 "$cbr8 stop "


	#Communication9
	set udp9 [new Agent/UDP]
	set sink9 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp9
	$ns_ attach-agent $node_(5) $sink9
	$ns_ connect $udp9 $sink9
	set cbr9 [new Application/Traffic/CBR]
	$cbr9 attach-agent $udp9
	$cbr9 set packetSize_ 30
	$cbr9 set interval_ 30 
	$cbr9 set random_ 0
	$ns_ at 0 "$cbr9 start "
	$ns_ at 60 "$cbr9 stop "


	#Communication10
	set udp10 [new Agent/UDP]
	set sink10 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp10
	$ns_ attach-agent $node_(0) $sink10
	$ns_ connect $udp10 $sink10
	set cbr10 [new Application/Traffic/CBR]
	$cbr10 attach-agent $udp10
	$cbr10 set packetSize_ 30
	$cbr10 set interval_ 30 
	$cbr10 set random_ 0
	$ns_ at 0 "$cbr10 start "
	$ns_ at 60 "$cbr10 stop "


	#Communication11
	set udp11 [new Agent/UDP]
	set sink11 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp11
	$ns_ attach-agent $node_(6) $sink11
	$ns_ connect $udp11 $sink11
	set cbr11 [new Application/Traffic/CBR]
	$cbr11 attach-agent $udp11
	$cbr11 set packetSize_ 30
	$cbr11 set interval_ 30 
	$cbr11 set random_ 0
	$ns_ at 0 "$cbr11 start "
	$ns_ at 60 "$cbr11 stop "


	#Communication12
	set udp12 [new Agent/UDP]
	set sink12 [new Agent/Null]
	$ns_ attach-agent $node_(6) $udp12
	$ns_ attach-agent $node_(5) $sink12
	$ns_ connect $udp12 $sink12
	set cbr12 [new Application/Traffic/CBR]
	$cbr12 attach-agent $udp12
	$cbr12 set packetSize_ 30
	$cbr12 set interval_ 30 
	$cbr12 set random_ 0
	$ns_ at 0 "$cbr12 start "
	$ns_ at 60 "$cbr12 stop "


	#Communication13
	set udp13 [new Agent/UDP]
	set sink13 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp13
	$ns_ attach-agent $node_(7) $sink13
	$ns_ connect $udp13 $sink13
	set cbr13 [new Application/Traffic/CBR]
	$cbr13 attach-agent $udp13
	$cbr13 set packetSize_ 30
	$cbr13 set interval_ 30 
	$cbr13 set random_ 0
	$ns_ at 0 "$cbr13 start "
	$ns_ at 60 "$cbr13 stop "


	#Communication14
	set udp14 [new Agent/UDP]
	set sink14 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp14
	$ns_ attach-agent $node_(5) $sink14
	$ns_ connect $udp14 $sink14
	set cbr14 [new Application/Traffic/CBR]
	$cbr14 attach-agent $udp14
	$cbr14 set packetSize_ 30
	$cbr14 set interval_ 30 
	$cbr14 set random_ 0
	$ns_ at 0 "$cbr14 start "
	$ns_ at 60 "$cbr14 stop "


	#Communication15
	set udp15 [new Agent/UDP]
	set sink15 [new Agent/Null]
	$ns_ attach-agent $node_(4) $udp15
	$ns_ attach-agent $node_(9) $sink15
	$ns_ connect $udp15 $sink15
	set cbr15 [new Application/Traffic/CBR]
	$cbr15 attach-agent $udp15
	$cbr15 set packetSize_ 30
	$cbr15 set interval_ 30 
	$cbr15 set random_ 0
	$ns_ at 0 "$cbr15 start "
	$ns_ at 60 "$cbr15 stop "


	#Communication16
	set udp16 [new Agent/UDP]
	set sink16 [new Agent/Null]
	$ns_ attach-agent $node_(9) $udp16
	$ns_ attach-agent $node_(4) $sink16
	$ns_ connect $udp16 $sink16
	set cbr16 [new Application/Traffic/CBR]
	$cbr16 attach-agent $udp16
	$cbr16 set packetSize_ 30
	$cbr16 set interval_ 30 
	$cbr16 set random_ 0
	$ns_ at 0 "$cbr16 start "
	$ns_ at 60 "$cbr16 stop "


	#Communication17
	set udp17 [new Agent/UDP]
	set sink17 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp17
	$ns_ attach-agent $node_(8) $sink17
	$ns_ connect $udp17 $sink17
	set cbr17 [new Application/Traffic/CBR]
	$cbr17 attach-agent $udp17
	$cbr17 set packetSize_ 30
	$cbr17 set interval_ 30 
	$cbr17 set random_ 0
	$ns_ at 0 "$cbr17 start "
	$ns_ at 60 "$cbr17 stop "


	#Communication18
	set udp18 [new Agent/UDP]
	set sink18 [new Agent/Null]
	$ns_ attach-agent $node_(8) $udp18
	$ns_ attach-agent $node_(7) $sink18
	$ns_ connect $udp18 $sink18
	set cbr18 [new Application/Traffic/CBR]
	$cbr18 attach-agent $udp18
	$cbr18 set packetSize_ 30
	$cbr18 set interval_ 30 
	$cbr18 set random_ 0
	$ns_ at 0 "$cbr18 start "
	$ns_ at 60 "$cbr18 stop "


	Mac/802_15_4 wpanNam FlowClr -p AODV -c tomato
	Mac/802_15_4 wpanNam FlowClr -p ARP -c green
	Mac/802_15_4 wpanNam FlowClr -p MAC -s 0 -d -1 -c navy
	if { "$val(traffic)" == "cbr" } {
		set pktType cbr
	} else {
		set pktType exp
	}


	$ns_ at $appTime1 "$ns_ trace-annotate \"(at $appTime1) $val(traffic) traffic from node 0 to node 1\" "
	Mac/802_15_4 wpanNam FlowClr -p $pktType -s 0 -d 1 -c blue
	$ns_ at $appTime3 "$ns_ trace-annotate \"(at $appTime3) $val(traffic) traffic from node 1 to node 0\" "
	Mac/802_15_4 wpanNam FlowClr -p $pktType -s 1 -d 0 -c green4
	$ns_ at $appTime5 "$ns_ trace-annotate \"(at $appTime5) $val(traffic) traffic from node 0 to node 2\" "
	Mac/802_15_4 wpanNam FlowClr -p $pktType -s 0 -d 2 -c cyan4
	$ns_ at $appTime7 "$ns_ trace-annotate \"(at $appTime7) $val(traffic) traffic from node 2 to node 0\" "
	Mac/802_15_4 wpanNam FlowClr -p $pktType -s 2 -d 0 -c red
	$ns_ at $appTime9 "$ns_ trace-annotate \"(at $appTime9) $val(traffic) traffic from node 0 to node 3\" "
	$ns_ at $appTime11 "$ns_ trace-annotate \"(at $appTime11) $val(traffic) traffic from node 3 to node 0\" "
	$ns_ at $appTime13 "$ns_ trace-annotate \"(at $appTime13) $val(traffic) traffic from node 0 to node 4\" "
	$ns_ at $appTime15 "$ns_ trace-annotate \"(at $appTime15) $val(traffic) traffic from node 4 to node 0\" "
	$ns_ at $appTime17 "$ns_ trace-annotate \"(at $appTime17) $val(traffic) traffic from node 0 to node 5\" "
	$ns_ at $appTime19 "$ns_ trace-annotate \"(at $appTime19) $val(traffic) traffic from node 5 to node 0\" "
	$ns_ at $appTime21 "$ns_ trace-annotate \"(at $appTime21) $val(traffic) traffic from node 5 to node 6\" "
	$ns_ at $appTime23 "$ns_ trace-annotate \"(at $appTime23) $val(traffic) traffic from node 6 to node 5\" "
	$ns_ at $appTime25 "$ns_ trace-annotate \"(at $appTime25) $val(traffic) traffic from node 5 to node 7\" "
	$ns_ at $appTime27 "$ns_ trace-annotate \"(at $appTime27) $val(traffic) traffic from node 7 to node 5\" "
	$ns_ at $appTime29 "$ns_ trace-annotate \"(at $appTime29) $val(traffic) traffic from node 4 to node 9\" "
	$ns_ at $appTime31 "$ns_ trace-annotate \"(at $appTime31) $val(traffic) traffic from node 9 to node 4\" "
	$ns_ at $appTime33 "$ns_ trace-annotate \"(at $appTime33) $val(traffic) traffic from node 7 to node 8\" "
	$ns_ at $appTime35 "$ns_ trace-annotate \"(at $appTime35) $val(traffic) traffic from node 8 to node 7\" "
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

	if { ("$val(nam)" == "TBoPS.nam") && ("$hasDISPLAY" == "1") } {
		exec nam TBoPS.nam &
	}

	exit 0

}

puts "\nStarting Simulation..."
$ns_ run
