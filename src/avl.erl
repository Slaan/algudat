-module(avl).
-compile(export_all).
-compile(util).

% creates a new avl tree
init(A) -> {open,{A,0,0},open}.

% adds an element to an avl tree
% First   - AVL Tree
% Second  - Element to insert
add({L,{Elem,H,B},R},Elem) -> {L,{Elem,H,B},R};			% Elemente Abfangen die bereits im Baum sind
add(OldTree,A) -> 
	{Left,Node,Right} = OldTree,
	{Cur,_Height,_Balance} = Node,
	case (A<Cur) of
		true -> case (Left==open) of
				true -> NewLeft=init(A);
				false -> NewLeft=add(Left,A)
			end,
			CurTree = {NewLeft,Node,Right};
		false -> case (Right==open) of
				true -> NewRight=init(A);
				false -> NewRight=add(Right,A)
			end,
			CurTree = {Left,Node,NewRight}
		end,
	NewTree = update(CurTree),
	update_balance(NewTree).
	
% removes an element from an avl tree
% First   - AVL Tree
% Second  - Element to remove
delete(open,_) -> open;
delete(Tree,Elem) ->
	{Left,{Cur,Height,Balance},Right} = Tree,
	case (Elem==Cur) of
		true -> Result = delete_(Tree);
		false -> case (Elem<Cur) of
				true -> NewTree = delete(Left,Elem),
					Result={NewTree,{Cur,Height,Balance},Right};
				false -> NewTree = delete(Right,Elem),
					Result={Left,{Cur,Height,Balance},NewTree}
			 end
	end,
	update(Result).
	
delete_(Tree) ->
	{Left,_,Right} = Tree,
	case (Left==Right) of
		true -> Result = open;
		false -> LeftHeight = get_height(Left),
				RightHeight = get_height(Right),
				case (LeftHeight<RightHeight) of
					true -> {NewRight,SwitchNode} = get_most_left_neighbour(Right),
						NewLeft = Left;
					false -> {NewLeft,SwitchNode} = get_most_right_neighbour(Left),
						NewRight = Right
			 end,
			 Result = {NewLeft,SwitchNode,NewRight}
	end,
	update(Result).

get_most_left_neighbour(Tree) ->
	{Left,Elem,Right} = Tree,
	case (Left==open) of
		true -> SwitchNode = Elem,
			Result=open;
		false -> {NewLeft,SwitchNode} = get_most_left_neighbour(Left),
			 Result={NewLeft,Elem,Right}
	end,
	NewResult = update(Result),
	{NewResult,SwitchNode}.

get_most_right_neighbour(Tree) ->
	{Left,Elem,Right} = Tree,
	case (Right==open) of
		true -> SwitchNode = Elem,
			Result=open;
		false -> {NewRight,SwitchNode} = get_most_right_neighbour(Right),
			 Result={Left,Elem,NewRight}
	end,
	NewResult = update(Result),
	{NewResult,SwitchNode}.
	
build_easy_tree() ->
	A = init(50),
	B = add(A,25),
	C = add(B,75),
	D = add(C,10),
	E = add(D,40),
	F = add(E,90),
	add(F,60).
			
% Updates stored height and balance in AVL Tree
% First   - AVL Tree
update(open) -> open;
update(Tree) ->
	{Left,{Cur,_,B},Right} = Tree,
	LeftHeight = get_height(Left),
	LeftBalance = get_balance(Left),
	RightHeight = get_height(Right),
	RightBalance = get_balance(Right),
	Height = max(LeftHeight,RightHeight)+1,
	NewTree = {Left,{Cur,Height,B},Right},
	NewBalance = RightHeight-(LeftHeight),
	case NewBalance of
		2 -> case RightBalance of
			1 -> RotatedTree = left_rotation(NewTree),
				util:counting1(left_rotation);
			0 -> RotatedTree = left_rotation(NewTree),
				util:counting1(left_rotation);
			-1 -> RotatedTree = doubleleft_rotation(NewTree),
				util:counting1(doubleleft_rotation)
		     end;
		-2 -> case LeftBalance of
			-1 -> RotatedTree = right_rotation(NewTree),
				util:counting1(right_rotation);
			0 -> RotatedTree = right_rotation(NewTree),
				util:counting1(right_rotation);
			1 -> RotatedTree = doubleright_rotation(NewTree),
				util:counting1(doubleright_rotation)
	  	     end;
	  	_ ->  RotatedTree = NewTree
	end,
	update_balance(RotatedTree).
	
