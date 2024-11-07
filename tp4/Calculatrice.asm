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
			
\false ; Sortie qui renvoie Z = 0 (aucune erreur).
; (L'instruction BRA ne modifie pas le flag Z.)
			andi.b 	#%11111011,ccr
			bra 	\quit
\true ; Sortie qui renvoie Z = 1 (erreur).
			ori.b 	#%00000100,ccr
\quit ; Restaure les registres puis sortie.
; (Les instructions MOVEM et RTS ne modifient pas le flag Z.)
			movem.l (a7)+,d0/a0
			rts	

StrLen 		move.l 	a0,-(a7) ; Sauvegarde le registre A0 dans la pile.
			clr.l 	d0
\loop 		tst.b 	(a0)+
			beq 	\quit
			addq.l 	#1,d0
			bra 	\loop
\quit 		movea.l (a7)+,a0 ; Restaure la valeur du registre A0.
			rts

Convert		tst 	(a0)
			beq		\false
			jsr 	IsCharError
			beq		\false
			jsr		IsMaxError
			beq		\false
			
			jsr 	Calcul			;appelle Atoui
			
\false 		andi.b 	#%11111011,ccr
			rts	

Calcul		movem.l d1/a0,-(a7) 	;Atoui
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


GetNum		move.l a0,-(a7) ;encadrement
			move.l a1,-(a7)
			move.l a2,-(a7)
			move.l a0,a1
			jsr NextOp
			beq \false
			move.l a0,a2
			move.l a1,a0
			
			move.w a2,d1
			move.w a2,'\0'
			jsr Convert
			beq \false
			move.w d1,a2
			
			jsr \true

\true 		
			movem.l (a7)+,a1/a2
			rts

\false 		movea.l (a7)+,a0
			movea.l (a7)+,a1
			movea.l (a7)+,a2
			rts
			

 		
sTest 		dc.b 	"Hello World",0












