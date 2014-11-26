Autor: Alex Mantel, Daniel Hofmeister
Inhalt: ADP Aufgabe 1
Dateien: liste.erl
   	 stack.erl
	 array.erl
	 sel_sort.erl
	 q_sort.erl
	 Skizze3.pdf
	 A3ReadMe.txt

Installationshinweise:
Die .erl Dateien sollten im werl Interpreter compiliert werden c(Datei) um auf die Methoden zuzugreifen.
Tipp: Mit "cover:compile_directory()." kann man einen gesamten Ordner compilieren.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Aufruf zum Starten des Quicksorts:
aufgabe2:main(Sort,NoElements).
Paramter "Sort" übergibt die Art und Weise wie sortiert werden soll. Es gibt hierbei 4 Möglichkeiten:
1. quick: Sortiert mit dem Pivot an linker Stelle, keine Zähler
2. quick_c: Sortiert mit dem Pivot an linker Stelle, mit Zähler
3. quick_rd: Sortiert mit dem Pivot an zufälliger Stelle, keine Zähler
4. quick_rd_c: Sortiert mit dem Pivot an zufälliger Stelle, mit Zähler
