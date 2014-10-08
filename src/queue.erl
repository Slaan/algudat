% Author: Daniel Hofmeister
-module(queue).
-export([createQ/0, front/1, enqueue/2, dequeue/1, isEmptyQ/1]).

%createQ: es werden intern zwei neue ADT Stacks ohne Elemente angelegt. Einer
%ist der Eingabestack, der andere der Ausgabestack
%createQ -> Queue
createQ() -> [stack:createS(),stack:createS()].

%front: das zuerst hinzugefügte Element wird ausgegeben. Ist der Ausgabestack
%leer, werden zuerst alle aus dem Eingabestack in den Ausgabestack umgestapelt.
%front(Queue) -> Elem
front([{},{}]) -> false;
front([Input,Output]) -> 
        case stack:isEmptyS(Output) of
							true -> Restacked = restack(Input,Output),stack:top(Restacked);
							false -> stack:top(Output)
			  end.

%restack -> StackxStack -> Stack						 
restack({},Output) -> Output;
restack(Input,Output) -> Elem = stack:top(Input), Inputnew = stack:pop(Input), Outputnew = stack:push(Output,Elem), restack(Inputnew,Outputnew).
						  

%enqueue: delegiert mit push wird das angegebene Element auf dem
%Eingabestack abgelegt
%enqueue(Queue,Elem) -> Queue
enqueue([Input,_Out],Elem) -> NewInput = stack:push(Input,Elem),[NewInput,_Out].

%dequeue: das zuerst hinzugefügte Element (das erste Element des
%Ausgabestacks) wird entfernt. Ist der Ausgabestack leer, werden zuerst alle aus
%dem Eingabestack in den Ausgabestack umgestapelt.
%dequeue(Queue) -> Queue
dequeue([Input,Output]) -> 
           case stack:isEmptyS(Output) of
							true -> Restacked = restack(Input,Output), OutputNew1 = stack:pop(Restacked), [{},OutputNew1];
							false -> OutputNew2 = stack:pop(Output),[Input,OutputNew2
           end.

%isEmptyQ: delegiert mit isEmptyS geprüft, ob sich Elemente im Eingabestack
%befinden
%isEmptyQ: 
isEmptyQ([Instack,Outstack]) -> stack::isEmptyS(Instack) and stack::isEmptyS(Outstack).
