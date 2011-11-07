#!/usr/bin/perl 

use strict;
use DBI;

my $dbh = DBI->connect('DBI:mysql:bacula', 'bacula', 'XXX') or die "Could not connect to database: $DBI::errstr";
my $sql = "select MediaType, VolumeName from Media where LastWritten < date_sub(now(), interval 2 month) ";
my $sth = $dbh->prepare($sql);
$sth->execute();

while ( my @row = $sth->fetchrow_array() ) {
        my $device = $row[0];
        my $volume = $row[1];
        $device =~ s/File-/Device-/g;
        my $file = "/data/bacula/$device/$volume";

        if ( -f $file ) {
                print "Deleting $file\n";
                unlink $file;
        }
}
