-module(sel_sort).
-compile(array).
-compile(util).
-compile(export_all).
%-export([sel_sort/1,sel_sort_counter/1]).

% Selection Sort
% sel_sort(array) -> array
sel_sort({}) -> {};
sel_sort(Array) ->  I = array:lengthA(Array),
				   sel_sort(Array,0,I).

sel_sort(Array,I,I) -> Array;
sel_sort(Array,I,Length) -> MinPos = getMin(Array,I,I,Length),
							case (MinPos==I) of
								true -> NewArray = Array;
								false -> NewArray = util:swap(Array,I,MinPos)
							end,
							sel_sort(NewArray,I+1,Length).

getMin(_Array,MinI,I,I) -> MinI;
getMin(Array,MinI,I,Length) -> Elem1 = array:getA(Array,MinI),
							   Elem2 = array:getA(Array,I),
							   case (Elem1 < Elem2) of
									true -> getMin(Array,MinI,I+1,Length); 
									false -> getMin(Array,I,I+1,Length)
							   end.
						 
sel_sort_counter(Array) ->
		util:countreset(vergleich),
		I = array:lengthA(Array),
		{Verschiebung,Result} = sel_sort(Array,0,I,0),
		Vergleich = util:countread(vergleich),
		{Vergleich,Verschiebung,Result}.
		
sel_sort(Array,I,I,Verschiebung) -> {Verschiebung,Array};
sel_sort(Array,I,Length,Verschiebung) ->
							MinPos = getMin_(Array,I,I,Length),
							case (MinPos==I) of
								true -> NewArray = Array,
										NewVerschiebung = Verschiebung;
								false -> NewArray = util:swap(Array,I,MinPos),
										NewVerschiebung = Verschiebung+1
							end,
							sel_sort(NewArray,I+1,Length,NewVerschiebung).

getMin_(_Array,MinI,I,I) -> MinI;
getMin_(Array,MinI,I,Length) ->
							   Elem1 = array:getA(Array,MinI),
							   Elem2 = array:getA(Array,I),
							   case (Elem1 < Elem2) of
									true -> util:counting1(vergleich),
											getMin_(Array,MinI,I+1,Length); 
									false -> util:counting1(vergleich), 
											getMin_(Array,I,I+1,Length)
							   end.