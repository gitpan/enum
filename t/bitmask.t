use strict;
use vars qw($test $ok $total @foo);
sub OK { print "ok " . $test++ . "\n" }
sub NOT_OK { print "not ok " . $test++ . "\n"};

BEGIN { $test = 1; $ok=0; $| = 1 }
END { NOT_OK unless $ok }

use enum;
$ok++;
OK;

use enum qw(BITMASK: Foo Bar Cat Dog Sheep=16 Car Robot=1024 );
use enum qw(BITMASK:Tag_ Foo Bar Cat Dog Sheep=16 Car Robot=1024 );
use enum qw(BITMASK:Fubar_=16 Foo Bar Cat Dog Sheep=16 Car Robot=1024 );

my $foo |= Tag_Foo|Tag_Cat|Tag_Sheep|Tag_Robot;
my $bar |= Tag_Bar|Tag_Dog|Tag_Car;

#2
$foo ^= Sheep;
($foo & Tag_Sheep)
	? NOT_OK
	: OK;

$foo |= Tag_Sheep;

#3
($foo & Bar or $foo & Dog or $foo & Car)
	? NOT_OK
	: OK;
#4
($foo & (Bar|Dog|Car))
	? NOT_OK
	: OK;
#5
($foo & Foo or $foo & Cat or $foo & Sheep or $foo & Robot)
	? OK
	: NOT_OK;

#6
($foo & (Foo|Cat|Sheep|Robot))
	? OK
	: NOT_OK;
#7
($bar & Foo or $bar & Cat or $bar & Sheep or $bar & Robot)
	? NOT_OK
	: OK;
#8
($bar & (Foo|Cat|Sheep|Robot))
	? NOT_OK
	: OK;
#9
($bar & Bar or $bar & Dog or $bar & Car)
	? OK
	: NOT_OK;
#10
($bar & Bar|Dog|Car)
	? OK
	: NOT_OK;
#11
(Fubar_Robot == 1024)
	? OK
	: NOT_OK;
#12
eval 'use enum qw(BITMASK: BadMask=255)';
($@ =~ /not a valid single bitmask/)
	? OK
	: NOT_OK;

#13
(Fubar_Robot == 1024)
	? OK
	: NOT_OK;

BEGIN { $total = 13; print "1..$total\n"; }
