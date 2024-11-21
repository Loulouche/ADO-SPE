		; ==============================
		; Initialisation des vecteurs
		; ==============================
			org $0
vector_000 	dc.l $ffb500
vector_001 	dc.l Main
		; ==============================
		; Programme principal
		; ==============================
			org $500
Main 		movea.l #sBuffer,a0
			clr.b d1
			clr.b d2
			move.l #60000,d3
			move.l #8000,d4
			jsr GetInput

			illegal	
		; ==============================
		; Sous-programmes
		; ==============================

GetInput 	incbin "GetInput.bin"

		; ==============================
		; Données
		; ==============================
sBuffer 	ds.b 60