update_balance(Tree) ->
	case Tree of
		open -> Result = open;
		_ -> 	{Left,{Cur,Height,_},Right} = Tree,
			LeftHeight = get_height(Left),
			RightHeight = get_height(Right),
			NewBalance = RightHeight-(LeftHeight),
			Result = {Left,{Cur,Height,NewBalance},Right}
	end,
	Result.
	
left_rotation(Tree) ->
	{L1,MNode,{L2,RNode,R}} = Tree,
	{El,Height,Ba} = MNode,
	NewMNode = {El,Height-2,Ba},
	NewLeft = {L1,NewMNode,L2},
	NewBLeft = update_balance(NewLeft),
	NewR = update_height(R),
	NewL = update_height(NewBLeft),
	NewTree = {NewL,RNode,NewR},
	Result = update_height(NewTree),
	update_balance(Result).

right_rotation(Tree) -> 
	{{L,LNode,R2},MNode,R1} = Tree,
	{El,Height,Ba} = MNode,
	NewMNode = {El,Height-2,Ba},
	NewRight = {R2,NewMNode,R1},
	NewBRight = update_balance(NewRight),
	NewL = update_height(L),
	NewR = update_height(NewBRight),
	NewTree = {NewL,LNode,NewR},
	Result = update_height(NewTree),
	update_balance(Result).	

doubleright_rotation(Tree) ->
	{Left,Node,Right} = Tree,
	NewLeft = left_rotation(Left),
	right_rotation({NewLeft,Node,Right}).

doubleleft_rotation(Tree) -> 
	{Left,Node,Right} = Tree,
	NewRight = right_rotation(Right),
	left_rotation({Left,Node,NewRight}).

% returns height of current tree	
% First   - AVL Tree
get_height(open) -> -1;
get_height({_,{_,H,_},_}) -> H.
	
% returns current balance in root node
% First   - AVL Tree
get_balance(open) -> 0;
get_balance({_,{_,_,B},_}) -> B.

update_height(open) -> open;
update_height(Tree) -> 
	{Left,{Elem,_,B},Right} = Tree,
	LeftHeight = get_height(Left),
	RightHeight = get_height(Right),
	NewHeight = max(LeftHeight,RightHeight)+1,
	{Left,{Elem,NewHeight,B},Right}.

% Stores an avl tree in graphviz dot format
% First   - Path to file
% Second  - AVL Tree to store
write_tree(Path, AVL) -> 
    {ok, File} = file:open(Path, [write]),
    io:fwrite(File, "digraph G {\r\n", []),
    file:open(Path, [write, append]),
    avl_to_arrow(File, AVL),
    io:fwrite(File, "}\r\n", []),
    file:close(File).

avl_to_arrow(File, {open, {E, _, _}, open})     -> io:fwrite(File, "  ~b;\r\n", [E]);
avl_to_arrow(File, {L, {E, _, _}, R})           -> avl_to_arrow(File, E, L), avl_to_arrow(File, E, R).

avl_to_arrow(_File, _P, open)                     -> ok;
avl_to_arrow(File, P, {open, {E, H, _}, open})  -> arrow(File, P, H, E);
avl_to_arrow(File, P, {open, {E, H, _}, R})     -> arrow(File, P, H, E), avl_to_arrow(File, E, R);
avl_to_arrow(File, P, {L, {E, H, _}, open})     -> arrow(File, P, H, E), avl_to_arrow(File, E, L);
avl_to_arrow(File, P, {L, {E, H, _}, R})        -> arrow(File, P, H, E), avl_to_arrow(File, E, L), avl_to_arrow(File, E, R).

arrow(File, P, H, E) -> io:fwrite(File, "  ~b -> ~b [ label=\"~b\"] ;\r\n", [P, E, H]).

