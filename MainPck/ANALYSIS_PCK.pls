create or replace PACKAGE BODY ANALYSIS_PCK AS
--?
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
  CURSOR movie_ext_cur is

  with 
    title(q_title,qq_title, moy_title, sd_title, med_title, min_title, max_title) as 
    ( select percentile_cont(0.99) within group (order by length(title)) value,
             percentile_cont(0.999) within group (order by length(title)) value,
              avg(length(title)),
              stddev(length(title)),
              median(length(title)),
              min(length(title)),
              max(length(title))
       from movies_ext
     ),
     tagline(q_tagline,qq_tagline, moy_tagline, sd_tagline, med_tagline, min_tagline, max_tagline) as 
    ( select  percentile_cont(0.99) within group (order by length(tagline)) value,
              percentile_cont(0.999) within group (order by length(tagline)) value,
              avg(length(tagline)),
              stddev(length(tagline)),
              median(length(tagline)),
              min(length(tagline)),
              max(length(tagline))
       from movies_ext
    ),

    genre (q_genre,moy_genre, sd_genre, med_genre, min_genre, max_genre, max_id_genre) as
     ( select percentile_cont(0.99) within group (order by length( nom)) value,
             
              avg(length(nom)),
              stddev(length(nom)),
              median(length(nom)),
              min(length(nom)),
              max(length(nom)),
              max(id) 
       from table(split_genre_fc)
       ),

    directeur (q_directeur,qq_directeur ,moy_directeur, sd_directeur, med_directeur, min_directeur, max_directeur, max_id_directeur) as
     ( select percentile_cont(0.99) within group (order by length( nom)) value,
              percentile_cont(0.999) within group (order by length( nom)) value,
              avg(length(nom)),
              stddev(length(nom)),
              median(length(nom)),
              min(length(nom)),
              max(length(nom)),
              max(id) 
       from table(split_director_fc)
       ),

     acteur (q_acteur,qq_acteur,moy_acteur, sd_acteur, med_acteur, min_acteur, max_acteur, max_id_acteur) as
      ( select percentile_cont(0.99) within group (order by length( nom)) value,
               percentile_cont(0.999) within group (order by length( nom)) value,
              avg(length(nom)),
              stddev(length(nom)),
              median(length(nom)),
              min(length(nom)),
              max(length(nom)),
              max(id) 
       from table(split_actor_fc)
       ),

      runtime(moy_runtime, min_runtime, max_runtime)as (Select avg(runtime),min(runtime), max(runtime) from movies_ext),
      runtime_2(nb_null_runtime)as (select count(*) from movies_ext where runtime=0),

      vote_average(moy_vote_Average, min_vote_average,max_vote_Average) as (Select avg(vote_average),min(vote_average), max(vote_average)from  movies_ext),
      vote_average_2(nb_null_vote_average) as ( select vote_average from movies_ext where vote_average=0),

      budget(moy_budget, min_budget,max_budget) as (Select avg(budget),min(budget), max(budget)from  movies_ext),
      budget_2(nb_null_budget) as ( select count(*) from movies_ext where budget<=0)


  Select * from title, tagline,genre, directeur, acteur, runtime, runtime_2, vote_average,vote_average_2, budget, budget_2;

  rowcur_var  movie_ext_cur%ROWTYPE;
