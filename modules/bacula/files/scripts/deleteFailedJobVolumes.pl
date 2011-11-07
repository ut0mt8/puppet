#!/usr/bin/perl 
# Quick script to delete failed volume
# RMZ 2008/2011

use strict;
use DBI;

my $dbh = DBI->connect('DBI:mysql:bacula', 'bacula', 'XXX') or die "Could not connect to database: $DBI::errstr";
my $sql = "select distinct VolumeName,MediaType from Job left join JobMedia on Job.JobId = JobMedia.JobId left join Media on JobMedia.MediaId = Media.MediaId where JobStatus = 'f' and VolumeName is not NULL";

my $sth = $dbh->prepare($sql);
$sth->execute();

while ( my @row = $sth->fetchrow_array() ) {
	my $volume = $row[0];
	my $device = $row[1];
	$device =~ s/File-/Device-/g;
	my $file = "/data/bacula/$device/$volume";
	
	if ( -f $file ) {
		print "Deleting $file\n";
		unlink $file;
	}
}

1;
