package Net::FTPServer::RO_FTPThis::Server;

# DATE
# VERSION

use Cwd;
use parent qw(Net::FTPServer::RO::Server);

sub user_login_hook {
}

sub root_directory_hook {
    my $self = shift;

    return Net::FTPServer::RO::DirHandle->new($self);
}

sub _chdir {
    my $self = shift;
    my $dirh = shift;

    # XXX
}

1;
# ABSTRACT: Subclass of Net::FTPServer::RO::Server for ftp_this
