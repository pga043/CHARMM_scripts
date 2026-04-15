# A lot of procs that I use a lot.
# Author: Jeff Comer <jeffcomer at gmail>
proc trimPath {name} {
    set ind [string last "/" $name]
    return [string range $name [expr {$ind+1}] end]
}

proc extractPath {name} {
    set ind [string last "/" $name]
    return [string range $name 0 [expr {$ind-1}]]
}

proc trimExtension {name} {
    set ind [string last "." $name]
    return [string range $name 0 [expr {$ind-1}]]
}

proc extractExtension {name} {
    set ind [string last "." $name]
    return [string range $name [expr {$ind+1}] end]
}

proc silent {} {
}

# Just read a space delimited data file.
proc readData {fileName} {
    set in [open $fileName r]
    
    set r {}
    while {[gets $in line] >= 0} {
	set line [string trim $line]
	if {[string match "#*" $line]} { continue }
	if {[string length $line] < 1} { continue }
	
	set tok [concat $line]
	set l {}
	foreach t $tok {
	    lappend l [string trim $t]
	}

	lappend r $l
    }

    close $in
    return $r
}

# Just read a space delimited data file.
proc readDataComments {fileName commentVar} {
    upvar $commentVar comment
    set in [open $fileName r]
    
    set r {}
    while {[gets $in line] >= 0} {
	if {[string match "#*" $line]} {
	    lappend comment [concat $line]
	    continue
	}
	if {[string length [string trim $line]] < 1} { continue }
	
	set tok [concat $line]
	set l {}
	foreach t $tok {
	    lappend l [string trim $t]
	}

	lappend r $l
    }

    close $in
    return $r
}


proc writeData {fileName data} {
    set out [open $fileName w]
    
    foreach d $data {
	puts $out $d
    }

    close $out
}

# Construct a pdb line from everything.
proc makePdbLineBeta {serial segName resId name resName r beta} {
    set template "ATOM     42  HN  ASN X   4     -41.083  17.391  50.684  0.00  0.00      P1    "

    foreach {x y z} $r {break}
    set record "ATOM  "
    set si [string range [format "     %5i " $serial] end-5 end]
    if {[string length $name] < 4} {
	set name [string range " $name    " 0 3]
    } else {
	set name [string range $name 0 3]
    }
    set resName [string range " $resName     " 0 4]
    set chain "[string index $segName 0]"
    set resId [string range "    $resId"  end-3 end]
    set temp1 [string range $template  26 29]
    set sx [string range [format "       %8.3f" $x] end-7 end]
    set sy [string range [format "       %8.3f" $y] end-7 end]
    set sz [string range [format "       %8.3f" $z] end-7 end]
    set temp2 [string range $template 54 59]
    set beta [string range [format "       %6.2f" $beta] end-5 end]
    set temp3 [string range $template 66 71]
    set segName [string range "$segName    "  0 3]
    set tempEnd [string range $template 76 end]

    # Construct the pdb line.
    return "${record}${si}${name}${resName}${chain}${resId}${temp1}${sx}${sy}${sz}${temp2}${beta}${temp3}${segName}${tempEnd}"
}


######################################################################
## Dave's stuff
######################################################################

# Dave's vmdargs
proc vmdargs { script args } {
    upvar argv argv_local
    
    if { [llength $argv_local] != [llength $args] } {
	puts -nonewline "Usage: vmd -dispdev text -e $script -args"
	foreach arg $args {
	    puts -nonewline " [ul $arg]"
	}
	puts ""
	exit -1
    }

    puts -nonewline "COMMAND: $script"
    foreach arg $args argv $argv_local {
	puts -nonewline " $argv"
	upvar $arg arg_local
	set arg_local [shift argv_local]
    }
    puts ""
}

