create or replace PACKAGE BODY ALIMCB_PKG AS

PROCEDURE AlimMovieById_pr (movie_id movie.id%type)
AS
	p_actors 	varchar2(5000);
  p_directors 	varchar2(5000);
	p_certif 	varchar2(500);
   p_genre  varchar(5000);


BEGIN
	INSERT INTO movie(id,title,status,release_date,vote_average,vote_count,runtime, budget, tagline,poster, nb_copies)
	SELECT 	id,
			filter_title_fc(title), 
			filter_status_fc(status),
			release_date, 
			vote_average,
			vote_count, 
			runtime,
			budget,	
			filter_tagline_fc(tagline),
			null,--get_blob_fc(poster_path),
			0
			FROM movies_ext where id=movie_id;

SELECT actors into p_actors FROM  movies_ext where id=movie_id; 
SPLIT_ACTORS_FC(p_actors, movie_id);

SELECT directors into p_directors FROM  movies_ext where id=movie_id; 
SPLIT_DIRECTORS_PR(p_directors, movie_id);

SELECT certification into p_certif FROM  movies_ext where id=movie_id; 
fill_certification_pr(p_certif, movie_id);

SELECT genres into p_genre FROM  movies_ext where id=movie_id; 
SPLIT_GENRE_PR(p_genre, movie_id);

	/*to do  :  status, enelever les espace devant title & tagline ,make copies*/


END AlimMovieById_pr;

/**********************************************************************
             ALIMMOVIEBYN 
***********************************************************************/

PROCEDURE AlimMovieByN_pr (n integer) 
AS

	CURSOR movie_cur is
		SELECT id
		FROM   (
		    SELECT id
		    FROM   movies_ext
		    ORDER BY DBMS_RANDOM.VALUE
		    )
		WHERE  rownum < n;
	rowcur_var movie_cur%rowtype;
BEGIN
	OPEN movie_cur;

LOOP	
  FETCH movie_cur INTO rowcur_var;
	EXIT WHEN movie_cur%NOTFOUND;

	AlimMovieById_pr(rowcur_var.id);

END LOOP;
close movie_cur;

END AlimMovieByN_pr;

/**********************************************************************
              FILTER_TITLE_FC 
***********************************************************************/

FUNCTION filter_title_fc (t varchar2) RETURN varchar2/*99q = 59 999q=81*/
AS
	len Integer;
BEGIN
	len := length(t);

	CASE
    WHEN  len<= 59 	THEN return t;
    WHEN  len >59 and  len<=81 THEN return substr(t,1,59);
    ELSE return null;
  END CASE;

END filter_title_fc;

/**********************************************************************
              FILTER_STATUTS_FC 
***********************************************************************/

FUNCTION filter_status_fc (s varchar2) RETURN varchar2
AS	

BEGIN
	IF s='Post Production'  or
		s='Rumored'or
		s='Released'or
		s='In Production'or
		s='Planned'or
		s='Canceled'
	THEN return s;
	ELSE return null;
	END IF;

END filter_status_fc;

/**********************************************************************
              FILTER_TAGLINE_FC 
***********************************************************************/

FUNCTION filter_tagline_fc (tag varchar2) RETURN varchar2
AS
	len Integer;
BEGIN
	len := length(tag);

	CASE
    WHEN  len<= 173	THEN return tag;
    WHEN  len >173 and  len<=382 THEN return substr(tag,1,172);
    ELSE return null;
	END CASE;

END filter_tagline_fc;

/**********************************************************************
              GET_BLOB_FC 
***********************************************************************/

FUNCTION get_blob_fc (url varchar2) RETURN BLOB
AS
 l_blob           BLOB;
 p_url            varchar2(1000);
BEGIN
if url is null  then return null;
  end if;
  
  p_url := 'http://image.tmdb.org/t/p/w185'||url;
  
  l_blob := HTTPURITYPE.createuri(p_url).getblob();
  return l_blob;

