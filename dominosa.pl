% Permet d'obtenir le nombre de lignes de la matrice
% rows(M,R)
rows([],0).
rows([_|B],S):-
    rows(B,S1),
    S is S1+1.

% Permet d'obtenir le nombre de colonnes de la matrice
% columns(M,C)
columns([A|_],S):-
    rows(A,S).

% Construit une liste d'entier jusqu'à un certain nombre
% create_list(N,L)
create_list(0,[]).
create_list(N,[N1|B]):-
    N > 0,
    N1 is N-1,
    create_list(N1,B).

% Renvoit la liste des éléments distinct de la matrice
% check_element(M,L)
check_element(M,L):-
    rows(M,R),
    columns(M,C),
    min_member(N,[R,C]),
    create_list(N,L).

% Renvoit la liste des dominos de la matrice
% dominos(Spe,Spe,L) on utilise check_element pour le Spe
dominos([],[],[]).
dominos([_|Y],[],D):-
    dominos(Y,Y,D).
dominos([X|Y],[A|B],[[X,A]|D]):-
    dominos([X|Y],B,D).


% Enleve le domino posé, de la liste
% sup_domino(L,NL,D)
sup_domino([],[],_).
sup_domino([[A,A]|R],R,[A,A]):-!.
sup_domino([[A,B]|R],R,[A,B]):-!.
sup_domino([[B,A]|R],R,[A,B]):-!.
sup_domino([L|R],[L|NR],D):-
    sup_domino(R,NR,D).


% Domino de ici a droite
% right(X,Droite,L)
right(_,[],[]).
right(A,[B|_],[A,B]).

% Domino de ici a en bas
% right(X,Droite,Bas,L)
down(_,_,[],[]).
down(A,B,[X|_],[A,C]):-
    length(B,Len1),
    length(X,Len2),
    N is Len2-Len1-1,
    nth0(N,X,C).

% Renvoit la liste des possibilité des dominos
% possibilities(M,L)
possibilities([],[]).
possibilities([[]|Y],L):-
    possibilities(Y,L).
possibilities([[A|B]|Y],[L1,L2|L]):-
    right(A,B,L1),
    down(A,B,Y,L2),
    possibilities([B|Y],L).

clear([],[]).
clear([A|B],[A|Y]):-
    A \= [],
    clear(B,Y).
clear([[]|B],X):-
    clear(B,X).

poss(M,L):-
    possibilities(M,L1),
    clear(L1,L).

% Renvoit la liste des possibilité des id
% id(A,B,R,C,N,L) A,B,N = 0 (normalement)
list2(A,B,[A,B]). % mini-prédicat
id(A,B,R,C,_,[]):-
    A1 is A+1,
    B1 is B+1,
    A1 == R,
    B1 == C,!.
id(A,C,R,C,N,L):-
    A1 is A+1,
    id(A1,0,R,C,N,L).
id(A,B,R,C,N,[L1|L]):-
    B1 is B+1,
    B1 == C,
    N1 is N+1,
    N2 is N+C,
    list2(N,N2,L1),
    id(A,B1,R,C,N1,L).
id(A,B,R,C,N,[L1|L]):-
    A1 is A+1,
    B1 is B+1,
    A1 == R,
    N1 is N+1,
    list2(N,N1,L1),
    id(A,B1,R,C,N1,L).
id(A,B,R,C,N,[L1,L2|L]):-
    B1 is B+1,
    A < R-1,
    B < C-1,
    N1 is N+1,
    N2 is N+C,
    list2(N,N1,L1),
    list2(N,N2,L2),
    id(A,B1,R,C,N1,L).


% Renvoit le premier domino distinct qu'il trouve
% distinct(D,M,L)
distinct([A|_],M,A):-
    nmb(A,M,N),
    N == 1,!.
distinct([A|B],M,L):-
    nmb(A,M,N),
    N \= 1,
    distinct(B,M,L).

