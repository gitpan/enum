
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

$foo[Foo] = "Foo";
$foo[Bar] = "Bar";
$foo[Cat] = "Cat";
$foo[Dog] = "Dog";

if (Foo != 0 or Bar != 1 or Cat != 2 or Dog != 3) {
	print "not ok 2";
} else {
	print "ok ", ++$ok, "\n";
}

if ($foo[Foo] ne "Foo" or $foo[Bar] ne "Bar" or $foo[Cat] ne "Cat" or $foo[Dog] ne "Dog") {
	print "not ok 3\n";
} else {
	print "ok ", ++$ok, "\n";
}

{
	package main::F;
	use enum qw(Foo Bar Cat Dog);
}

if ($foo[F::Foo] ne "Foo" or $foo[F::Bar] ne "Bar" or $foo[F::Cat] ne "Cat" or $foo[F::Dog] ne "Dog") {
	print "not ok 4\n";
} else {
	print "ok ", ++$ok, "\n";
}

if ($foo[Foo] ne "Foo" or $foo[Bar] ne "Bar" or $foo[Cat] ne "Cat" or $foo[Dog] ne "Dog") {
	print "not ok 5\n";
} else {
	print "ok ", ++$ok, "\n";
}

if (Zero != 0 or One != 1 or Two != 2 or Three != 3 or Four != 4) {
	print "not ok 6";
} else {
	print "ok ", ++$ok, "\n";
}

if (Ten != 10 or Forty != 40 or FortyOne != 41 or FortyTwo != 42) {
	print "not ok 7";
} else {
	print "ok ", ++$ok, "\n";
}

if (Months_Apr != 3 or Months_Dec != 11) {
	print "not ok 8";
} else {
	print "ok ", ++$ok, "\n";
}

if (Days_Thu != 4 or Days_Sat != 6) {
	print "not ok 9";
} else {
	print "ok ", ++$ok, "\n";
}

if (Days_Thu != 4 or Days_Sat != 6) {
	print "not ok 10";
} else {
	print "ok ", ++$ok, "\n";
}

if (Letters_A != 0 or Letters_Z != 25) {
	print "not ok 11";
} else {
	print "ok ", ++$ok, "\n";
}

if (A != 0 or Z != 25) {
	print "not ok 12";
} else {
	print "ok ", ++$ok, "\n";
}

BEGIN { $total = 12; print "1..$total\n" }

if ($total == $ok) {
	print "All $total of $ok tests passed\n";
} else {
	die "Failed $ok of $total test\n";
}
