			org 	$4

Vector_001 	dc.l 	Main

			org 	$500

Main 		move.l 	#-1,d0 ; Initialise D0.

Abs 		tst.b	d0 		; Programme Abs à développer.
			bmi 	test
			
test		neg.l 	d0
			illegal