% Renvoit le nombre d'un certain domino dans une matrice
% nmb(D,M,N)
nmb(_,[],0).
nmb([A,A],[[A,A]|Y],N):-
    nmb([A,A],Y,N1),
    N is N1+1,!.
nmb([A,B],[[B,A]|Y],N):-
    nmb([A,B],Y,N1),
    N is N1+1,!.
nmb([A,B],[[A,B]|Y],N):-
    nmb([A,B],Y,N1),
    N is N1+1,!.
nmb(A,[_|Y],N):-
    nmb(A,Y,N).

% Avoir l'ID correspondant au domino distinct
% domino_id(D,LD,I,LI)
domino_id([A,B],LD,I,LI):-
    nth0(N,LD,[A,B]),
    nth0(N,LI,I),!.
domino_id([A,B],LD,I,LI):-
    nth0(N,LD,[B,A]),
    nth0(N,LI,I),!.

% Change la matrice avec l'id de domino donné
% change_m(M,M1,I)
change_m(M,M1,[A,B]):-
    A1 is A+1,
    A1 == B,
    add_m(M,M1,[A,B],['E','W'],0).
change_m(M,M1,[A,B]):-
    A1 is A+1,
    A1 \= B,
    add_m(M,M1,[A,B],['S','N'],0).

% cas de fin
add_m([],[],[_,_],[_,_],_).
% cas X normal
add_m([[_|M1]|R],[[X|L]|LR],[N,B],[X,Y],N):-
    N1 is N+1,
    add_m([M1|R],[L|LR],[N,B],[X,Y],N1),!.
% cas X fin de liste
add_m([[_|[]]|R],[[X|[]]|LR],[N,B],[X,Y],N):-
    N1 is N+1,
    add_m(R,LR,[N,B],[X,Y],N1),!.
% cas Y normal
add_m([[_|M1]|R],[[Y|L]|LR],[A,N],[X,Y],N):-
    N1 is N+1,
    add_m([M1|R],[L|LR],[A,N],[X,Y],N1),!.
% cas Y fin de liste
add_m([[_|[]]|R],[[Y|[]]|LR],[A,N],[X,Y],N):-
    N1 is N+1,
    add_m(R,LR,[A,N],[X,Y],N1),!.
% cas normal normal
add_m([[M|M1]|R],[[M|L]|LR],[A,B],[X,Y],N):-
    N1 is N+1,
    add_m([M1|R],[L|LR],[A,B],[X,Y],N1).
% cas normal fin de liste
add_m([[M|[]]|R],[[M|[]]|LR],[A,B],[X,Y],N):-
    N1 is N+1,
    add_m(R,LR,[A,B],[X,Y],N1).

% Retourne le premier domino avec un id seul
% distinct_id(I,M,L) I -> create_list(R*C,I).
distinct_id([A|_],M,L):-
    nmb_id(A,M,N),
    N == 1,
    find_id(A,M,L),!.
distinct_id([A|B],M,L):-
    nmb_id(A,M,N),
    N \= 1,
    distinct_id(B,M,L).

% Renvoit le nombre d'un certain id dans une matrice
% nmb_id(I,M,N)
nmb_id(_,[],0).
nmb_id(A,[[A,_]|Y],N):-
    nmb_id(A,Y,N1),
    N is N1+1,!.
nmb_id(A,[[_,A]|Y],N):-
    nmb_id(A,Y,N1),
    N is N1+1,!.
nmb_id(A,[_|Y],N):-
    nmb_id(A,Y,N).

% Trouve l'id de domino a partir d'un id
% find_id(I,D,L)
find_id(I,[[I,X]|_],[I,X]):-!.
find_id(I,[[X,I]|_],[X,I]):-!.
find_id(I,[[_,_]|D1],L):-
    find_id(I,D1,L).

% Supprime les ids et dominos
% sup(I,D,LI,LD,NLI,NLD)
sup(_,_,[],[],[],[]).
% Sup cas ID
sup([A,B],D,[[A,_]|RI],[_|RD],NRI,NRD):-
    sup([A,B],D,RI,RD,NRI,NRD),!.
