-module(avl).
-compile(export_all).

init(A) -> {open,A,open}.
	
add(Tree,A) -> 
	{Left,Cur,Right} = Tree,
	case (A<Cur) of
		true -> case (Left==open) of
					true -> NewLeft={open,A,open};
					false -> NewLeft=add(Left,A)
				end,
				Result = {NewLeft,Cur,Right};
		false -> case (Right==open) of
					true -> NewRight={open,A,open};
					false -> NewRight=add(Right,A)
				end,
				Result = {Left,Cur,NewRight}
		end,
	Result.
		