proc vmdargslist { script args } {
    upvar argv argv_local
    
    # DEBUG
    puts "argv: $argv_local"
    
    set nargs [llength $args]
    set nlistargs 0
    set i 0
    foreach arg $args {
	# Loop through and check for a list arg ... more than one is a no-no
	if { [string match "@*" $arg] } {
	    incr nlistargs
	    set listargind $i
	}
	incr i
    }
    if { $nlistargs > 1 } {
	puts "Cannot use more than one list variable in vmdargs call!"
	exit -1
    }
    
    if { ($nlistargs == 0 && [llength $argv_local] != [llength $args]) || [llength $argv_local] < [llength $args] } {
	puts -nonewline "Usage: vmd -dispdev text -e $script -args"
	foreach arg $args {
	    if { [string match "@*" $arg] } {
		set arg2 [string range $arg 1 end]
		puts -nonewline " [ul $arg2] \[ [ul $arg2] ... \]"
	    } else {
		puts -nonewline " [ul $arg]"
	    }
	}
	puts ""
	puts "$argv_local"
	exit -1
    }
    
    foreach arg $args {
	if { [string match "@*" $arg] } {
	    # remove leading '@' symbol
	    set arg2 [string range $arg 1 end]
	    upvar $arg2 arg_local
	    while { [llength $argv_local] >= $nargs - $listargind } {
		lappend arg_local [shift argv_local]
	    }
	} else {
	    upvar $arg arg_local
	    set arg_local [shift argv_local]
	}
    }
}


proc ul { str } {
    # This proc brackets the provided string with the terminal escape sequence for underlining
    return "\033\[4m$str\033\[0m"
}

### STACK PROCS ###
# from Dave
proc push { stack value } {
    upvar $stack list
    lappend list $value
}

proc pop { stack } {
    upvar $stack list
    set value [lindex $list end]
    set list [lrange $list 0 [expr [llength $list]-2]]
    return $value
}

proc shift { stack } {
    upvar $stack list
    set value [lindex $list 0]
    set list [lrange $list 1 end]
    return $value
}

proc unshift { stack value } {
    upvar $stack list
    set list [concat $value $list]
}

proc stackrotate { stack {value 1} } {
    upvar $stack list
    while { $value > 0 } {
	set el [shift list]
	push list $el
	incr value -1
    }
    while { $value < 0 } {
	set el [pop list]
	unshift list $el
	incr value 1
    }
    return $list
}

######################################################################
# A method (hack) for inserting VMD selection text in the command line.
# Just replace spaces ' ' with underscores '_'.
# If you need an underscore '_', use a tilde '~'.
# Replace quotes '\"' (for VMD regexp) with pound signs '#'.
# Replace asterisks '*' with at signs '@'.
# Replace brackets with '[' and ']' with double angle brackets '<<' and '>>'
# This should cover most things you'll want in the selection text.
#
# Then just pass the modified command-line selection text through argSelText.
proc argSelText {s} {
    set ret [regsub -all "_" $s " "]
    set ret [regsub -all "~" $ret "_"]
    set ret [regsub -all "@" $ret "*"]
    set ret [regsub -all "#" $ret "\""]
    set ret [regsub -all "<<" $ret "\["]
    set ret [regsub -all ">>" $ret "\]"]

    return $ret
}

######################################################################
# Extract the frame interval (in ns) from a NAMD configuration file by
# reading dcdFreq and timestep.
proc namdFrameInterval {namdConfig} {
    if {[file exists $namdConfig]} {
	set in [open $namdConfig r]
	foreach line [split [read $in] "\n"] {
	    if {[string match -nocase "dcdFreq*" $line]}  { scan $line "%s %g" dummy dcdFreq } 
	    if {[string match -nocase "outputPeriod*" $line]}  { scan $line "%s %g" dummy dcdFreq } 
	    if {[string match -nocase "timestep*" $line]} { scan $line "%s %g" dummy timestep }
	}
    } else {
	puts "NAMD config file `$namdConfig' does not exist."
	exit
    }
    # Compute the interval in nanoseconds.
    set frameInterval [expr {1.0e-6*$dcdFreq*$timestep}]
    puts "TIMESTEP $timestep DCDFREQ $dcdFreq INTERVAL $frameInterval ns" 
    return $frameInterval
}

