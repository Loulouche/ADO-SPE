			org 	$0 ; ON A CHANGE CETAIT $4 AVANT, PK ??
			
vector_000 	dc.l 	$ffb500
vector_001 	dc.l 	Main

			org 	$500

Main 		;movea.l #String1,a0
			;movea.l #String1,a1
			;jsr		RemoveSpace
			
			;jsr 	IsCharError
			;jsr 	IsMaxError
			;jsr 	Convert
			
			lea 	sTest,a0
			move.b 	#24,d1
			move.b 	#20,d2
			jsr 	Print
			
			illegal
				
RemoveSpace	movem.l d0/a0/a1,-(a7)

			movea.l	a0,a1
			clr.l 	d0

\loop		move.b	(a0)+,d0
			beq		\quit

			cmpi.b	#' ',d0
			beq		\loop
			
			move.b	d0,(a1)+
			bne 	\loop
			
			
\quit		move.b 	d0,(a1)+
			movem.l (a7)+,d0/a1/a0
			
			rts
			
IsCharError	movem.l d0/a0,-(a7)

\loop		move.b 	(a0)+,d0
			beq 	\false
			
			cmpi.b #'0',d0
			blo \true
			
			cmpi.b #'9',d0
			bls \loop

\true		ori.b 	#%00000100,ccr
			bra 	\quit

\false		andi.b 	#%11111011,ccr

\quit		movem.l (a7)+,d0/a0
			rts


IsMaxError 			; Sauvegarde les registres dans la pile.
			movem.l d0/a0,-(a7)
					; On récupère la taille de la chaîne (dans D0).
			jsr 	StrLen
					; Si la chaîne a plus de 5 caractères, renvoie true (erreur).
					; Si la chaîne a moins de 5 caractères, renvoie false (pas d'erreur).
			cmpi.l 	#5,d0
			bhi 	\true
			blo 	\false
					; Si la chaîne contient exactement 5 caractères :
					; comparaisons successives avec '3', '2', '7', '6' et '7'.
					; Si supérieur, on quitte en renvoyant une erreur.
					; Si inférieur, on quitte sans renvoyer d'erreur.
					; Si égal, on compare le caractère suivant.
			cmpi.b 	#'3',(a0)+
			bhi 	\true
			blo 	\false
			
			cmpi.b 	#'2',(a0)+
			bhi 	\true
			blo 	\false
			
			cmpi.b 	#'7',(a0)+
			bhi 	\true
			blo 	\false
			
			cmpi.b 	#'6',(a0)+
			bhi 	\true
			blo 	\false
			
			cmpi.b 	#'7',(a0)
			bhi 	\true
			
\false 

			andi.b 	#%11111011,ccr
			bra 	\quit
\true 
			ori.b 	#%00000100,ccr
\quit 

			movem.l (a7)+,d0/a0
			rts	

StrLen 		move.l 	a0,-(a7) 
			clr.l 	d0
\loop 		tst.b 	(a0)+
			beq 	\quit
			addq.l 	#1,d0
			bra 	\loop
\quit 		movea.l (a7)+,a0 
			rts

Convert		tst 	(a0)
			beq		\false
			jsr 	IsCharError
			beq		\false
			jsr		IsMaxError
			beq		\false
			
			jsr 	Calcul			
			
\false 		andi.b 	#%11111011,ccr
			rts	

Calcul		movem.l d1/a0,-(a7) 	
			clr.l 	d0
			clr.l 	d1
			
\loop		move.b 	(a0)+,d1
			beq 	\quit
			
			subi.b 	#'0',d1
			
			mulu.w 	#10,d0
			add.l 	d1,d0

			bra \loop

\quit		movem.l (a7)+,d1/a0
			rts

Print		movem.l	d0/d1/a0,-(a7)

\loop		move.b	(a0)+,d0
			beq		\quit
			
			jsr 	PrintChar
			
			addq.b	#1,d1
			bra		\loop

\quit		movem.l	(a7)+,d1/a0/d0
			rts

PrintChar 	incbin 	"PrintChar.bin"

NextOp		tst.b 	(a0)
			beq		\quit
			
			cmpi.b #'+',(a0)
			beq \quit
			
			cmpi.b #'-',(a0)
			beq \quit
			
			cmpi.b #'*',(a0)
			beq \quit
			
			cmpi.b #'/',(a0)
			beq \quit
			
			addq.l #1,a0
			bra NextOp
			
\quit 		rts


GetNum		movem.l d1/a1-a2,-(a7)
			movea.l a0,a1
			jsr NextOp
			move.l a0,a2
			move.b (a2),d1
			clr.b (a2)
			
			movea.l a1,a0
			jsr Convert
			beq \true
			

\true 		
			move.b d1,(a2)
			movea.l a2,a0

\false 		
			move.b d1,(a2)
			andi.b #%11111011,ccr

\quit 		movem.l (a7)+,d1/a1-a2
			rts
			
GetExpr
			movem.l d1-d2/a0,-(a7)
			
			jsr GetNum
			bne \false
			move.l d0,d1

\loop
			move.b (a0)+,d2
			beq \true
			
			jsr GetNum
			bne \false

			cmp.b #'+',d2
			beq \ad

			cmp.b #'-',d2
			beq \subtract
			
			cmp.b #'*',d2
			beq \multiply

			bra \divide
			
\ad 		
			add.l d0,d1
			bra \loop
			
\subtract	
			sub.l d0,d1
			bra \loop

\multiply	
			muls.w d0,d1
			bra \loop

\divide		
			tst.w d0
			beq \false
			divs.w d0,d1
			ext.l d1
			bra \loop
			
\false		
			andi.b #%11111011,ccr
			bra \quit
			
\true		move.l d1,d0
			ori.b #%00000100,ccr

\quit 
			movem.l (a7)+,d1-d2/a0
			rts
			
Uitoa		
			movem.l d0/a0,-(a7)
			clr.w -(a7)

\loop		andi.l #$ffff,d0
			divu.w #10,d0
			swap d0
			addi.b #'0',d0
			move.w d0,-(a7)
			swap d0
			tst.w d0
			bne \loop
			
\writeChar 	
			move.w (a7)+,d0
			move.b d0,(a0)+
			bne \writeChar
			movem.l (a7)+,d0/a0
			rts
			
\Itoa		move.l d0,-(a7)
			move.w a1,-(a7)
			tst.w 	d0
			bpl 	\pos
			jsr 	Uitoa

\negative 	move.b 	#'-',(a0)+
			neg.w 	d0
			
\pos		jsr Uitoa

\quit		movem.l (a7)+,d0/a0
			rts
			
			
			
			
sTest 		dc.b	"52146",0










