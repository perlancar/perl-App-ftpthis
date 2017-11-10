package Net::FTPServer::RO_FTPThis::Server;

# DATE
# VERSION

use strict;
use warnings;

use parent qw(Net::FTPServer::RO::Server);

sub user_login_hook {
    my $self = shift;
    my $user = shift;
    my $user_is_anon = shift;

    # reject non-anonymous login
    die "only anonymous ftp mode supported" unless $user_is_anon;

    my $dir = $self->config("root directory");
    my @st = stat($dir) or die "Can't stat '$dir': $!";
    my @pw;
    if ($st[4] == 0) {
        @pw = getpwnam("nobody") or die "Can't get user nobody";
    } else {
        @pw = getpwuid($st[4]) or die "Can't get user with UID $st[4]";
    }

    if ($> == 0) {
        # chroot to directory and change to directory's owner

        chroot $dir or die "cannot chroot to '$dir': $!";

        # We don't allow users to relogin, so completely change to the user
        # specified.
        warn "D: Dropping to user $pw[0]\n" if $ENV{DEBUG};
        $self->_drop_privs ($pw[2], $pw[3], $pw[0]);
    } else {
        die "non-root mode unsupported yet";
    }
}

1;
# ABSTRACT: Subclass of Net::FTPServer::RO::Server for ftp_this
