

/**********************************************************************
		   CREATE TABLE  films
***********************************************************************/
create table films(
	id_films int constraint films_ID_NN not null,
	titre varchar2(100),
	status varchar2(200),
	date_sortie date,
	vote_moyen int,
	nombre_vote int 
	duree timestamp,
	budget int,
	tagline varchar2(200),
	nb_copies int constraint films_nbCopie_NN CHECK (nb_copies >= 0),
	constraint films_budget_NN CHECK (budget >= 0),
	constraint films_nombre_vote_NN CHECK (nombre_vote >= 0),
	constraint films_vote_moyen_NN CHECK (vote_moyen  >= 0)
	constraint ID_films  primary key (id_films)

);

create table certifications(
 id_cert Int 			constraint certifications_ID_NN not null,
 nom varchar2(256)			constraint certifications_Nom_NN not null,
 description varchar2(1000),
 constraint ID_certifications  primary key (id_cert)

);

create table artistes(
	id_artiste Int 		constraint artiste_ID_NN not null,
	nom varchar2(256) 	constraint artiste_nom_NN not null,
	constraint artiste_ID  primary key (id_artiste)

);

create table films(
	id_films int constraint films_ID_NN not null,
	titre varchar2(2000),
	status varchar2(1000),
	date_sortie date,
	vote_moyen int constraint films_vote_moyen_NN CHECK (vote_moyen  >= 0),
	nombre_vote int constraint films_nombre_vote_NN CHECK (nombre_vote >= 0),
	duree timestamp,
	budget int constraint films_budget_NN CHECK (budget >= 0),
	tagline varchar2(2000),
	nb_copies int constraint films_nbCopie_NN CHECK (nb_copies >= 0),
	constraint ID_films  primary key (id_films)

);

create table copies(
	id_copies Int 		constraint copies_id_copies_NN not null,
	id_films Int 		constraint copies_id_films_NN not null,
	constraint copies_ID primary key (id_films, id_copies),
	constraint copies_films_FK foreign key(id_copies) references films

);

create table cert_films(
	id_cert Int 		constraint cert_cert_film_id_NN not null,
	id_film Int 		constraint cert_film_cert_id_NN not null,
	constraint cert_films_ID  primary key (id_cert, id_film),
	constraint cert_films_FK foreign key(id_film) references films,
	constraint films_cert_FK foreign key(id_cert) references certifications

);

create table joue(
	id_artiste Int 		constraint joue_id_artiste_NN not null,
	id_films Int 		constraint joue_id_films_NN not null,
	constraint joue_ID  primary key (id_artiste, id_films),
	constraint joue_artiste_FK foreign key(id_artiste) references artistes,
	constraint films_joue_FK foreign key(id_films) references films
);


create table dirige(
	id_artiste Int 		constraint direct_id_artiste_NN not null,
	id_film Int 		constraint direct_id_film_NN not null,
	constraint direct_ID  primary key (id_artiste, id_film),
	constraint artiste_direct_FK foreign key(id_artiste) references artistes,
	constraint films_direct_FK foreign key(id_film) references films
);

create table genre_films(
	id_films int ,
	id_genre varchar2 (1000),
	constraint genre_films_ID  primary key (id_films, id_genre),
	constraint films_genre_FK foreign key(id_films) references films,
	constraint genre_films_FK foreign key(id_genre) references genres
);

create table genres(
	id_genre varchar2 (1000),
	constraint genre_ID  primary key (id_genre)
);

/**********************************************************************
		  			CREATE CB LIGHT 
***********************************************************************/
create table utilisateurs(

	u_id          INT          constraint utilisateurs_ID_nn not null,
	nom           VARCHAR(35)  constraint utilisateurs_Nom_nn not null
	                         constraint utilisateurs_Nom_CK check( SUBSTR(nom,1,1) <> LOWER(substr(nom,1,1)) ),
	sexe          CHAR(1)      constraint utilisateurs_sexe_CK check(sexe='F' OR sexe='M'),
	email         varchar(100),
	date_naissance date,     
	created_at    date         constraint utilisateurs_created_at_NN not null,
	updated_at    date,        
	constraint utilisateurs_updated_at check ( UPDATED_At>=created_at),
	constraint ID_Utilisteur  primary key (u_id)
);


create table adresses(
	a_id           INT        constraint addresses_id_NN not null,
	u_id           INT        constraint adresses_u_id_FK_NN not null,
	adresses        varchar(100),

	constraint adress_utilisateurs_FK foreign key(u_id)
	references utilisateurs
);



Create table cotes(
	c_id          INT        constraint Cote_ID_NN not null,
	u_id          INT        constraint Cotes_utilisateurs_FK_NN not null,
	avis          VARCHAR(1000)default Null,
	date_avis     Timestamp,
	date_cote     Timestamp  constraint Cote_date_NN not null,
	cote          INT        constraint Cote_number_CK check( cote between 1 and 10),
	film_ID       INT,    

	constraint ID_Cote primary key (c_id),
	constraint Cotes_utilisateurs_FK foreign key (u_id)
	references utilisateurs
);
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

