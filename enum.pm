package enum;

$VERSION='0.02';

=head1 NAME

enum - Perl pragma to declare enumerated values

=head1 SYNOPSIS

    use enum qw ( ZERO ONE TWO THREE FOUR FIVE );
    use enum qw ( TEN=10 ELEVEN TWELVE THIRTEEN TWENTY=20 TWENTYONE );
    use enum qw ( prefix:LETTER_ A=1 ), 'B'..'Z';

    my $zero = ZERO;
    print "Ten is correct\n" if TEN == 10;
    print "That was an E\n" if $foo == LETTER_E;

=head1 DESCRIPTION

This will declare a list of constants with consecutive values,
with the option of arbitrarily declaring the start value for
the list or subsection of the list. If you need single constants,
the C<use constant> pragma may be preferred.

=head1 NOTES

As shown above, an optional prefix may be declared as the first item.
This string will be prepended to all of the enumeration constants in the
list. This can make it easier to avoid cluttering a namespace, for
example. It is recommended but not required that the prefix end with an
underscore.

These enumeration constants do not directly interpolate into
double-quotish strings, although you may do so indirectly. (See L<perlref>
for details about how this works.)

    print "The value of TEN is @{[ TEN ]}.\n";

The use of all caps for enumeration names is merely a convention,
although it is recommended in order to make them stand out
and to help avoid collisions with other barewords, keywords, and
subroutine names. Enumeration names must begin with a letter.

Enumeration symbols are package scoped (rather than block scoped, as
C<use strict> is). That is, you can refer to an enumeration ENUM from
package Other as C<Other::ENUM>.

As with all C<use> directives, defining an enumeration happens at
compile time. Thus, it's probably not correct to put an enumeration
declaration inside of a conditional statement (like C<if ($foo)
{ use enum ... }>).

By default, the value of the enumeration starts at 0 (zero) with each
C<use> of enum. You may (re)define the start value any number of times on
the same list:

    use enum qw ( prefix:ERR_ NONE=0 BAD=10 WORSE=20 TERRIBLE=30 );

including

   use enum qw ( prefix:FOO_ A=0 B=0 C=0 D=0 );

though why you would want to is anyone's guess. Note that no spaces are
allowed before or after the equal sign.

The value of the enumeration may either be a positive or negative
integer or a value suitable for "magical autoincrement", as described in
L<perlop>.

=head1 TECHNICAL NOTE

In the current implementation, scalar enumeration constants are actually
inlinable subroutines. As of version 5.004 of Perl, the appropriate
scalar constant is inserted directly in place of some subroutine
calls, thereby saving the overhead of a subroutine call. See
L<perlsub/"Constant Functions"> for details about how and when this
happens.

=head1 AUTHOR

Nicholas J. Leon, E<lt>F<nicholas@binary9.net>E<gt>, with help from
Tom Phoenix, E<lt>F<rootbeer@teleport.com>E<gt>.

=head1 COPYRIGHT

Copyright (C) 1998, Nicholas J. Leon

This module is free software; you can redistribute it or modify it
under the same terms as Perl itself.

=cut

use strict;
use vars qw($VERSION $DEBUGGING);

$DEBUGGING = 0 unless defined $DEBUGGING;

require 5.003_96;

sub import {
    my($pack,@enums)=@_;
    return unless @enums;
    my $prefix;
    if ($enums[0] =~ /^prefix:(.*)/) {
	$prefix = $1;
	unless (length $prefix) {
	    require Carp;
	    &Carp::croak("Can't use null string as prefix");
	}
	shift @enums;
    } else {
	$prefix = '';
    }
    my $caller=caller;
    my $ref=0;
    my $sym;

    for $sym (@enums) {
	if ( $sym =~ /^=/ or $sym =~ /=$/ ) {
	    require Carp;
	    &Carp::croak("Can't declare symbol $sym" .
		" (No spaces allowed around equal sign.)");
	}
	if ($sym=~/^([^=]+)=(.+)$/) {
	    ($sym, $ref) = ($1, $2);
	    unless ($ref=~/^[a-zA-Z]*[0-9]*$/	# auto-inc-able
		    or $ref =~ /^[+\-]?\d+$/	# other integer
	    ) {
		require Carp;
		&Carp::croak("Can't enumerate from value '$ref'");
	    }
	}

	my $full = "$prefix$sym";

	unless ($full=~/^[^\W_0-9]\w*$/) {
	    require Carp;
	    &Carp::croak("Can't define '$full' as enumeration constant" .
		" (Name is empty or doesn't start with a letter)");
	}

	my $value=$ref++;
	no strict 'refs';
	if ($DEBUGGING) {
	    require Carp;
	    &Carp::carp("### Defining ${caller}::$full = $value");
	}
	*{"${caller}::$full"}=sub () { $value };
    }
}

1;
