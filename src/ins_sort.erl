% author alex mantel
-module(ins_sort).
-compile(util).
-export([insertionsort/1, insert/2]).

% insertionsort: Array -> Array
insertionsort(A) ->
        Accu  = array:initA(),
        Size  = array:lengthA(A),
        Index = 0,
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
        insert_(array:setA(Accu, Size, Elem), Size).

insert_(Accu, I) ->
        Curr = array:getA(Accu, I),
        Prev = array:getA(Accu, I-1),
        if 
          Curr < Prev -> 
            NewAccu = util:swap(Accu, I, I-1),
            insert_(NewAccu, I-1);
          true ->
            Accu
        end.
