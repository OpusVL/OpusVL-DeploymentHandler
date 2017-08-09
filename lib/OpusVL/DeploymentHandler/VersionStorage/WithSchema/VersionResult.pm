use strict;
use warnings;
package OpusVL::DeploymentHandler::VersionStorage::WithSchema::VersionResult;

our $VERSION = '0.002';

use parent 'DBIx::Class::Core';

__PACKAGE__->table('dbix_class_deploymenthandler_versions_withschemata');

__PACKAGE__->add_columns(
    id => {
        data_type => 'int',
        is_auto_increment => 1,
    },
    schema => {
        data_type => 'text',
    },
    version => {
        data_type         => 'text',
    },
    ddl => {
        data_type         => 'text',
        is_nullable       => 1,
    },
    upgrade_sql => {
        data_type         => 'text',
        is_nullable       => 1,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(deploymenthandler_uniqueness => ['schema', 'version']);
__PACKAGE__->resultset_class('OpusVL::DeploymentHandler::VersionStorage::WithSchema::VersionResultSet');

1;
