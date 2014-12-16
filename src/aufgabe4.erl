-module(aufgabe4).
-compile(avl).
-compile(array).
-compile(util).
-compile(export_all).

%Aufgabe4

main(Create,Delete) ->
	reset_counters(),
	generate(Create),
	{Array,Tree} = build_tree(),
	%output Tree for GraphViz
	%util:file_write('build.dat',Tree),
	avl:write_tree('build.dat',Tree),
	NewTree = delete_from(Tree,Delete,Array),
	%output NewTree for GraphViz
	%util:file_write('delete.dat',NewTree),
	avl:write_tree('delete.dat',NewTree),
	return_counters(),
	stop_counters().

generate(Num) -> 
	util:zahlenfolge('zahlen.dat',Num,1,Num*2,rd).
		
build_tree() ->
	Zahlen = util:file_read('zahlen.dat'),
	Length = array:lengthA(Zahlen),
	Result = array_to_tree(Zahlen,Length),
	{Zahlen,Result}.
	
delete_from(Tree,Num,Array) -> 
	DA = util:build_list(Num,0,255,rd),			%Array enhält zufällige Positionen des Elementenarrays. Die Elemente dieser Positionen werden gelöscht.
	DeleteArray = util:list_to_array(DA),
	delete_from_(Tree,Array,DeleteArray,25,0).

delete_from_(Tree,_Array,_,Length,Length) -> Tree;
delete_from_(Tree,Array,DeleteArray,Length,Index) ->
	Elem = array:getA(Array,array:getA(DeleteArray,Index)),  % zu löschendes Element
	NewTree = avl:delete(Tree,Elem),
	delete_from_(NewTree,Array,DeleteArray,Length,Index+1).
	
array_to_tree(Zahlen,Length) ->
	Elem = array:getA(Zahlen,0),
	Tree = avl:init(Elem),
	array_to_tree_(Zahlen,Length,1,Tree).

array_to_tree_(_,Length,Length,Tree) -> Tree;
array_to_tree_(Zahlen,Length,Index,Tree) ->
	Elem = array:getA(Zahlen,Index),
	NewTree = avl:add(Tree,Elem),
	array_to_tree_(Zahlen,Length,Index+1,NewTree).
	
return_counters() ->
	Left = util:countread(left_rotation),
	Left2 = util:countread(doubleleft_rotation),
	Right = util:countread(right_rotation),
	Right2 = util:countread(doubleright_rotation),
	Format = "Left Rotations: ~b \r\n"
			 "DoubleLeft Rotations: ~b\r\n"
			 "Right Rotations: ~b \r\n"
			 "DoubleRight Rotations: ~b \r\n",				   
	Arguments = [Left,Left2,Right,Right2],
	io:fwrite(Format,Arguments).
	
reset_counters() ->
	util:countreset(left_rotation),
	util:countreset(doubleleft_rotation),
	util:countreset(right_rotation),
	util:countreset(doubleright_rotation).
	
stop_counters() ->
	util:countstop(left_rotation),
	util:countstop(doubleleft_rotation),
	util:countstop(right_rotation),
	util:countstop(doubleright_rotation).