END get_blob_fc;


/**********************************************************************
              FILL_ACTOR_PR 
***********************************************************************/
PROCEDURE fill_artist_pr(p_id artist.id%type, p_name artist.name%type)
AS
BEGIN
    MERGE INTO artist d
    USING (select p_id as id, p_name as name from dual) s
    ON (d.id = s.id)
    WHEN MATCHED THEN
      UPDATE SET d.name = s.name
    WHEN NOT MATCHED THEN
      INSERT (d.id, d.name)
      VALUES (s.id, s.name);

END fill_artist_pr;


/**********************************************************************
             SPLIT_ACTORS_FC 
***********************************************************************/
PROCEDURE SPLIT_ACTORS_FC(p_actors varchar2, mv_id movie.id%type)
AS
	CURSOR actor_split_cur is
		 WITH Split(genre,stpos,endpos)
	  	AS(
	        SELECT p_actors, 0 AS stpos,  REGEXP_INSTR(p_actors,'‖')   AS endpos from dual 
	        UNION ALL
	        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'‖',endpos+1)
	            FROM Split
	   	         WHERE endpos > 0
	   	 )

	    SELECT  distinct (regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z /. /-/öä]+',1,1)) as name ,
		(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)) as id
	    FROM Split  ;
	rowcur_var actor_split_cur%rowtype;
BEGIN
	OPEN actor_split_cur;

    LOOP	
      FETCH actor_split_cur INTO rowcur_var;
      EXIT WHEN actor_split_cur%NOTFOUND;
    
        fill_artist_pr(to_number(rowcur_var.id), rowcur_var.name);
        merge_play_pr(mv_id,to_number(rowcur_var.id));
    
    END LOOP;
  CLOSE actor_split_cur;
  EXCEPTION
   WHEN OTHERS THEN   
       IF SQLCODE = -1400 THEN  dbms_output.put_line('valeur id film ou actor null / SPLIT_ACTORS_FC');
       end if;

END SPLIT_ACTORS_FC;



/**********************************************************************
             merge_play_pr(movie.id%type, artist.id%type) MERGE TABLE PLAY 
***********************************************************************/
 PROCEDURE merge_play_pr(mv_id movie.id%type, a_id artist.id%type) 
 AS
 BEGIN
 	
 	Insert into play values(mv_id, a_id);
  
  EXCEPTION
   WHEN OTHERS THEN   
       IF SQLCODE = -1400 THEN  dbms_output.put_line('valeur id film ou actor null');
       end if;

END merge_play_pr;





/**********************************************************************
             SPLIT_DIRECTORS_FC 
***********************************************************************/

PROCEDURE SPLIT_DIRECTORS_PR(p_director varchar2, mv_id movie.id%type)
AS
	CURSOR director_split_cur is
		 WITH Split(genre,stpos,endpos)
	  	AS(
	        SELECT p_director, 0 AS stpos,  REGEXP_INSTR(p_director,'‖')   AS endpos from dual 
	        UNION ALL
	        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'‖',endpos+1)
	            FROM Split
	   	         WHERE endpos > 0
	   	 )

	    SELECT  distinct (regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z /. /-/öä]+',1,1)) as name ,
		(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)) as id
	    FROM Split  ;
	rowcur_var director_split_cur%rowtype;
BEGIN
	OPEN director_split_cur;

    LOOP	
      FETCH director_split_cur INTO rowcur_var;
      EXIT WHEN director_split_cur%NOTFOUND;
       
        fill_artist_pr(to_number(rowcur_var.id), rowcur_var.name);
        merge_direct_pr(mv_id,to_number(rowcur_var.id));
    
    END LOOP;
  CLOSE director_split_cur;
  EXCEPTION
   WHEN OTHERS THEN   
       IF SQLCODE = -1400 THEN  dbms_output.put_line('valeur id film ou directeur null / SPLIT_ACTORS_FC');
       end if;

