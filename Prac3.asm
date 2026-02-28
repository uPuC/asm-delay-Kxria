;------------- definiciones e includes ------------------------------
.INCLUDE "m1280def.inc" ; Incluir definiciones de Registros para 1280
;.INCLUDE "m2560def.inc" ; Incluir definiciones de Registros para 2560

.equ INIT_VALUE = 0 ; Valor inicial R24

;------------- inicializar ------------------------------------------
ldi R24,INIT_VALUE
;------------- implementar ------------------------------------------
;call delay20uS

call delay20uS ; 5 TM
nop

delay20uS:
	ldi R24, 51    ; 1  TM
	nxt: nop       ; 1n TM
		 nop	   ; 1n TM
		 nop	   ; 1n TM
		 dec R24   ; 1n TM
		 brne nxt  ; 2n - 1 TM
	nop			   ; 1 TM
	nop			   ; 1 TM
	nop			   ; 1 TM
	nop			   ; 1 TM 			
	ret			   ; 5 TM

; T = t * TCPU
; 20uS (0.00002) = t * 1/16,000,000
; (0.00002)(16,000,000) = t = 320
; 2n + n + n + n + n + 10 + 4 = 320
; 6n + 14 = 320
; n = 306/6
; n = 51

;call delay4mS

call delay4mS ; 5 TM
nop

delay4mS:
	ldi R24, 90    ; 1  TM
	nxt: 
		ldi R25, 236 ; 1n TM
		nxt2:
		 	dec R25   ; 1n * 1m TM
		 	brne nxt2  ; (2m - 1) * 1n TM
		dec R24 ; 1n TM
		brne nxt ; (2n - 1) 	
ret			   		; 5 TM

; T = t * TCPU
; 4mS (0.00002) = t * 1/16,000,000
; (0.004)(16,000,000) = t = 64,000

; 1 + n + nm + 2nm - n + n + 2n - 1 + 10 = 64,000
; 3nm + 3n + 10 = 64,000
; n(3m + 3) = 63,990
; (3m + 3) = 63,990/n
; 63,990/2 = 31,995/5 = 6,399/9 = 711 (sin division entera)
; n = 2*5*9 = 90 (valor n)
; 3m + 3 = 63,990/90 = 711
; 3m = 711 - 3 = 708
; m = 708/3 = 236

;call delay1S

call delay1s	; 5 TM
nop

delay1s:
	ldi R24, 241	; 1 TM
	nxt:
		ldi R25, 38	; n TM
		nop 		; n TM
		nxt2:
			ldi R26, 218 ; m * n TM
			nxt3:
				dec R26	  ; m * n * o TM
				nop		  ; m * n * o TM
				nop		  ; m * n * o TM
				nop		  ; m * n * o TM
				nop		  ; m * n * o TM
				nop		  ; m * n * o TM
				brne nxt3 ; (2o - 1)mn TM
			dec R25   ; m * n TM
			brne nxt2 ; (2m -1)n TM
		dec R24  ; n TM
		brne nxt ; 2n - 1 TM
ret		; 5 TM

; 1 + n + nm + nmo  + (n) + 2nmo - nm + nm + 2nm - n + n + 2n - 1 + 10
; 3nmo + 3nm + 4n + 10
; n(3mo + 3m + 4) + 10 = 16,000,000
; n(3mo + 3m + 4) = 16,000,000 - 10 = 15,999,990
; 3mo + 3m + 4 = 15,999,990/n = = 15,999,990/241 = 66,390 -> n = 241
; 3mo + 3m = 66,390 - 4 = 66,386
; m(3o + 3) = 66,386
; 3o + 3 = 66,386/m = 66,386/38 = 1,747 -> m = 38
; 8o = 1,747 - 3 = 1,744
; o = 1744/8 = 218 -> o = 218


;call myRand ; Retorna valor en R25

; Metodo Congruencial Lineal
; X_n+1 = (a * Xn + C)
; R25 = SALIDA
LDI R20, 0xF0 ; seed Xn
ldi R21, 30 ; -> a
ldi R22, 86 ; -> c

ldi R16, 5
loop:
	call aleatorio
	dec r3
	brne loop
	
aleatorio:
	MUL R21, R20
	ADD R0, R22
	MOV R20, R0
	MOV R25, R0
	ret
;------------- ciclo principal --------------------------------------
arriba: inc R24
	cpi R24,10
	breq abajo
	out PORTA,R24
	rjmp arriba

abajo: dec R24
	cpi R24,0
	breq arriba
	out PORTA,R24
	rjmp abajo
