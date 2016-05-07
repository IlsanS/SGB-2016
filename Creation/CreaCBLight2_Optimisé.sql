drop table "CB".movie cascade constraints PURGE;
drop table "CB".artist cascade constraints PURGE;
drop table "CB".certification cascade constraints PURGE;
drop table "CB".copy cascade constraints PURGE;
drop table "CB".status cascade constraints PURGE;
drop table "CB".genre cascade constraints PURGE;


drop table "CB".play cascade constraints PURGE;
drop table "CB".direct cascade constraints PURGE;
drop table "CB".genre_movie cascade constraints PURGE;
drop table "CB".cert_movie cascade constraints PURGE;
drop table "CB".status_movie cascade constraints PURGE;






-- ###############################
-- # CREATE TABLE USER
-- ###############################

CREATE TABLE user_movie
(
	id_user			NUMBER(5),
	lastname 		VARCHAR2(40),
	firstname		VARCHAR2(60),	
	login			VARCHAR2(30),
	pwd				VARCHAR2(30),
	sex				CHAR(1),
	email			VARCHAR2(80),
	birthday		DATE,
	created_at		DATE,
	updated_at		DATE,
	address			VARCHAR2(100),	--Facultative
	is_deleted		CHAR(1) 	DEFAULT '0',
	deleted_at		DATE		DEFAULT NULL,
	token			VARCHAR(30) DEFAULT 'REMOTE',
	CONSTRAINT nn_lastname			CHECK(lastname IS NOT NULL),
	CONSTRAINT nn_firstname			CHECK(firstname IS NOT NULL),		
	CONSTRAINT nn_login				CHECK(login IS NOT NULL),
	CONSTRAINT nn_pwd				CHECK(pwd IS NOT NULL),
	CONSTRAINT nn_sex				CHECK(sex IS NOT NULL),
	CONSTRAINT nn_email				CHECK(email IS NOT NULL),
	CONSTRAINT nn_birthday			CHECK(birthday IS NOT NULL),
	CONSTRAINT nn_created			CHECK(created_at IS NOT NULL),
	CONSTRAINT nn_updated			CHECK(updated_at IS NOT NULL),
	CONSTRAINT nn_token_user		CHECK(token IS NOT NULL),
	CONSTRAINT pk_idUser 		    PRIMARY KEY(id_user),
	CONSTRAINT un_auth 				UNIQUE(login),
	CONSTRAINT un_email				UNIQUE(email),
	CONSTRAINT ck_initcap 			CHECK(lastname = UPPER(lastname)),
	CONSTRAINT ck_sex 				CHECK(UPPER(sex) = 'M' OR UPPER(sex) = 'F'),
	CONSTRAINT ck_crea_upd 			CHECK(created_at <= updated_at)
	
);
/
/**********************************************************************
		  			TABLE LOG UTILES
***********************************************************************/

CREATE TABLE "LOGS"( 
	"AT" DATE, 
	"MESSAGE" VARCHAR2(1000 BYTE)
) ;

CREATE TABLE "ERRLOG" (
	"CREATED_ON" DATE, 
	"ERRCODE" int,
	"ERRMSG" VARCHAR2(4000 BYTE), 
	"CREATED_BY" VARCHAR2(1000 BYTE)
);

commit;



-- ###############################
-- # CREATE TABLE OVERVIEW
-- ###############################

CREATE TABLE overview
(
	id_user			NUMBER(5),
	id_movie		integer,
	vote			NUMBER(4,2),
	opinion			VARCHAR2(200),
	inserted_at		DATE,
	token			VARCHAR(30) DEFAULT 'REMOTE_ASYNC',
	CONSTRAINT	nn_fkUser				CHECK(id_user IS NOT NULL),
	CONSTRAINT	nn_fkMovie				CHECK(id_movie IS NOT NULL),
	CONSTRAINT 	nn_vote					CHECK(vote IS NOT NULL),
	CONSTRAINT 	nn_inserted				CHECK(inserted_at IS NOT NULL),
	CONSTRAINT 	nn_token_overv			CHECK(token IS NOT NULL),
	CONSTRAINT  ck_vote					CHECK(vote > 0),
	CONSTRAINT  pk_overview 			PRIMARY KEY(id_user, id_movie),
	CONSTRAINT  fk_overv_idUser_user	FOREIGN KEY(id_user) REFERENCES user_movie(id_user),
	CONSTRAINT  fk_overv_idMovie_movie	FOREIGN KEY(id_movie) REFERENCES movie(id)
);
/

-- -- ###############################
-- -- # CREATE TABLE MOVIE
-- -- ###############################

create table movie(
	id integer ,
	title varchar2(100),
	status varchar2(200),
	release_date date,
	vote_average number(2),
	vote_count number(10), 
	runtime number(5),
	budget int,
	tagline varchar2(200),
	poster blob,
	nb_copies int constraint movie_nbCopie_NN CHECK (nb_copies >= 0),
	constraint movie_budget_NN CHECK (budget >= 0),
	constraint movie_vote_count_NN CHECK (vote_count >= 0),
	constraint movie_vote_average_NN CHECK (vote_average  >= 0),
	constraint ID_movie  primary key (id)

);

-- -- ###############################
-- -- # CREATE TABLE CERTIFICATION
-- -- ###############################

CREATE TABLE certification
(
	id 				varchar(6),
	name 			VARCHAR(50),
	description		VARCHAR2(500),
	CONSTRAINT  ck_cert_id			CHECK (id in ('G', 'PG', 'PG-13', 'R', 'NC-17')),
	CONSTRAINT	nn_name_cert		CHECK(name IS NOT NULL),
	CONSTRAINT  pk_cert				PRIMARY KEY(id)
);
/

