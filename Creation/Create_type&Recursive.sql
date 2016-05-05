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
             CREATE DU TABLEAU D'OBJET (id, varchar)
*********************************************************/
create or replace TYPE nomId_tab AS TABLE OF nomId;


/*********************************************************
             CREATE  DU TABLEAU D'OBJET (varchar)
*********************************************************/

create or replace TYPE varchar_tab_type AS TABLE OF varchar2(3000);