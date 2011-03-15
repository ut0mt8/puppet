CREATE DATABASE pureftpd;

GRANT SELECT ON pureftpd.* TO 'ftpd'@'10.%' IDENTIFIED BY '*******';

USE pureftpd;

CREATE TABLE users (
    Username varchar(64) NOT NULL default '',
    Password varchar(64) NOT NULL default '',
    Uid varchar(11) NOT NULL default '-1',
    Gid varchar(11) NOT NULL default '-1',
    Base varchar(128) NOT NULL default '',
    Home varchar(128) NOT NULL default '',
    Quota smallint(5) NOT NULL default '100',
    MaxUploadSpeed smallint(5) NOT NULL default '50',
    MaxDownloadSpeed smallint(5) NOT NULL default '50',
    Active enum('Yes','No') NOT NULL default 'Yes',
    PRIMARY KEY (Username),
    UNIQUE KEY User (Username)
);
