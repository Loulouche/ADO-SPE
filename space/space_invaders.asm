				; ==============================
				; Définition des constantes
				; ==============================
				
				; Mémoire vidéo
				; ------------------------------
VIDEO_START 	equ 	$ffb500 ; Adresse de départ
VIDEO_WIDTH 	equ 	480 ; Largeur en pixels
VIDEO_HEIGHT 	equ 	320 ; Hauteur en pixels
VIDEO_SIZE 		equ 	(VIDEO_WIDTH*VIDEO_HEIGHT/8) ; Taille en octets
BYTE_PER_LINE 	equ 	(VIDEO_WIDTH/8) ; Nombre d'octets par ligne

				; ==============================
				; Initialisation des vecteurs
				; ==============================
				
				org 	$0
vector_000 		dc.l 	VIDEO_START ; Valeur initiale de A7
vector_001 		dc.l 	Main ; Valeur initiale du PC
				
				; ==============================
				; Programme principal
				; ==============================

				org 	$500

Main 			; Test 1
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
				
				illegal
			
				; ==============================
				; Sous-programmes
				; ==============================
FillScreen		moveq.l d7,-(a7) 
				lea 	VIDEO_START,a0 ;possible aussi de faire un movea
				
				

				dbra 	FillScreen,d1

				; ==============================
				; Données
				; ==============================
	
				; ...
				; ...	
				; ...
