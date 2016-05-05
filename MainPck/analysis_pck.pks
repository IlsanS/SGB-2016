create or replace PACKAGE ANALYSIS_PCK AS 



procedure WriteFile_pr( message varchar, quantil number);

procedure Analyse_pr;

FUNCTION split_genre_fc return nomId_tab;
FUNCTION split_director_fc return nomId_tab;
FUNCTION split_actor_fc return nomId_tab;

PROCEDURE print_status_pr;
PROCEDURE print_certification_pr;
PROCEDURE print_genres_pr;
 
 
 
 
 
END ANALYSIS_PCK;