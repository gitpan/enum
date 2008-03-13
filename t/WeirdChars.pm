#  Subclass for 'enum' test suite.
# This one uses odd characters in its symbol names.

use strict;
use warnings;
package WeirdChars;
use base 'enum';

__PACKAGE__->set_enumerations('0', '%^^&$', '---', '');
