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
liste.erl enthält folgende Methoden:

- create/0():
Erstellt neuen Abstrakten Datentyp Liste.

- isEmpty/1(Liste):
Überprüft, ob eine Liste leer ist.

- laenge/1(Liste):
Gibt die länge einer Liste zurück.

- insert/3(Liste,Position,Element):
Fügt ein Element an einer bestimmten Position einer Liste ein. Alle anderen Elemente
werden dabei nach hinten geschoben.

- delete/2(Liste,Position):
Löscht ein Element einer Liste an der Position.

- find/2(Liste,Element):
Findet die Position eines Elemente in einer Liste

- retrieve/2(Liste,Position):
Gibt das Element zurück, was an der angegenbenen Position in der Liste steht.

- concat/2(Liste,Liste):
Fügt zwei Listen in eine zusammen.
_________________________________________________________________
stack.erl enthält folgende Methoden:

- createS/0():
Erstellt neuen Stack

- push/2(Stack,Element):
Erstellt einen neuen Stack, in dem das Element eingesetzt wurde.

- pop/1(Stack):
Gibt einen Stack zurück, in dem das erste Element herausgelöscht wurde.

- top/1(Stack)
Gibt ein Element zurück nach dem Concept First in Last Out.

- isEmptyS/1(Stack)
Überprüft, ob ein Stack leer ist.
__________________________________________________________________
queue.erl enthält folgende Methoden.

- createQ/0()
Erstellt eine neue Queue

- front/1(Queue)
Gibt ein Element zurück nach dem Concept First in First Out.

- enqueue/2(Queue,Element)
Fügt ein Element der Queue zu.

- dequeue/1(Queue)
Gibt eine Queue zurück in der das erste Element (FIFO) entfernt wird.

- isEmptyQ/1(Queue)
Überprüft, ob eine Queue leer ist.
___________________________________________________________________
array.erl enthält folgende Methoden

- initA/0():
Erstellt ein neues Array

- setA/3(Array,Position,Element):
Fügt ein Element an der Stelle ein. Vorsicht. Das Element was vorher an dieser
Position war wird dadurch entfernt.

- getA/2(Array,Position):
Gibt das Element eines Array an einer bestimmten Position zurück.

- lengthA/1(Array):
Gibt die Länge eines Arrays zurück.