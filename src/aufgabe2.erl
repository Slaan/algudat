-module(aufgabe2).
-compile(sel_sort).
-compile(ins_sort).
-compile(export_all).
-compile(util).

%Aufgabe 2

% Hauptaufruf. Sort gibt die Art des zu verwendeten Algorithmus,
% Num die Anzahl der Elemente die sortiert werden sollen an.
% Derzeit unterstützte Algorithmen:
% - selection -> Selection Sort
% - insertion -> Insertion Sort
% Schreibt man ein "_c" (z.b. selection_c) hinter den Algorithmus werden bei der 
% Ausgabe auch die Anzahl der Verschiebungen und gemachten Vergleiche ausgegeben.

main(Sort,Num) -> Indicators={[],[],[]},
				  main_(Sort,Num,Indicators).
				  
% Hilfsfunktion des Hauptaufrufes. Erstellung der Zahlenlisten,
% Sortierung dieser und anschließende Ausgabe der Indikatoren.

main_(Sort,Num,Indicators) ->
		%Filename = 'daten.dat',
		%case (util:countread(rd)<80) of
		%	true -> util:zahlenfolge(Filename,Num,1,Num*2,rd),
		%			util:counting(rd,1),
		%			{Time_o,Comp_o,Swaps_o} = Indicators,
		%			{Time,Comp,Swaps} = sort(Sort),
		%			NewIndicators = {Time ++ Time_o,Comp ++ Comp_o,Swaps ++ Swaps_o},
		%			main_(Sort,Num,NewIndicators);					
		%	false -> util:countstop(rd),
		%			 false
		%end,
		Indicators_Random = random_main(Sort,Num,Indicators,80),
		Indicators_Best = best_main(Sort,Num,Indicators,10),
		Indicators_Worst = worst_main(Sort,Num,Indicators,10),
		{Time_r,Vergleiche_r,Verschieben_r} = Indicators_Random,
		{Time_b,Vergleiche_b,Verschieben_b} = Indicators_Best,
		{Time_w,Vergleiche_w,Verschieben_w} = Indicators_Worst,
		NewIndicators = {Time_r ++ Time_b ++ Time_w, Vergleiche_r ++ Vergleiche_b ++ Vergleiche_w, Verschieben_r ++ Verschieben_w ++ Verschieben_b},
		generate_output(Sort,Num,NewIndicators).
			
		
%Lädt eine Liste aus der Datei 'daten.dat', und sortiert diese je nach algorithmus und
%je nachdem ob Zähler gewünscht sind oder nicht.
sort(Sort) ->
			Unsorted = get_content(),
			case Sort of
					selection -> {Time,Sorted} = timer:tc(sel_sort_2,sel_sort,[Unsorted]),
								 util:file_write('sortiert.dat',Sorted),
								 {[Time],[],[]};
					selection_c -> {Time,Result} = timer:tc(sel_sort_2,sel_sort_counter,[Unsorted]),
								 {Vergleich,Verschiebung,Sorted} = Result,
								 util:file_write('sortiert.dat',Sorted),
								 {[Time],[Vergleich],[Verschiebung]};
								
					insertion -> {Time,Sorted} = timer:tc(ins_sort,insertionsort,[Unsorted]),
								 util:file_write('sortiert.dat',Sorted),
								 {[Time],[],[]};
					insertion_c -> {Time,Result} = timer:tc(ins_sort,ins_sort_counter,[Unsorted]),
								 {Vergleich,Verschiebung,Sorted} = Result,
								 util:file_write('sortiert.dat',Sorted),
								 {[Time],[Vergleich],[Verschiebung]}
			end.
			
			
%Lädt aus der Datei 'daten.dat'.			
get_content() ->	util:file_read('daten.dat').

%Führt den Algorithmus eine bestimmte Anzahl (Counter) auf Zufallszahlen aus.
random_main(_,_,Indicators,0) -> Indicators;
random_main(Sort,Num,Indicators,Counter) ->
					util:zahlenfolge('daten.dat',Num,1,Num*2,rd),
					NewIndicators = get_indicators(Indicators,Sort),
					random_main(Sort,Num,NewIndicators,Counter-1).					

%Führt den Algorithmus auf einer bereits sortierten Liste aus, best case szenario.
best_main(_,_,Indicators,0) -> Indicators;
best_main(Sort,Num,Indicators,Counter) ->
					util:zahlenfolge('daten.dat',Num,1,Num*2,bc),
					NewIndicators = get_indicators(Indicators,Sort),
					best_main(Sort,Num,NewIndicators,Counter-1).

%Führt den Algorithmus auf einer "falschrum" sortierten Liste aus, worst case szenario.
worst_main(_,_,Indicators,0) -> Indicators;
worst_main(Sort,Num,Indicators,Counter) ->
					util:zahlenfolge('daten.dat',Num,1,Num*2,wc),
					NewIndicators = get_indicators(Indicators,Sort),
					worst_main(Sort,Num,NewIndicators,Counter-1).
					
%Gibt die nach der Ausführung des Algorithmus zurück..
get_indicators(Indicators,Sort) -> 			
					{Time_o,Comp_o,Swaps_o} = Indicators,
					{Time,Comp,Swaps} = sort(Sort),
					NewIndicators = {Time ++ Time_o,Comp ++ Comp_o,Swaps ++ Swaps_o},
					NewIndicators.
			
%Schreibt die Ausgabe auf die Konsole und in die Datei 'Message.log'.
generate_output(Sort,Num,Indicators) ->
		  {Time,Vergleich,Verschiebung} = Indicators,
		  T_total = lists:sum(Time),
		  T_max = lists:max(Time),
		  T_min = lists:min(Time),
		  Vg_total = lists:sum(Vergleich),
		  Vg_max = util:max(Vergleich),
		  Vg_min = util:min(Vergleich),
		  Vs_total = lists:sum(Verschiebung),
		  Vs_max = util:max(Verschiebung),
		  Vs_min = util:min(Verschiebung),
		  {ok,File} = file:open('message.log',[write]),
		  Format = "Algorithmus: ~s \r\n"
				   "Number of Elements: ~b Elements\r\n"
				   "Total Time: ~b mics\r\n"
				   "Maximal Time: ~b mics\r\n"
				   "Minimal Time: ~b mics\r\n"
				   "Total Comparisions: ~b \r\n"
				   "Maximal Comparisions: ~w \r\n"
				   "Minimal Comparisions: ~w \r\n"
				   "Total Switches: ~b \r\n"
				   "Maximal Switches: ~w \r\n"
				   "Minimal Switches: ~w \r\n",
		  Arguments = [Sort,Num,T_total,T_max,T_min,Vg_total,Vg_max,Vg_min,Vs_total,Vs_max,Vs_min],
		  io:fwrite(File,Format,Arguments),
			file:close(File),
			io:fwrite(Format,Arguments).					
			