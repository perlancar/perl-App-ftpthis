package Net::FTPServer::ftpthis_RO::DirHandle;

use 5.010;
use strict;
use warnings;

use parent qw(Net::FTPServer::RO::DirHandle);

# DATE
# VERSION

sub new {
    my ($class, $ftps) = @_;
    my $self = $class->SUPER::new($ftps);
    $self->{_ftps} = $ftps;
    bless $self, $class;
}

sub list {
    my $self = shift;

    local $self->{_pathname} = $self->{_ftps}->config("root directory") .
        "/" . $self->{_pathname};
    say "D:_pathname=$self->{_pathname}";
    $self->SUPER::list(@_);
}

sub get {
    my $self = shift;

    local $self->{_pathname} = $self->{_ftps}->config("root directory") .
        "/" . $self->{_pathname};
    say "D:_pathname=$self->{_pathname}";
    $self->SUPER::get(@_);
}

1;
