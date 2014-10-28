-module(util).
-compile(export_all).
-define(ZERO, integer_to_list(0)).

%zahlenfolge(Dateiname,Anzahl,Min,Max)	 
zahlenfolge(Name,Num,Min,Max) ->
	case file:write_file(Name, randomliste(Num, Min, Max)) of
		ok -> ok;
		{error, Reason} -> {error,Reason} 
	end.

randomliste(Num,Min,Max) ->
	RangeInt = Max-Min,
	lists:flatten([random:uniform(RangeInt+1) + Min-1 || _ <- lists:seq(1, Num)]).

sortliste(Num) ->
	lists:seq(1, Num).
resortliste(Num) ->
	lists:reverse(lists:seq(1, Num)).
	
%% -------------------------------------------
% Ermittelt den Typ
% Beispielaufruf: type_is(Something),
%
type_is(Something) ->
    if is_atom(Something) -> atom;
	   is_binary(Something) -> binary;
	   is_bitstring(Something) -> bitstring;
	   is_boolean(Something) -> boolean;
	   is_float(Something) -> float;
	   is_function(Something) -> function;
	   is_integer(Something) -> integer;
	   is_list(Something) -> list;
	   is_number(Something) -> number;
	   is_pid(Something) -> pid;
	   is_port(Something) -> port;
	   is_reference(Something) -> reference;
	   is_tuple(Something) -> tuple
	end.
	
% Wandelt in eine Zeichenkette um
% Beispielaufruf: to_String(Something),
%
to_String(Etwas) ->
	lists:flatten(io_lib:format("~p", [Etwas])).	

% Wandelt Liste in eine Zeichenketten Liste um
% Beispielaufruf: list2String(Liste),
%
list2String([]) ->
	lists:concat(["[ ]"]);	
list2String([Head]) ->
	lists:concat(["[",werkzeug:to_String(Head),"]"]);	
list2String([Head|Tail]) ->
	lists:concat(["[",werkzeug:to_String(Head),",",list2Stringrek(Tail)]).	
list2Stringrek([Head]) ->
	lists:concat([werkzeug:to_String(Head),"]"]);	
list2Stringrek([Head|Tail]) ->
	lists:concat([werkzeug:to_String(Head),",",list2Stringrek(Tail)]);	
list2Stringrek([]) -> "]".
	
	
%% -------------------------------------------
%% Mischt eine Liste
% Beispielaufruf: NeueListe = shuffle([a,b,c]),
%
shuffle(List) -> shuffle(List, []).
shuffle([], Acc) -> Acc;
shuffle(List, Acc) ->
    {Leading, [H | T]} = lists:split(random:uniform(length(List)) - 1, List),
    shuffle(Leading ++ T, [H | Acc]).

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
						reset -> countloop(Count);
						kill -> true
					end.

%% -------------------------------------------
% Schreibt auf den Bildschirm und in eine Datei
% nebenlÃ¤ufig zur Beschleunigung
% Beispielaufruf: logging('FileName.log',"Textinhalt"),
%
% logging(_Datei,_Inhalt) -> ok;
logging(Datei,Inhalt) -> Known = erlang:whereis(logklc),
						 case Known of
							undefined -> PIDlogklc = spawn(fun() -> logloop(0) end),
										 erlang:register(logklc,PIDlogklc);
							_NotUndef -> ok
						 end,
						 logklc ! {Datei,Inhalt},
						 ok.

logstop( ) -> 	Known = erlang:whereis(logklc),
				case Known of
					undefined -> false;
					_NotUndef -> logklc ! kill, true
				end.
					
logloop(Y) -> 	receive
					{Datei,Inhalt} -> io:format(Inhalt),
									  file:write_file(Datei,Inhalt,[append]),
									  logloop(Y+1);
					kill -> true
				end.

%% Zeitstempel: 'MM.DD HH:MM:SS,SSS'
% Beispielaufruf: Text = lists:concat([Clientname," Startzeit: ",timeMilliSecond()]),
%
timeMilliSecond() ->
	{_Year, Month, Day} = date(),
	{Hour, Minute, Second} = time(),
	Tag = lists:concat([klebe(Day,""),".",klebe(Month,"")," ",klebe(Hour,""),":"]),
	{_, _, MicroSecs} = now(),
	Tag ++ concat([Minute,Second],":") ++ "," ++ toMilliSeconds(MicroSecs)++"|".
toMilliSeconds(MicroSecs) ->
	Seconds = MicroSecs / 1000000,
	%% Korrektur, da string:substr( float_to_list(0.234567), 3, 3). 345 ergibt
	if (Seconds < 1) -> CorSeconds = Seconds + 1;
	   (Seconds >= 1) -> CorSeconds = Seconds
	end,
	string:substr( float_to_list(CorSeconds), 3, 3).
concat(List, Between) -> concat(List, Between, "").
concat([], _, Text) -> Text;
concat([First|[]], _, Text) ->
	concat([],"",klebe(First,Text));
concat([First|List], Between, Text) ->
	concat(List, Between, string:concat(klebe(First,Text), Between)).
klebe(First,Text) -> 	
	NumberList = integer_to_list(First),
	string:concat(Text,minTwo(NumberList)).	
minTwo(List) ->
	case {length(List)} of
		{0} -> ?ZERO ++ ?ZERO;
		{1} -> ?ZERO ++ List;
		_ -> List
	end.				

