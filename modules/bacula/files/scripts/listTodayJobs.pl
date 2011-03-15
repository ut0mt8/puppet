#!/usr/bin/perl 

use strict;
use DBI;

my $dbh = DBI->connect('DBI:mysql:bacula', 'bacula', 'B4uv0DgB2sZUyWgzSRywWecrJpmj6mqNX3NNSCdGaYWFlkBzk6FesqB') or die "Could not connect to database: $DBI::errstr";
my $sql = "select Name,Level,StartTime,EndTime,JobStatus from Job where EndTime <= NOW() and UNIX_TIMESTAMP(EndTime) >UNIX_TIMESTAMP(NOW())-86400 order by Name";

my $sth = $dbh->prepare($sql);
$sth->execute();

while ( my @row = $sth->fetchrow_array() ) {
	print "@row\n";
}
