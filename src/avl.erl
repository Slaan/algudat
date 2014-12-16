-module(avl).
-compile(export_all).
-compile(util).

% creates a new avl tree
init(A) -> {open,{A,0,0},open}.

% add an element to 
add(Tree,A) ->
	{_Left,{Elem,_,_},_Right} = Tree,
	case (A==Elem) of
		true -> Result = Tree;
		false -> Result = add_(Tree,A)
	end,
	Result.
	
add_(OldTree,A) -> 
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
	
delete(Tree,Elem) ->
	{Left,{Cur,Height,Balance},Right} = Tree,
	case (Elem==Cur) of
		true -> Result = delete_(Tree,Elem);
		false -> case (Elem<Cur) of
				true -> NewTree = delete(Left,Elem),
					Result={NewTree,{Cur,Height,Balance},Right};
				false -> NewTree = delete(Right,Elem),
					Result={Left,{Cur,Height,Balance},NewTree}
			 end
	end,
	update(Result).
	
delete_(Tree,Elem) ->
	{Left,{Cur,_,_},Right} = Tree,
	case (Left==Right) of
		true -> Result = open;
		false -> {_,{_,LeftHeight,_},_} = Left,
		 	 {_,{_,RightHeight,_},_} = Right,
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
			
update(open) -> open;
update(Tree) ->
	{Left,{Cur,_,_},Right} = Tree,
	case Left of
		open -> LeftHeight = -1,
			LeftBalance = 0;
		_ -> {_,{_,LeftHeight,LeftBalance},_} = Left
	end,
	case Right of
		open -> RightHeight = -1,
			RightBalance = 0;
		_ -> {_,{_,RightHeight,RightBalance},_} = Right
	end,
	NewBalance = RightHeight-(LeftHeight),
	case NewBalance of
		2 -> case RightBalance of
			1 -> RotatedTree = left_rotation(Tree);
			-1 -> RotatedTree = doubleleft_rotation(Tree)
		     end;
		-2 -> case LeftBalance of
			-1 -> RotatedTree = right_rotation(Tree);
			1 -> RotatedTree = doubleright_rotation(Tree)
	  	     end;
	  	_ -> 	NewHeight = max(LeftHeight,RightHeight)+1,
	  		RotatedTree = {Left,{Cur,NewHeight,NewBalance},Right}
	end,
	update_balance(RotatedTree).
	
update_balance(Tree) ->
	case Tree of
		open -> Result = open;
		_ -> 	{Left,{Cur,Height,_},Right} = Tree,
			case Left of
				open -> LeftHeight = -1;
				_ ->{_,{_,LeftHeight,_},_} = Left
			end,
			case Right of
				open -> RightHeight = -1;
				_ -> {_,{_,RightHeight,_},_} = Right
			end,
			NewBalance = RightHeight-(LeftHeight),
			Result = {Left,{Cur,Height,NewBalance},Right}
	end,
	Result.
	
left_rotation(Tree) ->
	{L1,MNode,{L2,RNode,R}} = Tree,
	{El,Height,Ba} = MNode,
	NewMNode = {El,Height-1,Ba},
	NewLeft = {L1,NewMNode,L2},
	NewBLeft = update_balance(NewLeft),
	NewTree = {NewBLeft,RNode,R},
	update_balance(NewTree).
	

right_rotation(Tree) -> 
	{{L,LNode,R2},MNode,R1} = Tree,
	{El,Height,Ba} = MNode,
	NewMNode = {El,Height-1,Ba},
	NewRight = {R2,NewMNode,R1},
	NewBRight = update_balance(NewRight),
	NewTree = {L,LNode,NewBRight},
	update_balance(NewTree).	

doubleright_rotation(Tree) ->
	{Left,Node,Right} = Tree,
	NewLeft = left_rotation(Left),
	right_rotation({NewLeft,Node,Right}).

doubleleft_rotation(Tree) -> 
	{Left,Node,Right} = Tree,
	NewRight = right_rotation(Right),
	left_rotation({Left,Node,NewRight}).

write_tree(Path, AVL) -> 
    {ok, File} = file:open(Path, [write]),
    io:fwrite(File, "digraph G {\r\n", []),
    file:open(Path, [write, append]),
    avl_to_arrow(File, AVL),
    io:fwrite(File, "}\r\n", []),
    file:close(File).

avl_to_arrow(File, {open, {E, _, _}, open})     -> io:fwrite(File, "  ~b;\r\n", [E]);
avl_to_arrow(File, {L, {E, _, _}, R})           -> avl_to_arrow(File, E, L), avl_to_arrow(File, E, R).

avl_to_arrow(File, P, open)                     -> ok;
avl_to_arrow(File, P, {open, {E, _, _}, open})  -> arrow(File, P, E);
avl_to_arrow(File, P, {open, {E, _, _}, R})     -> arrow(File, P, E), avl_to_arrow(File, E, R);
avl_to_arrow(File, P, {L, {E, _, _}, open})     -> arrow(File, P, E), avl_to_arrow(File, E, L);
avl_to_arrow(File, P, {L, {E, _, _}, R})        -> arrow(File, P, E), avl_to_arrow(File, E, L), avl_to_arrow(File, E, R).

arrow(File, P, E) -> io:fwrite(File, "  ~b -> ~b;\r\n", [P, E]).

