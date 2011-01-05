CREATE TABLE `bookmarks` (
  `id` int(11) NOT NULL auto_increment,
  `url` varchar(255) NOT NULL default '',
  `tags` varchar(255) default NULL,
  `page_title` varchar(500) default NULL,
  `meta_data` varchar(1000) default NULL,
  `tiny_url` varchar(255) NOT NULL default '',
  `site_id` bigint(20) NOT NULL default '1',
  `bookmark_date` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `FK_bookmarks` (`site_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sites` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `domain` varchar(255) NOT NULL default '',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('20101227045753');

INSERT INTO schema_migrations (version) VALUES ('20101227045841');