######################################################################
# Wrapping
proc wrapDiffReal {x l} {
    set l [expr {double($l)}]
    set image [expr {int(floor($x/$l))}]
    set x [expr {$x - $image*$l}]

    if {$x >= 0.5*$l} { set x [expr {$x - $l}] }
    return $x
}

proc wrapDiffOrthoTop {r} {
    foreach {x y z} $r { break }
    
    set x [wrapDiffReal $x [molinfo top get a]]
    set y [wrapDiffReal $y [molinfo top get b]]
    set z [wrapDiffReal $z [molinfo top get c]]
    return [list $x $y $z]
}

proc wrapDiffOrtho {r a b c} {
    foreach {x y z} $r { break }
    
    set x [wrapDiffReal $x $a]
    set y [wrapDiffReal $y $b]
    set z [wrapDiffReal $z $c]
    return [list $x $y $z]
}

proc wrapDiffBasis {r basis basisInv} {
    set l [vecTransform $basisInv $r]
    set l1 {}
    foreach c $l {
	lappend l1 [wrapDiffReal $c 1.0]
    }
    return [vecTransform $basis $l1]
}

######################################################################
# Periodic cell
proc cellFromXsc {xscFile {molid top}} {
    set pi [expr 4.0*atan(1.0)]
    set in [open $xscFile r]
    
    foreach line [split [read $in] "\n"] {
	if {[llength $line] < 10} {continue}
	if {[string match "#*" $line]} {continue}
	
	set tok [concat $line]
	foreach {step ax ay az bx by bz cx cy cz ox oy oz} $tok {break}
	
	set aMag [expr sqrt($ax*$ax + $ay*$ay + $az*$az)]
	set bMag [expr sqrt($bx*$bx + $by*$by + $bz*$bz)]
	set cMag [expr sqrt($cx*$cx + $cy*$cy + $cz*$cz)]
	
	set b_c [expr $bx*$cx + $by*$cy + $bz*$cz]
	set a_c [expr $ax*$cx + $ay*$cy + $az*$cz]
	set a_b [expr $ax*$bx + $ay*$by + $az*$bz]
	
	set alpha [expr acos($b_c/$bMag/$cMag)*180./$pi]
	set beta [expr acos($a_c/$aMag/$cMag)*180./$pi]
	set gamma [expr acos($a_b/$aMag/$bMag)*180./$pi]
    }
    close $in
    
    puts "alpha $alpha"
    puts "beta $beta"
    puts "gamma $gamma"
    puts "a $aMag"
    puts "b $bMag"
    puts "c $cMag"
    
    if {[string equal $molid all]} {
	set molList [molinfo list]
    } else {
	set molList [list $molid]
    }

    foreach m $molList {
	molinfo $m set alpha $alpha
	molinfo $m set beta $beta
	molinfo $m set gamma $gamma
	molinfo $m set a $aMag
	molinfo $m set b $bMag
	molinfo $m set c $cMag
    }

    return [list $aMag $bMag $cMag $alpha $beta $gamma]
}

proc setCell {a b c alpha beta gamma {molid top}} {
    molinfo $molid set alpha $alpha
    molinfo $molid set beta $beta
    molinfo $molid set gamma $gamma
    molinfo $molid set a $a
    molinfo $molid set b $b
    molinfo $molid set c $c
}

proc printCell {{molid top}} {
    set alpha [molinfo $molid get alpha]
    set beta [molinfo $molid get beta]
    set gamma [molinfo $molid get gamma]
    set a [molinfo $molid get a]
    set b [molinfo $molid get b]
    set c [molinfo $molid get c]

    foreach var {alpha beta gamma a b c} {
	set val [set $var]
	puts "$var $val"
    }
}

proc setCellFrames {a b c alpha beta gamma {molid top}} {
    set numFrames [molinfo $molid get numframes]
    for {set i 0} {$i < $numFrames} {incr i} {
	molinfo $molid set frame $i
	setCell $a $b $c $alpha $beta $gamma
    }
}

