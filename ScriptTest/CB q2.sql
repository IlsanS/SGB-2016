

  WITH Split(genre,stpos,endpos)
  AS(
        SELECT directors, 0 AS stpos,  REGEXP_INSTR(directors,'?')   AS endpos from movies_ext 
        UNION ALL
        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'?',endpos+1)
            FROM Split
            WHERE endpos > 0
    )
    SELECT distinct  regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z ä/-/.]+',1,1)
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
select status from movies_ext where rownum<25
;

