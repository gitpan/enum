package enum;
use strict;
no strict 'refs';  # Let's just make this very clear right off

use Carp;
use vars qw($VERSION);
$VERSION = do { my @r = (q$Revision: 1.9 $ =~ /\d+/g); sprintf '%d.%03d'.'%02d' x ($#r-1), @r};

my $Ident = '[^\W_0-9]\w*';

sub import {
	my $class	= shift;
	@_ or return;		# Ignore 'use enum;'
	my $pkg		= caller() . '::';
	my $prefix	= '';	# default no prefix 
	my $index	= 0;	# default start index

	## Pragmas should be as fast as they can be, so we inline some
	## pieces.
	foreach (@_) {
		if (/^$Ident$/o) {							## Plain tag is most common case
			my $n = $index++;
			die "pkg" unless defined $pkg;
			die "prefix" unless defined $prefix;
			die "_" unless defined $_;
			die "n" unless defined $n;
			*{"$pkg$prefix$_"} = sub () { $n };
		} elsif (/^($Ident)=(.+)$/o) {				## Index change
			$index	= $2;
			my $n	= $index++;
			die "pkg" unless defined $pkg;
			die "prefix" unless defined $prefix;
			die "_" unless defined $_;
			die "n" unless defined $n;
			*{"$pkg$prefix$1"} = sub () { $n };
		} elsif (/^:($Ident)?(=?)(.*)/) {			## Prefix change
			if ($2) {								## Index change too?
				if (length $3) {
					$index = $3;
				} else {
					croak qq(No index value defined after "=");
				}
			}
			$prefix = defined $1 ? $1 : '';  ## Incase it's a null prefix
		} elsif (/^($Ident)\.\.($Ident)$/o) {		## A..Z case magic lists
			foreach my $name ("$1" .. "$2") {		## Almost never used, so check last
				my $n = $index++;
				die "pkg" unless defined $pkg;
				die "prefix" unless defined $prefix;
				die "_" unless defined $_;
				die "n" unless defined $n;
				*{"$pkg$prefix$name"} = sub () { $n };
			}
		} else {
			croak qq(Can't define "$_" as enum type (name contains invalid characters));
		}
	}
}

1;

__END__


=head1 NAME

enum - C style enumerated types in Perl

=head1 SYNOPSIS

  use enum qw(Zero One Two Three Four);
  # Zero == 0, One == 1, Two == 2, etc

  use enum qw(Forty=40 FortyOne Five=5 Six Seven);
  # Yes, you can change the start indexs at any time as in C

  use enum qw(Sun Mon Tue Wed Thu Fri Sat);
  # Sun == 0, Mon == 1, etc

  use enum qw(:Prefix_ One Two Three);
  ## Creates Prefix_One, Prefix_Two, Prefix_Three

  use enum qw(:Letters_ A..Z);
  ## Creates Letters_A, Letters_B, etc

  use enum qw(
      :Months_=0 Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
      :Days_=0   Sun Mon Tue Wed Thu Fri Sat
      :Letters_=20 A..Z
  );
  ## Prefixes can be changed mid list and can have index changes too

=head1 DESCRIPTION

Defines a set of symbolic constants with ordered numeric values ala B<C> B<enum> types.

What are they good for?  Typical uses would be for giving mnemonic names to indexes of
arrays.  Such arrays might be a list of months, days, or a return value index from
a function such as localtime():

  use enum qw(
      :Months_=0 Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
      :Days_=0   Sun Mon Tue Wed Thu Fri Sat
      :LC_=0     Sec Min Hour MDay Mon Year WDay YDay Isdst
  );

  if ((localtime)[LC_Mon] == Months_Jan) {
      print "It's January!\n";
  }
  if ((localtime)[LC_WDay] == Days_Fri) {
      print "It's Friday!\n";
  }

Another useful use of enum array index names is when using an array ref instead of
a hash ref for building objects:

  package My::Class;
  use strict;

  use enum qw(Field Names You Want To Use);
  sub new {
      my $class = shift;
      my $self  = [];

      $self->[Field] = 'value'; # Field is '0'
      $self->[Names] = 'value'; # Names is '1'
      $self->[You]   = 'value'; # etc...
      $self->[Want]  = 'value';
      $self->[To]    = ['some', 'list'];
      $self->[Use]   = 'value';
      return bless $self, $class;
  }

This has a couple of advantages over using a hash ref and keys:

=over 4

=item Speed

Using an array ref for an object yields much faster access times then a hash ref.
Because the symbolic constants this module defines will be inlined by the perl
interpreter there is no run time over head for name look up as there is when using
a hash style object.

=item Error Checking

Because these names are used as bare words, when B<use strict> is applied it will
cause compile time errors if you misspell a field name.  Conversely traditional hash
value lookups are very prone to this type of error and will never cause a compile time
error or warning, and in some cases no warning at all.

This module is very similar to the B<constant> module.  In fact, these statements
are the same:

  use constant Foo => 0; use constant Bar => 1;
  use enum qw(Foo Bar);

Using B<-w> will cause compile time warnings to be produced if you accidently override
a field with a method name or vis-versa.

=back

=head1 BUGS

Enum names can not be the same as method, function, or constant names.  This
is probably a Good Thing[tm].

No way to cause compile time errors when one of these enum names get redefined.
IMHO, there is absolutely no time when redefining a sub is a Good Thing[tm], and
should be taken out of the language.

Enumerated types are package scoped just like constants, not block scoped as some
other pragma modules are.

Supports A..Z nonsense.  Can anyone give me a Real World[tm] reason why anyone would
ever use this feature...?

=head1 HISTORY

 $Log: enum.pm,v $
 Revision 1.9  1998/06/12 00:21:00  byron
 	-Fixed -w warning when a null tag is used

 Revision 1.8  1998/06/11 23:04:53  byron
 	-Fixed documentation bugs
 	-Moved A..Z case to last as it's not going to be used
 	 as much as the other cases.

 Revision 1.7  1998/06/10 12:25:04  byron
 	-Changed interface to match original design by Tom Phoenix
 	 as implemented in an early version of enum.pm by Benjamin Holzman.
 	-Changed tag syntax to not require the 'PREFIX' string of Tom's
 	 interface.
 	-Allow multiple prefix tags to be used at any point.
 	-Allowed index value changes from tags.

 Revision 1.6  1998/06/10 03:37:57  byron
 	-Fixed superfulous -w warning

 Revision 1.5  1998/06/10 01:31:12  byron
 	-Fixed typo in docs

 Revision 1.4  1998/06/10 01:07:03  byron
 	-Changed behaver to closer resemble C enum types
 	-Changed docs to match new behaver

 Revision 1.3  1998/06/08 16:28:58  byron
 	-Changed name from fields to enum

 Revision 1.1  1998/06/01 18:02:06  byron
 Initial revision

=head1 AUTHOR

Zenin <zenin@archive.rhps.org>

aka Byron Brummer <byron@thrush.omix.com>.

Based off of the B<constant> module by Tom Phoenix.

Original implementation of an interface of Tom Phoenix's
design by Benjamin Holzman, for which we borrow the basic
parse algorithm layout.

=head1 SEE ALSO

constant(3), perl(1).

=cut
