-module(q_sort).
-compile(util).
-compile(sel_sort).
-compile(export_all).
-compile(array).

% Hauptaufruf
quicksort(Unsorted,Case) -> Length = array:lengthA(Unsorted),
		    case (Length<12) of
			true -> Sorted = sel_sort:sel_sort(Unsorted);
			false -> {NewArray,Pivot} = getPivot(Case,Unsorted,Length),
				   	 {Left,Right} = partition(NewArray,Pivot,Length),
		    		 SoLeft = quicksort(Left,Case),
		    		 SoRight = quicksort(Right,Case),
		    		 Sorted = append(SoLeft,Pivot,SoRight)
		    end,
		    Sorted.

%Gibt das gesuchte Pivotelement je nach gewünschter Methode zurück
%und setzt es an die erste Stelle des Arrays.
getPivot(Case,Array,Length) ->
		    case Case of
				left -> PivotPos = 0;
				random -> PivotPos = random:uniform(Length)-1
		    end,
		    Pivot = array:getA(Array,PivotPos),
		    NewArray = util:swap(Array,0,PivotPos),
		    {NewArray,Pivot}.

%partition(Unsorted,Pivot,CurIndex,Length,Left,LeftIndex,Right,RightIndex)
%spaltet das Eingabearray am Pivotelement in ein linkes und ein rechts Array
partition(Unsorted,Pivot,Length) -> partition(Unsorted,Pivot,1,Length,{},0,{},0).

partition(_Unsorted,_Pivot,I,I,Left,_LeftIndex,Right,_RightIndex) -> {Left,Right};
partition(Unsorted,Pivot,CurIndex,Length,Left,LeftIndex,Right,RightIndex) ->
	CurElem = array:getA(Unsorted,CurIndex),
	case (CurElem<Pivot) of
		true -> NewLeft = array:setA(Left,LeftIndex,CurElem),
			partition(Unsorted,Pivot,CurIndex+1,Length,NewLeft,LeftIndex+1,Right,RightIndex);
		false -> NewRight = array:setA(Right,RightIndex,CurElem),
			partition(Unsorted,Pivot,CurIndex+1,Length,Left,LeftIndex,NewRight,RightIndex+1)
	end.

%append/3 klebt zwei Array mit einem Pivot dazwischen zusammen.
append(A1,Pivot,A2) ->
	Length1 = array:lengthA(A1),
	Length2 = array:lengthA(A2),
	NewA1 = array:setA(A1,Length1,Pivot),
	append(NewA1,Length1+1,A2,0,Length2).

append(A1,_L1,_A2,I,I) -> A1;
append(A1,L1,A2,I2,L2) -> 
	Elem = array:getA(A2,I2),
	NewA1 = array:setA(A1,L1,Elem),
	append(NewA1,L1+1,A2,I2+1,L2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
quicksort_counter(Unsorted,Case) -> util:countreset(verschiebung),
				   util:countreset(vergleich),
				   {Vergleich1,Verschiebung1,Sorted} = quicksort_counter_(Unsorted,Case),
				   Vergleich2 = util:countread(vergleich),
				   Verschiebung2 = util:countread(verschiebung),
				   Vergleich = Vergleich1+Vergleich2,
				   Verschiebung = Verschiebung1+Verschiebung2,
				   {Vergleich,Verschiebung,Sorted}. 

quicksort_counter_(Unsorted,Case) -> Length = array:lengthA(Unsorted),
		    case (Length<12) of
			true -> {Vergleich,Verschiebung,Sorted} = sel_sort:sel_sort_counter(Unsorted);
			false -> case Case of
					 left -> {NewArray,Pivot} = getPivot(left,Unsorted,Length);
					 random -> {NewArray,Pivot} = getPivot(random,Unsorted,Length)
				 end,
		         	 {Left,Right} = partition_(NewArray,Pivot,Length),
		    		 {Vergleich1,Verschiebung1,SoLeft} = quicksort_counter_(Left,Case),
		    		 {Vergleich2,Verschiebung2,SoRight} = quicksort_counter_(Right,Case),
		    		 Sorted = append(SoLeft,Pivot,SoRight),
				 Vergleich = Vergleich1+Vergleich2,
				 Verschiebung = Verschiebung1+Verschiebung2
		    end,
		    {Vergleich,Verschiebung,Sorted}.

partition_(Unsorted,Pivot,Length) -> partition_(Unsorted,Pivot,1,Length,{},0,{},0).

partition_(_Unsorted,_Pivot,I,I,Left,_LeftIndex,Right,_RightIndex) -> {Left,Right};
partition_(Unsorted,Pivot,CurIndex,Length,Left,LeftIndex,Right,RightIndex) ->
	CurElem = array:getA(Unsorted,CurIndex),
	util:counting(vergleich,1),
	util:counting(verschiebung,1),
	case (CurElem<Pivot) of
		true -> NewLeft = array:setA(Left,LeftIndex,CurElem),
			partition_(Unsorted,Pivot,CurIndex+1,Length,NewLeft,LeftIndex+1,Right,RightIndex);
		false -> NewRight = array:setA(Right,RightIndex,CurElem),
			partition_(Unsorted,Pivot,CurIndex+1,Length,Left,LeftIndex,NewRight,RightIndex+1)
	end.
