#!/usr/bin/perl 
# Quick script to delete a client
# RMZ 2008/2011

use strict;
use DBI;

defined ($ARGV[0]) or die "Usage $0 <client>";

my $client = $ARGV[0];

my $dbh = DBI->connect('DBI:mysql:bacula', 'bacula', 'B4uv0DgB2sZUyWgzSRywWecrJpmj6mqNX3NNSCdGaYWFlkBzk6FesqB') or die "Could not connect to database: $DBI::errstr";
my $sql = "select distinct VolumeName,MediaType from Job left join JobMedia on Job.JobId = JobMedia.JobId left join Media on JobMedia.MediaId = Media.MediaId where JobStatus = 'T' and VolumeName is not NULL and Job.Name='$client'";

my $sth = $dbh->prepare($sql);
$sth->execute();

while ( my @row = $sth->fetchrow_array() ) {
	my $volume = $row[0];
	my $device = $row[1];
	$device =~ s/File-/Device-/g;
	my $file = "/data/bacula/$device/$volume";
	print "Found $file\n";
	
	if ( -f $file ) {
		print "Deleting $file\n";
		unlink $file;
	}
}

$sql="delete from Client where Name='$client'";
$sth = $dbh->prepare($sql);
$sth->execute();

$sql="delete from FileSet where FileSet='$client'";
$sth = $dbh->prepare($sql);
$sth->execute();

$sql="delete from Job where Name ='$client'";
$sth = $dbh->prepare($sql);
$sth->execute();

$sql="delete from Media where VolumeName like '%-$client-00%'";
$sth = $dbh->prepare($sql);
$sth->execute();

$sql="delete from Pool where Name like '%-$client'";
$sth = $dbh->prepare($sql);
$sth->execute();

my $file = "/data/bacula/BSR/$client.bsr";
if ( -f $file ) {
	print "Deleting $file\n";
	unlink $file;
}

$file = "/etc/bacula/clients/$client.conf";
if ( -f $file ) {
	print "Deleting $file\n";
	unlink $file;
}

$file = "/etc/bacula/filesets/$client.conf";
if ( -f $file ) {
	print "Deleting $file\n";
	unlink $file;
}

1;
