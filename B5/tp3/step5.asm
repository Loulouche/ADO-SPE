			;==============================
			; Initialisation des vecteurs
			; ==============================
			
			org 	$4

vector_001 	dc.l 	Main

			; ==============================
			; Programme principal
			; ==============================
		
			org 	$500	

Main 		movea.l #String1,a0
			jsr 	AlphaCount
			
			movea.l #String2,a0
			jsr 	AlphaCount

			illegal
	
			; ==============================
			; Sous-programmes
			; ==============================

LowerCount	movem.l d1/a0,-(a7)

			clr.l d0
			
\loop		move.b 	(a0)+,d1
			beq		\quit
			
			cmp.b	#'a',d1
			blo 	\loop
			
			cmp.b	#'z',d1
			bhi		\loop
			
			addq.l	#1,d0
			bra 	\loop

\quit		movem.l	(a7)+,d1/a0
			rts
 	
			
			

UpperCount movem.l d1/a0,-(a7)

			clr.l d0
			
\loop		move.b 	(a0)+,d1
			beq		\quit
			
			cmp.b	#'A',d1
			blo 	\loop
			
			cmp.b	#'Z',d1
			bhi		\loop
			
			addq.l	#1,d0
			bra 	\loop

\quit		movem.l	(a7)+,d1/a0
			rts
 	

DigitCount	movem.l d1/a0,-(a7)

			clr.l d0
			
\loop		move.b 	(a0)+,d1
			beq		\quit
			
			cmp.b	#'0',d1
			blo 	\loop
			
			cmp.b	#'9',d1
			bhi		\loop
			
			addq.l	#1,d0
			bra 	\loop
			
\quit		movem.l	(a7)+,d1/a0
			rts
 	

AlphaCount	jsr 	LowerCount
			move.l	d0,-(a7)
			
			jsr 	UpperCount
			add.l	d0,(a7)
			
			jsr 	DigitCount
			add.l	(a7)+,d0
			
			rts

			; ==============================
			; Données
			; ==============================

String1 	dc.b 		"Cette chaine comporte 46 caracteres alphanumeriques.",0
String2 	dc.b 		"Celle-ci en comporte 19.",0
