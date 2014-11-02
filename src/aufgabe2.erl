-module(aufgabe2).
-compile(sel_sort).
-compile(ins_sort).
-compile(export_all).
-compile(util).

%Aufgabe 2

% Hauptaufruf, 100 mal einen Suchalgorithmus ausführen und
% Keyindicatoren angeben.

main(Sort,Num) -> Indicators={[],[],[]},
				  main_(Sort,Num,Indicators).
				  
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
		case Sort of
			selection_c -> generate_output_c(Sort,Num,NewIndicators);
			insertion_c -> generate_output_c(Sort,Num,NewIndicators);
			selection -> generate_output(Sort,Num,NewIndicators);
			insertion -> generate_output(Sort,Num,NewIndicators)
		end.
			
		

sort(Sort) ->
					Unsorted = get_content(),
					case Sort of
							selection -> {Time,Sorted} = timer:tc(sel_sort,sel_sort,[Unsorted]),
										 util:file_write('sortiert.dat',Sorted),
										 {[Time],[],[]};
							selection_c -> {Time,Result} = timer:tc(sel_sort,sel_sort_counter,[Unsorted]),
										 {Vergleich,Verschiebung,Sorted} = Result,
										 util:file_write('sortiert.dat',Sorted),
										 {[Time],[Vergleich],[Verschiebung]};
										
							insertion -> {Time,Sorted} = timer:tc(ins_sort,insertionsort,[Unsorted]),
										 util:file_write('sortiert.dat',Sorted),
										 {[Time],[],[]}
					end.
			
			
			
get_content() ->	util:file_read('daten.dat').

random_main(_,_,Indicators,0) -> Indicators;
random_main(Sort,Num,Indicators,Index) ->
					util:zahlenfolge('daten.dat',Num,1,Num*2,rd),
					NewIndicators = get_indicators(Indicators,Sort),
					random_main(Sort,Num,NewIndicators,Index-1).					

best_main(_,_,Indicators,0) -> Indicators;
best_main(Sort,Num,Indicators,Index) ->
					util:zahlenfolge('daten.dat',Num,1,Num*2,bc),
					NewIndicators = get_indicators(Indicators,Sort),
					best_main(Sort,Num,NewIndicators,Index-1).
					
worst_main(_,_,Indicators,0) -> Indicators;
worst_main(Sort,Num,Indicators,Index) ->
					util:zahlenfolge('daten.dat',Num,1,Num*2,wc),
					NewIndicators = get_indicators(Indicators,Sort),
					worst_main(Sort,Num,NewIndicators,Index-1).
					
get_indicators(Indicators,Sort) -> 			
					{Time_o,Comp_o,Swaps_o} = Indicators,
					{Time,Comp,Swaps} = sort(Sort),
					NewIndicators = {Time ++ Time_o,Comp ++ Comp_o,Swaps ++ Swaps_o},
					NewIndicators.
			
generate_output(Sort,Num,Indicators) ->
		  {Time,_Vergleich,_Verschiebung} = Indicators,
		  T_total = lists:sum(Time),
		  T_max = lists:max(Time),
		  T_min = lists:min(Time),
		  {ok,File} = file:open('message.log',[write]),
		  Format = "Algorithmus: ~s \r\n"
				   "Number of Elements: ~b Elements\r\n"
				   "Total Time: ~b mics\r\n"
				   "Maximal Time: ~b mics\r\n"
				   "Minimal Time: ~b mics\r\n",
		  Arguments = [Sort,Num,T_total,T_max,T_min],
		  io:fwrite(File,Format,Arguments),
			file:close(File),
			io:fwrite(Format,Arguments).			

generate_output_c(Sort,Num,Indicators) ->
		  {Time,Vergleich,Verschiebung} = Indicators,
		  T_total = lists:sum(Time),
		  T_max = lists:max(Time),
		  T_min = lists:min(Time),
		  Vg_total = lists:sum(Vergleich),
		  Vg_max = lists:max(Vergleich),
		  Vg_min = lists:min(Vergleich),
		  Vs_total = lists:sum(Verschiebung),
		  Vs_max = lists:max(Verschiebung),
		  Vs_min = lists:min(Verschiebung),
		  {ok,File} = file:open('message.log',[write]),
		  Format = "Algorithmus: ~s \r\n"
				   "Number of Elements: ~b Elements\r\n"
				   "Total Time: ~b mics\r\n"
				   "Maximal Time: ~b mics\r\n"
				   "Minimal Time: ~b mics\r\n"
				   "Total Comparisions: ~b \r\n"
				   "Maximal Comparisions: ~b \r\n"
				   "Minimal Comparisions: ~b \r\n"
				   "Total Switches: ~b \r\n"
				   "Maximal Switches: ~b \r\n"
				   "Minimal Switches: ~b \r\n",
		  Arguments = [Sort,Num,T_total,T_max,T_min,Vg_total,Vg_max,Vg_min,Vs_total,Vs_max,Vs_min],
		  io:fwrite(File,Format,Arguments),
			file:close(File),
			io:fwrite(Format,Arguments).					
			
			
			
			
			