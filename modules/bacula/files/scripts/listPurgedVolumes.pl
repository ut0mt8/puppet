#!/usr/bin/perl 

use strict;
use DBI;

my $dbh = DBI->connect('DBI:mysql:bacula', 'bacula', 'B4uv0DgB2sZUyWgzSRywWecrJpmj6mqNX3NNSCdGaYWFlkBzk6FesqB') or die "Could not connect to database: $DBI::errstr";
my $sql = "select MediaType, VolumeName from Media where VolStatus='Purged';";

my $sth = $dbh->prepare($sql);
$sth->execute();

while ( my @row = $sth->fetchrow_array() ) {
        $_ = @row;
	chomp;
	s,File-,/data/bacula/Device-,;
	s,\s+,/,;
	print $_;
}
