% author alex mantel
-module(ins_sort).
-compile(util).
-export([insertionsort/1, ins_sort_counter/1]).

% sorts given array 
insertionsort(A) ->
        Accu  = array:initA(),
        Size  = array:lengthA(A),
        Index = 0,
        insertionsort_(A, Accu, Index, Size).

insertionsort_(_A, Accu, Index, Index) -> Accu;
insertionsort_(A, Accu, Index, Size)  -> Elem = array:getA(A, Index),
                                         Newaccu = insert(Accu, Elem),
                                         insertionsort_(A, Newaccu, Index+1, Size).

% insert: Array x Elem -> Array
% inserts Elem in Accu an array
insert(Accu, Elem) ->
        Size = array:lengthA(Accu),
        insert_(array:setA(Accu, Size, Elem), Size).

insert_(Accu, I) ->
        Curr = array:getA(Accu, I),
        Prev = array:getA(Accu, I-1),
        % vergleich
        if 
          Curr < Prev -> 
            NewAccu = util:swap(Accu, I, I-1),
            % verschiebung
            insert_(NewAccu, I-1);
          true ->
            Accu
        end.
		
%%--------------------------------------------------------------------
%Aufruf mit Zählern
ins_sort_counter(A) ->
		Accu  = array:initA(),
        Size  = array:lengthA(A),
        Index = 0,
        insertionsort_c(A, Accu, Index, Size,0,0).

insertionsort_c(_A, Accu, Index, Index,Vergleich,Verschiebung) -> {Vergleich,Verschiebung,Accu};
insertionsort_c(A, Accu, Index, Size,Vergleich,Verschiebung)  -> 
		Elem = array:getA(A, Index),
        {Newaccu,NewVergleich,NewVerschiebung} = insert_c(Accu, Elem,Vergleich,Verschiebung),
        insertionsort_c(A, Newaccu, Index+1, Size,NewVergleich,NewVerschiebung).

% insert: Array x Elem -> Array
% inserts Elem in Accu an array
insert_c(Accu, Elem,Vergleich,Verschiebung) ->
        Size = array:lengthA(Accu),
        insert_c_(array:setA(Accu, Size, Elem), Size,Vergleich,Verschiebung).

insert_c_(Accu, I,Vergleich,Verschiebung) ->
        Curr = array:getA(Accu, I),
        Prev = array:getA(Accu, I-1),
        % vergleich
        if 
          Curr < Prev -> 
            NewAccu = util:swap(Accu, I, I-1),
            % verschiebung
            insert_c_(NewAccu, I-1,Vergleich+1,Verschiebung+1);
          true ->
            {Accu,Vergleich+1,Verschiebung}
        end.