proc writeXsc {xscList outFile} {
    set out [open $outFile w]
    puts $out "# NAMD extended system configuration restart file"
    puts $out "#\$LABELS step a_x a_y a_z b_x b_y b_z c_x c_y c_z o_x o_y o_z s_x s_y s_z s_u s_v s_w"
    puts $out $xscList
    close $out
    return
}

proc cellToXscHex {outFile {clearEpsilon 0}} {
    set degToRad [expr {atan(1.0)/45.0}]
    set alpha [molinfo top get alpha]
    set beta [molinfo top get beta]
    set gamma [molinfo top get gamma]
    set a [molinfo top get a]
    set b [molinfo top get b]
    set c [molinfo top get c]

    foreach var {a b c alpha beta gamma} {
	puts "$var [set $var]"
    }

    foreach vec {gamma} {
	set t [set $vec]
	set cos($vec) [expr {cos($degToRad*$t)}]
	set sin($vec) [expr {sin($degToRad*$t)}]
    }

    set vol [expr { $a*$b*$c*sqrt(1.0 - $cos(gamma)*$cos(gamma)) }]
    set yz [expr { (1.0 - $cos(gamma))/$sin(gamma) }]

    set ex [list $a 0 0]
    set ey [list [expr {$b*$cos(gamma)}] [expr {$b*$sin(gamma)}] 0]
    set ez [list 0 0 $c]

    set xscList [concat 0 $ex $ey $ez [list 0 0 0 0 0 0 0 0 0]]
    # Change values near zero to zero.
    if {$clearEpsilon} {
	set xscList0 {}
	foreach v $xscList {
	    if {abs($v) < 1e-13} {
		set v 0
	    }
	    lappend xscList0 $v
	}
	set xscList $xscList0
    }

    writeXsc $xscList $outFile
}


proc cellToXsc {outFile {clearEpsilon 0}} {
    set degToRad [expr {atan(1.0)/45.0}]
    set alpha [molinfo top get alpha]
    set beta [molinfo top get beta]
    set gamma [molinfo top get gamma]
    set a [molinfo top get a]
    set b [molinfo top get b]
    set c [molinfo top get c]

    foreach var {a b c alpha beta gamma} {
	puts "$var [set $var]"
    }

    foreach vec {alpha beta gamma} {
	set t [set $vec]
	set cos($vec) [expr {cos($degToRad*$t)}]
	set sin($vec) [expr {sin($degToRad*$t)}]
    }

    set vol [expr { $a*$b*$c*sqrt(1 - $cos(alpha)*$cos(alpha) - $cos(beta)*$cos(beta) - $cos(gamma)*$cos(gamma) + 2.0*$cos(alpha)*$cos(beta)*$cos(gamma) ) }]
    set yz [expr { ($cos(alpha) - $cos(beta)*$cos(gamma))/$sin(gamma) }]

    set ex [list $a [expr {$b*$cos(gamma)}] [expr {$c*$cos(beta)}] ]
    set ey [list 0 [expr {$b*$sin(gamma)}] [expr {$c*$yz}] ]
    set ez [list 0 0 [expr {$vol/($a*$b*$sin(gamma))}] ]

    set xscList [concat 0 $ex $ey $ez [list 0 0 0 0 0 0 0 0 0]]
    # Change values near zero to zero.
    if {$clearEpsilon} {
	set xscList0 {}
	foreach v $xscList {
	    if {abs($v) < 1e-13} {
		set v 0
	    }
	    lappend xscList0 $v
	}
	set xscList $xscList0
    }

    writeXsc $xscList $outFile
}


