-module(sel_sort_2).
-compile(array).
-compile(util).
-export([sel_sort/1,sel_sort_counter/1]).

% Selection Sort
% sel_sort(array) -> array
sel_sort({}) -> {};
sel_sort(Array) -> util:countreset(vergleich),
				   util:countreset(verschiebung),
				   I = array:lengthA(Array),
				   sel_sort(Array,0,I).

sel_sort(Array,I,I) -> Array;
sel_sort(Array,I,Length) -> MinPos = getMin(Array,I,I,Length),
							case (MinPos==I) of
							true -> NewArray = Array,
							  		 util:counting(vergleich,1);
							false -> NewArray = swap(Array,I,MinPos),
									 util:counting(verschiebung,1),
									 util:counting(vergleich,1)
							end,
							sel_sort(NewArray,I+1,Length).

getMin(_Array,MinI,I,I) -> MinI;
getMin(Array,MinI,I,Length) -> Elem1 = array:getA(Array,MinI),
							   Elem2 = array:getA(Array,I),
							   case (Elem1 < Elem2) of
									true ->  util:counting(vergleich,1),
											getMin(Array,MinI,I+1,Length); 
									false -> util:counting(vergleich,1),
											getMin(Array,I,I+1,Length)
							   end.
							   
swap(Array,Pos1,Pos2) -> Tmp = array:getA(Array,Pos1),
					     Array1 = array:setA(Array,Pos1,array:getA(Array,Pos2)),
						 _Result = array:setA(Array1,Pos2,Tmp).

%200 Elem Time = 504632000 mics ~ 8,41ish minutes
sel_sort_counter(Array) ->
		NewArray = sel_sort(Array),
		Vergleich = util:countread(vergleich),
		Verschiebung = util:countread(verschiebung),
		%util:countstop(vergleich),
		%util:countstop(verschiebung),
		{Vergleich,Verschiebung,NewArray}.