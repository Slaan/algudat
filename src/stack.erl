% Author: Daniel Hofmeister
-module(stack).
-compile(liste).
-export([createS/0, push/2, pop/1, top/1, isEmptyS/1]).

%createS: durch internes create von ADT Liste einen Stack anlegen
%createS() -> Stack
createS() -> liste:create().

%push: mit insert an erster Position das Element in der Liste einfügen
%push(Stack,Elem) -> Stack
push(Stack,Elem) -> liste:insert(Stack,1,Elem).

%pop: mit delete das Element an erster Stelle aus der Liste löschen
%pop(Stack) -> Stack
pop(Stack) -> liste:delete(Stack,1).

%top: das Element an erster Stelle ausgeben
%top(Stack) -> Elem
top(Stack) -> liste:retrieve(Stack,1).

%isEmptyS: delegieren an isEmpty der Liste
%isEmptyS(Stack) -> bool
isEmptyS(Stack) -> liste:isEmpty(Stack).
