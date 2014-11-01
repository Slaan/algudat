-module(aufgabe2).
-compile(sel_sort).
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
		NewIndicators.
		%generate_output(Sort,Num,Indicators).
		

sort(Sort) ->
					Unsorted = get_content(),
					case Sort of
							selection -> {Time,Sorted} = timer:tc(sel_sort,sel_sort,[Unsorted]),
										 util:file_write('sortiert.dat',Sorted),
										 Vergleiche = util:countread(vergleich),
										 Verschiebung = util:countread(verschiebung),
										 {[Time],[Vergleiche],[Verschiebung]};
										
							insertion -> {Time,Sorted} = timer:tc(ins_sort,insertionsort,[Unsorted]),
										 util:file_write('sortiert.dat',Sorted),
										 Vergleiche = util:countread(vergleich),
										 Verschiebung = util:countread(verschiebung),
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
			
			
			
			
			
			
			
			
			
			
			