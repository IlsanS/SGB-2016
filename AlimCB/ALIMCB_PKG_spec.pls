create or replace PACKAGE ALIMCB_PKG AS 

PROCEDURE AlimMovieById_pr(movie_id movie.id%type);
PROCEDURE AlimMovieByN_pr(n integer);
FUNCTION filter_title_fc(t varchar2) return varchar2;
FUNCTION filter_status_fc(s varchar2) return varchar2;
FUNCTION filter_tagline_fc(tag varchar2) return varchar2;
FUNCTION get_blob_fc(url varchar2) return blob;

/**************************** ACTORS ***************************************************/

PROCEDURE SPLIT_ACTORS_FC ( p_actors varchar2 , mv_id movie.id%type);
PROCEDURE fill_artist_pr ( p_id artist.id%type , p_name artist.name%type);
PROCEDURE merge_play_pr(mv_id movie.id%type, a_id artist.id%type);


/**************************** DIRECTORS *************************************************/
PROCEDURE SPLIT_DIRECTORS_PR(p_director varchar2, mv_id movie.id%type);
PROCEDURE merge_direct_pr(mv_id movie.id%type, a_id artist.id%type);


/**************************** CERTIFICATIONS ********************************************/
PROCEDURE fill_certification_pr(p_cert certification.id%type, mv_id movie.id%type);


/**************************** GENRES*****************************************************/

PROCEDURE SPLIT_GENRE_Pr ( p_genre varchar2 , mv_id movie.id%type);
PROCEDURE fill_genre_pr ( p_id genre.id%type , p_name genre.name%type);
PROCEDURE merge_genre_movie_pr(mv_id movie.id%type, a_id genre.id%type);


END ALIMCB_PKG;