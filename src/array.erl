-module(array).
-compile(liste).
-export([initA/0, setA/3, getA/2, lengthA/1]).

% initA() -> Array
initA() -> liste:create().

% setA(Array, Pos, Elem) -> Array
setA(List, Pos, Elem) ->
    ListPos = Pos + 1,
    Size  = liste:laenge(List),
        if 
            Size >= ListPos ->
                CList = liste:delete(List, ListPos),
                liste:insert(CList, ListPos, Elem);
            Size < ListPos -> 
                L = liste:insert(List, Size+1, 0),
                setA(L, Pos, Elem)
        end.

% getA(Array, Pos) -> Elem
getA({}, _) -> 0;
getA(List, Pos) ->
        ListPos = Pos + 1,  
        Size    = liste:laenge(List),
        if
            Size < ListPos -> 0;
            Pos  < 0   -> 0;  
            true       -> liste:retrieve(List, ListPos)
        end.

% lengthA(Array) -> Pos
lengthA(List) -> liste:laenge(List).


