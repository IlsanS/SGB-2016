create or replace PACKAGE ANALYSIS_PCK AS 



procedure WriteFile_pr( message varchar, quantil number);

procedure Analyse_pr;

FUNCTION split_genre return nomId_tab;
FUNCTION split_directors return nomId_tab;
/*function quantil_max return number (mot varchar);
 */
 
 
 
 
 
 
 
 
 
 
END ANALYSIS_PCK;