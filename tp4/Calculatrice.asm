			org 	$4
vector_001 	dc.l 	Main

			; ==============================
			; Programme principal
			; ==============================
			
			org 	$500
			
Main		movea.l #String1,a0
			;jsr 	RemoveSpace
			
			;jsr	IscharError
			
			;jsr 	IsMaxError
			
			jsr 	Convert
			
			illegal
			
			; ==============================
			; Sous-programmes
			; ==============================

RemoveSpace	movem.l d0/a0/a1,-(a7)
			movea.l a0,a1
			
\loop		move.b 	(a0)+,d0
			cmpi.b 	#' ',d0
			beq 	\loop
			
			move.b 	d0,(a1)+
			bne		\loop
			
			beq		\quit
			
\quit		movem.l	(a7)+,d0/a0/a1
			rts
			
			
IsCharError ; Sauvegarde les registres dans la pile.
			movem.l d0/a0,-(a7)
			
\loop 		; Charge un caractère de la chaîne dans D0 et incrémente A0.
			; Si le caractère est nul, on renvoie false (pas d'erreur).
			move.b (a0)+,d0
			beq \false
			
			; Compare le caractère au caractère '0'.
			; S'il est inférieur, on renvoie true (ce n'est pas un chiffre).
			cmpi.b #'0',d0
			blo \true
			
					
			; Compare le caractère au caractère '9'.
			; S'il est inférieur ou égal, on reboucle (c'est un chiffre).
			; S'il est supérieur, on renvoie true (ce n'est pas un chiffre).
			cmpi.b #'9',d0
			bls \loop
			
			
\true 		; Sortie qui renvoie Z = 1 (erreur).
			; (L'instruction BRA ne modifie pas le flag Z.)
			ori.b #%00000100,ccr
			bra \quit
			
\false 		; Sortie qui renvoie Z = 0 (aucune erreur).
			andi.b #%11111011,ccr
			
\quit 		; Restaure les registres puis sortie.
			; (Les instructions MOVEM et RTS ne modifient pas le flag Z.)
			movem.l (a7)+,d0/a0
			rts
			
IsMaxError 	; Sauvegarde les registres dans la pile.
			movem.l d0/a0,-(a7)
			
			; On récupère la taille de la chaîne (dans D0).
			jsr StrLen
	
			; Si la chaîne a plus de 5 caractères, renvoie true (erreur).
			; Si la chaîne a moins de 5 caractères, renvoie false (pas d'erreur).
			cmpi.l #5,d0
			bhi \true
			blo \false
			
			; Si la chaîne contient exactement 5 caractères :
			; comparaisons successives avec '3', '2', '7', '6' et '7'.
			; Si supérieur, on quitte en renvoyant une erreur.
			; Si inférieur, on quitte sans renvoyer d'erreur.
			; Si égal, on compare le caractère suivant.
			cmpi.b #'3',(a0)+
			bhi \true
			blo \false
			
			cmpi.b #'2',(a0)+
			bhi \true
			blo \false
			
			cmpi.b #'7',(a0)+
			bhi \true
			blo \false

			cmpi.b #'6',(a0)+
			bhi \true
			blo \false

			cmpi.b #'7',(a0)
			bhi \true

\false 		; Sortie qui renvoie Z = 0 (aucune erreur).
			; (L'instruction BRA ne modifie pas le flag Z.)
			andi.b #%11111011,ccr
			bra \quit

\true 		; Sortie qui renvoie Z = 1 (erreur).
			ori.b #%00000100,ccr

\quit 		; Restaure les registres puis sortie.
			; (Les instructions MOVEM et RTS ne modifient pas le flag Z.)
			movem.l (a7)+,d0/a0
			rts
			
StrLen 		move.l 	a0,-(a7) 	; Sauvegarde le registre A0 dans la pile.

			clr.l 	d0
			
\loop 		tst.b 	(a0)+
			beq 	\quit

			addq.l 	#1,d0
			bra 	\loop

\quit 		movea.l (a7)+,a0 	; Restaure la valeur du registre A0.
			rts

			
Convert		tst	(a0)
			beq \false
			jsr IsCharError
			beq \false
			jsr IsMaxError
			beq \false
			
			jsr Atoui
			
\false		andi.b #%11111011,ccr
			rts

Atoui 		; Sauvegarde les registres dans la pile.
			movem.l d1/a0,-(a7)

			; Initialise la variable de retour à 0.
			clr.l d0

			; Initialise la variable de conversion à 0.
			clr.l d1

\loop 		; On copie le caractère courant dans D1
			; A0 pointe ensuite sur le caractère suivant (post incrémentation).
			move.b (a0)+,d1

			; Si le caractère copié est nul,
			; on quitte (fin de chaîne).
			beq \quit

			; Sinon, on réalise la conversion numérique du caractère.
			subi.b #'0',d1

			; On décale la variable de retour vers la gauche (x10),
			; puis on y ajoute la valeur numérique du caractère.
			mulu.w #10,d0
			add.l d1,d0
		
			; Passage au caractère suivant.
			bra \loop

\quit 		; Restaure les registres puis sortie.
			movem.l (a7)+,d1/a0
			rts

			
			
			; ==============================
			; Données
			; ==============================
			
String1 	dc.b 	' 5 + 12 ', 0
