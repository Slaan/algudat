-module(sel_sort).
-compile(array).
-compile(util).
-export([sel_sort/1,sel_sort_counter/1]).

% Selection Sort
% sel_sort(array) -> array
sel_sort({}) -> {};
sel_sort(Array) -> %util:countstop(vergleich),
				   I = array:lengthA(Array),
				   sel_sort(Array,0,I).

sel_sort(Array,I,I) -> Array;
sel_sort(Array,I,Length) -> MinPos = getMin(Array,I,I,Length),
							NewArray = swap(Array,I,MinPos),
							sel_sort(NewArray,I+1,Length).

getMin(_Array,MinI,I,I) -> MinI;
getMin(Array,MinI,I,Length) -> Elem1 = array:getA(Array,MinI),
							   Elem2 = array:getA(Array,I),
							   case (Elem1 < Elem2) of
									true ->  %util:counting(vergleich,1),
											getMin(Array,MinI,I+1,Length); 
									false -> %util:counting(vergleich,1),
											getMin(Array,I,I+1,Length)
							   end.
							   
swap(Array,Pos1,Pos2) -> Tmp = array:getA(Array,Pos1),
					     Array1 = array:setA(Array,Pos1,array:getA(Array,Pos2)),
						 _Result = array:setA(Array1,Pos2,Tmp).
						 
sel_sort_counter(Array) ->
		NewArray = sel_sort(Array),
		{util:countread(vergleich),NewArray}.