proc cellToMatrix {} {
    set degToRad [expr {atan(1.0)/45.0}]
    set alpha [molinfo top get alpha]
    set beta [molinfo top get beta]
    set gamma [molinfo top get gamma]
    set a [molinfo top get a]
    set b [molinfo top get b]
    set c [molinfo top get c]

    foreach vec {alpha beta gamma} {
	set t [set $vec]
	set cos($vec) [expr {cos($degToRad*$t)}]
	set sin($vec) [expr {sin($degToRad*$t)}]
    }

    set vol [expr { $a*$b*$c*sqrt(1 - $cos(alpha)*$cos(alpha) - $cos(beta)*$cos(beta) - $cos(gamma)*$cos(gamma) + 2.0*$cos(alpha)*$cos(beta)*$cos(gamma) ) }]
    set yz [expr { ($cos(alpha) - $cos(beta)*$cos(gamma))/$sin(gamma) }]

    set ex [list $a [expr {$b*$cos(gamma)}] [expr {$c*$cos(beta)}] ]
    set ey [list 0 [expr {$b*$sin(gamma)}] [expr {$c*$yz}] ]
    set ez [list 0 0 [expr {$vol/($a*$b*$sin(gamma))}] ]

    set m [list $ex $ey $ez]
    return [matTranspose $m]
}

# Get mean of y for data (x, y) and x0 <= x <= x1
proc meanData {data x0 x1} {
    set n 0
    set sum 0.0
    foreach d $data {
	foreach {x y} $d { break }
	if {$x < $x0 || $x > $x1} { continue }

	set sum [expr {$sum + $y}]
	incr n
    }

    return [expr {$sum/$n}]
}

proc expandBraces {l} {
    set ret {}

    # Check for braces.
    set remaining 0
    foreach item $l {
	if [string match "*\{*\}*" $item] {
	    incr remaining
	}
    }

    # If there are no braces, we are done.
    if {$remaining == 0} {
	return $l
    }

    foreach item $l {
	set b0 [string first "\{" $item]
	set b1 [string first "\}" $item $b0]

	if {$b0 < 0} {
	    # There are no remaining braces.
	    lappend ret $item
	} else {
	    set perm [string range $item [expr {$b0+1}] [expr {$b1-1}]]
	    set s0 [string range $item 0 [expr {$b0-1}]]
	    set s1 [string range $item [expr {$b1+1}] end]

	    # Do we have a sequence {1..10} or a list {a,b,c}?
	    if {[string match "*..*" $perm]} {
		# Supposedly a sequence.
		set d0 [string first ".." $perm]
		set n0 [string range $perm 0 [expr {$d0-1}]]
		set n1 [string range $perm [expr {$d0+2}] end]
		if {![string is integer $n0] || ![string is integer $n1]} {
		    error "Sequence parameter not an integer `$n0' `$n1' `$perm'."
		}

		# Is the sequence zero prepended?
		if {[string equal "0" [string index $n0 0]]} {
		    # Create the sequence.
		    set len [string length $n0]
		    for {set n $n0} {$n <= $n1} {incr n} {
			lappend ret [format "%s%0${len}d%s" $s0 $n $s1]
		    }
		} else {
		    # Create the sequence.
		    for {set n $n0} {$n <= $n1} {incr n} {
			lappend ret ${s0}${n}${s1}
		    }
		}
	    } else {
		# A list.
		foreach p [split $perm ","] {
		    lappend ret ${s0}${p}${s1}
		}
	    }
	}
    }

    # Recursively expand braces if any remain.
    return [expandBraces $ret]
}


## Base36
proc threeDigitBase36 {n} {
    set base36 "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    set d0 [string index $base36 [expr {$n%36}] ]
    set d1 [string index $base36 [expr {($n/36)%36}] ] 
    set d2 [string index $base36 [expr {(($n/36)/36)%36}] ]

    return ${d2}${d1}${d0}
}


