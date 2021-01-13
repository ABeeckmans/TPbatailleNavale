program batnav;

uses crt;


TYPE
	//ce type a ete cree afin de pouvoir appeler des tableaux en argument de procedures et fonctions
	tab = array[1..10,1..10] of CHAR;

	//on cree le type bateau
TYPE bateau = record
		nom : string;
		vie : integer;
		longueur: integer;
		tableau : array of string;
	end;	

VAR
	//il s'agit du tableau qui apparaitra au tour du joueur 1
	TabJ1 : array[1..10,1..10] of CHAR;

	//tableau  contenant les bateaux placés par le joueur 1
	TabJ1_selec : array[1..10,1..10] of CHAR;

	//il s'agit du tableau qui apparaitra au tour du joueur 2
	TabJ2 : array[1..10,1..10] of CHAR;

	//tableau  contenant les bateaux placés par le joueur 2
	TabJ2_selec : array[1..10,1..10] of CHAR;

	//il s agit d un tableau vide qui sera utilise comme argument non influent sur le programme
	Tab_vide : array[1..10,1..10] of CHAR;

	intro, joueur1 : BOOLEAN;

	i, viesJ1, viesJ2, tour_creation_bateau : INTEGER;

	nomJ1, nomJ2, coordonees : STRING;

	//NOTE creer un type bateau avec un champ nom, vies et un tableau des cases chosisies aurait certainement ete plus efficace

	bateau_vide: bateau;

	//donnes relatives aux bateaux du J1
	porteavionJ1 : bateau;
	croiseurJ1 :   bateau;
	contretorpilleur1J1 : bateau;
	contretorpilleur2J1 : bateau;
	torpilleurJ1 : bateau;



	//donnees relatives aux bateaux du J2
	porteavionJ2 : bateau;
	croiseurJ2 :   bateau;
	contretorpilleur1J2 : bateau;
	contretorpilleur2J2 : bateau;
	torpilleurJ2 : bateau;




procedure noms(VAR nom1, nom2 : STRING);

BEGIN
	while (nom1 = '') do
	begin
		writeln('Joueur 1, quel est votre nom');
		readln(nom1);
	end;

	while (nom2 = '') do
	begin
		writeln('Joueur 2, quel est votre nom');
		readln(nom2);
	end;

END;



//cette procedure remplacera la valeur de chaque case d un tableau par des 'O'
procedure initialisation (VAR tableau : tab);

VAR
	i,j : integer;


BEGIN
	for i := 1 to 10 do
	begin
		for j := 1 to 10 do
		begin
			tableau[i,j] := 'O';
		end;
	end;
END;



//cette procedure affichera la carte ainsi que le nom des lignes/colonnes au joueur
procedure affichage (VAR tableau : tab);

VAR
	i,j : integer;

BEGIN
	writeln('  A B C D E F G H I J');

	for i := 1 to 10 do
	begin
		write(i-1 , ' ');
		for j := 1 to 10 do
		begin
			if tableau[i,j] = '*' then
			begin
				TextColor(Red); //afin de mieux identifier les endroits ou un bateau a ete touche
			end
			else
			begin
				if tableau[i,j] = 'O' then
				begin
					TextColor(Blue);
				end;
			end;
			write(tableau[i,j] , ' ');
			TextColor(White);
		end;
		writeln;
	end;
END;




procedure position (VAR tableau : tab; VAR horizontale, verticale : integer; VAR selection_valide : boolean);


