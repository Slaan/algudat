% author alex mantel
-module(ins_sort).
-compile(util).
-export([insertionsort/1]).

% insertionsort: Array -> Array
insertionsort(A) ->
        Accu  = array:initA(),
        Index = 0,
        Size  = array:lengthA(),
        insertionsort_(A, Accu, Index, Size).

insertionsort_(A, Accu, Index, Size) ->
        if 
          Index < Size ->
            Elem = array:getA(A, Index),
            Newaccu = insert(Accu, Elem),
            insertionsort_(A, Newaccu, Index+1, Size);
          true ->
            Accu
        end.

% insert: Array x Elem -> Array
% inserts Elem in Accu an array
insert(Accu, Elem) ->
        Size = array:lengthA(Accu),
        insert_(array:setA(Elem, Size), Size).

insert_(Accu, I) ->
        Curr = array:getA(I),
        Prev = array:getA(I-1),
        if 
          Curr < Prev -> 
            NewAccu = util:swap(Accu, I, I-1),
            NewI = I - 1,
            insert_(NewAccu, NewI);
          true ->
            Accu
        end.
