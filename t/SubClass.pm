#  Subclass for 'enum' test suite.

use strict;
use warnings;
package SubClass;
use base 'enum';

__PACKAGE__->set_enumerations(qw(this IS a test));
