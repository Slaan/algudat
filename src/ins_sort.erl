% author alex mantel
-module(ins_sort).
-compile(util).
-export([insertionsort/1, insert/2]).

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
