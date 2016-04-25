create or replace PACKAGE BODY ANALYSIS_PCK AS

/**********************************************************************
              WRITE FILE 
***********************************************************************/

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

/**************************************************************************************************************
                                             ANALYSE PR
*************************************************************************************************************/

PROCEDURE Analyse_pr
IS 
  CURSOR employee_id_cur is

  with 
    title(q_title) as (select percentile_cont(0.99) within group (order by length(title)) value from movies_ext),
    tagline (q_tagline) as (select percentile_cont(0.99) within group (order by length(tagline)) value from movies_ext),
    genre (q_genre,moy_genre) as (select percentile_cont(0.99) within group (order by length( nom)) ,avg(id)  from table(split_genre_fc)),
    directeur(q_directeur,moy_directeur) as (select percentile_cont(0.99) within group (order by length( nom)) ,avg(id)  from table(split_director_fc)),
    acteur(q_acteur,moy_acteur) as (select percentile_cont(0.99) within group (order by length( nom)),avg(id)  from table(split_actor_fc)),
    status(stat )as (select distinct status from movies_ext)

    

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


/**************************************************************************************************************
                                             SPLIT_GENRE
*************************************************************************************************************/


FUNCTION split_genre_fc return nomId_tab
as
  id_nom nomId_tab;
begin 

  WITH Split(genre,stpos,endpos)
  AS(
        SELECT genres, 0 AS stpos,  REGEXP_INSTR(genres,'?')   AS endpos from movies_ext 
        UNION ALL
        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'?',endpos+1)
            FROM Split
            WHERE endpos > 0
    )

    SELECT   distinct nomId(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z ]+',1,1) ,
    to_number(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)))
    BULK COLLECT into id_nom
    FROM Split  ;
return id_nom;
end split_genre_fc;



/**************************************************************************************************************
                                             SPLIT_DIRECTOR
*************************************************************************************************************/

FUNCTION split_director_fc return nomId_tab
as
  id_nom nomId_tab;
begin 

  WITH Split(genre,stpos,endpos)
  AS(
        SELECT directors, 0 AS stpos,  REGEXP_INSTR(directors,'?')   AS endpos from movies_ext 
        UNION ALL
        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'?',endpos+1)
            FROM Split
            WHERE endpos > 0
    )

    SELECT   distinct nomId(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z /. /-/äö]+',1,1) ,
    to_number(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)))
    BULK COLLECT into id_nom
    FROM Split  ;
return id_nom;
end split_director_fc;


/**************************************************************************************************************
                                             SPLIT_ACTORS
*************************************************************************************************************/





FUNCTION split_actor_fc return nomId_tab
as
  id_nom nomId_tab;
begin 

  WITH Split(genre,stpos,endpos)
  AS(
        SELECT actors, 0 AS stpos,  REGEXP_INSTR(actors,'?') AS endpos from movies_ext 
        UNION ALL
        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'?',endpos+1)
            FROM Split
            WHERE endpos > 0
    )

    SELECT   distinct nomId(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z /. /-/äö]+',1,1) ,
    to_number(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)))
    BULK COLLECT into id_nom
    FROM Split  ;
return id_nom;
end split_actor_fc;




/******************************************************************************************************************
                                             PRINT_STATUS_PR
******************************************************************************************************************/

procedure print_status_pr
AS 
    fileHandler UTL_FILE.FILE_TYPE;


begin

  fileHandler := UTL_FILE.FOPEN('MYDIR', 'test_file.txt', 'A');
    UTL_FILE.PUTF(fileHandler,'Status disponibles \n');
  FOR v_cursor IN (select distinct status from movies_ext)

              LOOP
                UTL_FILE.put_line (fileHandler, v_cursor.status);
                        
             END LOOP;
                UTL_FILE.fclose (fileHandler);

END print_status_pr;

END ANALYSIS_PCK;

