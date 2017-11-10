package App::FTPThis;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Cwd;
use Getopt::Long;
use Pod::Usage;

sub new {
    my $class = shift;
    my $self = bless {port => 8021, root => '.'}, $class;

    GetOptions($self, "help", "man", "port=i",
           ) || pod2usage(2);
    pod2usage(1) if $self->{help};
    pod2usage(-verbose => 2) if $self->{man};

    if (@ARGV > 1) {
        pod2usage("$0: Too many roots, only single root supported");
    } elsif (@ARGV) {
        $self->{root} = shift @ARGV;
    } else {
        $self->{root} = getcwd();
    }

    return $self;
}

sub run {
    require File::Slurper;
    require File::Temp;
    require Net::FTPServer::RO_FTPThis::Server;

    my ($self) = @_;

    my $dir = File::Temp::tempdir(CLEANUP => !$ENV{DEBUG});
    say "D: temporary dir = $dir" if $ENV{DEBUG};

    File::Slurper::write_text(
        "$dir/conf",
        join(
            "",
            "root directory: $self->{root}\n",
            "allow anonymous: 1\n",
            "anonymous password check: none\n",
            "anonymous password enforce: 0\n",
            "home directory: $self->{root}\n",
            "limit memory: -1\n",
            "limit nr processes: -1\n",
            "limit nr files: -1\n",
        ),
    );

    say "Starting FTP server on port $self->{port} ...";

    chdir $self->{root} or die "Can't chdir to $self->{root}: $!";
    local @ARGV = (
        "-C=$dir/conf",
        "-p", $self->{port},
        "-s", # daemon mode (not background, which is -S)
    );
    my $ftpd = Net::FTPServer::RO_FTPThis::Server->run;
}

1;
# ABSTRACT: Export the current directory over anonymous FTP

=head1 SYNOPSIS

 # Not to be used directly, see ftp_this command


=head1 DESCRIPTION


=head1 METHODS

=head2 new

=head2 run


=head1 ENVIRONMENT

=head2 DEBUG => bool

If set to true, won't cleanup temporary directory.


=head1 SEE ALSO

=cut
