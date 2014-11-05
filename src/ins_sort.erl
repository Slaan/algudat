% author alex mantel
-module(ins_sort).
-compile(util).
-export([insertionsort/1, ins_sort_counter/1]).

% insertionsort: Array -> Array
% sorts given array ascendent 
insertionsort(A) ->
        Size  = array:lengthA(A),
        Index = 1,
        insertionsort_(A, Index, Size).

insertionsort_(A, Index, Index) -> A;
insertionsort_(A, Index, Size)  ->
        NewArray = insert(A, Index),
        insertionsort_(NewArray, Index+1, Size).

% insert: Array x Index -> Array
% sorts Elem of Index to correct positiony
insert(Accu, 0) -> Accu;
insert(Accu, I) ->
        Curr = array:getA(Accu, I),
        Prev = array:getA(Accu, I-1),
        % vergleich
        if 
          Curr < Prev -> 
            NewAccu = util:swap(Accu, I, I-1),
            % verschiebung
            insert(NewAccu, I-1);
          true ->
            Accu
        end.
		
%%--------------------------------------------------------------------
%Aufruf mit Zählern
ins_sort_counter(A) ->
        Size  = array:lengthA(A),
        Index = 1,
        insertionsort_(A, Index, Size, 0, 0).

insertionsort_(A, Index, Index, Vergleich, Verschiebung) -> {Vergleich, Verschiebung, A};
insertionsort_(A, Index, Size, Vergleich, Verschiebung) ->
        {NewVergleich, NewVerschiebung, NewArray} = insert(A, Index, Vergleich, Verschiebung),
        insertionsort_(NewArray, Index+1, Size, NewVergleich, NewVerschiebung).

% insert: Array x Index -> Array
% sorts Elem of Index to correct positiony
insert(Accu, 0, Vergleich, Verschiebung) -> {Vergleich, Verschiebung, Accu};
insert(Accu, I, Vergleich, Verschiebung) ->
        Curr = array:getA(Accu, I),
        Prev = array:getA(Accu, I-1),
        % vergleich
        if 
          Curr < Prev -> 
            NewAccu = util:swap(Accu, I, I-1),
            % verschiebung
            insert(NewAccu, I-1, Vergleich+1, Verschiebung+1);
          true ->
            {Vergleich+1, Verschiebung, Accu}
        end.
