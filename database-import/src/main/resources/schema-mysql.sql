DROP VIEW IF EXISTS taste_preferences;
DROP TABLE IF EXISTS POST_TAG;
DROP TABLE IF EXISTS TAG;
DROP TABLE IF EXISTS COMMENTS;
DROP TABLE IF EXISTS VOTES;
DROP TABLE IF EXISTS POSTS;
DROP TABLE IF EXISTS USERS;
DROP TABLE IF EXISTS taste_item_similarity;

CREATE TABLE USERS (
  ID BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  VERSION BIGINT NOT NULL,
  REPUTATION INT NOT NULL,
  CREATION_DATE DATETIME NOT NULL,
  DISPLAY_NAME VARCHAR (255),
  LAST_ACCESS_DATE DATETIME NOT NULL,
  LOCATION VARCHAR (255),
  ABOUT TEXT,
  VIEWS INT NOT NULL,
  UP_VOTES INT NOT NULL,
  DOWN_VOTES INT NOT NULL
);

CREATE TABLE POST (
  ID BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  VERSION BIGINT NOT NULL,
  POST_TYPE INT NOT NULL,
  ACCEPTED_ANSWER_ID BIGINT,
  CREATION_DATE DATETIME,
  SCORE INT,
  VIEW_COUNT INT NOT NULL,
  BODY TEXT,
  OWNER_USER_ID BIGINT NOT NULL,
  TITLE VARCHAR (255) NULL,
  ANSWER_COUNT INT,
  COMMENT_COUNT INT,
  FAVORITE_COUNT INT,
  PARENT_ID BIGINT
  -- constraint POST_USER foreign key (OWNER_USER_ID) references USERS(ID)
);

CREATE TABLE VOTES (
  ID BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  VERSION BIGINT NOT NULL,
  POST_ID BIGINT NOT NULL,
  VOTE_TYPE INT NOT NULL,
  CREATION_DATE DATETIME NOT NULL,
  constraint VOTE_POST foreign key (POST_ID) references POST(ID)
);

CREATE TABLE COMMENTS (
  ID BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  VERSION BIGINT NOT NULL,
  POST_ID BIGINT NOT NULL,
  VALUE TEXT,
  CREATION_DATE DATETIME,
  USER_ID BIGINT NOT NULL,
  SCORE INT,
	constraint COMMENTS_POST foreign key (POST_ID) references POST(ID),
  constraint USERS_POST foreign key (USER_ID) references USERS(ID)
);

CREATE TABLE TAG (
  ID BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  VERSION BIGINT NOT NULL,
  TAG VARCHAR(255) NOT NULL
);

CREATE TABLE POST_TAG (
  POST_ID BIGINT NOT NULL,
  TAG_ID BIGINT NOT NULL,
  constraint POST_TAG_POST foreign key (POST_ID) references POST(ID),
  constraint POST_TAG_TAG foreign key (TAG_ID) references TAG(ID)
);

CREATE VIEW taste_preferences AS
  SELECT pp.owner_user_id AS user_id,
         t.id as item_id,
         SUM(coalesce(pp.score, 1)) as preference
  FROM tag t INNER JOIN
    post_tag tp ON t.id = tp.tag_id LEFT OUTER JOIN
    post p ON tp.post_id = p.id INNER JOIN
    post pp ON pp.parent_id = p.id
  WHERE pp.post_type = 2
  GROUP BY PP.OWNER_USER_ID, T.ID;

CREATE TABLE taste_item_similarity (
  item_id_a BIGINT NOT NULL,
  item_id_b BIGINT NOT NULL,
  similarity FLOAT NOT NULL,
  PRIMARY KEY (item_id_a, item_id_b)
);