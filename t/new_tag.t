use strict;
my ($ok, $total, @foo);
BEGIN { $ok=0; $| = 1 }
END { print "not ok 1\n" unless $ok }
$ok++;
print "ok $ok\n";

use enum qw(Foo Bar Cat Dog);
use enum qw(
	:Months_=0 Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
	:Days_     Sun=0 Mon Tue Wed Thu Fri Sat
	:Letters_=0 A..Z
	:=0
	: A..Z
	Ten=10	Forty=40	FortyOne	FortyTwo
	Zero=0	One			Two			Three=3	Four
	:=100
);

if (Months_Apr != 3 or Months_Dec != 11) {
	print "not ok 2";
} else {
	print "ok ", ++$ok, "\n";
}

if (Days_Thu != 4 or Days_Sat != 6) {
	print "not ok 3";
} else {
	print "ok ", ++$ok, "\n";
}

BEGIN { $total = 3; print "1..$total\n" }
