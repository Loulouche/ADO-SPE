			; ==============================
			; Initialisation des vecteurs
			; ==============================
			
			org 	$4
vector_001 	dc.l 	Main
	
			; ==============================
			; Programme principal
			; ==============================
			org 	$500
Main 		movea.l	#String1,a0
			jsr 	AlphaCount
			
			\movea.l #String2,a0
			jsr AlphaCount
			
			illegal

			; ==============================
			; Sous-programmes
			; ==============================


			; ==============================
			; Données
			; ==============================