BEGIN
      OPEN movie_ext_cur;
  
        FETCH movie_ext_cur INTO rowcur_var;
     -- LOOP
      -- EXIT WHEN movie_ext_cur%NOTFOUND;

        Analysis_pck.WriteFile_pr('titres 99ème quantil :',rowcur_var.q_title);
        Analysis_pck.WriteFile_pr('titres 999ème quantil :',rowcur_var.qq_title);
        Analysis_pck.WriteFile_pr('titres moyenne :',rowcur_var.moy_title);
        Analysis_pck.WriteFile_pr('titres ecart type :',rowcur_var.sd_title);
        Analysis_pck.WriteFile_pr('titres median :',rowcur_var.med_title);
        Analysis_pck.WriteFile_pr('titres longeur min :',rowcur_var.min_title);
        Analysis_pck.WriteFile_pr('titres longeur max :',rowcur_var.max_title);
        Analysis_pck.WriteFile_pr('************************************************************************************************************:',0);


        Analysis_pck.WriteFile_pr('taglines 99ème quantil :',rowcur_var.q_tagline);
        Analysis_pck.WriteFile_pr('taglines 999ème quantil :',rowcur_var.qq_tagline);
        Analysis_pck.WriteFile_pr('taglines moyenne :',rowcur_var.moy_tagline);
        Analysis_pck.WriteFile_pr('taglines ecart type :',rowcur_var.sd_tagline);
        Analysis_pck.WriteFile_pr('taglines longeur min :',rowcur_var.min_tagline);
        Analysis_pck.WriteFile_pr('taglines longeur max :',rowcur_var.max_tagline);
        Analysis_pck.WriteFile_pr('************************************************************************************************************:',0);

        Analysis_pck.WriteFile_pr('genres 99ème quantil :',rowcur_var.q_genre);
        Analysis_pck.WriteFile_pr('genres moyenne :',rowcur_var.moy_genre);
        Analysis_pck.WriteFile_pr('genres ecart type :',rowcur_var.sd_genre);
        Analysis_pck.WriteFile_pr('genres longeur min :',rowcur_var.min_genre);
        Analysis_pck.WriteFile_pr('genres longeur max :',rowcur_var.max_genre);
        Analysis_pck.WriteFile_pr('id_genre max :',rowcur_var.max_id_genre);
        Analysis_pck.WriteFile_pr('************************************************************************************************************:',0);


        Analysis_pck.WriteFile_pr('directeurs 99ème quantil :',rowcur_var.q_directeur);
        Analysis_pck.WriteFile_pr('directeurs 999ème quantil :',rowcur_var.qq_directeur);
        Analysis_pck.WriteFile_pr('directeurs moyenne :',rowcur_var.moy_directeur);
        Analysis_pck.WriteFile_pr('directeurs ecart type :',rowcur_var.sd_directeur);
        Analysis_pck.WriteFile_pr('directeurs longeur min :',rowcur_var.min_directeur);
        Analysis_pck.WriteFile_pr('directeurs longeur max :',rowcur_var.max_directeur);
        Analysis_pck.WriteFile_pr('id_directeurs max :',rowcur_var.max_id_directeur);
        Analysis_pck.WriteFile_pr('************************************************************************************************************:',0);

        Analysis_pck.WriteFile_pr('acteurs 99ème quantil :',rowcur_var.q_acteur);
        Analysis_pck.WriteFile_pr('acteurs 999ème quantil :',rowcur_var.qq_acteur);
        Analysis_pck.WriteFile_pr('acteurs moyenne :',rowcur_var.moy_acteur);
        Analysis_pck.WriteFile_pr('acteurs ecart type :',rowcur_var.sd_acteur);
        Analysis_pck.WriteFile_pr('acteurs longeur min :',rowcur_var.min_acteur);
        Analysis_pck.WriteFile_pr('acteurs longeur max :',rowcur_var.max_acteur);
        Analysis_pck.WriteFile_pr('id_acteurs max :',rowcur_var.max_id_acteur);
        Analysis_pck.WriteFile_pr('************************************************************************************************************:',0);

        Analysis_pck.WriteFile_pr('runtime valeur max :',rowcur_var.max_runtime);
        Analysis_pck.WriteFile_pr('runtime valeur min :',rowcur_var.min_runtime);
        Analysis_pck.WriteFile_pr('runtime valeur nulle :',rowcur_var.nb_null_runtime);
        Analysis_pck.WriteFile_pr('************************************************************************************************************:',0);

        Analysis_pck.WriteFile_pr('vote moyen valeur max :',rowcur_var.max_vote_Average);
        Analysis_pck.WriteFile_pr('vote moyen valeur min :',rowcur_var.min_vote_average);
        Analysis_pck.WriteFile_pr('vote moyen valeur nulle :',rowcur_var.nb_null_vote_average);
        Analysis_pck.WriteFile_pr('************************************************************************************************************:',0);

        Analysis_pck.WriteFile_pr('budget valeur max :',rowcur_var.max_budget);
        Analysis_pck.WriteFile_pr('budget valeur min :',rowcur_var.min_budget);
        Analysis_pck.WriteFile_pr('budget valeur nulle :',rowcur_var.nb_null_budget);
        Analysis_pck.WriteFile_pr('************************************************************************************************************:',0);



        
  --END LOOP;
    CLOSE movie_ext_cur;
    print_genres_pr;
    print_status_pr;
    print_certification_pr;
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
        SELECT directors, 0 AS stpos,  REGEXP_INSTR(directors,'‖')   AS endpos from movies_ext 
        UNION ALL
        SELECT genre, endpos+1,  REGEXP_INSTR(genre,'‖',endpos+1)
            FROM Split
            WHERE endpos > 0
    )

    SELECT   distinct nomId(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z /. /-/öä]+',1,1) ,
    to_number(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)))
    BULK COLLECT into id_nom
    FROM Split  ;
