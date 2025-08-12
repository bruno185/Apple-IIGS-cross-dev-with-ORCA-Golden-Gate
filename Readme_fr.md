# Une configuration pour le cross développement sur PC d'applications pour Apple IIGS

## Table des matières
1. Introduction
2. Prérequis de base sur le PC
3. Prérequis spécifiques au cross-développement Apple IIGS
4. Processus de compilation
5. Exemples
## 1. Introduction
Ce document s’adresse aux développeurs souhaitant utiliser leur PC pour du cross-développement pour l’Apple IIGS. Son objectif est de présenter un retour d'expérience détaillé sur une solution, parmi d'autres, de cross développement d'applications pour Apple IIGS en langage de 3ème génération (Pascal et C), en utilisant un PC sous Windows et ORCA. Il ne s'agit pas d'une initiation à ces langages de programmation ni à l'environnement ORCA, mais d'une description des outils et de leur configuration. Une connaissance préalable des outils ORCA et des langages Pascal ou C est nécessaire.

NB : Il existe d'autre solutions de cross développement sur PC vers Apple IIGS, en particulier avec le compilateur Merlin32 pour les projets en assembleur.


## 2. Prérequis de base sur le PC
- **Windows 10 ou 11** : testé sous Windows 11, mais compatible Windows 10.
- **Visual Studio Code** : cœur de la solution proposée. Gratuit, puissant, modulaire, extensible, facile à utiliser, disponible aussi sur Macintosh et Linux. L'éditeur de code est particulièrement puissant.
- **Python** : utilisé pour compiler les fichiers sources via un script, mais non obligatoire (batch ou PowerShell possible).
- **Émulateur Apple IIGS** : préférence pour Crossrunner (mapping clavier français, débogueur, présentation, etc.), KEGS est une alternative (avec Cyrene de Brutal Deluxe pour le débogage). Tester sur un vrai Apple IIGS reste indispensable.

## 3. Prérequis spécifiques au cross développement Apple IIGS

- **ORCA (Byte Works)** : environnement de développement pour Apple II, compilateurs pour plusieurs langages (Assembleur, C, Pascal, Modula, Basic, etc.). Disponible dans le package OPUS II sur juiced.com, payant. Permet de compiler et lier des programmes pour Apple IIGS.

- **Golden Gate (Kelvin Sherlock)** : couche de compatibilité pour ORCA (et GNO/ME), permet d'exécuter les programmes ORCA sur PC pour Apple IIGS. Disponible sur juiced.com, payant. L'installation de Golden Gate met à jour automatiquement la variable d'environnement PATH de Windows. Sert d’interface entre les outils ORCA et l’environnement Windows pour faciliter le cross développement.

- **Ciderpress II (faddenSoft)** : application Windows gratuite pour travailler avec les images disques.

- **Cadius (Brutal Deluxe)** : outil en ligne de commande pour gérer les fichiers d'image disque Apple II sous Windows. Permet notamment d’ajouter, supprimer ou modifier des fichiers sur une image disque. Il est beaucoup plus pratique que le fichier "Cadius.exe" soit dans le PATH Windows pour pouvoir être exécuté depuis n'importe quel répertoire. Il n'y a pas de programme d'installation, c'est à l'utilisateur de s'en assurer s'il le souhaite.
- **une Image disque avec un OS (GS/OS)** : nécessaire pour démarrer l'émulateur et lancer le logiciel dans son environnement cible (ProDOS, GS/OS, etc.).

## 4. Processus de compilation
Le principe général est le suivant : 

| Étape | Description                            | Outil(s)                |
|-------|----------------------------------------|-------------------------|
| 1     | Édition du code                        | Visual Studio Code      |
| 2     | Compilation                            | Golden Gate / ORCA      |
| 3     | Édition des liens                      | Golden Gate / ORCA      |
| 4     | Compilation des ressources éventuelles | Golden Gate / ORCA      |
| 5     | Copie sur une image disque             | Cadius                  |
| 6     | Test/exécution dans l'émulateur        | KEGS ou Crossrunner     |

L'étape 4 n'est nécessaire que si le code utilise un fichier de ressources.


## Exemples
### Exemple 1 : programme en Pascal sans fichier ressource
### Étapes :
- Édition du code : ouvrir Visual Studio Code, puis sélectionner File/Open Folder et choisir le répertoire "1.HelloPascal".

- Compilation : adapter les variables de configuration (voir ci-dessous).

- Édition des liens : réalisée automatiquement par le script.
Copie sur l’image disque : réalisée automatiquement par le script.

- Test dans l’émulateur : une fois le programme copié, il peut être lancé dans KEGS ou Crossrunner.

### Le code (HelloPascal.pas) :
```pascal program Hello (input,output);
uses Common, QuickDrawII, ResourceMgr;
begin
        StartGraph(320); 
        MoveTo(50, 100);
        writeln('Hello, Pascal!')
        writeln('Press Enter to exit...');
        readln; { Wait for user input before closing the program }
        EndGraph;
end.
```

#### Compilation : 

