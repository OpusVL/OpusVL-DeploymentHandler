package OpusVL::DeploymentHandler::VersionStorage::WithSchema::VersionResultSet;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

use Try::Tiny;

our $VERSION = '0.002';

sub version_storage_is_installed {
    return 0;
    my $self = shift;
    try { $self->count; 1 } catch { undef }
}

1;
