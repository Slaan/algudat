-module(q_sort).
-compile(util).
-compile(sel_sort).
-compile(export_all).
-compile(array).

quicksort(Unsorted,Case) -> Length = array:lengthA(Unsorted),
		    case (Length<12) of
			true -> Sorted = sel_sort:sel_sort(Unsorted);
			false -> case Case of
					 left -> Pivot = getPivot(left,Unsorted,Length);
					 random -> Pivot = getPivot(random,Unsorted,Length)
				 end,
		         	 {Left,Right} = partition(Unsorted,Pivot,Length),
		    		 SoLeft = quicksort(Left,Case),
		    		 SoRight = quicksort(Right,Case),
		    		 Sorted = append(SoLeft,Pivot,SoRight)
		    end,
		    Sorted.

getPivot(Case,Array,Length) ->
		    case Case of
			left -> array:getA(Array,0);
			random -> Pos = random:uniform(Length)-1,
				array:getA(Array,Pos)
		    end.

%partition_(Unsorted,Pivot,CurIndex,Length,Left,LeftIndex,Right,RightIndex)
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

append(A1,Pivot,A2) ->
	Length1 = array:lengthA(A1),
	Length2 = array:lengthA(A2),
	NewA1 = array:setA(A1,Length1,Pivot),
	append(NewA1,Length1+1,A2,0,Length2).

append(A1,_L1,_A2,I,I) -> A1;
append(A1,L1,A2,I2,L2) -> Elem = 
	Elem = array:getA(A2,I2),
	NewA1 = array:setA(A1,L1,Elem),
	append(NewA1,L1+1,A2,I2+1,L2).

