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


set val(nam)		dynamic.nam
set val(traffic)	cbr ;


set appTime1            0;
set appTime2            8;
set appTime3            1;
set appTime4            9;
set appTime5            0;
set appTime6            8;
set appTime7            1;
set appTime8            9;
set appTime9            0;
set appTime10            8;

set appTime19            1;
set appTime20            9;

set appTime25            0;
set appTime26            8;

set appTime31            1;
set appTime32            9;
set appTime33            0;
set appTime34            8;
set appTime35            0;
set appTime36            8;
set appTime37            1;
set appTime38            9;
set appTime39            1;
set appTime40            9;

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
set tracefd     [open ./dynamic.tr w]
$ns_ trace-all $tracefd
if { "$val(nam)" == "dynamic.nam" } {
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
$ns_ at 0.0	"$node_(0) sscs startCTPANCoord 1 8 2 "		;
$ns_ at 0.062 	"$node_(1) sscs startCTDevice  1 8 2 "		;
$ns_ at 0.124 	"$node_(2) sscs startCTDevice  1 8 2 "		;
$ns_ at 0.186 	"$node_(3) sscs startCTDevice  1 8 2 "		;
$ns_ at 0.248 	"$node_(4) sscs startCTDevice  1 8 2 "		;
$ns_ at 0.310 	"$node_(5) sscs startCTDevice  1 8 2 "		;
$ns_ at 0.062 	"$node_(6) sscs startCTDevice  1 8 2 "		;
$ns_ at 0.124 	"$node_(7) sscs startCTDevice  1 8 2 "		;
$ns_ at 0.186 	"$node_(8) sscs startCTDevice  1 8 2 "		;
$ns_ at 0.6 	"$node_(9) sscs startCTDevice  1 8 2 "		;
$ns_ at 0.6 	"$node_(10) sscs startCTDevice  0 "		;
$ns_ at 0.6 	"$node_(11) sscs startCTDevice  0 "		;
$ns_ at 0.6 	"$node_(12) sscs startCTDevice  0 "		;
$ns_ at 0.6 	"$node_(13) sscs startCTDevice  0 "		;
$ns_ at 0.6 	"$node_(14) sscs startCTDevice  0 "		;
$ns_ at 0.6 	"$node_(15) sscs startCTDevice  0 "		;





# Setup traffic flow between nodes
#synchronization
if { ("$val(traffic)" == "cbr") } {
	puts "Traffic: $val(traffic)"
	puts [format "Acknowledgement for data: " [Mac/802_15_4 wpanCmd ack4data]]
	#Communication1
	set udp1 [new Agent/UDP]
	set sink1 [new Agent/Null]
	$ns_ attach-agent $node_(1) $udp1
	$ns_ attach-agent $node_(0) $sink1
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
	$ns_ attach-agent $node_(0) $udp2
	$ns_ attach-agent $node_(1) $sink2
	$ns_ connect $udp2 $sink2
	set cbr2 [new Application/Traffic/CBR]
	$cbr2 attach-agent $udp2
        $cbr2 set packetSize_ 50
	$cbr2 set rate_ 25000
	$cbr2 set interval_ 10 
	$cbr2 set random_ 0
	$ns_ at 1 "$cbr2 start "
	$ns_ at 9 "$cbr2 stop "

	set udp2 [new Agent/UDP]
	set sink2 [new Agent/Null]
	$ns_ attach-agent $node_(1) $udp2
	$ns_ attach-agent $node_(0) $sink2
	$ns_ connect $udp2 $sink2
	set cbr2 [new Application/Traffic/CBR]
	$cbr2 attach-agent $udp2
        $cbr2 set packetSize_ 50
	$cbr2 set rate_ 25000
	$cbr2 set interval_ 10 
	$cbr2 set random_ 0
	$ns_ at 2 "$cbr2 start "
	$ns_ at 9 "$cbr2 stop "

	set udp2 [new Agent/UDP]
	set sink2 [new Agent/Null]
	$ns_ attach-agent $node_(1) $udp2
	$ns_ attach-agent $node_(12) $sink2
	$ns_ connect $udp2 $sink2
	set cbr2 [new Application/Traffic/CBR]
	$cbr2 attach-agent $udp2
        $cbr2 set packetSize_ 50
	$cbr2 set rate_ 25000
	$cbr2 set interval_ 10 
	$cbr2 set random_ 0
	$ns_ at 2 "$cbr2 start "
	$ns_ at 9 "$cbr2 stop "

	set udp2 [new Agent/UDP]
	set sink2 [new Agent/Null]
	$ns_ attach-agent $node_(1) $udp2
	$ns_ attach-agent $node_(13) $sink2
	$ns_ connect $udp2 $sink2
	set cbr2 [new Application/Traffic/CBR]
	$cbr2 attach-agent $udp2
        $cbr2 set packetSize_ 50
	$cbr2 set rate_ 25000
	$cbr2 set interval_ 10 
	$cbr2 set random_ 0
	$ns_ at 2 "$cbr2 start "
	$ns_ at 9 "$cbr2 stop "

	


	#Communication3
	set udp3 [new Agent/UDP]
	set sink3 [new Agent/Null]
	$ns_ attach-agent $node_(2) $udp3
	$ns_ attach-agent $node_(0) $sink3
	$ns_ connect $udp3 $sink3
	set cbr3 [new Application/Traffic/CBR]
	$cbr3 attach-agent $udp3
	$cbr3 set packetSize_ 100
	$cbr3 set rate_ 25000	
	$cbr3 set interval_ 10 
	$cbr3 set random_ 0
	$ns_ at 0 "$cbr3 start "
	$ns_ at 8 "$cbr3 stop "

	set udp2 [new Agent/UDP]
	set sink2 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp2
	$ns_ attach-agent $node_(2) $sink2
	$ns_ connect $udp2 $sink2
	set cbr2 [new Application/Traffic/CBR]
	$cbr2 attach-agent $udp2
        $cbr2 set packetSize_ 50
	$cbr2 set rate_ 25000
	$cbr2 set interval_ 10 
	$cbr2 set random_ 0
	$ns_ at 1 "$cbr2 start "
	$ns_ at 9 "$cbr2 stop "

	set udp2 [new Agent/UDP]
	set sink2 [new Agent/Null]
	$ns_ attach-agent $node_(2) $udp2
	$ns_ attach-agent $node_(0) $sink2
	$ns_ connect $udp2 $sink2
	set cbr2 [new Application/Traffic/CBR]
	$cbr2 attach-agent $udp2
        $cbr2 set packetSize_ 50
	$cbr2 set rate_ 25000
	$cbr2 set interval_ 10 
	$cbr2 set random_ 0
	$ns_ at 2 "$cbr2 start "
	$ns_ at 9 "$cbr2 stop "

	set udp2 [new Agent/UDP]
	set sink2 [new Agent/Null]
	$ns_ attach-agent $node_(2) $udp2
	$ns_ attach-agent $node_(10) $sink2
	$ns_ connect $udp2 $sink2
	set cbr2 [new Application/Traffic/CBR]
	$cbr2 attach-agent $udp2
        $cbr2 set packetSize_ 20
	$cbr2 set rate_ 25000
	$cbr2 set interval_ 10 
	$cbr2 set random_ 0
	$ns_ at 2 "$cbr2 start "
	$ns_ at 9 "$cbr2 stop "

	


	#Communication4
	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(3) $udp4
	$ns_ attach-agent $node_(0) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 100
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "
	
	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp4
	$ns_ attach-agent $node_(3) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 2 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "




	#Communication5
	set udp5 [new Agent/UDP]
	set sink5 [new Agent/Null]
	$ns_ attach-agent $node_(4) $udp5
	$ns_ attach-agent $node_(0) $sink5
	$ns_ connect $udp5 $sink5
	set cbr5 [new Application/Traffic/CBR]
	$cbr5 attach-agent $udp5
	$cbr5 set packetSize_ 100
	$cbr5 set rate_ 25000	
	$cbr5 set interval_ 10 
	$cbr5 set random_ 0
	$ns_ at 0 "$cbr5 start "
	$ns_ at 8 "$cbr5 stop "


	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp4
	$ns_ attach-agent $node_(4) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(4) $udp4
	$ns_ attach-agent $node_(0) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(4) $udp4
	$ns_ attach-agent $node_(9) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "

	


	#Communication6
	


	#Communication7
	


	#Communication8
	


	#Communication9
	


	#Communication10
	set udp10 [new Agent/UDP]
	set sink10 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp10
	$ns_ attach-agent $node_(0) $sink10
	$ns_ connect $udp10 $sink10
	set cbr10 [new Application/Traffic/CBR]
	$cbr10 attach-agent $udp10
	$cbr10 set packetSize_ 100
	$cbr10 set rate_ 25000
	$cbr10 set interval_ 10 
	$cbr10 set random_ 0
	$ns_ at 1 "$cbr10 start "
	$ns_ at 9 "$cbr10 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(0) $udp4
	$ns_ attach-agent $node_(5) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp4
	$ns_ attach-agent $node_(0) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp4
	$ns_ attach-agent $node_(6) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp4
	$ns_ attach-agent $node_(7) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "


	#Communication11
	


	#Communication12
	


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


	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp4
	$ns_ attach-agent $node_(6) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(6) $udp4
	$ns_ attach-agent $node_(5) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "


	#Communication14
	

	#Communication15
	

	#Communication16
	set udp16 [new Agent/UDP]
	set sink16 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp16
	$ns_ attach-agent $node_(5) $sink16
	$ns_ connect $udp16 $sink16
	set cbr16 [new Application/Traffic/CBR]
	$cbr16 attach-agent $udp16
	$cbr16 set packetSize_ 100
	$cbr16 set rate_ 25000
	$cbr16 set interval_ 10 
	$cbr16 set random_ 0
	$ns_ at 1 "$cbr16 start "
	$ns_ at 9 "$cbr16 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp4
	$ns_ attach-agent $node_(7) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp4
	$ns_ attach-agent $node_(5) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp4
	$ns_ attach-agent $node_(8) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "
	
	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp4
	$ns_ attach-agent $node_(13) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp4
	$ns_ attach-agent $node_(14) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "


	#Communication17
	set udp17 [new Agent/UDP]
	set sink17 [new Agent/Null]
	$ns_ attach-agent $node_(8) $udp17
	$ns_ attach-agent $node_(7) $sink17
	$ns_ connect $udp17 $sink17
	set cbr17 [new Application/Traffic/CBR]
	$cbr17 attach-agent $udp17
	$cbr17 set packetSize_ 100
	$cbr17 set rate_ 25000
	$cbr17 set interval_ 10 
	$cbr17 set random_ 0
	$ns_ at 0 "$cbr17 start "
	$ns_ at 8 "$cbr17 stop "


	set udp18 [new Agent/UDP]
	set sink18 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp18
	$ns_ attach-agent $node_(8) $sink18
	$ns_ connect $udp18 $sink18
	set cbr18 [new Application/Traffic/CBR]
	$cbr18 attach-agent $udp18
	$cbr18 set packetSize_ 50
	$cbr18 set rate_ 25000
	$cbr18 set interval_ 10 
	$cbr18 set random_ 0
	$ns_ at 1 "$cbr18 start "
	$ns_ at 9 "$cbr18 stop "


	set udp19 [new Agent/UDP]
	set sink19 [new Agent/Null]
	$ns_ attach-agent $node_(8) $udp19
	$ns_ attach-agent $node_(7) $sink19
	$ns_ connect $udp19 $sink19
	set cbr19 [new Application/Traffic/CBR]
	$cbr19 attach-agent $udp19
	$cbr19 set packetSize_ 50
	$cbr19 set rate_ 25000
	$cbr19 set interval_ 10 
	$cbr19 set random_ 0
	$ns_ at 1 "$cbr19 start "
	$ns_ at 9 "$cbr19 stop "


	set udp20 [new Agent/UDP]
	set sink20 [new Agent/Null]
	$ns_ attach-agent $node_(8) $udp20
	$ns_ attach-agent $node_(15) $sink20
	$ns_ connect $udp20 $sink20
	set cbr20 [new Application/Traffic/CBR]
	$cbr20 attach-agent $udp20
	$cbr20 set packetSize_ 50
	$cbr20 set rate_ 25000
	$cbr20 set interval_ 10 
	$cbr20 set random_ 0
	$ns_ at 1 "$cbr20 start "
	$ns_ at 9 "$cbr20 stop "


	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(9) $udp4
	$ns_ attach-agent $node_(4) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 100
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 1 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(4) $udp4
	$ns_ attach-agent $node_(9) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 2 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "

	set udp4 [new Agent/UDP]
	set sink4 [new Agent/Null]
	$ns_ attach-agent $node_(9) $udp4
	$ns_ attach-agent $node_(4) $sink4
	$ns_ connect $udp4 $sink4
	set cbr4 [new Application/Traffic/CBR]
	$cbr4 attach-agent $udp4
	$cbr4 set packetSize_ 50
	$cbr4 set rate_ 25000	
	$cbr4 set interval_ 10 
	$cbr4 set random_ 0
	$ns_ at 2 "$cbr4 start "
	$ns_ at 9 "$cbr4 stop "


	

   #regular traffic
        set udp29 [new Agent/UDP]
	set sink29 [new Agent/Null]
	$ns_ attach-agent $node_(12) $udp29
	$ns_ attach-agent $node_(1) $sink29
	$ns_ connect $udp29 $sink29
	set cbr29 [new Application/Traffic/CBR]
	$cbr29 attach-agent $udp29
	$cbr29 set packetSize_ 100
	$cbr29 set rate_ 25000
	$cbr29 set interval_ 10 
	$cbr29 set random_ 0
	$ns_ at 15 "$cbr29 start "
	$ns_ at 290 "$cbr29 stop "



	set udp30 [new Agent/UDP]
	set sink30 [new Agent/Null]
	$ns_ attach-agent $node_(1) $udp30
	$ns_ attach-agent $node_(0) $sink30
	$ns_ connect $udp30 $sink30
	set cbr30 [new Application/Traffic/CBR]
	$cbr30 attach-agent $udp30
	$cbr30 set packetSize_ 100
	$cbr30 set rate_ 25000
	$cbr30 set interval_ 10 
	$cbr30 set random_ 0
	$ns_ at 16 "$cbr30 start "
	$ns_ at 290 "$cbr30 stop "


	
	set udp31 [new Agent/UDP]
	set sink31 [new Agent/Null]
	$ns_ attach-agent $node_(11) $udp31
	$ns_ attach-agent $node_(1) $sink31
	$ns_ connect $udp31 $sink31
	set cbr31 [new Application/Traffic/CBR]
	$cbr31 attach-agent $udp31
	$cbr31 set packetSize_ 100
	$cbr31 set rate_ 25000
	$cbr31 set interval_ 10 
	$cbr31 set random_ 0
	$ns_ at 15 "$cbr31 start "
	$ns_ at 290 "$cbr31 stop "



	set udp32 [new Agent/UDP]
	set sink32 [new Agent/Null]
	$ns_ attach-agent $node_(1) $udp32
	$ns_ attach-agent $node_(0) $sink32
	$ns_ connect $udp32 $sink32
	set cbr32 [new Application/Traffic/CBR]
	$cbr32 attach-agent $udp32
	$cbr32 set packetSize_ 100
	$cbr32 set rate_ 25000
	$cbr32 set interval_ 10 
	$cbr32 set random_ 0
	$ns_ at 16 "$cbr32 start "
	$ns_ at 290 "$cbr32 stop "


	set udp33 [new Agent/UDP]
	set sink33 [new Agent/Null]
	$ns_ attach-agent $node_(10) $udp33
	$ns_ attach-agent $node_(2) $sink33
	$ns_ connect $udp33 $sink33
	set cbr33 [new Application/Traffic/CBR]
	$cbr33 attach-agent $udp33
	$cbr33 set packetSize_ 100
	$cbr33 set rate_ 25000
	$cbr33 set interval_ 10 
	$cbr33 set random_ 0
	$ns_ at 15 "$cbr33 start "
	$ns_ at 290 "$cbr33 stop "



	set udp34 [new Agent/UDP]
	set sink34 [new Agent/Null]
	$ns_ attach-agent $node_(2) $udp34
	$ns_ attach-agent $node_(0) $sink34
	$ns_ connect $udp34 $sink34
	set cbr34 [new Application/Traffic/CBR]
	$cbr34 attach-agent $udp34
	$cbr34 set packetSize_ 100
	$cbr34 set rate_ 25000
	$cbr34 set interval_ 10 
	$cbr34 set random_ 0
	$ns_ at 16 "$cbr34 start "
	$ns_ at 290 "$cbr34 stop "





	set udp35 [new Agent/UDP]
	set sink35 [new Agent/Null]
	$ns_ attach-agent $node_(13) $udp35
	$ns_ attach-agent $node_(7) $sink35
	$ns_ connect $udp35 $sink35
	set cbr35 [new Application/Traffic/CBR]
	$cbr35 attach-agent $udp35
	$cbr35 set packetSize_ 100
	$cbr35 set rate_ 25000
	$cbr35 set interval_ 10 
	$cbr35 set random_ 0
	$ns_ at 15 "$cbr35 start "
	$ns_ at 290 "$cbr35 stop "



	set udp36 [new Agent/UDP]
	set sink36 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp36
	$ns_ attach-agent $node_(5) $sink36
	$ns_ connect $udp36 $sink36
	set cbr36 [new Application/Traffic/CBR]
	$cbr36 attach-agent $udp36
	$cbr36 set packetSize_ 100
	$cbr36 set rate_ 25000
	$cbr36 set interval_ 10 
	$cbr36 set random_ 0
	$ns_ at 16 "$cbr36 start "
	$ns_ at 290 "$cbr36 stop "


	
	set udp37 [new Agent/UDP]
	set sink37 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp37
	$ns_ attach-agent $node_(0) $sink37
	$ns_ connect $udp37 $sink37
	set cbr37 [new Application/Traffic/CBR]
	$cbr37 attach-agent $udp37
	$cbr37 set packetSize_ 100
	$cbr37 set rate_ 25000
	$cbr37 set interval_ 10 
	$cbr37 set random_ 0
	$ns_ at 17 "$cbr37 start "
	$ns_ at 290 "$cbr37 stop "

	










	set udp38 [new Agent/UDP]
	set sink38 [new Agent/Null]
	$ns_ attach-agent $node_(14) $udp38
	$ns_ attach-agent $node_(7) $sink38
	$ns_ connect $udp38 $sink38
	set cbr38 [new Application/Traffic/CBR]
	$cbr38 attach-agent $udp38
	$cbr38 set packetSize_ 100
	$cbr38 set rate_ 25000
	$cbr38 set interval_ 5 
	$cbr38 set random_ 0
	$ns_ at 15 "$cbr38 start "
	$ns_ at 290 "$cbr38 stop "



	set udp39 [new Agent/UDP]
	set sink39 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp39
	$ns_ attach-agent $node_(5) $sink39
	$ns_ connect $udp39 $sink39
	set cbr39 [new Application/Traffic/CBR]
	$cbr39 attach-agent $udp39
	$cbr39 set packetSize_ 100
	$cbr39 set rate_ 25000
	$cbr39 set interval_ 5 
	$cbr39 set random_ 0
	$ns_ at 16 "$cbr39 start "
	$ns_ at 290 "$cbr39 stop "


	
	set udp40 [new Agent/UDP]
	set sink40 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp40
	$ns_ attach-agent $node_(0) $sink40
	$ns_ connect $udp40 $sink40
	set cbr40 [new Application/Traffic/CBR]
	$cbr40 attach-agent $udp40
	$cbr40 set packetSize_ 100
	$cbr40 set rate_ 25000
	$cbr40 set interval_ 5 
	$cbr40 set random_ 0
	$ns_ at 17 "$cbr40 start "
	$ns_ at 290 "$cbr40 stop "



	
	



	set udp41 [new Agent/UDP]
	set sink41 [new Agent/Null]
	$ns_ attach-agent $node_(15) $udp41
	$ns_ attach-agent $node_(8) $sink41
	$ns_ connect $udp41 $sink41
	set cbr41 [new Application/Traffic/CBR]
	$cbr41 attach-agent $udp41
	$cbr41 set packetSize_ 100
	$cbr41 set rate_ 25000
	$cbr41 set interval_ 5 
	$cbr41 set random_ 0
	$ns_ at 15 "$cbr41 start "
	$ns_ at 290 "$cbr41 stop "


	set udp42 [new Agent/UDP]
	set sink42 [new Agent/Null]
	$ns_ attach-agent $node_(8) $udp42
	$ns_ attach-agent $node_(7) $sink42
	$ns_ connect $udp42 $sink42
	set cbr42 [new Application/Traffic/CBR]
	$cbr42 attach-agent $udp42
	$cbr42 set packetSize_ 100
	$cbr42 set rate_ 25000
	$cbr42 set interval_ 5 
	$cbr42 set random_ 0
	$ns_ at 16 "$cbr42 start "
	$ns_ at 290 "$cbr42 stop "



	set udp43 [new Agent/UDP]
	set sink43 [new Agent/Null]
	$ns_ attach-agent $node_(7) $udp43
	$ns_ attach-agent $node_(5) $sink43
	$ns_ connect $udp43 $sink43
	set cbr43 [new Application/Traffic/CBR]
	$cbr43 attach-agent $udp43
	$cbr43 set packetSize_ 100
	$cbr43 set rate_ 25000
	$cbr43 set interval_ 5 
	$cbr43 set random_ 0
	$ns_ at 17 "$cbr43 start "
	$ns_ at 290 "$cbr43 stop "


	
	set udp44 [new Agent/UDP]
	set sink44 [new Agent/Null]
	$ns_ attach-agent $node_(5) $udp44
	$ns_ attach-agent $node_(0) $sink44
	$ns_ connect $udp44 $sink44
	set cbr44 [new Application/Traffic/CBR]
	$cbr44 attach-agent $udp44
	$cbr44 set packetSize_ 100
	$cbr44 set rate_ 25000
	$cbr44 set interval_ 5 
	$cbr44 set random_ 0
	$ns_ at 18 "$cbr44 start "
	$ns_ at 290 "$cbr44 stop "




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
	
	$ns_ at $appTime19 "$ns_ trace-annotate \"(at $appTime19) $val(traffic) traffic from node 7 to node 8\" "
	
	$ns_ at $appTime25 "$ns_ trace-annotate \"(at $appTime25) $val(traffic) traffic from node 6 to node 5\" "
		
	$ns_ at $appTime31 "$ns_ trace-annotate \"(at $appTime31) $val(traffic) traffic from node 5 to node 6\" "
	$ns_ at $appTime33 "$ns_ trace-annotate \"(at $appTime33) $val(traffic) traffic from node 9 to node 4\" "
	$ns_ at $appTime35 "$ns_ trace-annotate \"(at $appTime35) $val(traffic) traffic from node 4 to node 0\" "
	$ns_ at $appTime37 "$ns_ trace-annotate \"(at $appTime37) $val(traffic) traffic from node 0 to node 4\" "
	$ns_ at $appTime39 "$ns_ trace-annotate \"(at $appTime39) $val(traffic) traffic from node 4 to node 9\" "
	
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

	if { ("$val(nam)" == "dynamic.nam") && ("$hasDISPLAY" == "1") } {
		exec nam dynamic.nam &
	}

	exit 0

}

puts "\nStarting Simulation..."
$ns_ run
