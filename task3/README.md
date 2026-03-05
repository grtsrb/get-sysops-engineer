Zadatak 3 ⇒ Linux, Bash

U prilogu se nalazi lista fajlova u formatu 'kABCDEFGH.kod' gde je
ABCDEFGH broj u heksadecimalnom formatu, npr. k000ccf3b.kod .
Potrebno je napraviti bash skript koji će u lokalnom direktorijumu:
1. Kreirati prazne fajlove sa nazivima iz liste
2. Proveriti za svaki fajl da li mu je naziv u zadatom formatu i
prikazati neispravne nazive fajlova
3. Napraviti potrebne poddirektorijume i u njih rasporediti fajlove
po sledećem šablonu:
- Fajl kABCDEFGH.kod treba prebaciti u direktorijum G0/E0 , ako je G
paran broj
- Fajl kABCDEFGH.kod treba prebaciti u direktorijum X0/E0 , gde je
X=G-1 , ako je G neparan broj
Na primer, fajl k000ccf3b.kod treba prebaciti u folder 20/c0, fajl
k000cde67.kod treba prebaciti u folder 60/d0 .
Fajlove čiji naziv nije u zadatom formatu treba ignorisati
