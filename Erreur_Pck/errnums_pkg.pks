CREATE OR REPLACE package errnums_pkg
is
	validation_ex exception;
	validation_const constant number := -20001;
	pragma exception_init (validation_ex, -20001);
	
	insertion_ex exception;
	insertion_const constant number := -20002;
	pragma exception_init (insertion_ex, -20002);
  
   user_add_ex exception;
	 user_add_const constant number := -20003;
	pragma exception_init (insertion_ex, -20003);
  
  user_read_ex exception;
	user_read_const constant number := -20004;
	pragma exception_init (insertion_ex, -20004);

  user_update_ex exception;
	user_update_const constant number := -20007;
	pragma exception_init (insertion_ex, -20007);
  
  user_del_ex exception;
	user_del_const constant number := -20009;
	pragma exception_init (insertion_ex, -20009);
  
  
   user_eval_ex exception;
	 user_eval_const constant number := -20010;
	pragma exception_init (insertion_ex, -20010);

	WriteFile_ex exception;
	WriteFile_const constant number := -20011;
	pragma exception_init (WriteFile_ex, -20011);

	Analyse_ex exception;
	Analyse_const constant number := -20012;
	pragma exception_init (Analyse_ex, -20012);



end errnums_pkg;
/