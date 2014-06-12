package Net::FTPServer::ftpthis_RO::Server;

use 5.010;
use strict;
use warnings;

use parent qw(Net::FTPServer::RO::Server);
use Net::FTPServer::ftpthis_RO::DirHandle;
use Net::FTPServer::ftpthis_RO::FileHandle;

# DATE
# VERSION

sub user_login_hook {
    # Net::FTPServer::RO::Server tries to look up user 'ftp' to drop privs to.
    # this is not always available, some OS'es might use 'nobody' etc.
}

sub root_directory_hook {
    my $self = shift;

    return Net::FTPServer::ftpthis_RO::DirHandle->new($self);
}

1;
