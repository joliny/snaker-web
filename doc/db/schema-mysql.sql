CREATE TABLE `sec_menu` (
  `id` BIGINT(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `description` VARCHAR(500) DEFAULT NULL,
  `name` VARCHAR(200) NOT NULL,
  `parent_menu` BIGINT(20) DEFAULT NULL
);

CREATE TABLE `sec_resource` (
  `id` BIGINT(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `source` VARCHAR(200) DEFAULT NULL,
  `menu` BIGINT(20) DEFAULT NULL
);
ALTER TABLE SEC_RESOURCE ADD UNIQUE (NAME);
ALTER TABLE SEC_RESOURCE ADD CONSTRAINT FK_RESOURCE_MENU FOREIGN KEY (MENU) REFERENCES SEC_MENU (ID);

CREATE TABLE `sec_authority` (
  `id` BIGINT(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `description` VARCHAR(500) DEFAULT NULL,
  `name` VARCHAR(200) NOT NULL
);
ALTER TABLE SEC_AUTHORITY ADD UNIQUE (NAME);

CREATE TABLE `sec_authority_resource` (
  `authority_id` BIGINT(20) NOT NULL,
  `resource_id` BIGINT(20) NOT NULL
);
ALTER TABLE SEC_AUTHORITY_RESOURCE ADD CONSTRAINT FK_AUTHORITY_RESOURCE1 FOREIGN KEY (AUTHORITY_ID) REFERENCES SEC_AUTHORITY (ID);
ALTER TABLE SEC_AUTHORITY_RESOURCE ADD CONSTRAINT FK_AUTHORITY_RESOURCE2 FOREIGN KEY (RESOURCE_ID) REFERENCES SEC_RESOURCE (ID);

CREATE TABLE `sec_role` (
  `id` BIGINT(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `description` VARCHAR(500) DEFAULT NULL,
  `name` VARCHAR(200) NOT NULL
);
ALTER TABLE SEC_ROLE ADD UNIQUE (NAME);

CREATE TABLE `sec_role_authority` (
  `role_id` BIGINT(20) NOT NULL,
  `authority_id` BIGINT(20) NOT NULL
);
ALTER TABLE SEC_ROLE_AUTHORITY ADD CONSTRAINT FK_ROLE_AUTHORITY1 FOREIGN KEY (AUTHORITY_ID) REFERENCES SEC_AUTHORITY (ID);
ALTER TABLE SEC_ROLE_AUTHORITY ADD CONSTRAINT FK_ROLE_AUTHORITY2 FOREIGN KEY (ROLE_ID) REFERENCES SEC_ROLE (ID);

CREATE TABLE `sec_org` (
  `id` BIGINT(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `active` VARCHAR(255) DEFAULT NULL,
  `description` VARCHAR(500) DEFAULT NULL,
  `fullname` VARCHAR(200) DEFAULT NULL,
  `name` VARCHAR(200) NOT NULL,
  `type` VARCHAR(200) DEFAULT NULL,
  `parent_org` BIGINT(20) DEFAULT NULL
);
ALTER TABLE SEC_ORG ADD CONSTRAINT FK_ORG_PARENT FOREIGN KEY (PARENT_ORG) REFERENCES SEC_ORG (ID);

CREATE TABLE `sec_user` (
  `id` BIGINT(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `address` VARCHAR(200) DEFAULT NULL,
  `age` INT(11) DEFAULT NULL,
  `email` VARCHAR(100) DEFAULT NULL,
  `enabled` VARCHAR(255) DEFAULT NULL,
  `fullname` VARCHAR(100) DEFAULT NULL,
  `password` VARCHAR(50) DEFAULT NULL,
  `salt` VARCHAR(255) DEFAULT NULL,
  `sex` VARCHAR(255) DEFAULT NULL,
  `type` INT(11) DEFAULT NULL,
  `username` VARCHAR(50) NOT NULL,
  `org` BIGINT(20) DEFAULT NULL
);
ALTER TABLE SEC_USER ADD UNIQUE (USERNAME);
ALTER TABLE SEC_USER ADD CONSTRAINT FK_USER_ORG FOREIGN KEY (ORG) REFERENCES SEC_ORG (ID);

CREATE TABLE `sec_role_user` (
  `user_id` BIGINT(20) NOT NULL,
  `role_id` BIGINT(20) NOT NULL
);
ALTER TABLE SEC_ROLE_USER ADD CONSTRAINT FK_ROLE_USER1 FOREIGN KEY (USER_ID) REFERENCES SEC_USER (ID);
ALTER TABLE SEC_ROLE_USER ADD CONSTRAINT FK_ROLE_USER2 FOREIGN KEY (ROLE_ID) REFERENCES SEC_ROLE (ID);

CREATE TABLE `sec_user_authority` (
  `user_id` BIGINT(20) NOT NULL,
  `authority_id` BIGINT(20) NOT NULL
);
ALTER TABLE SEC_USER_AUTHORITY ADD CONSTRAINT FK_USER_AUTHORITY1 FOREIGN KEY (AUTHORITY_ID) REFERENCES SEC_AUTHORITY (ID);
ALTER TABLE SEC_USER_AUTHORITY ADD CONSTRAINT FK_USER_AUTHORITY2 FOREIGN KEY (USER_ID) REFERENCES SEC_USER (ID);

CREATE TABLE `conf_dictionary` (
  `id` BIGINT(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `cn_name` VARCHAR(200) NOT NULL,
  `description` VARCHAR(500) DEFAULT NULL,
  `name` VARCHAR(200) NOT NULL
);
ALTER TABLE CONF_DICTIONARY ADD UNIQUE (NAME);

CREATE TABLE `conf_dictitem` (
  `id` BIGINT(20) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `code` VARCHAR(50) DEFAULT NULL,
  `description` VARCHAR(500) DEFAULT NULL,
  `name` VARCHAR(200) NOT NULL,
  `orderby` INT(11) DEFAULT NULL,
  `dictionary` BIGINT(20) DEFAULT NULL
);
ALTER TABLE CONF_DICTITEM ADD UNIQUE (NAME);
ALTER TABLE CONF_DICTITEM ADD CONSTRAINT FK_DICTITEM_DICTIONARY FOREIGN KEY (DICTIONARY) REFERENCES CONF_DICTIONARY (ID);