BEGIN
		//le debut de cette procedure permet de verifier que le joueur ne divise pas son bateau
		//il aurait cependant ete plus judicieux de demander au joueur de choisir les deux estremites de son bateau plutot que le creer cases par cases....
					case tour_creation_bateau of
						1:	begin
								//on regarde toute les cases autour de la case selectionnee pour que le joueur ne colle pas de bateaux
								//DEBUT de la condition 1************************************************************************************************************************
								if
								(  ((horizontale > 1) AND (horizontale < 10) AND (verticale > 1) AND (verticale < 10))
								AND ((tableau[horizontale+1, verticale] <> 'X') AND (tableau[horizontale-1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X')
								AND (tableau[horizontale, verticale + 1] <> 'X'))  )

								OR
								//meme regard mais pour les coins
								((horizontale = 1) AND (verticale = 1) AND (tableau[horizontale + 1,verticale] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X'))

								OR

								((horizontale = 10) AND (verticale = 1) AND (tableau[horizontale - 1,verticale] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X'))

								OR

								((horizontale = 10) AND (verticale = 10) AND (tableau[horizontale - 1,verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X'))

								OR

								((horizontale = 1) AND (verticale = 10) AND (tableau[horizontale+1,verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X'))

								OR
								//meme recherche mais pour les cases sur les cotes
								(  ((horizontale = 1) AND (verticale < 10) AND (verticale > 1))
								AND (tableau[horizontale+1,verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )

								OR

								(  ((horizontale = 10) AND (verticale < 10) AND (verticale > 1))
								AND (tableau[horizontale-1,verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )

								OR

								(  ((verticale = 1) AND (horizontale < 10) AND (horizontale > 1))
								AND (tableau[horizontale-1,verticale] <> 'X') AND (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )

								OR

								(  ((verticale = 10) AND (horizontale < 10) AND (horizontale > 1))
								AND (tableau[horizontale-1,verticale] <> 'X') AND (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X')  ) then
								//FIN de la condition 1 ****************************************************************************************************************************************
								begin
									selection_valide := true
								end
								else

								begin
									affichage(tableau);
									writeln('Vous ne pouvez pas poser des bateaux cote a cote');
								end;

							end;
						2:
							begin
								//on scanne les cases autour et on regarde si il y a bien le bateau en construction autour, afin de ne pas pouvoir le decouper
								//et si il n y a pas deja un bateau autour
								//DEBUT de la condition 2 *****************************************************************************************************************************************
								if ((horizontale > 1) AND (horizontale < 10) AND (verticale > 1) AND (verticale < 10)) AND ((tableau[horizontale+1, verticale] = 'W')
								OR (tableau[horizontale-1, verticale] = 'W') OR (tableau[horizontale, verticale - 1] = 'W') OR (tableau[horizontale, verticale + 1] = 'W'))
								AND((tableau[horizontale+1, verticale] <> 'X') AND (tableau[horizontale-1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X')
								AND (tableau[horizontale, verticale + 1] <> 'X'))

								OR
								//la meme chose mais pour les coins
								((horizontale = 1) AND (verticale = 1) AND (tableau[horizontale+1,verticale] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')
									AND ((tableau[horizontale + 1, verticale] = 'W') OR (tableau[horizontale, verticale + 1] = 'W')))

								OR

								 ((horizontale = 10) AND (verticale = 1) AND (tableau[horizontale - 1,verticale] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')
									AND ((tableau[horizontale - 1, verticale] = 'W') OR (tableau[horizontale, verticale + 1] = 'W')))

								OR

								((horizontale = 10) AND (verticale = 10) AND (tableau[horizontale-1,verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X')
									AND ((tableau[horizontale - 1, verticale] = 'W') OR (tableau[horizontale, verticale - 1] = 'W')))

								OR

								((horizontale = 1) AND (verticale = 10) AND (tableau[horizontale+1,verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X')
									AND ((tableau[horizontale + 1, verticale] = 'W') OR (tableau[horizontale, verticale - 1] = 'W')))

								OR
								//meme chose pour les cotes
								(((horizontale = 1) AND (verticale > 1) AND (verticale < 10))
								AND ((tableau[horizontale+1, verticale] = 'W') OR (tableau[horizontale, verticale - 1] = 'W') OR (tableau[horizontale, verticale + 1] = 'W'))
								AND((tableau[horizontale+1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')))

								OR

								(((horizontale = 10) AND (verticale > 1) AND (verticale < 10))
								AND ((tableau[horizontale - 1, verticale] = 'W') OR (tableau[horizontale, verticale - 1] = 'W') OR (tableau[horizontale, verticale + 1] = 'W'))
								AND ((tableau[horizontale - 1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')))

								OR


								(((verticale = 1) AND (horizontale > 1) AND (horizontale < 10))
								AND ((tableau[horizontale + 1, verticale] = 'W') OR (tableau[horizontale - 1, verticale] = 'W') OR (tableau[horizontale, verticale + 1] = 'W'))
								AND ((tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale -1, verticale] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')))

								OR

								(((verticale = 10) AND (horizontale > 1) AND (horizontale < 10))
								AND ((tableau[horizontale + 1, verticale] = 'W') OR (tableau[horizontale - 1, verticale] = 'W') OR (tableau[horizontale, verticale - 1] = 'W'))
								AND ((tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale -1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X'))) then
								//FIN de la condition 2************************************************************************************************************************************



								begin
									selection_valide := true
								end
								else
								begin
									affichage(tableau);
									writeln(tour_creation_bateau);
									writeln('Veuillez selectionner une case valide');
								end;
							end;

						
						else
							begin
								//on scanne les cases autour et on regarde si il y a bien le bateau en construction autour, afin de ne pas pouvoir le decouper
								//et si il n y a pas deja un bateau autour
								//debut de la condition 3 ************************************************************************************************************************************
								if
								(   ((horizontale > 2) AND (horizontale < 9) AND (verticale > 1) AND (verticale < 10))
								AND(  ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR    ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))
								OR    ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W'))  )
								AND(  (tableau[horizontale+1, verticale] <> 'X') AND (tableau[horizontale-1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X')
								AND (tableau[horizontale, verticale + 1] <> 'X')  )   )


								OR


								//la meme chose mais pour les coins
								(  ((horizontale = 1) AND (verticale = 1))
								AND ((tableau[horizontale + 1,verticale] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X'))
								AND (  ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR     ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W'))  )  )

								OR

								(  ((horizontale = 1) AND (verticale = 10))
								AND ((tableau[horizontale+1,verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X'))
								AND (  ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR     ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))  )  )

								OR

								(  ((horizontale = 10) AND (verticale = 10))
								AND ((tableau[horizontale - 1,verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X'))
								AND (  ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR     ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))  )  )


								OR

								(  ((horizontale = 10) AND (verticale = 1))
								AND ((tableau[horizontale - 1,verticale] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X'))
								AND (  ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR     ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W'))  )  )


								OR
								//8 cases sur les cotes qui peuvent poser souci
								//1
								(  ((horizontale = 2) AND (verticale = 1))
								AND(  (tableau[horizontale - 1, verticale] <> 'X') AND (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )
								AND(  ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W'))  )  )

								OR
								//2
								(  ((horizontale = 9) AND (verticale = 1))
								AND(  (tableau[horizontale - 1, verticale] <> 'X') AND (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )
								AND( ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR   ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W'))  )  )

								OR
								//3
								(  ((horizontale = 10) AND (verticale = 2))
								AND(  (tableau[horizontale - 1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )
								AND(  ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W'))  )  )

								OR
								//4
								(  ((horizontale = 10) AND (verticale = 9))
								AND(  (tableau[horizontale - 1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )
								AND(  ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))  )  )

								OR
								//5
								(  ((horizontale = 9) AND (verticale = 10))
								AND(  (tableau[horizontale - 1, verticale] <> 'X') AND (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X')  )
								AND(  ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))  )  )

								OR
								//6
								(  ((horizontale = 2) AND (verticale = 10))
								AND(  (tableau[horizontale - 1, verticale] <> 'X') AND (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X')  )
								AND(  ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))  )  )

								OR
								//7
								(  ((horizontale = 1) AND (verticale = 9))
								AND(  (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )
								AND(  ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))  )  )


								OR
								//8
								(  ((horizontale = 1) AND (verticale = 2))
								AND(  (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )
								AND(  ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W'))  )  )

								OR
								//meme chose pour les cotes
								//1
								(  ((horizontale = 1) AND (verticale > 2) AND (verticale < 9))
								AND ( ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))
								OR    ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W')) )
								AND ((tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X'))  )

								OR
								//2
								(  ((horizontale = 10) AND (verticale > 2) AND (verticale < 9))
								AND ( ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))
								OR    ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W')) )
								AND ((tableau[horizontale - 1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X'))  )

								OR
								//3
								(  ((verticale = 1) AND (horizontale > 2) AND (horizontale < 9))
								AND ( ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR    ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W')) )
								AND((tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale - 1, verticale] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X'))  )

								OR
								//4
								(  ((verticale = 10) AND (horizontale > 2) AND (horizontale < 9))
								AND ( ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR    ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W')) )
								AND((tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale - 1, verticale] <> 'X') AND (tableau[horizontale, verticale - 1] <> 'X'))  )




								OR
								//la meme chose pour les coins a 2 de distance
								//1
								(  ((horizontale = 2) AND (verticale = 2))
								AND ( ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W'))  )
								AND ( (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale - 1, verticale] <> 'X')
								AND   (tableau[horizontale, verticale + 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )  )

								OR
								//2
								(  ((horizontale = 2) AND (verticale = 9))
								AND ( ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))  )
								AND ( (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale - 1, verticale] <> 'X')
								AND   (tableau[horizontale, verticale + 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )  )

								OR
								//3
								(  ((horizontale = 9) AND (verticale = 2))
								AND ( ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W'))  )
								AND ( (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale - 1, verticale] <> 'X')
								AND   (tableau[horizontale, verticale + 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )  )

								OR
								//4
								(  ((horizontale = 9) AND (verticale = 9))
								AND ( ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR    ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))  )
								AND ( (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale - 1, verticale] <> 'X')
								AND   (tableau[horizontale, verticale + 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )  )

								OR
								//meme chose pour les cotes a deux de distance
								//1
								( ((horizontale = 2) AND (verticale > 2) AND (verticale < 9))
								AND (  ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR 	   ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))
								OR     ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W'))  )
								AND ( (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale - 1, verticale] <> 'X')
								AND   (tableau[horizontale, verticale + 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')  )  )

								OR
								//2
								( ((horizontale = 9) AND (verticale > 2) AND (verticale < 9))
								AND (  ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR 	   ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))
								OR     ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W'))
									)
								AND ( (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale - 1, verticale] <> 'X')
								AND	  (tableau[horizontale, verticale + 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')
									)
								)

								OR
								//3
								( ((verticale = 2) AND (horizontale > 2) AND (horizontale < 9))
								AND (  ((tableau[horizontale, verticale + 1] = 'W') AND (tableau[horizontale, verticale + 2] = 'W'))
								OR 	   ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR     ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
									)
								AND ( (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale - 1, verticale] <> 'X')
								AND	  (tableau[horizontale, verticale + 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')
									)
								)

								OR
								//4
								( ((verticale = 9) AND (horizontale > 2) AND (horizontale < 9))
								AND (  ((tableau[horizontale + 1, verticale] = 'W') AND (tableau[horizontale + 2, verticale] = 'W'))
								OR 	   ((tableau[horizontale - 1, verticale] = 'W') AND (tableau[horizontale - 2, verticale] = 'W'))
								OR     ((tableau[horizontale, verticale - 1] = 'W') AND (tableau[horizontale, verticale - 2] = 'W'))
									)
								AND ( (tableau[horizontale + 1, verticale] <> 'X') AND (tableau[horizontale - 1, verticale] <> 'X')
								AND   (tableau[horizontale, verticale + 1] <> 'X') AND (tableau[horizontale, verticale + 1] <> 'X')
									)
								) then



								//FIN de la condition 3********************************************************************************************************************************************
								begin
									selection_valide := true
								end
								else
								begin
									affichage(tableau);
									writeln('Veuillez selectionner une case valide');
								end;
							end;
						// 4:
						// 5:
					end;
	//selection_valide := true;
	if selection_valide = true then
	begin
		tableau[horizontale, verticale] := 'W'; // on rentre ce caractere afin de reconnaitre le tableau deja rentre et de differencier les touches du bateau en cours de formation, de celles d un bateau deja forme
	end;
END;

//procedure permettant de changer tout les W en X
procedure WtoX (VAR tableau : tab);
VAR
	i,j : INTEGER;

BEGIN
	for i:= 1 to 10 do
	begin
		for j := 1 to 10 do
		begin
			if tableau[i,j] = 'W' then
			begin
				tableau[i,j] := 'X';
			end;
		end;
	end;
END;

//procedure permettant au joueur de selectionner une case
procedure selection (VAR tableau, tableau_selec : tab; Var boat: bateau);

VAR
	horizontale, verticale : INTEGER;

VAR
	valide_lettre, valide_chiffre, choix_valide, selection_valide : BOOLEAN;

procedure touche_ou_coule (VAR tableau, tableau_selec : tab; horizontale, verticale : integer);

procedure verif_coule (VAR boat : bateau);

VAR
	i : INTEGER;
BEGIN
		//porte-avion
		for i := 1 to boat.longueur do
		begin


							if coordonees = boat.tableau[i] then
							begin
								boat.vie := boat.vie - 1;
							end;


		end;
		if boat.vie = 0 then
		begin
			writeln(boat.nom , ' coule');
			boat.vie := boat.vie - 1; //on descend sa valeur à -1 afin que celui-ci ne soit pas rappele
		end;

END;


//procedure touche_ou_coule*********************************************
BEGIN
	if tableau_selec[horizontale, verticale] = 'X' then
	begin
		writeln('Touche');
		tableau[horizontale, verticale] := '*';
		if joueur1 = true then
		begin
			viesJ2 := viesJ2 - 1;
			verif_coule(porteavionJ2);
			verif_coule(croiseurJ2);
			verif_coule(contretorpilleur1J2);
			verif_coule(contretorpilleur2J2);
			verif_coule(torpilleurJ2);
		end
		else
		begin
			viesJ1 := viesJ1 - 1;
			verif_coule(porteavionJ1);
			verif_coule(croiseurJ1);
			verif_coule(contretorpilleur1J1);
			verif_coule(contretorpilleur2J1);
			verif_coule(torpilleurJ1);
		end;
	end
	else
	begin
		writeln('Dans l eau');
	    tableau[horizontale, verticale] := 'X';
	end;
	readln;
	tableau_selec[horizontale, verticale] := '*';
	selection_valide:= true;

END;

// procedure selection ***************************
BEGIN

	valide_lettre := false;
	valide_chiffre := false;
	choix_valide := false;
	selection_valide := false;

	while selection_valide = false do
	begin
		valide_lettre := false;
		valide_chiffre := false;
		choix_valide := false;
		while (choix_valide = false) do
		begin
		valide_lettre := false;
		valide_chiffre := false; // pour reinitialiser la selection
			while (valide_chiffre = false) or (valide_lettre = false) do
			begin
				coordonees := ' '; //on reinitialise la variable avant que le joueur rentre une nouvelle valeur pour eviter que coordonees garde la valeur precedente si l utilisateur ne rentre rien
				readln(coordonees);
				case coordonees[1] of
					'A':begin
							verticale := 1;
							valide_lettre := true;
						end;
					'B': begin
							verticale := 2;
							valide_lettre := true;
						end;
					'C': begin
						 	verticale := 3;
						 	valide_lettre := true;
						 end;
					'D': begin
							verticale := 4;
							valide_lettre := true;
						end;
					'E': begin
							verticale := 5;
							valide_lettre := true;
						end;
					'F': begin
							verticale := 6;
							valide_lettre := true;
						end;
					'G': begin
							verticale := 7;
							valide_lettre := true;
						end;
					'H': begin
							verticale := 8;
							valide_lettre := true;
						end;
					'I': begin
							verticale := 9;
							valide_lettre := true;
						end;
					'J': begin
							verticale := 10;
							valide_lettre := true;
						end;
					else
				end;


				case coordonees[2] of
						'0': begin
								horizontale := 1;
								valide_chiffre := true;
							end;
						'1': begin
								horizontale := 2;
								valide_chiffre := true;
							end;
						'2': begin
								horizontale := 3;
								valide_chiffre := true;
							end;
						'3': begin
								horizontale := 4;
								valide_chiffre := true;
							end;
						'4': begin
								horizontale := 5;
								valide_chiffre := true;
							end;
						'5': begin
								horizontale := 6;
								valide_chiffre := true;
							end;
						'6': begin
								horizontale := 7;
								valide_chiffre := true;
							end;
						'7': begin
								horizontale := 8;
								valide_chiffre := true;
							end;
						'8': begin
								horizontale := 9;
								valide_chiffre := true;
							end;
						'9': begin
								horizontale := 10;
								valide_chiffre := true;
							end;
				end;
				


				





				//on verifie si l utilisateur a bien rentre une lettre correcte et un chiffre
				if (valide_chiffre = false) OR (valide_lettre = false) then
				begin
					writeln('Veuillez entrer une case valide');
				end;
			end;
			
			//on verifie si le joueur n a pas deja selectionne la case en question
			if (tableau[horizontale, verticale] = 'X') OR (tableau[horizontale, verticale] = '*') OR (tableau[horizontale, verticale] = 'W') then
			begin
				writeln('case deja attaquee');
	        end
			else
			begin
				choix_valide := true;
			end;
		end;




		clrscr;
		if intro = false then
		begin
			touche_ou_coule(tableau, tableau_selec, horizontale, verticale);
		end
		else
		begin
			position(tableau, horizontale, verticale, selection_valide);
		end;
	end;

END;


procedure premiere_phase (VAR tableau : tab; VAR boat : bateau);

VAR
	i,j : integer;

BEGIN

	for i := 1 to boat.longueur do
	begin
		writeln('Veuillez entrer la ' , i , 'eme case de votre ' , boat.nom , ' (' , boat.longueur , ' cases)');
		tour_creation_bateau := i;
		selection(tableau, Tab_vide, bateau_vide); // on rajoute un espace vide afin d'avoir le nombre correct d'arguments mais celui-ci n'influence pas le code
		
		// la case selectionne par le joueur rentre dans le tableau
		//on rajoute la valeur entree par le joueur dans un tableau approprie a son bateau
		boat.tableau[i] := coordonees;
		affichage(tableau);
	end;
	WtoX(tableau);
	clrscr;
	affichage(tableau);
END;


procedure attaque(VAR mon_tab_selec, ennemi_tab_selec, mon_tab : tab; VAR ma_vie, ennemi_vie : integer; VAR nom : string);

BEGIN
	writeln('VOTRE TERRAIN :');
	affichage(mon_tab_selec);
	writeln('Cases restantes : ' , ma_vie);
	writeln('---------------------------------------');
	writeln(' ');
	writeln('TERRAIN ADVERSE :');
	affichage(mon_tab);
	writeln(nom , ' quelle case voulez vous viser ?');
	selection(mon_tab, ennemi_tab_selec, bateau_vide);
	clrscr;
	affichage(mon_tab);
	writeln('Cases ennemies restantes : ' , ennemi_vie); //sert de verification
	writeln('Veuillez appuyer sur Entree');
	readln;
END;



//PROGRAMME PRINCIPAL********************************
BEGIN


	clrscr;
	//on donne 17 vies a chaque joueur car le nombre total de points a toucher est de 17
	viesJ1 := 17;
	viesJ2 := 17;



		//on donne de la vie a chacuns des bateaux du J1
	porteavionJ1.longueur := 5;
	porteavionJ1.vie := porteavionJ1.longueur;
	porteavionJ1.nom := 'Porte-avion';
	setlength(porteavionJ1.tableau, 6); //on met les tableau de 1 plus long pour ne pas dépasser des tableaux
	croiseurJ1.longueur := 4;
	croiseurJ1.vie := croiseurJ1.longueur;
	croiseurJ1.nom := 'Croiseur';
	setlength(croiseurJ1.tableau, 5);
	contretorpilleur1J1.longueur := 3;
	contretorpilleur1J1.vie := contretorpilleur1J1.longueur;
	contretorpilleur1J1.nom := 'Contre-torpilleur';
	setlength(contretorpilleur1J1.tableau, 4);
	contretorpilleur2J1.longueur := 3;
	contretorpilleur2J1.vie := contretorpilleur2J1.longueur;
	contretorpilleur2J1.nom := 'Contre-Torpilleur';
	setlength(contretorpilleur2J1.tableau, 4);
	torpilleurJ1.longueur := 2;
	torpilleurJ1.vie := torpilleurJ1.longueur;
	torpilleurJ1.nom := 'Torpilleur';
	setlength(torpilleurJ1.tableau, 3);


	//on donne de la vie a chacuns des bateaux du J2
	porteavionJ2.longueur := 5;
	porteavionJ2.vie := porteavionJ2.longueur;
	porteavionJ2.nom := 'Porte-avion';
	setlength(porteavionJ2.tableau, 6);
	croiseurJ2.longueur := 4;
	croiseurJ2.vie := croiseurJ2.longueur;
	croiseurJ2.nom := 'Croiseur';
	setlength(croiseurJ2.tableau, 5);
	contretorpilleur1J2.longueur := 3;
	contretorpilleur1J2.vie := contretorpilleur1J2.longueur;
	contretorpilleur1J2.nom := 'Contre-torpilleur';
	setlength(contretorpilleur1J2.tableau, 4);
	contretorpilleur2J2.longueur := 3;
	contretorpilleur2J2.vie := contretorpilleur2J2.longueur;
	contretorpilleur2J2.nom := 'Contre-Torpilleur';
	setlength(contretorpilleur2J2.tableau, 4);
	torpilleurJ2.longueur := 2;
	torpilleurJ2.vie := torpilleurJ2.longueur;
	torpilleurJ2.nom := 'Torpilleur';
	setlength(torpilleurJ2.tableau, 3);



	initialisation(TabJ1_selec);
	initialisation(TabJ2_selec);
	//TabJ2_selec[1,1] := 'X'; // sert juste de verification
	initialisation(TabJ1);
	initialisation(TabJ2);
	
	
	noms(nomJ1, nomJ2);

	//*****************$$$$
	//selection des bateaux
	intro := true;

	joueur1 := true;
	affichage(Tabj1_selec);
	writeln('L ecran est au JOUEUR 1');
	premiere_phase(Tabj1_selec, porteavionJ1);
	premiere_phase(Tabj1_selec, croiseurJ1);
	premiere_phase(Tabj1_selec, contretorpilleur1J1);
	premiere_phase(Tabj1_selec, contretorpilleur2J1);
	premiere_phase(Tabj1_selec, torpilleurJ1);
	readln;
	clrscr;

	writeln('Veuillez passer l ecran au joueur 2');
	readln;
	clrscr;

	joueur1 := false;
	affichage(Tabj2_selec);
	writeln('L ecran est au JOUEUR 2');
	premiere_phase(Tabj2_selec, porteavionJ2);
	premiere_phase(Tabj2_selec, croiseurJ2);
	premiere_phase(Tabj2_selec, contretorpilleur1J2);
	premiere_phase(Tabj2_selec, contretorpilleur2J2);
	premiere_phase(Tabj2_selec, torpilleurJ2);
	readln;
	clrscr;

	writeln('Veuillez passer l ecran au joueur 1');
	readln;
	clrscr;

	//**************************************

	




	//*********************************$$$
	//jeu principal
	intro := false;
	while (viesJ1 > 0)  AND (viesJ2 > 0) do
	begin
		clrscr;
		joueur1 := true; //pour savoir si c est le joueur 1 qui joue

		attaque(TabJ1_selec, TabJ2_selec, TabJ1, viesJ1, viesJ2, nomJ1);

		

		if (viesJ2 > 0) then
		begin
			clrscr;
			writeln('Veuillez passer l ecran au joueur 2');
			readln;
			clrscr;


			joueur1 := false; //pour savoir si c est le joueur 2 qui joue

			attaque(TabJ2_selec, TabJ1_selec, TabJ2, viesJ2, viesJ1, nomJ2);

			if (viesJ2 > 0) then
			begin
				clrscr;
				writeln('Veuillez passer l ecran au joueur 1');
				readln;
				clrscr;
			end;
		end;
	end;
	//********************************************

	


	//ecran de fin

	if (viesJ1>0) then
	begin
		writeln(nomJ1 , ' l emporte !!!!');
	end
	else
	begin
		writeln(nomJ2 , ' l emporte !!!!');
	end;
	readln;

END.