return id_nom;
end split_director_fc;


/**************************************************************************************************************
                                             SPLIT_ACTORS'?'
*************************************************************************************************************/





FUNCTION split_actor_fc return nomId_tab
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

    SELECT   distinct nomId(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z /. /-/öä]+',1,1) ,
    to_number(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)))
    BULK COLLECT into id_nom
    FROM Split  ;
return id_nom;
end split_actor_fc;




/******************************************************************************************************************
                                             PRINT_STATUS_PR
******************************************************************************************************************/

PROCEDURE print_status_pr
AS 
    fileHandler UTL_FILE.FILE_TYPE;
    nb_null number;


begin

  select count(*)  into nb_null from movies_ext where status is null;
  fileHandler := UTL_FILE.FOPEN('MYDIR', 'test_file.txt', 'A');
    UTL_FILE.PUTF(fileHandler,'Status distincts.\n Nombre de nuls :'||nb_null ||'\n');
  FOR v_cursor IN (select distinct status from movies_ext)

              LOOP
                UTL_FILE.put_line (fileHandler, v_cursor.status);
                        
             END LOOP;
                UTL_FILE.fclose (fileHandler);

END print_status_pr;


/**************************************************************************************************************
                                             PRINT_CERTIFICATION_Pr
*************************************************************************************************************/

PROCEDUre print_certification_pr
as

    fileHandler UTL_FILE.FILE_TYPE;
    nb_null number;

begin

 select count(*) into nb_null from movies_ext where certification is null;
  fileHandler := UTL_FILE.FOPEN('MYDIR', 'test_file.txt', 'A');
   UTL_FILE.PUTF(fileHandler,'certifications distinctes.\n Nombre de nuls :'||nb_null ||'\n');
  FOR v_cursor IN (select distinct certification from movies_ext)
           LOOP
                UTL_FILE.put_line (fileHandler, v_cursor.certification);
                        
             END LOOP;
                UTL_FILE.fclose (fileHandler);

end print_certification_pr;

/**************************************************************************************************************
                                             PRINT_GENRES
************************************************************************************************************/
PROCEDURE print_genres_pr
as

    fileHandler UTL_FILE.FILE_TYPE;
        nb_null number;


begin

   select count(*) into nb_null from movies_ext where genres is null;
   fileHandler := UTL_FILE.FOPEN('MYDIR', 'test_file.txt', 'A');
   UTL_FILE.PUTF(fileHandler,'Genres distincts.\n Nombre de nuls :'||nb_null ||'\n');
   FOR v_cursor IN (select nom from table( split_genre_fc))

              LOOP
                UTL_FILE.put_line (fileHandler, v_cursor.nom);
                        
             END LOOP;
                UTL_FILE.fclose (fileHandler);

end print_genres_pr;



END ANALYSIS_PCK;

