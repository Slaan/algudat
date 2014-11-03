-module(sel_sort).
-compile(array).
-compile(util).
-compile(export_all).
%-export([sel_sort/1,sel_sort_counter/1]).

% Selection Sort
% sel_sort(array) -> array
% Aufruf ohne Aktionen zu zählen.
sel_sort({}) -> {};
sel_sort(Array) ->  I = array:lengthA(Array),
				   sel_sort(Array,0,I).

%Sucht rekursiv das kleinste Element und setzt es an die kleineste
% noch nicht sortierte Stelle.
sel_sort(Array,I,I) -> Array;
sel_sort(Array,I,Length) -> MinPos = getMin(Array,I,I,Length),
							case (MinPos==I) of
								true -> NewArray = Array;
								false -> NewArray = util:swap(Array,I,MinPos)
							end,
							sel_sort(NewArray,I+1,Length).

%Sucht das Minimum in einem Array
getMin(_Array,MinI,I,I) -> MinI;
getMin(Array,MinI,I,Length) -> Elem1 = array:getA(Array,MinI),
							   Elem2 = array:getA(Array,I),
							   case (Elem1 < Elem2) of
									true -> getMin(Array,MinI,I+1,Length); 
									false -> getMin(Array,I,I+1,Length)
							   end.

%Aufruf mit Zählern							   
sel_sort_counter(Array) ->
		%util:countstop(vergleich),
		I = array:lengthA(Array),
		sel_sort(Array,0,I,0,0).
		%{Vergleich,Verschiebung,Result} = sel_sort(Array,0,I,0,0).
		%Vergleich = util:countread(vergleich),
		%{Vergleich,Verschiebung,Result}.
		
sel_sort(Array,I,I,Verschiebung,Vergleich) -> {Vergleich,Verschiebung,Array};
sel_sort(Array,I,Length,Verschiebung,Vergleich) ->
							{MinPos,NewVergleich} = getMin_(Array,I,I,Length,Vergleich),
							case (MinPos==I) of
								true -> NewArray = Array,
										NewVerschiebung = Verschiebung;
								false -> NewArray = util:swap(Array,I,MinPos),
										NewVerschiebung = Verschiebung+1
							end,
							sel_sort(NewArray,I+1,Length,NewVerschiebung,NewVergleich+1).

getMin_(_Array,MinI,I,I,Vergleich) -> {MinI,Vergleich};
getMin_(Array,MinI,I,Length,Vergleich) ->
							   Elem1 = array:getA(Array,MinI),
							   Elem2 = array:getA(Array,I),
							   case (Elem1 < Elem2) of
									true -> %util:counting(vergleich,0),
											NewVergleich = Vergleich+1,
											getMin_(Array,MinI,I+1,Length,NewVergleich); 
									false -> %util:counting(vergleich,0), 
											NewVergleich = Vergleich+1,
											getMin_(Array,I,I+1,Length,NewVergleich)
							   end.