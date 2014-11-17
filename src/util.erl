-module(util).
-compile(export_all).
-compile(array).
-define(ZERO, integer_to_list(0)).

%zahlenfolge(Dateiname,Anzahl,Min,Max,Case)	 
zahlenfolge(Name,Num,Min,Max,Case) ->
	List = build_list(Num,Min,Max,Case),
	Array = list_to_array(List),
	case file_write(Name,Array) of
   		 ok -> ok;
		 {error, Reason} -> {error,Reason} 
	end.
	
build_list(Num,Min,Max,Case) ->
	case Case of
		rd -> randomliste(Num,Min,Max);
		bc -> sortliste(Num);
		wc -> resortliste(Num)
	end.

randomliste(Num,Min,Max) ->
	RangeInt = Max-Min,
	lists:flatten([random:uniform(RangeInt+1) + Min-1 || _ <- lists:seq(1, Num)]).
	
sortliste(Num) ->
	lists:seq(1, Num).
resortliste(Num) ->
	lists:reverse(lists:seq(1, Num)).

%% ------------------------------------------
%File utilities
%file_write(FileName,Content)
file_write(FileName,Content) ->
	file:write_file(FileName,io_lib:fwrite("~p.\n",[Content])).
	
%file_read(FileName)
file_read(FileName) ->
	{ok,T} = file:consult(FileName),
	[Content|_] = T,
	Content.
%% ----------------------------------------------
%List Operations
%Definiert die Rückgabe 0 für leere Liste bei der Bestimmung eines Minimums und Maximums
min([]) -> 0;
min(List) -> lists:min(List).

max([]) -> 0;
max(List) -> lists:max(List).

% Swap/3 tauscht zwei Elemente eines Arrays.
% Array x Int x Int -> Array
% Die Ints sind dabei der Indizes der zu tauschenden Elemente.

swap(Array,Pos1,Pos2) -> Tmp = array:getA(Array,Pos1),
					     Array1 = array:setA(Array,Pos1,array:getA(Array,Pos2)),
						 _Result = array:setA(Array1,Pos2,Tmp).
%% -------------------------------------------
%list_to_array(List) -> Array
%Converts a List to our own ADT Array
list_to_array(List) -> 
	Array = array:initA(),
	Index = 0,
	list_to_array_(List,Index,Array).
	
list_to_array_([],_,Array) -> Array;
list_to_array_([H|T],Index,Array) ->
	NewArray = array:setA(Array,Index,H),
	list_to_array_(T,Index+1,NewArray).
	
%% -------------------------------------------
% Ein globaler ZÃ¤hler
%
counting1(Counter) -> Known = erlang:whereis(Counter),
						 case Known of
							undefined -> PIDcountklc = spawn(fun() -> countloop(0) end),
										 erlang:register(Counter,PIDcountklc);
							_NotUndef -> ok
						 end,
						 Counter ! {count,1},
						 ok.

counting(Counter,Step) -> Known = erlang:whereis(Counter),
						 case Known of
							undefined -> PIDcountklc = spawn(fun() -> countloop(0) end),
										 erlang:register(Counter,PIDcountklc);
							_NotUndef -> ok
						 end,
						 Counter ! {count,Step},
						 ok.

countread(Counter) -> Known = erlang:whereis(Counter),
						case Known of
							undefined -> 0;
							_NotUndef -> 
								Counter ! {get,self()},
								receive
									{current,Num} -> Num;
									_SomethingElse -> 0
								end
						end.

countreset(Counter) -> 	Known = erlang:whereis(Counter),
				case Known of
					undefined -> false;
					_NotUndef -> Counter ! reset, true
				end.

countstop(Counter) -> 	Known = erlang:whereis(Counter),
				case Known of
					undefined -> false;
					_NotUndef -> Counter ! kill, true
				end.
					
countloop(Count) -> receive
						{count,Num} -> countloop(Count+Num);
						{get,PID} -> PID ! {current,Count},
									countloop(Count);
						reset -> countloop(0);
						kill -> true
					end.