END SPLIT_DIRECTORS_PR;


/**********************************************************************
             MERGE_DIRECT_PR
***********************************************************************/

PROCEDURE merge_direct_pr(mv_id movie.id%type, a_id artist.id%type)
AS
BEGIN
 	
 	Insert into direct values(mv_id, a_id);
  
EXCEPTION
WHEN OTHERS THEN   
   IF SQLCODE = -1400 THEN  dbms_output.put_line('valeur id film ou actor null');
   end if;
END merge_direct_pr;




/**********************************************************************
             FILL_CERTIFICATION
***********************************************************************/


PROCEDURE fill_certification_pr(p_cert certification.id%type, mv_id movie.id%type)
AS
 CHECK_CONSTRAINT_VIOLATED EXCEPTION;
  PRAGMA EXCEPTION_INIT(CHECK_CONSTRAINT_VIOLATED, -2290);
BEGIN

 	Insert into cert_movie values(mv_id, p_cert);
  
EXCEPTION
	WHEN CHECK_CONSTRAINT_VIOLATED THEN 
		dbms_output.put_line('la certification pas prise en compte');

	WHEN OTHERS THEN   
    IF SQLCODE = -1400 THEN  dbms_output.put_line('valeur id film ou actor null');
    end if;

END fill_certification_pr;


/**********************************************************************
             SPLIT_GENRE_FC 
***********************************************************************/
PROCEDURE SPLIT_GENRE_Pr ( p_genre varchar2 , mv_id movie.id%type)
AS
	CURSOR genre_split_cur is
		 WITH Split(genre,stpos,endpos)
	  	AS(
	        SELECT p_genre, 0 AS stpos,  REGEXP_INSTR(p_genre,'‖')   AS endpos from dual 
	        UNION ALL
	        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'‖',endpos+1)
	            FROM Split
	   	         WHERE endpos > 0
	   	 )

	    SELECT  distinct (regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z /. /-/öä]+',1,1)) as name ,
		(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)) as id
	    FROM Split  ;
	rowcur_var genre_split_cur%rowtype;
BEGIN
	OPEN genre_split_cur;

    LOOP	
      FETCH genre_split_cur INTO rowcur_var;
      EXIT WHEN genre_split_cur%NOTFOUND;
    
        fill_genre_pr(to_number(rowcur_var.id), rowcur_var.name);
        merge_genre_movie_pr(mv_id,to_number(rowcur_var.id));
    
    END LOOP;
  CLOSE genre_split_cur;
  EXCEPTION
   WHEN OTHERS THEN   
       IF SQLCODE = -1400 THEN  dbms_output.put_line('valeur id film ou genre null / SPLIT_GNRE_FC');
       end if;

END SPLIT_GENRE_PR;


/**********************************************************************
          FILL_GENRE_PR
***********************************************************************/

PROCEDURE fill_genre_pr(p_id genre.id%type, p_name genre.name%type)
AS
BEGIN
    MERGE INTO genre d
    USING (select p_id as id, p_name as name from dual) s
    ON (d.id = s.id)
    WHEN MATCHED THEN
      UPDATE SET d.name = s.name
    WHEN NOT MATCHED THEN
      INSERT (d.id, d.name)
      VALUES (s.id, s.name);

END fill_genre_pr;



/**********************************************************************
             MERGE_GENRE_MOVIE_PR
***********************************************************************/
 PROCEDURE merge_genre_movie_pr(mv_id movie.id%type, a_id genre.id%type) 
 AS
 BEGIN
 	
 	Insert into genre_movie values(mv_id, a_id);
  
  EXCEPTION
   WHEN OTHERS THEN   
       IF SQLCODE = -1400 THEN  dbms_output.put_line('valeur id film ou genre null');
       end if;

END merge_genre_movie_pr;


END ALIMCB_PKG;