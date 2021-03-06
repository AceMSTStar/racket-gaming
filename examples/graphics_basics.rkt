#lang racket/base

(#%require "../graphics.rkt") ; laad de library uit de bovenstaande directory

;; Enkele hulpfuncties

(define (write-line msg)
  (display msg)
  (newline))

;; Spelen met het graphics zelf

(define my-graphics (make-graphics 400 300 "Simple Graphics Example")) ; een eenvoudig canvas aanmaken

(chain my-graphics (hide)) ; het canvas verbergen
(chain my-graphics (show)) ; en terug zichtbaar maken

; of ook:

(show-graphics my-graphics) ; het canvas verbergen
(show-graphics my-graphics) ; en terug zichtbaar maken

(define extra-graphics ; uitgebreidere opties
  (new graphics%
       [width 300]
       [height 200]
       [title "Mini canvas"]
       [shown? #f]))

;; Luisteren naar events

; Om alles mooi en netjes te houden nesten we objecten in andere objecten.
; Al dit wordt makkelijk toegankelijk via een speciale "chain" special form.

(chain my-graphics keyboard (get-key #\a) press (add! (lambda () (display "A pressed"))))

; In nederlands: voer een lambda uit wanneer de press-gebeurtenis van een
; zekere toets #\a van het toetsenbord van my-graphics wordt geactiveerd.
; Dit valt te vergelijken met de dispatchnotatie in de lessen van structuur van
; computerprogramma's: ((((my-graphics 'keyboard) 'get-key #\A) 'press) 'add! (lambda () ...))
;
; NOOT: "press" is hier een object, geen operatie
;
; Merk op dat de naam "keyboard", "get-key", etc. wel altijd moet opgezocht worden.
; Daarom is het soms beter om een bepaald deel van de ketting naar buiten te brengen.
; Op die manier moet het programma niet telkens doorheen heel de ketting gaan,
; en bespaar je dus rekenkracht van je computer.
;
; NOOT: alleen nodig voor lange en/of veelgebruikte kettingen
;
; Een voorbeeld:

(define the-keyboard (chain my-graphics keyboard))

(chain* the-keyboard
  ((get-key #\a) press (add! (thunk (write-line "A pressed"))))
  ((get-key #\a) release (add! (thunk (write-line "A released"))))
  ((get-key #\A) press (add! (thunk (write-line "SHIFT+A pressed"))))
  ((get-key #\space) press (add! (thunk (write-line "Space pressed"))))
  ((get-key #\space) release (add! (thunk (write-line "Space released"))))
  ((get-key #\return) press (add! (thunk (write-line "Enter pressed")))))

;; Kleuren en stijlen aanmaken

(define blue-brush (new brush% [color "blue"]))
(define black-pen (new pen% [color "black"]))

;; Tekenen van objecten

(set-pen my-graphics black-pen)
(draw-rectangle my-graphics 200 200 50 50)

(set-brush my-graphics blue-brush)
(draw-rectangle my-graphics 50 50 50 50)

(set-brush my-graphics "red" 'solid)
(draw-ellipse my-graphics 200 50 35 60)

(update-graphics my-graphics)