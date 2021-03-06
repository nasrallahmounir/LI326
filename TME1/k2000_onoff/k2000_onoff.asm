;; Adresse 0, instructions qui sont executés après un reset.
ORG 0
	call initialisation
	goto main


;; Adresse 4, instructions à executer en cas d'interruption, qui équivaut à un return.
ORG 4
	retfie

	
list    p=16f877        	; definit le processeur cible
include "p16f877.inc" ; declaration des noms de registres


li macro r, v
	movlw v
	movwf r
endm
	

	
initialisation
	
;;  Definition du registre de configuration du pic
;;  _CP_OFF   : le code n'est pas protege et peut être relu
;;  _WDT_OFF  : pas de timer watch dog
;;  _PWRTE_ON : attente d'un délai de 72ms apres le power on
;;  _HS_OSC   : le pic utilise un oscillateur à quartz
;;  _LVP_OFF  : pas de mode programmation basse tension

__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_ON & _HS_OSC & _LVP_OFF
	
	
BANKSEL 1

;; On définit TRISD qui contient l'adresse du registre TRISD
TRISD		EQU H'0088'

;; On met le port D en sortie ( tout les bits du registre TRISD à 0 )
	clrf TRISD

BANKSEL0

;; On définit PORTD qui contient l'adresse du registre PORTD
PORTD	EQU  H'0008'

	return
main
;; On met la valeur B'0000 0001' sur le port D
	li PORTD,1
		
boucledroite

	btfss PORTB, 1

	goto arret
	
;; Si le bit 8 est activé, alors on boucle à gauche
	btfss 0x20, 8
	
	goto bouclegauche

	rrf 0x20,1
	
;; On éffectue une rotation droite sur le PORTD
	rrf PORTD,1

;; On boucle en retournant à l'adresse de l'étiquette "boucle"
	goto boucledroite


bouclegauche

	btfss PORTB, 1

	goto arret
	
;;;  Si le bit 1 est activé, alors on boucle à droite
	btfss 0x20, 1

	goto boucledroite

	rlf 0x20,1
	
;;;  On éffectue une rotation droite sur le PORTD
	rlf PORTD,1

;;;  On boucle en retournant à l'adresse de l'étiquette "boucle"
	goto bouclegauche


;; arret
	
;; Directive de fin de programme
	END		