sup([A,B],D,[[_,A]|RI],[_|RD],NRI,NRD):-
    sup([A,B],D,RI,RD,NRI,NRD),!.
sup([A,B],D,[[B,_]|RI],[_|RD],NRI,NRD):-
    sup([A,B],D,RI,RD,NRI,NRD),!.
sup([A,B],D,[[_,B]|RI],[_|RD],NRI,NRD):-
    sup([A,B],D,RI,RD,NRI,NRD),!.
% Sup cas Domino
sup(ID,[A,A],[_|RI],[[A,A]|RD],NRI,NRD):-
    sup(ID,[A,A],RI,RD,NRI,NRD).
sup(ID,[A,B],[_|RI],[[A,B]|RD],NRI,NRD):-
    sup(ID,[A,B],RI,RD,NRI,NRD).
sup(ID,[A,B],[_|RI],[[B,A]|RD],NRI,NRD):-
    sup(ID,[A,B],RI,RD,NRI,NRD).
% Sup cas Normal
sup(ID,Domino,[I|RI],[D|RD],[I|NRI],[D|NRD]):-
    sup(ID,Domino,RI,RD,NRI,NRD).

% Supprime l'id et domino
% sup1(I,LI,LD,NLI,NLD)
% INUTILE (n'a pas était utilisé)
sup1(ID,[ID|RI],[_|RD],RI,RD).
sup1(ID,[I|RI],[D|RD],[I|NRI],[D|NRD]):-
    sup1(ID,RI,RD,NRI,NRD).

% Retourne l'id et le domino qu'il doit faire partie
% check_same(SD,LD,LI,N,L)
check_same([SD|_],LD,LI,I,SD):-
    group(SD,LD,LI,G), % renvoit G, liste des id de SD
    commun(G,I),!. % renvoit l'id qui appartient a tout G, sinon false
check_same([_|R],LD,LI,N,L):-
    check_same(R,LD,LI,N,L).

% Renvoit la liste des id du domino correspondant
% group(SD,LD,LI,G)
group(_,[],[],[]).
group([A,A],[[A,A]|RD],[I|RI],[I|RG]):-
    group([A,A],RD,RI,RG),!.
group([A,B],[[A,B]|RD],[I|RI],[I|RG]):-
    group([A,B],RD,RI,RG),!.
group([A,B],[[B,A]|RD],[I|RI],[I|RG]):-
    group([A,B],RD,RI,RG),!.
group(SD,[_|RD],[_|RI],RG):-
    group(SD,RD,RI,RG).

% Renvoit l'id communs, sinon false
% commun(G,I)
commun([[A,_],[A,_]|[]],A):-!.
commun([[A,_],[_,A]|[]],A):-!.
commun([[_,B],[B,_]|[]],B):-!.
commun([[_,B],[_,B]|[]],B):-!.
commun([[A,_],[A,_]|R],I):-
    commun([[A,A]|R],I),!.
commun([[A,_],[_,A]|R],I):-
    commun([[A,A]|R],I),!.
commun([[_,B],[B,_]|R],I):-
    commun([[B,B]|R],I),!.
commun([[_,B],[_,B]|R],I):-
    commun([[B,B]|R],I),!.

% Supprime les id et dominos a part si c'est celui qu'il faut garder
% sup_spe(I,D,LI,LD,NLI,NLD)
sup_spe(_,_,[],[],[],[]).
% cas gauche 
sup_spe(I,[A,B],[[I,J]|RI],[[A,B]|RD],[[I,J]|NRI],[[A,B]|NRD]):-
    sup_spe(I,[A,B],RI,RD,NRI,NRD),!.
% cas gauche inversé
sup_spe(I,[A,B],[[I,J]|RI],[[B,A]|RD],[[I,J]|NRI],[[B,A]|NRD]):-
    sup_spe(I,[A,B],RI,RD,NRI,NRD),!.
% cas gauche same
sup_spe(I,[A,A],[[I,J]|RI],[[A,A]|RD],[[I,J]|NRI],[[A,A]|NRD]):-
    sup_spe(I,[A,A],RI,RD,NRI,NRD),!.
% cas droite 
sup_spe(I,[A,B],[[J,I]|RI],[[A,B]|RD],[[J,I]|NRI],[[A,B]|NRD]):-
    sup_spe(I,[A,B],RI,RD,NRI,NRD),!.
% cas droite inversé
sup_spe(I,[A,B],[[J,I]|RI],[[B,A]|RD],[[J,I]|NRI],[[B,A]|NRD]):-
    sup_spe(I,[A,B],RI,RD,NRI,NRD),!.
% cas droite same
sup_spe(I,[A,A],[[J,I]|RI],[[A,A]|RD],[[J,I]|NRI],[[A,A]|NRD]):-
    sup_spe(I,[A,A],RI,RD,NRI,NRD),!.
% cas gauche sup
sup_spe(I,ID,[[I,_]|RI],[_|RD],NRI,NRD):-
    sup_spe(I,ID,RI,RD,NRI,NRD),!.
% cas droite sup
sup_spe(I,ID,[[_,I]|RI],[_|RD],NRI,NRD):-
    sup_spe(I,ID,RI,RD,NRI,NRD),!.
% cas normal
sup_spe(I,ID,[LI|RI],[D|RD],[LI|NRI],[D|NRD]):-
    sup_spe(I,ID,RI,RD,NRI,NRD).



% GAME

% Cas de fin
dominosa(S,S,_,_,[],[],_,[],_):-!.


% Cas de possibilité unique
dominosa(M,S,R,C,LD,LI,ListeID,SetDomino,SetDominoSPE):-
    distinct_id(ListeID,LI,L),
    change_m(M,M1,L),
    domino_id(D,LD,L,LI),
    sup_domino(SetDomino,NSetDomino,D),
    sup_domino(SetDominoSPE,NSetDominoSPE,D),
    sup(L,D,LI,LD,NLI,NLD),
    dominosa(M1,S,R,C,NLD,NLI,ListeID,NSetDomino,NSetDominoSPE),!.

% BUG : FAIT 2 CAS EN MEME TEMPS ???????????????????

% Cas de domino unique
dominosa(M,S,R,C,LD,LI,ListeID,SetDomino,SetDominoSPE):-
    distinct(SetDomino,LD,D),
    domino_id(D,LD,L,LI),
    change_m(M,M1,L),
    sup_domino(SetDomino,NSetDomino,D),
    sup_domino(SetDominoSPE,NSetDominoSPE,D),
    sup(L,D,LI,LD,NLI,NLD),
    dominosa(M1,S,R,C,NLD,NLI,ListeID,NSetDomino,NSetDominoSPE),!.


% Cas de suppression de possibilité
dominosa(M,S,R,C,LD,LI,ListeID,SetDomino,SetDominoSPE):-
    check_same(SetDominoSPE,LD,LI,N,L),
    sup_spe(N,L,LI,LD,NLI,NLD),
    sup_domino(SetDominoSPE,NSetDominoSPE,L),
    dominosa(M,S,R,C,NLD,NLI,ListeID,SetDomino,NSetDominoSPE),!.



solution(M,S):-
    rows(M,R),
    columns(M,C),
    RC is R*C,
    create_list(RC,ListeID),
    check_element(M,ListeN),
    dominos(ListeN,ListeN,SetDomino),
    poss(M,LD),
    id(0,0,R,C,0,LI),
    dominosa(M,S,R,C,LD,LI,ListeID,SetDomino,SetDomino).



/* DIFFERENTS TESTS :

ERREUR :
solution([[5,3,0,3,0,1,3,4],[6,0,2,0,2,4,0,1],[2,6,2,0,5,4,4,6],[5,5,0,1,3,1,1,3],[4,4,6,6,3,2,3,5],[1,0,4,5,6,4,2,5],[1,5,2,1,6,3,6,2]],S).
solution([[2,4,4,3,6,6,1,3],[3,6,0,4,1,1,1,1],[5,4,6,3,5,4,2,5],[5,4,2,0,6,0,6,0],[1,5,1,4,6,0,5,2],[0,3,1,0,6,0,2,5],[4,2,2,2,3,3,3,5]],S).
RAISON ????

Pour avoir le temps :
time((INSERT_FUNCTION, fail; true)).

- TEST 1X1
solution([[0,0]],S).
Temps : 0.000s

- TEST 2X2
solution([[0,1,1],[1,0,0]],S).
Temps : 0.000s

- TEST 3X3
solution([[1,1,1,0],[2,2,1,0],[2,2,0,0]],S).
Temps : 0.000s~0.001s

- TEST 4X4
solution([[1,2,1,0,3],[2,1,1,0,2],[3,3,3,3,0],[0,1,2,2,0]],S).
Temps : 0.001s

- TEST 5X5
solution([[1,4,0,4,4,0],[3,3,1,1,0,0],[2,2,2,1,4,2],[1,3,0,3,3,3],[4,0,2,1,2,4]],S).
Temps : 0.003s

- TEST 6X6
solution([[5,2,3,3,2,1,1],[1,4,0,2,4,3,4],[3,4,1,5,0,2,4],[1,0,0,5,2,1,4],[3,5,4,1,2,0,0],[2,3,0,3,5,5,5]],S).
Temps : 0.005s~0.006s

- TEST 7X7
solution([[6,2,0,5,6,5,2,0],[5,1,2,3,6,1,4,6],[3,0,5,4,6,0,4,6],[4,2,3,0,1,3,0,6],[4,5,1,0,4,3,4,1],[1,5,3,3,4,2,2,1],[2,5,3,2,1,6,5,0]],S).
Temps : 0.011s~0.015s

- TEST 8X8
solution([[3,3,4,0,1,2,2,0,0],[1,5,5,3,3,4,5,6,1],[0,6,0,5,7,4,7,1,7],[3,7,2,1,7,1,2,1,4],[0,7,5,6,6,4,7,4,2],[6,4,0,3,5,6,6,5,5],[1,6,6,0,0,3,7,1,2],[2,7,2,4,4,3,2,3,5]],S).
Temps : 0.032s~0.035s

- TEST 9X9
solution([[6,0,7,7,9,8,2,1,1,3,3],[9,9,0,1,7,2,3,2,8,9,5],[1,9,9,6,4,0,8,8,4,1,8],[9,8,7,0,6,8,7,4,5,9,1],[2,0,9,3,8,5,2,5,3,3,5],[4,0,5,6,2,2,6,6,4,6,4],[2,1,8,0,0,4,7,4,1,3,4],[7,4,8,1,5,6,1,3,7,0,6],[1,3,9,7,3,6,4,5,8,0,2],[2,0,2,5,5,7,9,7,3,6,5]],S).
Temps : 0.091s~0.098s

- TEST 10X10
solution(,S).
Temps : 0.091s~0.098s

- TEST 11X11
solution(,S).
Temps : 0.091s~0.098s

- TEST 12X12
solution([[5,3,3,12,7,11,2,1,8,4,0,4,10,4],[5,11,0,6,4,1,5,4,3,0,12,8,7,11],[8,0,9,5,1,12,1,6,2,9,11,1,11,11],[9,1,5,9,2,1,4,12,6,2,8,6,5,4],[9,0,3,6,2,12,6,2,1,6,7,2,0,7],[7,7,0,3,3,12,8,8,10,9,11,6,2,12],[6,5,5,9,8,2,4,9,10,8,6,3,8,7],[10,3,6,12,9,6,4,10,10,8,9,3,12,10],[10,1,0,10,7,6,4,11,0,5,2,5,0,10],[2,1,8,4,7,7,12,0,12,10,1,3,7,8],[0,3,7,9,12,5,11,11,3,0,0,10,5,8],[6,1,2,11,10,8,9,3,7,1,11,2,12,2],[10,9,11,12,4,4,5,7,1,4,9,11,5,3]],S).
Temps : 0.390s~0.420s
*/