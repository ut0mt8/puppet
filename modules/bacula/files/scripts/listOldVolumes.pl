#!/usr/bin/perl 

use strict;
use DBI;

my $dbh = DBI->connect('DBI:mysql:bacula', 'bacula', 'XXX') or die "Could not connect to database: $DBI::errstr";
my $sql = "select MediaType, VolumeName, LastWritten from Media where LastWritten < date_sub(now(), interval 2 month) ";
my $sth = $dbh->prepare($sql);
$sth->execute();

while ( my @row = $sth->fetchrow_array() ) {
	$row[0] =~ s,File-,/data/bacula/Device-,;
	print $row[0]."/".$row[1]." : ".$row[2]."\n";
}
