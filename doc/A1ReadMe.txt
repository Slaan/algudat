Autor: Alex Mantel, Daniel Hofmeister
Inhalt: ADP Aufgabe 1
Dateien: liste.erl
	 liste.beam
   	 stack.erl
	 stack.beam
	 queue.erl
	 queue.beam
	 array.erl
  	 array.beam
	 Skizze.pdf
	 Fremdskizze.pdf
	 A1ReadMe.txt

Installationshinweise:
Die .erl Dateien sollten im werl Interpreter compiliert werden c(Datei) um auf die Methoden zuzugreifen.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Hinweise zu den Dateien:
liste.erl enth�lt folgende Methoden:

- create/0():
Erstellt neuen Abstrakten Datentyp Liste.

- isEmpty/1(Liste):
�berpr�ft, ob eine Liste leer ist.

- laenge/1(Liste):
Gibt die l�nge einer Liste zur�ck.

- insert/3(Liste,Position,Element):
F�gt ein Element an einer bestimmten Position einer Liste ein. Alle anderen Elemente
werden dabei nach hinten geschoben.

- delete/2(Liste,Position):
L�scht ein Element einer Liste an der Position.

- find/2(Liste,Element):
Findet die Position eines Elemente in einer Liste

- retrieve/2(Liste,Position):
Gibt das Element zur�ck, was an der angegenbenen Position in der Liste steht.

- concat/2(Liste,Liste):
F�gt zwei Listen in eine zusammen.
_________________________________________________________________
stack.erl enth�lt folgende Methoden:

- createS/0():
Erstellt neuen Stack

- push/2(Stack,Element):
Erstellt einen neuen Stack, in dem das Element eingesetzt wurde.

- pop/1(Stack):
Gibt einen Stack zur�ck, in dem das erste Element herausgel�scht wurde.

- top/1(Stack)
Gibt ein Element zur�ck nach dem Concept First in Last Out.

- isEmptyS/1(Stack)
�berpr�ft, ob ein Stack leer ist.
__________________________________________________________________
queue.erl enth�lt folgende Methoden.

- createQ/0()
Erstellt eine neue Queue

- front/1(Queue)
Gibt ein Element zur�ck nach dem Concept First in First Out.

- enqueue/2(Queue,Element)
F�gt ein Element der Queue zu.

- dequeue/1(Queue)
Gibt eine Queue zur�ck in der das erste Element (FIFO) entfernt wird.

- isEmptyQ/1(Queue)
�berpr�ft, ob eine Queue leer ist.
___________________________________________________________________
array.erl enth�lt folgende Methoden

- initA/0():
Erstellt ein neues Array

- setA/3(Array,Position,Element):
F�gt ein Element an der Stelle ein. Vorsicht. Das Element was vorher an dieser
Position war wird dadurch entfernt.

- getA/2(Array,Position):
Gibt das Element eines Array an einer bestimmten Position zur�ck.

- lengthA/1(Array):
Gibt die L�nge eines Arrays zur�ck.