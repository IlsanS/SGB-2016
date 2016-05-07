

  WITH Split(genre,stpos,endpos)
  AS(
        SELECT directors, 0 AS stpos,  REGEXP_INSTR(directors,'?')   AS endpos from movies_ext 
        UNION ALL
        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'?',endpos+1)
            FROM Split
            WHERE endpos > 0
    )
    SELECT distinct  regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z �/-/.]+',1,1)
FROM Split;

/
  select directors from movies_ext where rownum<8;

/
begin 
  ANALYSIS_PCK.Analyse_pr;
end;
/
  
  CREATE TYPE nomId_tab AS TABLE OF nomId;
/
select nom,id  from table( ANALYSIS_PCK.split_genre);
/
select nom,id  from table( ANALYSIS_PCK.split_directors);
/

/
select vote_count from movies_ext where rownum<25
;
select distinct certification from movies_ext where regexp_instr(certification,'[^0-9]') <>0 
                                              and certification <>'None' 
                                              and certification<>'-' 
                                              and certification <> ' '
;
/
begin 
  ANALYSIS_PCK.ANAlyse_pr;
  end;

/ 
Select avg(runtime),max(runtime), min(runtime) from  movies_ext;
select count(*) from movies_ext where runtime=0;
/
Select avg(vote_average),max(vote_average), min(vote_average) from  movies_ext;
select vote_average from movies_ext where vote_average=0;
/

Select * from  movies_ext where budget <=0;
select vote_average from movies_ext where vote_average=0;

/
select * from movies_ext where rownum <5;
/
begin
	 WITH Split(genre,stpos,endpos)
	  	AS(
	        SELECT 'Harnos‖105988„Galyn Görg‖22621„Angela Alvarado‖10822„Stephen Dorff  ', 0 AS stpos,  REGEXP_INSTR('Harnos‖105988„Galyn Görg‖22621„Angela Alvarado‖10822„Stephen Dorff  ','‖')   AS endpos from dual 
	        UNION ALL
	        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'‖',endpos+1)
	            FROM Split
	   	         WHERE endpos > 0
	   	 )

	    SELECT  distinct (regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z /. /-/öä]+',1,1)) as name ,
		(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)) as id
	    FROM Split  ;
  end;

select * from movies_ext where id = 5;

/
begin
ALIMCB_PKG.ALIMMOVIEByn_pr(15);
end;

/
select* from cert_movie;
select * from movies_ext where id = 10048;
select*from artist;
select * from play;
select * from direct;
select name, title from artist, movie, direct where id_movie=movie.id and id_director=artist.id;
select * from genre;
/
select * from movies_ext where rownum <20;

