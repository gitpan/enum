use strict;
use vars qw($test $ok $total);
sub OK { print "ok " . $test++ . "\n" }
sub NOT_OK { print "not ok " . $test++ . "\n"};

BEGIN { $test = 1; $ok=0; $| = 1 }
END { NOT_OK unless $ok }
use enum;
$ok++;
OK;

use enum qw(
	:PreFix
	BITMASK: One Two Four Eight
	ENUM: Zero Three=3
	BITMASK:=16 SixTeen ThirtyTwo
	ENUM:=33 ThirtyThree ThirtyFour
);

Zero		== 0 ? OK : NOT_OK;
One			== 1 ? OK : NOT_OK;
Two			== 2 ? OK : NOT_OK;
Three		== 3 ? OK : NOT_OK;
Four		== 4 ? OK : NOT_OK;
Eight		== 8 ? OK : NOT_OK;
SixTeen		== 16 ? OK : NOT_OK;
ThirtyTwo	== 32 ? OK : NOT_OK;
ThirtyThree	== 33 ? OK : NOT_OK;
ThirtyFour	== 34 ? OK : NOT_OK;

BEGIN { $total = 11; print "1..$total\n"; }
