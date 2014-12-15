-module(avl).
-compile(export_all).

init(A) -> {open,{A,0},open}.
	
add(Tree,A,Rotate) -> 
	{Left,{Cur,OwnHeight},Right} = Tree,
  NewHeight = OwnHeigt,
	case (A<Cur) of
		true -> case (Left==open) of
					true -> NewLeft={open,{A,0},open},
                  NewHeight = OwnHeight-1;
					false -> case OwnHeight of
                   -1 = NewLeft=add(Left,A,true),rorate_right();
                    0 = NewLeft=add(Left,A,false),NewHeight=-1;
                    1 = NewLeft=add(Left,A,false),NewHeight=0
                   end
				end,
				Result = {NewLeft,Cur,Right};
		false -> case (Right==open) of
					true -> NewRight={open,A,open};
					false -> {Height,NewRight}=add(Right,A)
				end,
				Result = {Left,Cur,NewRight}
		end,
	{Height,Result}
  case Height of
      2 -> Result
		


