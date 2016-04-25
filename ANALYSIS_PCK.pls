c r e a t e   o r   r e p l a c e   P A C K A G E   B O D Y   A N A L Y S I S _ P C K   A S 
 
 
 / * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
   *                                                                                       W R I T E _ F I L E 
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * / 
 
 P R O C E D U R E   W r i t e F i l e _ p r (   m e s s a g e   v a r c h a r ,   q u a n t i l   n u m b e r )   
 I S 	 
         f i l e H a n d l e r   U T L _ F I L E . F I L E _ T Y P E ; 
 B E G I N 
 	 f i l e H a n d l e r   : =   U T L _ F I L E . F O P E N ( ' M Y D I R ' ,   ' t e s t _ f i l e . t x t ' ,   ' A ' ) ; 
 	   U T L _ F I L E . P U T F ( f i l e H a n d l e r , m e s s a g e ) ; 
 	   U T L _ F I L E . P U T F ( f i l e H a n d l e r , '     ' ) ; 
 	   U T L _ F I L E . P U T F ( f i l e H a n d l e r , q u a n t i l ) ; 	 
 	   U T L _ F I L E . F C L O S E ( f i l e H a n d l e r ) ; 
 E X C E P T I O N 
 	     W H E N   O T H E R S   T H E N   e r r _ p k g . r e p o r t _ a n d _ s t o p ( ' A N A L Y S I S _ P C K . W r i t e F i l e _ p r ' , E R R N U M S _ p c k . W r i t e F i l e _ c o n s t ,   ' E r r e u r   f i c h i e r   a n a l y s e '   , t r u e ,   t r u e ) ; 
 E N D   W r i t e F i l e _ p r ; 
 
 
 
 
 / * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
   *                                                                                       A N A L Y S E _ P R 
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * / 
 
 P R O C E D U R E   A n a l y s e _ p r 
 I S   
     C U R S O R   e m p l o y e e _ i d _ c u r   i s 
 
     w i t h   
 	     t i t l e ( q _ t i t l e )   a s   ( s e l e c t   p e r c e n t i l e _ c o n t ( 0 . 9 9 )   w i t h i n   g r o u p   ( o r d e r   b y   l e n g t h ( t i t l e ) )   v a l u e   f r o m   m o v i e s _ e x t ) , 
 	     t a g l i n e   ( q _ t a g l i n e )   a s   ( s e l e c t   p e r c e n t i l e _ c o n t ( 0 . 9 9 )   w i t h i n   g r o u p   ( o r d e r   b y   l e n g t h ( t a g l i n e ) )   v a l u e   f r o m   m o v i e s _ e x t ) , 
         g e n r e   ( q _ g e n r e , m o y _ g e n r e )   a s   ( s e l e c t   p e r c e n t i l e _ c o n t ( 0 . 9 9 )   w i t h i n   g r o u p   ( o r d e r   b y   l e n g t h (   n o m ) )   , a v g ( i d )     f r o m   t a b l e ( s p l i t _ g e n r e ) ) , 
         d i r e c t e u r ( q _ d i r e c t e u r , m o y _ d i r e c t e u r )   a s   ( s e l e c t   p e r c e n t i l e _ c o n t ( 0 . 9 9 )   w i t h i n   g r o u p   ( o r d e r   b y   l e n g t h (   n o m ) )   , a v g ( i d )     f r o m   t a b l e ( s p l i t _ d i r e c t o r ) ) , 
         
         a c t e u r ( q _ a c t e u r , m o y _ a c t e u r )   a s   ( s e l e c t   p e r c e n t i l e _ c o n t ( 0 . 9 9 )   w i t h i n   g r o u p   ( o r d e r   b y   l e n g t h (   n o m ) ) , a v g ( i d )     f r o m   t a b l e ( s p l i t _ a c t o r ) ) , 
         v o t e _ a v e r a g e ( m o y _ v o t e ,   m i n _ v o t e ,   m a x _ v o t e )   a s   ( s e l e c t   a v g ( v o t e _ c o u n t )   f r o m   m o v i e s _ e x t   ) 
 
     S e l e c t   *   f r o m   t i t l e ,   t a g l i n e ,   d i r e c t e u r ,   g e n r e ,   a c t e u r ; 
 
     l _ e m p l o y e e _ i d     e m p l o y e e _ i d _ c u r % R O W T Y P E ; 
 B E G I N 
 	         O P E N   e m p l o y e e _ i d _ c u r ; 
     
             L O O P 
                 F E T C H   e m p l o y e e _ i d _ c u r   I N T O   l _ e m p l o y e e _ i d ; 
                 E X I T   W H E N   e m p l o y e e _ i d _ c u r % N O T F O U N D ; 
 
                 A n a l y s i s _ p c k . W r i t e F i l e _ p r ( ' t i t r e   9 9 � m e   q u a n t i l   : ' , l _ e m p l o y e e _ i d . q _ t i t l e ) ; 
                 A n a l y s i s _ p c k . W r i t e F i l e _ p r ( ' t a g l i n e   9 9 � m e   q u a n t i l : ' , l _ e m p l o y e e _ i d . q _ t a g l i n e ) ; 
                 A n a l y s i s _ p c k . W r i t e F i l e _ p r ( ' g e n r e   9 9 q   : ' , l _ e m p l o y e e _ i d . q _ g e n r e ) ; 
                 A n a l y s i s _ p c k . W r i t e F i l e _ p r ( ' I D   m o y e n   d e s   g e n r e s   : ' , l _ e m p l o y e e _ i d . m o y _ g e n r e ) ; 
                 A n a l y s i s _ p c k . W r i t e F i l e _ p r ( ' n o m _ d i r e c t e u r   9 9 � m e   q u a n t i l :   ' , l _ e m p l o y e e _ i d . q _ d i r e c t e u r ) ; 
                 A n a l y s i s _ p c k . W r i t e F i l e _ p r ( ' I D   m o y e n   d e s   d i r e c t e u r s   :   ' , l _ e m p l o y e e _ i d . m o y _ d i r e c t e u r ) ; 
                 A n a l y s i s _ p c k . W r i t e F i l e _ p r ( ' n o m _ a c t e u r   9 9 � m e   q u a n t i l :   ' , l _ e m p l o y e e _ i d . q _ a c t e u r ) ; 
                 A n a l y s i s _ p c k . W r i t e F i l e _ p r ( ' I D   m o y e n   d e s   a c t e u r s   :   ' , l _ e m p l o y e e _ i d . m o y _ a c t e u r ) ; 
 
                 
         E N D   L O O P ; 
         C L O S E   e m p l o y e e _ i d _ c u r ; 
 E X C E P T I O N   
         W H E N   O T H E R S   T H E N   e r r _ p k g . r e p o r t _ a n d _ s t o p ( ' A N A L Y S I S _ P C K . A n a l y s e _ p r ' , E R R N U M S _ p c k . A n a l y s e _ c o n s t ,   ' E r r e u r   a n a l y s e '   , t r u e ,   t r u e ) ; 
 
 E N D   A n a l y s e _ p r ;   
 
 
 
 F U N C T I O N   s p l i t _ g e n r e   r e t u r n   n o m I d _ t a b 
 a s 
     i d _ n o m   n o m I d _ t a b ; 
 b e g i n   
 
     W I T H   S p l i t ( g e n r e , s t p o s , e n d p o s ) 
     A S ( 
                 S E L E C T   g e n r e s ,   0   A S   s t p o s ,     R E G E X P _ I N S T R ( g e n r e s , '  ' )       A S   e n d p o s   f r o m   m o v i e s _ e x t   
                 U N I O N   A L L 
                 S E L E C T   g e n r e ,   e n d p o s + 1 ,     R E G E X P _ I N S T R ( g e n r e , '  ' , e n d p o s + 1 ) 
                         F R O M   S p l i t 
                         W H E R E   e n d p o s   >   0 
         ) 
 
         S E L E C T       d i s t i n c t   n o m I d ( r e g e x p _ s u b s t r ( s u b s t r ( g e n r e , s t p o s , C O A L E S C E ( N U L L I F ( e n d p o s , 0 ) , L E N G T H ( g e n r e ) + 1 ) - s t p o s ) , ' [ A - Z   ] + ' , 1 , 1 )   , 
         t o _ n u m b e r ( r e g e x p _ s u b s t r ( s u b s t r ( g e n r e , s t p o s , C O A L E S C E ( N U L L I F ( e n d p o s , 0 ) , L E N G T H ( g e n r e ) + 1 ) - s t p o s ) , ' [ 0 - 9 ] + ' , 1 , 1 ) ) ) 
         B U L K   C O L L E C T   i n t o   i d _ n o m 
         F R O M   S p l i t     ; 
 r e t u r n   i d _ n o m ; 
 e n d   s p l i t _ g e n r e ; 
 
 
 
 
 F U N C T I O N   s p l i t _ d i r e c t o r   r e t u r n   n o m I d _ t a b 
 a s 
     i d _ n o m   n o m I d _ t a b ; 
 b e g i n   
 
     W I T H   S p l i t ( g e n r e , s t p o s , e n d p o s ) 
     A S ( 
                 S E L E C T   d i r e c t o r s ,   0   A S   s t p o s ,     R E G E X P _ I N S T R ( d i r e c t o r s , '  ' )       A S   e n d p o s   f r o m   m o v i e s _ e x t   
                 U N I O N   A L L 
                 S E L E C T   g e n r e ,   e n d p o s + 1 ,     R E G E X P _ I N S T R ( g e n r e , '  ' , e n d p o s + 1 ) 
                         F R O M   S p l i t 
                         W H E R E   e n d p o s   >   0 
         ) 
 
         S E L E C T       d i s t i n c t   n o m I d ( r e g e x p _ s u b s t r ( s u b s t r ( g e n r e , s t p o s , C O A L E S C E ( N U L L I F ( e n d p o s , 0 ) , L E N G T H ( g e n r e ) + 1 ) - s t p o s ) , ' [ A - Z   / .   / - / � � ] + ' , 1 , 1 )   , 
         t o _ n u m b e r ( r e g e x p _ s u b s t r ( s u b s t r ( g e n r e , s t p o s , C O A L E S C E ( N U L L I F ( e n d p o s , 0 ) , L E N G T H ( g e n r e ) + 1 ) - s t p o s ) , ' [ 0 - 9 ] + ' , 1 , 1 ) ) ) 
         B U L K   C O L L E C T   i n t o   i d _ n o m 
         F R O M   S p l i t     ; 
 r e t u r n   i d _ n o m ; 
 e n d   s p l i t _ d i r e c t o r ; 
 
 
 
 
 
 
 
 F U N C T I O N   s p l i t _ a c t o r   r e t u r n   n o m I d _ t a b 
 a s 
     i d _ n o m   n o m I d _ t a b ; 
 b e g i n   
 
     W I T H   S p l i t ( g e n r e , s t p o s , e n d p o s ) 
     A S ( 
                 S E L E C T   a c t o r s ,   0   A S   s t p o s ,     R E G E X P _ I N S T R ( a c t o r s , '  ' )   A S   e n d p o s   f r o m   m o v i e s _ e x t   
                 U N I O N   A L L 
                 S E L E C T   g e n r e ,   e n d p o s + 1 ,     R E G E X P _ I N S T R ( g e n r e , '  ' , e n d p o s + 1 ) 
                         F R O M   S p l i t 
                         W H E R E   e n d p o s   >   0 
         ) 
 
         S E L E C T       d i s t i n c t   n o m I d ( r e g e x p _ s u b s t r ( s u b s t r ( g e n r e , s t p o s , C O A L E S C E ( N U L L I F ( e n d p o s , 0 ) , L E N G T H ( g e n r e ) + 1 ) - s t p o s ) , ' [ A - Z   / .   / - / � � ] + ' , 1 , 1 )   , 
         t o _ n u m b e r ( r e g e x p _ s u b s t r ( s u b s t r ( g e n r e , s t p o s , C O A L E S C E ( N U L L I F ( e n d p o s , 0 ) , L E N G T H ( g e n r e ) + 1 ) - s t p o s ) , ' [ 0 - 9 ] + ' , 1 , 1 ) ) ) 
         B U L K   C O L L E C T   i n t o   i d _ n o m 
         F R O M   S p l i t     ; 
 r e t u r n   i d _ n o m ; 
 e n d   s p l i t _ a c t o r ; 
 
 
 
 
 
 
 E N D   A N A L Y S I S _ P C K ; 
 
 