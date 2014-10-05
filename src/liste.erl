% Author: Alex Mantel
-module(liste).
-export([create/0, isEmpty/1, laenge/1, insert/3, delete/2, find/2, retrieve/2, concat/2]).

% create() -> List
create() -> {}.

% isEmpty(List) -> bool.
isEmpty({}) -> true;
isEmpty({_, _}) -> false.

% laenge(List) -> Length (int).
laenge({}) -> 0;
laenge({_, X}) -> laenge(X) + 1.

% insert(List, Pos, Elem) -> List.
insert({},    1,   Elem) -> {Elem, {}};
insert({X,L}, 1,   Elem) -> {Elem, {X, L}};
insert({X,L}, Pos, Elem) -> {X, insert(L, Pos-1, Elem)};
insert(List, _,   _)    -> List.

% delete(List, Pos) -> List.
delete({}, _) -> {};
delete({_F, R}, 1) -> R;  % delete F
delete({F, R}, Pos) -> {F, delete(R, Pos-1)};
delete(List, _) -> List.

% find(List, Elem) -> Pos.
find(List, Elem) -> find_(List, Elem, 1).
find_({}, _Elem, _Accu) -> nil;
find_({F, _R}, Elem, Accu) when Elem == F -> Accu;
find_({_F, R}, Elem, Accu) -> find_(R, Elem, Accu+1).

% retrieve(List, Pos) -> Elem.
retrieve(List, Pos) -> retrieve_(List, Pos, 1).
retrieve_({}, _, _) -> nil;
retrieve_({F, _R}, Pos, Accu) when Pos == Accu -> F;
retrieve_({_F, R}, Pos, Accu) -> retrieve_(R, Pos, Accu+1).

% concat(List, List) -> List.
concat({}, List)   -> List;
concat({F, R}, List) -> {F, concat(R, List)}.