- Il faut d'abord adapter les variables de configuration :

        - Modifier la ligne 19 en remplaçant "C:\\Apple IIgs\\Disks\\System.po" par le path complet vers votre propre image disque comportant un système GS/OS.

        - Modifier la ligne 20 en remplaçant /SYSTEM/ par le prefix de destination sur cet image disque

        - les lignes 17 et 18 désignent respectivement le nom du fichier du programme principal et l'extension (.pas, .c, .cc, etc. qui indique à ORCA le langage utilisé et donc compilateur à mettre en oeuvre). Ces 2 lignes sont déjà renseignées correctement pour l'exemple HelloPascal

- Dans la fenêtre "TERMINAL" de Visual Studio Code, exécuter le script Python avec la commande : python DEPLOY.py 

**Le script Python compile et link le code HelloPascal, puis copie l'exécutable au format OMF (Object Module Format) sur l'image disque que vous avez choisie.**

Pour les compilations ultérieures, il suffit de relancer la commande : python DEPLOY.py

#### Que fait le programme python DEPLOY.py ?
- Il vérifie que Cadius.exe et iix.exe (exécutable de Golden Gate) sont accessibles, c'est à dire dans le PATH de Windows. Dans le cas contraire, le programme s'arrête avec un message.

- Il rappelle les variables de configuration, définies aux lignes 17 à 20, à adapter à chaque projet. Ce sont les seules informations dont le programme Python a besoin.
- Il vérifie que le fichier principal est bien présent, ainsi que l'image disque. Dans le cas contraire, le programme s'arrête avec un message. L'absence de fichier de ressource n'est pas bloquante (juste un warning), il n'y en a d'ailleurs pas dans l'exemple HelloPascal.
- Il exécute la compilation par le compilateur ORCA/Pascal, à travers la couche d'émulation Golden Gate par la commande : "iix compile HelloPascal.pas keep=HelloPascal"
- Il exécute l'édition des liens de l'application, de la même façon par la commande : iix -DKeepType=S16 link HelloPascal keep=HelloPascal". Cette étape produit l'exécutable au format de l'Apple IIGS (OMF)
- Il supprime les fichiers intermédiaires (fichier .a et .root)
- Il détecte la présence d'un fichier ressources HelloPascal.rez, et en exécute la compilation par la commande : "iix compile HelloPascal.rez keep=HelloPascal", et il extrait la ressource compilée dans le fichier HelloPascal_ResourceFork.bin (voir exemple 4)
- Il copie l'exécutable sur l'image disque indiquée dans les variables de configuration, après avoir supprimé un éventuel fichier existant. NB : Cadius a besoin d'un fichier "_FileInformation.txt" pour définir les attributs du fichier copié sur l'image disque. En l'occurrence, il faut informer Cadius que HelloPascal est une Application GS/OS. Le fichier "_FileInformation.txt" commence donc par "HelloPascal=Type(B3)...". Le programme HelloPascal est maintenant sur l'image disque, et peut être exécuté dans un émulateur ou sur un Apple IIGS.

### Exemple 2 : programme en C sans fichier ressource
Cet exemple est dans le répertoire "2.HelloC". 
Le principe est le même. La seule différence est que le programme HelloC fait appel à des fonctions en assembleur codées dans un fichier séparé, asm.h. En plus de ORCA/C, le macro assembleur ORCA/M est nécessaire pour compiler ce programme.

NB : Dans le module asm.s, l'appel à la fonction "debug" permet d'interrompre le programme, par exemple, pour exécuter pas à pas le code compilé, dès lors que dans l'émulateur, Crossrunner par exemple, un break a été défini avec les conditions : A = $AAAA et X = $BBBB. On aurait pu choisir d'autres valeurs. 

### Exemple 3 : programme en Pascal sans fichier ressource, avec de l'assembleur
Le répertoire "3.Pasm2" fournit un exemple similaire, en Pascal. Il est repris d'après un exemple donné dans la documentation sur ORACA/Pascal, "Chapter 5 – Writing Assembly Language Subroutines".

### Exemple 4 : programme en Pascal avec un fichier ressource
#### Etapes :
1. Édition du code : ouvrir le répertoire "4.HelloPascal+Rez" dans Visual Studio Code.
2. Compilation et édition des liens : réalisées automatiquement par le script Python (ORCA via Golden Gate)
3. Traitement du fichier ressource : une étape supplémentaire après l'édition des liens est nécessaire car Cadius a besoin d'un fichier supplémentaire, sous la forme {programname_name}_ResourceFork.bin contenant les ressources compilées (binaire).
4. Copie sur l’image disque : réalisée automatiquement par le script (Cadius).
5. Test dans l’émulateur : une fois le programme copié, il peut être lancé dans KEGS ou Crossrunner.

L'étape 3 a été ajoutée par rapport aux exemples précédents. La commande Golden Gate "iix export cadius {programname_name}" extrait la ressource du programme compilé et lié pour créer ce fichier resource binaire séparé. Ainsi, la commande Cadius ADDFILE pourra écrire sur l'image disque l'exécutable complet, avec sa ressource. Cela n'aurait pas été le cas sans la création du fichier {programname_name}_ResourceFork.bin dans le même répertoire que le fichier {programname_name}.

Dans cet exemple, le fichier "rez1.bat" effectue les mêmes opérations de déploiement que le script Python, de façon plus simple mais sans vérifications.