### From 
### http://wiki.tcl.tk/775
proc b64en str {
    binary scan $str B* bits
    switch [expr {[string length $bits]%6}] {
        0 {set tail {}}
        2 {append bits 0000; set tail ==}
        4 {append bits 00; set tail =}
    }
    return [string map {
        000000 A 000001 B 000010 C 000011 D 000100 E 000101 F
        000110 G 000111 H 001000 I 001001 J 001010 K 001011 L
        001100 M 001101 N 001110 O 001111 P 010000 Q 010001 R
        010010 S 010011 T 010100 U 010101 V 010110 W 010111 X
        011000 Y 011001 Z 011010 a 011011 b 011100 c 011101 d
        011110 e 011111 f 100000 g 100001 h 100010 i 100011 j
        100100 k 100101 l 100110 m 100111 n 101000 o 101001 p
        101010 q 101011 r 101100 s 101101 t 101110 u 101111 v
        110000 w 110001 x 110010 y 110011 z 110100 0 110101 1
        110110 2 110111 3 111000 4 111001 5 111010 6 111011 7
        111100 8 111101 9 111110 + 111111 /
    } $bits]${tail}
}
proc b64de {_str} {
    set nstr [string trimright $_str =]
    set dstr [string map {
        A 000000 B 000001 C 000010 D 000011 E 000100 F 000101
        G 000110 H 000111 I 001000 J 001001 K 001010 L 001011
        M 001100 N 001101 O 001110 P 001111 Q 010000 R 010001
        S 010010 T 010011 U 010100 V 010101 W 010110 X 010111
        Y 011000 Z 011001 a 011010 b 011011 c 011100 d 011101
        e 011110 f 011111 g 100000 h 100001 i 100010 j 100011
        k 100100 l 100101 m 100110 n 100111 o 101000 p 101001
        q 101010 r 101011 s 101100 t 101101 u 101110 v 101111
        w 110000 x 110001 y 110010 z 110011 0 110100 1 110101
        2 110110 3 110111 4 111000 5 111001 6 111010 7 111011
        8 111100 9 111101 + 111110 / 111111
    } $nstr]
    switch [expr [string length $_str]-[string length $nstr]] {
        0 {#nothing to do}
        1 {set dstr [string range $dstr 0 {end-2}]}
        2 {set dstr [string range $dstr 0 {end-4}]}
    }
    return [binary format B* $dstr]
}



# Vector procedures
# All procedures work on n-vectors except
# vecCross, matInvert, vecZero, matIdentity, matMake4, matRandomRot
# which assume 3-vectors.
# Author: Jeff Comer <jeffcomer at gmail>

proc vecZero {} {
    return [list 0.0 0.0 0.0]
}
proc vecInvert {a} {
    set b {}
    foreach ai $a {
	lappend b [expr {-$ai}]
    }
    return $b
}
proc vecAdd {a b} {
    set c {}
    foreach ai $a bi $b {
	lappend c [expr {$ai+$bi}]
    }
    return $c
}
proc vecSub {a b} {
    set c {}
    foreach ai $a bi $b {
	lappend c [expr {$ai-$bi}]
    }
    return $c
}
proc vecDot {a b} {
    set sum 0
    foreach ai $a bi $b {
	set sum [expr {$sum + $ai*$bi}]
    }
    return $sum
}
proc vecCross {a b} {
    foreach {ax ay az} $a {break}
    foreach {bx by bz} $b {break}
    
    set cx [expr {$ay*$bz - $az*$by}]
    set cy [expr {$az*$bx - $ax*$bz}]
    set cz [expr {$ax*$by - $ay*$bx}]
    return [list $cx $cy $cz]
}
proc vecLength {a} {
    set sum 0
    foreach ai $a {
	set sum [expr {$sum + $ai*$ai}]
    }
    return [expr sqrt($sum)]
}
proc vecLength2 {a} {
    set sum 0
    foreach ai $a {
	set sum [expr {$sum + $ai*$ai}]
    }
    return [expr $sum]
}
proc vecUnit {v} {
    set len [vecLength $v]
    return [vecScale [expr {1.0/$len}] $v]
}
proc vecScale {s a} {
    set b {}
    foreach ai $a {
	lappend b [expr {$ai*$s}]
    }
    return $b
}
proc vecTransform {m a} {
    set b {}
    foreach row $m {
	lappend b [vecDot $row $a]
    }
    return $b
}
proc vecRandom {} {
    set pi [expr {4.*atan(1.)}]
    # Create a random vector, uniform on a sphere.
    set theta [expr {2.0*rand()*$pi}]
    set phi [expr {acos(2.0*rand()-1.0)}]

    set x [expr {cos($theta)*sin($phi)}]
    set y [expr {sin($theta)*sin($phi)}]
    set z [expr {cos($phi)}]

    return [list $x $y $z]
}

proc dodecahedron {} {
    set phi [expr {0.5*(1.0 + sqrt(5.0))}]
    set invPhi [expr {1.0/$phi}]

    set vertexList {}
    foreach i {-1.0 1.0} {
	foreach j {-1.0 1.0} {
	    foreach k {-1.0 1.0} {
		lappend vertexList [list $i $j $k]
	    }
	}
    }

    foreach i {-1.0 1.0} {
	foreach j {-1.0 1.0} {
	    lappend vertexList [list 0.0 [expr {$i*$invPhi}] [expr {$j*$phi}]]
	    lappend vertexList [list [expr {$i*$invPhi}] [expr {$j*$phi}] 0.0]
	    lappend vertexList [list [expr {$j*$phi}] 0.0 [expr {$i*$invPhi}]]
	}
    }
    return $vertexList
}

proc icosahedron {} {
    set phi [expr {0.5*(1.0 + sqrt(5.0))}]
    
    set vertexList {}
    foreach i {-1.0 1.0} {
	foreach j {-1.0 1.0} {
	    lappend vertexList [list 0 $i [expr {$j*$phi}]]
	    lappend vertexList [list $i [expr {$j*$phi}] 0]
	    lappend vertexList [list [expr {$j*$phi}] 0 $i]
	}
    }
    return $vertexList
}

proc shiftWrap {v} {
    return [concat [lindex $v end] [lrange $v 0 end-1]]
}

proc truncIcosahedron {} {
    set phi [expr {0.5*(1.0 + sqrt(5.0))}]
    set threePhi [expr {3.0*$phi}]
    
    set vertexList {}
    foreach i {-1.0 1.0} {
	foreach j {-1.0 1.0} {
	    set v [list 0.0 $i [expr {$j*$threePhi}]]
	    lappend vertexList $v
	    lappend vertexList [shiftWrap $v]
	    lappend vertexList [shiftWrap [shiftWrap $v]]
	}
    }

    set permList {{0 1 2} {2 0 1} {}}
    foreach i {-1.0 1.0} {
	foreach j {-1.0 1.0} {
	    foreach k {-1.0 1.0} {
		set v1 [list [expr {$i*$phi}] [expr {$j*2.0}] [expr {$k*(1.0+2.0*$phi)}]]
		lappend vertexList $v1
		lappend vertexList [shiftWrap $v1]
		lappend vertexList [shiftWrap [shiftWrap $v1]]


		set v2 [list [expr {$i*2.0*$phi}] $j [expr {$k*(2.0+$phi)}]]
		lappend vertexList $v2
		lappend vertexList [shiftWrap $v2]
		lappend vertexList [shiftWrap [shiftWrap $v2]]
	    }
	}
    }
    return $vertexList
}


proc matIdentity {} {
    return [list [list 1.0 0.0 0.0] [list 0.0 1.0 0.0] [list 0.0 0.0 1.0]]
}
proc matTranspose {m} {
    set n [llength $m]
    set t $m

    for {set i 0} {$i < $n} {incr i} {
	for {set j 0} {$j < $n} {incr j} {
	    lset t $i $j [lindex $m $j $i]
	}
    }
    return $t
}
proc matScale {s m} {
    set ret {}
    
    foreach row $m {
	set newRow {}
	foreach n $row {
	    lappend newRow [expr {$s*$n}]
	}
	lappend ret $newRow
    }
    return $ret
}
proc matInvert {m} {
    foreach {mxx mxy mxz} [lindex $m 0] {break}
    foreach {myx myy myz} [lindex $m 1] {break}
    foreach {mzx mzy mzz} [lindex $m 2] {break}
    
    set det [expr {1.0*($mxx*($myy*$mzz-$myz*$mzy) - $mxy*($myx*$mzz-$myz*$mzx) + $mxz*($myx*$mzy-$myy*$mzx))}]
    set ixx [expr {($myy*$mzz - $myz*$mzy)/$det}]
    set ixy [expr {-($mxy*$mzz - $mxz*$mzy)/$det}]
    set ixz [expr {($mxy*$myz - $mxz*$myy)/$det}]
    set iyx [expr {-($myx*$mzz - $myz*$mzx)/$det}]
    set iyy [expr {($mxx*$mzz - $mxz*$mzx)/$det}]
    set iyz [expr {-($mxx*$myz - $mxz*$myx)/$det}]
    set izx [expr {($myx*$mzy - $myy*$mzx)/$det}]
    set izy [expr {-($mxx*$mzy - $mxy*$mzx)/$det}]
    set izz [expr {($mxx*$myy - $mxy*$myx)/$det}]

    return [list [list $ixx $ixy $ixz] [list $iyx $iyy $iyz] [list $izx $izy $izz]]
}
proc matDet {m} {
    foreach {mxx mxy mxz} [lindex $m 0] {break}
    foreach {myx myy myz} [lindex $m 1] {break}
    foreach {mzx mzy mzz} [lindex $m 2] {break}

    set det [expr {1.0*($mxx*($myy*$mzz-$myz*$mzy) - $mxy*($myx*$mzz-$myz*$mzx) + $mxz*($myx*$mzy-$myy*$mzx))}]
    return $det
}
proc matMul {a b} {
    set bt [matTranspose $b]

    set ret {}
    foreach rowA $a {
	set r {}
	foreach colB $bt {
	    lappend r [vecDot $rowA $colB]
	}
	lappend ret $r
    }
    return $ret
}
proc matRandomRot {} {
    set pi [expr {4.*atan(1.)}]
    # Create a random rotation matrix, uniform on a sphere.
    set a [expr {2.0*rand()*$pi}]
    set b [expr {acos(2.0*rand()-1.0)}]
    set c [expr {2.0*rand()*$pi}]

    set ca [expr {cos($a)}]
    set sa [expr {sin($a)}]
    set za [expr {-sin($a)}]
    set cb [expr {cos($b)}]
    set sb [expr {sin($b)}]
    set zb [expr {-sin($b)}]
    set cc [expr {cos($c)}]
    set sc [expr {sin($c)}]
    set zc [expr {-sin($c)}]

    set ta [list [list $ca $za 0] [list $sa $ca 0] [list 0 0 1]]
    set tb [list [list 1 0 0] [list 0 $cb $zb] [list 0 $sb $cb]]
    set tc [list [list $cc $zc 0] [list $sc $cc 0] [list 0 0 1]]

    set basis $ta
    set basis [matMul $tb $basis]
    set basis [matMul $tc $basis]
    return $basis
}
proc matMake4 {m {d {0.0 0.0 0.0}}} {
    set ret {}
    lappend ret [concat [lindex $m 0] [lindex $d 0]]
    lappend ret [concat [lindex $m 1] [lindex $d 1]]
    lappend ret [concat [lindex $m 2] [lindex $d 2]]
    lappend ret [list 0.0 0.0 0.0 1.0]
}
proc matConvert3To4 {m {d {0.0 0.0 0.0}}} {
    set ret {}
    lappend ret [concat [lindex $m 0] [lindex $d 0]]
    lappend ret [concat [lindex $m 1] [lindex $d 1]]
    lappend ret [concat [lindex $m 2] [lindex $d 2]]
    lappend ret [list 0.0 0.0 0.0 1.0]
}
proc matConvert4To3 {m} {
    set mat {}
    lappend mat [lrange [lindex $m 0] 0 2]
    lappend mat [lrange [lindex $m 1] 0 2]
    lappend mat [lrange [lindex $m 2] 0 2]
    set disp [list [lindex $m 0 3] [lindex $m 1 3] [lindex $m 2 3]]
    return [list $mat $disp]
}
proc matBasisVec {m dir} {
    set ret {}
    foreach row $m {
	lappend ret [lindex $row $dir]
    }
    return $ret
}
