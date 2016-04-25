create or replace PACKAGE BODY ANALYSIS_PCK AS

PROCEDURE WriteFile_pr( message varchar, quantil number) 
IS	
    fileHandler UTL_FILE.FILE_TYPE;
BEGIN
	fileHandler := UTL_FILE.FOPEN('MYDIR', 'test_file.txt', 'A');
	 UTL_FILE.PUTF(fileHandler,message);
	 UTL_FILE.PUTF(fileHandler,'  ');
	 UTL_FILE.PUTF(fileHandler,quantil);	
	 UTL_FILE.FCLOSE(fileHandler);
EXCEPTION
	  WHEN utl_file.invalid_path THEN raise_application_error(-20000, 'ERROR: Invalid PATH FOR file.');
END WriteFile_pr;



PROCEDURE Analyse_pr
IS 
  CURSOR employee_id_cur is

  with 
	  title(q_title) as (select percentile_cont(0.99) within group (order by length(title)) value from movies_ext),
	  tagline (q_tagline) as (select percentile_cont(0.99) within group (order by length(tagline)) value from movies_ext),
    genre (q_genre,moy_genre) as (select percentile_cont(0.99) within group (order by length( nom)) ,avg(id)  from table(split_genre)),
    directeur(q_directeur,moy_directeur) as (select percentile_cont(0.99) within group (order by length( nom)) ,avg(id)  from table(split_director)),
    acteur(q_acteur,moy_acteur) as (select percentile_cont(0.99) within group (order by length( nom)),avg(id)  from table(split_actor)),
    

  Select * from title, tagline, directeur, genre, acteur;

  l_employee_id  employee_id_cur%ROWTYPE;
BEGIN
	    OPEN employee_id_cur;
  
      LOOP
        FETCH employee_id_cur INTO l_employee_id;
        EXIT WHEN employee_id_cur%NOTFOUND;

        Analysis_pck.WriteFile_pr('titre 99q :',l_employee_id.q_title);
        Analysis_pck.WriteFile_pr('tagline 99q :',l_employee_id.q_tagline);
        Analysis_pck.WriteFile_pr('genre 99q :',l_employee_id.q_genre);
        Analysis_pck.WriteFile_pr('ID moyen des genres :',l_employee_id.moy_genre);
        Analysis_pck.WriteFile_pr('nom_directeur 99 q : ',l_employee_id.q_directeur);
        Analysis_pck.WriteFile_pr('ID moyen des directeurs : ',l_employee_id.moy_directeur);
        Analysis_pck.WriteFile_pr('nom_acteur 99 q : ',l_employee_id.q_acteur);
        Analysis_pck.WriteFile_pr('ID moyen des acteurs : ',l_employee_id.moy_acteur);

        
    END LOOP;
    CLOSE employee_id_cur;
END Analyse_pr; 



FUNCTION split_genre return nomId_tab
as
  id_nom nomId_tab;
begin 

  WITH Split(genre,stpos,endpos) --remplacer les ? par un double pipe
  AS(
        SELECT genres, 0 AS stpos,  REGEXP_INSTR(genres,'‖')   AS endpos from movies_ext 
        UNION ALL
        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'‖',endpos+1)
            FROM Split
            WHERE endpos > 0
    )

    SELECT   distinct nomId(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z ]+',1,1) ,
    to_number(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)))
    BULK COLLECT into id_nom
    FROM Split  ;
return id_nom;
end split_genre;




FUNCTION split_director return nomId_tab
as
  id_nom nomId_tab;
begin 

  WITH Split(genre,stpos,endpos)
  AS(
        SELECT directors, 0 AS stpos,  REGEXP_INSTR(directors,'‖')   AS endpos from movies_ext 
        UNION ALL
        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'‖',endpos+1)
            FROM Split
            WHERE endpos > 0
    )

    SELECT   distinct nomId(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z /. /-/äö]+',1,1) ,
    to_number(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)))
    BULK COLLECT into id_nom
    FROM Split  ;
return id_nom;
end split_director;







FUNCTION split_actor return nomId_tab
as
  id_nom nomId_tab;
begin 

  WITH Split(genre,stpos,endpos)
  AS(
        SELECT actors, 0 AS stpos,  REGEXP_INSTR(actors,'‖') AS endpos from movies_ext 
        UNION ALL
        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'‖',endpos+1)
            FROM Split
            WHERE endpos > 0
    )

    SELECT   distinct nomId(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z /. /-/äö]+',1,1) ,
    to_number(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)))
    BULK COLLECT into id_nom
    FROM Split  ;
return id_nom;
end split_actor;






END ANALYSIS_PCK;

