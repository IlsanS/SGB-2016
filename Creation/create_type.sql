/*******************************************************
             CREATE OBJECT + COMPARATEUR
*********************************************************/

create or replace TYPE nomId AS OBJECT (
 nom    varchar(1000),
  id     number,
ORDER MEMBER FUNCTION SORT (P nomId) RETURN INTEGER );

/

create or replace TYPE BODY nomId AS
ORDER MEMBER FUNCTION SORT(P nomId) RETURN INTEGER IS
BEGIN

   IF id < P.id THEN
      RETURN -1;
   ELSIF id > P.id THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END;
END;
/*********************************************************
             CREATE DU TABLEAU D'OBJET
*********************************************************/

create or replace TYPE nomId_tab AS TABLE OF nomId;


/***********************************************************************
             FONCTION RECURSIVE UTILISANT LE TYPE TABLE
************************************************************************/

FUNCTION split_directors return nomId_tab
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

    SELECT   
        distinct nomId(
          regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[A-Z /. /-/äö]+',1,1) as nom,
          to_number(regexp_substr(substr(genre,stpos,COALESCE(NULLIF(endpos,0),LENGTH(genre)+1)-stpos),'[0-9]+',1,1)) as Id 
          )
    BULK COLLECT into id_nom
    FROM Split;
return id_nom;
end split_directors;
END ANALYSIS_PCK;

//***************************************************************
          TEST DE LA FONCTION
*****************************************************************/


select nom,id  from table( ANALYSIS_PCK.split_directors);



//***************************************************************
          RESULTATS (25sec)
*****************************************************************/

