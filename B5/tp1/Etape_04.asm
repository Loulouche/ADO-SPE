			org 	$4
Vector_001 	dc.l 	Main
			org 	$500
Main 		movea.l #TAB,a0 ; On initialise A0 avec l'adresse du tableau.
			move.b 	(a0)+,d0 ; Nombre 1 -> D0.B ; A0 + 1 -> A0
			add.b 	(a0)+,d0 ; Nombre 2 + D0.B -> D0.B ; A0 + 1 -> A0
			add.b 	(a0)+,d0 ; Nombre 3 + D0.B -> D0.B ; A0 + 1 -> A0
			add.b 	(a0)+,d0 ; Nombre 4 + D0.B -> D0.B ; A0 + 1 -> A0
			add.b 	(a0),d0 ; Nombre 5 + D0.B -> D0.B
			move.b 	d0,SUM ; D0.B -> (SUM)
			illegal
			org 	$550
TAB 		dc.b 	18,3,5,9,14 ; Tableau contenant les 5 nombres.
SUM 		ds.b 	1 ; On réserve 8 bits pour stocker la somme.
