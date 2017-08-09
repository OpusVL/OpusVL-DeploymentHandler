use strict;
use warnings;
package OpusVL::DeploymentHandler;

use Moose;
use File::Temp;

extends 'DBIx::Class::DeploymentHandler';
use OpusVL::DeploymentHandler::VersionStorage::WithSchema;

around deploy => sub {
    my $orig = shift;
    my $self = shift;

    my $args = shift // {};

    $args->{version} //= $self->schema_version;

    my $ddl = $self->$orig($args);

    $self->add_database_version({
        version => $args->{version},
        ddl => $ddl
    });

    return $ddl;
};

override _build_version_storage => sub {
    my $self = shift;

    OpusVL::DeploymentHandler::VersionStorage::WithSchema->new({ schema => $self->schema });
};

override install_version_storage => sub {
    my $self = shift;
    my $version = (shift||{})->{version} || $self->schema_version;
    my $source = $self->version_storage->version_rs->result_source;

    my $proto_file = File::Temp->new( SUFFIX => '.yml' );
    my $install_file = File::Temp->new( SUFFIX => '.sql' );

    # FIXME: this requires that we use the SQL::Translator deploy method.
    $self->deploy_method->prepare_protoschema({
        parser_args => { sources => [$source->source_name], }
    }, sub{"$proto_file"});

    $proto_file->seek(0,0);

    $self->deploy_method->_prepare_install({}, sub{ "$proto_file" }, sub{ "$install_file" });
    $install_file->seek(0,0);

    $self->deploy_method->_run_sql_and_perl([ "$install_file" ], [], [$version]);
};
1;
