# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

BEGIN { $enum::DEBUGGING = 0 }

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..13\n"; }
END {print "not ok 1\n" unless $loaded;}

use enum qw ( ZERO ONE TWO TEN=10 TWENTY=20 TWENTYONE );
$loaded = 1;

print "ok 1\n";

######################### End of black magic.

my $test_count = 2;

# pass this two values which should be equal
sub test_eq ($$) {
    my($v1, $v2) = @_;
    unless ($v1 eq $v2) {	# Yes, string equality
	print "# $v1 is not $v2\nnot ";
    }
    print "ok $test_count\n";
    $test_count++;
}

test_eq ZERO, 0;
test_eq ONE, 1;
test_eq TWO, 2;
test_eq TEN, 10;
test_eq TWENTY, 20;
test_eq TWENTYONE, 21;

use enum qw/prefix:LETTER_ A=1/, 'B'..'Z';
test_eq LETTER_T, 20;

use enum qw/A0=a0 A1/;
test_eq A1, 'a1';

use enum qw/Az=Az Ba/;
test_eq Ba, 'Ba';

use enum qw/ZZ=zz AAA/;
test_eq AAA, 'aaa';

use enum qw/prefix:NEGS_ MINUS_TWO=-2 MINUS_ONE ZERO ONE TWO/;
test_eq NEGS_MINUS_ONE, -1;
test_eq NEGS_TWO, 2;