INSERT into certification values('G', 'General Audiences', 'Nothing that would offend parents for viewing by children.');
INSERT into certification values('PG', 'Parental guidance suggested', 'Parents urged to give parental guidance.');
INSERT into certification values('PG-13', 'Parent strongly cautioned', 'Parents are urged to be cautious. Some material may be innapropriate for pre-teen.');
INSERT into certification values('R', 'Restricted', 'Parents are urged to be cautious. Some material may be innapropriate for pre-teen.');
INSERT into certification values('NC-17', 'No one 17 and under admitted', 'Clrearly adult. Childre are not admitted.');
COMMIT
/


-- ###############################
-- # CREATE TABLE ARTIST
-- ###############################
CREATE TABLE artist
(
	id				number(7),
	name			VARCHAR2(30),
	CONSTRAINT	nn_name_artist			CHECK(name IS NOT NULL),
	CONSTRAINT  pk_artist				PRIMARY KEY(id)
);
/

-- ###############################
-- # CREATE TABLE GENRE
-- ###############################
CREATE TABLE genre
(
	id				number(5),
	name			VARCHAR2(30),
	CONSTRAINT	nn_name_genre			CHECK(name IS NOT NULL),
	CONSTRAINT  pk_genre				PRIMARY KEY(id)
);
/

-- ###############################
-- # CREATE TABLE STATUS
-- ###############################
CREATE TABLE status
(
	id				INTEGER,
	name			VARCHAR(50),
	CONSTRAINT	nn_name_status			CHECK(name IS NOT NULL),
	CONSTRAINT  pk_status				PRIMARY KEY(id)
);
/

-- ###############################
-- # CREATE TABLE COPY
-- ###############################
CREATE TABLE copy
(
	num				INTEGER, 
	id_movie 		integer, 	 	
	CONSTRAINT	nn_fkMovie_copy			CHECK(id_movie IS NOT NULL),
	CONSTRAINT  pk_copy					PRIMARY KEY(num, id_movie),
	CONSTRAINT  fk_copy_idMovie_movie	FOREIGN KEY(id_movie) REFERENCES movie(id)

);
/

-- ###############################
-- # CREATE TABLE CERT_MOVIE
-- ###############################
CREATE TABLE cert_movie
(
	id_movie		INTEGER,
	id_cert			VARCHAR(5),
	CONSTRAINT	nn_fkMovie_cert			CHECK(id_movie IS NOT NULL),
	CONSTRAINT	nn_fkCert				CHECK(id_cert IS NOT NULL),
	CONSTRAINT  pk_cert_movie			PRIMARY KEY(id_movie, id_cert),
	CONSTRAINT  fk_certm_idMovie_movie	FOREIGN KEY(id_movie) REFERENCES movie(id),
	CONSTRAINT  fk_certm_idMovie_cert	FOREIGN KEY(id_cert) REFERENCES certification(id)
	
);
/
-- ###############################
-- # CREATE TABLE PLAY
-- ###############################
CREATE TABLE play
(
	id_movie		INTEGER,
	id_actor		 number(7),
	CONSTRAINT	nn_fkMovie_play			CHECK(id_movie IS NOT NULL),
	CONSTRAINT	nn_fkActor				CHECK(id_actor IS NOT NULL),
	CONSTRAINT  pk_play					PRIMARY KEY(id_movie, id_actor),
	CONSTRAINT  fk_play_idMovie_movie	FOREIGN KEY(id_movie) REFERENCES movie(id),
	CONSTRAINT  fk_play_idMovie_actor	FOREIGN KEY(id_actor) REFERENCES artist(id)
	
);
/

-- ###############################
-- # CREATE TABLE DIRECT
-- ###############################
CREATE TABLE direct
(
	id_movie		Integer,
	id_director		number(7),
	CONSTRAINT	nn_fkMovie_direct		CHECK(id_movie IS NOT NULL),
	CONSTRAINT	nn_fkDirector			CHECK(id_director IS NOT NULL),
	CONSTRAINT  pk_direct				PRIMARY KEY(id_movie, id_director),
	CONSTRAINT  fk_dir_idMovie_movie	FOREIGN KEY(id_movie) REFERENCES movie(id),
	CONSTRAINT  fk_dir_idMovie_direct 	FOREIGN KEY(id_director) REFERENCES artist(id)
);
/

-- ###############################
-- # CREATE TABLE GENRE_MOVIE
-- ###############################
CREATE TABLE genre_movie
(
	id_movie		INTEGER,
	id_genre		INTEGER,
	CONSTRAINT	nn_fkMovie_genre		CHECK(id_movie IS NOT NULL),
	CONSTRAINT	nn_fkGenre				CHECK(id_genre IS NOT NULL),
	CONSTRAINT  pk_genre_movie			PRIMARY KEY(id_movie, id_genre),
	CONSTRAINT  fk_genrem_idMovie_movie	FOREIGN KEY(id_movie) REFERENCES movie(id),
	CONSTRAINT  fk_genrem_idMovie_actor	FOREIGN KEY(id_genre) REFERENCES genre(id)
);
/

-- ###############################
-- # CREATE TABLE STATUS_MOVIE
-- ###############################
CREATE TABLE status_movie
(
	id_movie		INTEGER,
	id_status		INTEGER,
	CONSTRAINT	nn_fkMovie_status		CHECK(id_movie IS NOT NULL),
	CONSTRAINT	nn_fkStatus				CHECK(id_status IS NOT NULL),
	CONSTRAINT  pk_status_movie			PRIMARY KEY(id_movie, id_status),
	CONSTRAINT  fk_stasm_idMovie_movie	FOREIGN KEY(id_movie) REFERENCES movie(id),
	CONSTRAINT  fk_statm_idMovie_status	FOREIGN KEY(id_status) REFERENCES status(id)
);
/


COMMIT;






	
	
	