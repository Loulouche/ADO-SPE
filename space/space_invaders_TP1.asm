			; ==============================
			; Définition des constantes
			; ==============================
			; Mémoire vidéo
			; ------------------------------
VIDEO_START 	equ 	$ffb500 						; Adresse de départ
VIDEO_WIDTH 	equ 	480 							; Largeur en pixels
VIDEO_HEIGHT 	equ 	320 							; Hauteur en pixels
VIDEO_SIZE 		equ 	(VIDEO_WIDTH*VIDEO_HEIGHT/8) 	; Taille en octets
BYTE_PER_LINE 	equ 	(VIDEO_WIDTH/8) 				; Nombre d'octets par ligne
			; ==============================
			; Initialisation des vecteurs
			; ==============================
				org 	$0
vector_000 		dc.l 	VIDEO_START 					; Valeur initiale de A7
vector_001 		dc.l 	Main 							; Valeur initiale du PC
			; ==============================
			; Programme principal
			; ==============================
				org 	$500
Main		; Test 1
				move.l 	#$ffffffff,d0
				jsr 	FillScreen
			; Test 2
				move.l 	#$f0f0f0f0,d0
				jsr 	FillScreen
			; Test 3
				move.l 	#$fff0fff0,d0
				jsr 	FillScreen
			; Test 4
				moveq.l #$0,d0
				jsr 	FillScreen
				
			;Whitesquare32
				jsr WhiteSquare32 
				illegal
			; ==============================
			; Sous-programmes
			; ==============================
FillScreen
				movem.l d7/a0,-(a7)
				movea.l #VIDEO_START,a0
				
				move.w 	#VIDEO_SIZE/4-1,d7
				
\loop			move.l	d0,(a0)+
				dbra	d7,\loop
				movem.l (a7)+,d7/a0
				rts

HLines			movem.l d6/d7/a0,-(a7)
				movea.l #VIDEO_START,a0
				
				move.w 	#VIDEO_SIZE/16-1,d7
				
\loop			move.w 	#BYTE_PER_LINE*8/4-1,d6

\white_loop 	move.l 	#$ffffffff,(a0)+
				dbra 	d6,\white_loop

				move.w 	#BYTE_PER_LINE*8/4-1,d6
\black_loop 	clr.l 	(a0)+
				dbra 	d6,\black_loop

				dbra 	d7,\loop
				movem.l	(a7)+,d6/d7/a0
				rts

WhiteSquare32	movem 	d7-d5/a0,-(a7)
				lea 	VIDEO_START+((BYTE_PER_LINE-4)/2) + ((VIDEO_HEIGHT-32)/2) + ((VIDEO_WIDTH-32)/2),a0
				;movea.l	#VIDEO_START,a01
				;move.l 	#VIDEO_SIZE,d7
				;move.l 	d6,VIDEO_HEIGHT/2-16
				;move.l 	d5,VIDEO_WIDTH/2-16

\loop 			move.l 	#$ffffffff,(a0)
				adda.l	#BYTE_PER_LINE,a0
				dbra 	d7,\loop
				movem 	(a7)+,d7/a0

			; ==============================
			; Données
			; ==============================
; ...
; ...
; ...
