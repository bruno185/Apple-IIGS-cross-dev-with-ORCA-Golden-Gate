# Une configuration pour le cross-développement sur PC d'applications pour Apple IIGS

## Table des matières
1. Introduction
2. Prérequis de base sur le PC
3. Prérequis spécifiques au cross-développement Apple IIGS
4. Processus de compilation
5. Exemples
6. Conclusion

## 1. Introduction
Ce document s’adresse aux développeurs souhaitant utiliser leur PC pour du cross-développement pour l’Apple IIGS. Son objectif est de présenter un retour d'expérience détaillé sur une solution, <u>parmi d'autres</u>, de cross-développement en langage de 3ᵉ génération (Pascal et C), en utilisant un PC sous Windows et ORCA. Il ne s'agit pas d'une initiation à ces langages de programmation sur Apple IIGS, ni à l'environnement ORCA, mais d'une description des outils et de leur utilisation automatisée via un script Python ou batch. Une connaissance préalable des outils ORCA, des langages Pascal ou C et de l'environnement Apple II est nécessaire.

NB : Il existe d'autres solutions de cross-développement sur PC vers Apple IIGS, en particulier avec le compilateur Merlin32 pour les projets en assembleur : https://brutaldeluxe.fr/products/crossdevtools/merlin


## 2. Prérequis de base sur le PC
- **Windows 10 ou 11** : la configuration a été testée sous Windows 11, elle est compatible avec Windows 10.

- **Visual Studio Code** : cœur de la solution proposée. Gratuit, puissant, modulaire, extensible, facile à utiliser, disponible aussi sur Macintosh et Linux. L'éditeur de code est particulièrement puissant : http://www.visualstudio.com

- **Python** : utilisé pour compiler et lier les fichiers sources via un script, mais non obligatoire (batch ou PowerShell possible, voir exemple 4). https://www.python.org


## 3. Prérequis spécifiques au cross-développement Apple IIGS

- **Émulateur Apple IIGS** : 

        - Crossrunner : très bon émulateur (mapping clavier français, débogueur intégré, UI efficace) : https://www.crossrunner.gs

        - KEGS : https://kegs.sourceforge.net (option : Cyrene de Brutal Deluxe pour le débogage : https://www.brutaldeluxe.fr/products/crossdevtools/cyrene/)

NB : Tester sur un vrai Apple IIGS reste indispensable.

- **ORCA (Byte Works)** : environnement complet de développement pour Apple II, compilateurs pour plusieurs langages (Assembleur, C, Pascal, Modula, Basic, etc.). Disponible dans le package OPUS II : https://juiced.gs/store/opus-ii-software, payant. Il permet de compiler et de lier tous types de programmes pour Apple IIGS. 

- **Golden Gate (Kelvin Sherlock)** : couche de compatibilité pour ORCA (et GNO/ME), permet d'exécuter les programmes ORCA sur PC pour Apple IIGS : https://juiced.gs/store/golden-gate/, payant. L'installation de Golden Gate met à jour automatiquement la variable d'environnement PATH de Windows. Sert d’interface entre les outils ORCA et l’environnement Windows et permet donc le cross-développement. **IMPORTANT** : la version 2.1.0 (septembre 2025) est nécessaire ! Elle est disponible ici : https://juiced.gs/store/golden-gate/ 

- **Ciderpress II (faddenSoft)** : application Windows gratuite pour créer et travailler avec les images disques pour Apple II de différents formats : https://ciderpress2.com


- **Cadius (Brutal Deluxe)** : outil en ligne de commande pour gérer les fichiers d'image disque Apple II sous Windows. Permet notamment d’ajouter, supprimer ou modifier des fichiers sur une image disque : https://www.brutaldeluxe.fr/products/crossdevtools/cadius
Il est beaucoup plus pratique que le fichier "Cadius.exe" soit dans le PATH Windows pour pouvoir être exécuté depuis n'importe quel répertoire. Il n'y a pas de programme d'installation, c'est à l'utilisateur de s'en assurer s'il le souhaite.

- **une image disque avec un OS (GS/OS)** : nécessaire pour démarrer l'émulateur et lancer le logiciel dans son environnement cible (ProDOS, GS/OS, etc.). Peut être créée notamment avec Ciderpress II, ou récupérée sur un site de téléchargement d'images disques pour Apple II, comme Asimov : https://mirrors.apple2.org.za/ftp.apple.asimov.net. L'image disque système peut être chargée ici :  https://www.macintoshrepository.org/57822-apple-iigs-system-6-0-x par exemple, ou là : https://www.macintoshrepository.org/30859-apple-iigs-hard-drive-image 


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
| 7     | Test/exécutionsur un vrai Apple IIGS   | Apple IIGS              |

L'étape 4 n'est nécessaire que si le code utilise un fichier de ressources (cf. exemple 4).


## Exemples
### Exemple 1 : programme en Pascal simple
### Étapes :
- Édition du code : ouvrir Visual Studio Code, puis sélectionner File/Open Folder et choisir le répertoire "1.HelloPascal".

- Compilation : adapter les variables de configuration (voir ci-dessous).

- Édition des liens : réalisée automatiquement par le script.
La oopie sur l’image disque est réalisée automatiquement par le script.

- Test dans l’émulateur : une fois le programme copié, il peut être lancé dans KEGS ou Crossrunner.

### Le code du programme pour Apple IIGS (HelloPascal.pas) :
```pascal 
program Hello (input,output);
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

- Il faut d'abord adapter les variables de configuration dans le script Python DEPLOY.py :

    - Modifier la ligne 19 en remplaçant "C:\\dev\\apple2gs\\system.po" par le path complet vers votre propre image disque comportant un système GS/OS.

    - Modifier la ligne 20 en remplaçant /SYSTEM6/ par le prefix de destination sur cette image disque

    - les lignes 17 et 18 désignent respectivement le nom du fichier du programme principal et l'extension (.pas, .c, .cc, etc. qui indique à ORCA le langage utilisé et donc le compilateur à mettre en œuvre). Ces 2 lignes sont déjà renseignées correctement pour l'exemple HelloPascal

- Dans la fenêtre "TERMINAL" de Visual Studio Code, exécuter le script Python avec la commande : "python DEPLOY.py"

**Le script Python compile et lie le code HelloPascal, puis copie l'exécutable au format OMF (Object Module Format) sur l'image disque que vous avez choisie.**

Pour les compilations ultérieures, il suffit de relancer la commande : "python DEPLOY.py"

#### Que fait le script Python DEPLOY.py ?
- Il vérifie que Cadius.exe et iix.exe (exécutable de Golden Gate) sont accessibles, c'est à dire dans le PATH de Windows. Dans le cas contraire, le programme s'arrête avec un message.

- Il rappelle les variables de configuration, définies aux lignes 17 à 20, à adapter à chaque projet. Ce sont les seules informations dont le script Python a besoin.
    - Il vérifie que le fichier principal est bien présent, ainsi que l'image disque. Dans le cas contraire, le programme s'arrête avec un message. L'absence de fichier de ressource n'est pas bloquante (juste un avertissement), il n'y en a d'ailleurs pas dans l'exemple HelloPascal.
- Il exécute la compilation par le compilateur ORCA/Pascal, à travers la couche d'émulation Golden Gate par la commande : "iix compile HelloPascal.pas keep=HelloPascal"
    - Il exécute l'édition des liens de l'application, de la même façon par la commande : "iix -DKeepType=S16 link HelloPascal keep=HelloPascal". Cette étape produit l'exécutable au format de l'Apple IIGS (OMF).
- Il supprime les fichiers intermédiaires (fichier .a et .root)
- Il détecte la présence d'un fichier ressources HelloPascal.rez, et en exécute la compilation par la commande : "iix compile HelloPascal.rez keep=HelloPascal", et il extrait la ressource compilée dans le fichier HelloPascal_ResourceFork.bin (voir exemple 4)
    - Il copie l'exécutable sur l'image disque indiquée dans les variables de configuration, après avoir supprimé un éventuel fichier existant par la commande : "Cadius ADDFILE HelloPascal". NB : Cadius a besoin d'un fichier "_FileInformation.txt" pour définir les attributs du fichier copié sur l'image disque. En l'occurrence, il faut informer Cadius que HelloPascal est une Application GS/OS, donc de type B3 (voir la documentation Apple). Le fichier "_FileInformation.txt" commence donc par "HelloPascal=Type(B3)...". Le programme HelloPascal est maintenant sur l'image disque, et peut être exécuté dans un émulateur ou sur un Apple IIGS.

le code python de DEPLOY.py est le suivant : 
```python
#
# Script Python to compile and deploy a program for Apple IIGS 
# using Golden Gate and Cadius
#

import os
import sys
import subprocess
import shutil
from pathlib import Path

# ===============================================
#           Configuration Variables
# ===============================================
# Change these variables to your own configuration
PRG = "HelloPascal" # Program name without extension
lang = ".pas"
AppleDiskPath = "C:\\dev\\apple2gs\\system.po"
ProdosDir = "/SYSTEM6/"
# ===============================================
#
def run_command(command, description=""):
    """Executes a command and displays the result"""
    print(f"Executing: {command}")
    try:
        result = subprocess.run(command, shell=True, check=True, 
                              capture_output=True, text=True)
        if result.stdout:
            print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"ERROR: {description}")
        print(f"Command failed: {command}")
        print(f"Error output: {e.stderr}")
        return False

def check_executable(exe_name):
    """Checks if an executable is available in the PATH"""
    try:
        result = subprocess.run(f"where {exe_name}", shell=True, 
                              capture_output=True, text=True, check=True)
        print(f"✓ {exe_name} found at: {result.stdout.strip()}")
        return True
    except subprocess.CalledProcessError:
        print(f"✗ ERROR: {exe_name} not found in PATH!")
        return False

def check_required_tools():
    """Checks that all required tools are available"""
    print("=" * 50)
    print("           Checking Required Tools")
    print("=" * 50)
    
    tools = ["iix.exe", "Cadius.exe"]
    all_found = True
    
    for tool in tools:
        if not check_executable(tool):
            all_found = False
    
    if not all_found:
        print("\nERROR: Missing required tools!")
        print("Please ensure the following are in your Windows PATH:")
        print("- iix.exe (Golden Gate compiler)")
        print("- Cadius.exe (Apple disk utility)")
        sys.exit(1)
    
    print("✓ All required tools found!")
    print()


def cleanup_intermediate_files():
    print("\nCleaning intermediate files...")
    intermediate_files = [f"{PRG}.a", f"{PRG}.root", f"{PRG}.sym", f"{PRG}.B"]
    for file in intermediate_files:
        if os.path.exists(file):
            os.remove(file)
            print(f"Deleted: {file}")


def main():
    # --------------- Check Required Tools ---------------
    check_required_tools()
    
    # --------------- Variables ---------------
    print("=" * 50)
    print("           Variables Configuration")
    print("=" * 50)
    
    print(f"Program name: {PRG}")
    print(f"Language extension: {lang}")
    print(f"Apple image disk path: {AppleDiskPath}")
    print(f"ProDOS directory: {ProdosDir}")
    print()
    
    # Vérification des fichiers requis
    source_file = f"{PRG}{lang}"
    rez_file = f"{PRG}.rez"
    
    if not os.path.exists(source_file):
        print(f"ERROR: Source file {source_file} not found!")
        sys.exit(1)
    
    if not os.path.exists(rez_file):
        print(f"WARNING: Resource file {rez_file} not found!")

    if not os.path.exists(AppleDiskPath):
        print(f"ERROR: Apple disk path {AppleDiskPath} does not exist!")
        sys.exit(1)
    
    # --------------- Golden Gate Compilation ---------------
    print("=" * 50)
    print("           Golden Gate Compilation")
    print("=" * 50)
    
    # Compile the program
    if not run_command(f"iix compile {PRG}{lang}", "Compiling Pascal source"):
        sys.exit(1)
    
    # Link the program
    if not run_command(f"iix -DKeepType=S16 link {PRG} keep={PRG}", "Linking program"):
        sys.exit(1)
    
    # Compile the resource file and create archive (only if .rez exists)
    has_resources = os.path.exists(rez_file)
    if has_resources:
        if not run_command(f"iix compile {PRG}.rez keep={PRG}", "Compiling resource file"):
            print("WARNING: Resource compilation failed, continuing...")
            has_resources = False
        else:
            # Create archive to preserve resource fork
                if not run_command(f"iix rexport -i cadius {PRG}", "Exporting resource with Cadius format"):
                    print("WARNING: Export failed, will copy executable directly")
                    has_resources = False


    # --------------- Cadius Disk Operations ---------------
    print("=" * 50)
    print("           Cadius Disk Operations")
    print("=" * 50)
    
    # Determine which file to copy based on whether resources were processed
    file_to_copy = PRG
    print(f"Copying executable to disk: {file_to_copy}")
    # Vérification que le fichier exécutable existe
    if not os.path.exists(file_to_copy):
        print(f"ERROR: Executable file {file_to_copy} not found!")
        sys.exit(1)
    # Delete existing file from disk (ignore errors)
    print(f"Removing existing {file_to_copy} from disk...")
    result = subprocess.run(
        f'Cadius.exe DELETEFILE "{AppleDiskPath}" {ProdosDir}{file_to_copy}',
        shell=True, capture_output=True, text=True
    )
    output = result.stdout + result.stderr
    if output:
        print(output)
    if "error" in output.lower():
        print("Erreur détectée dans la sortie Cadius (DELETEFILE).")
        cleanup_intermediate_files()

    # Add new file to disk
    result = subprocess.run(
        f'Cadius.exe ADDFILE "{AppleDiskPath}" {ProdosDir} .\\{file_to_copy}',
        shell=True, capture_output=True, text=True
    )
    output = result.stdout + result.stderr
    if output:
        print(output)
    if "error" in output.lower():
        print("Erreur détectée dans la sortie Cadius (ADDFILE).")
        cleanup_intermediate_files()
        sys.exit(1)

    cleanup_intermediate_files()
    print()

    # --------------- Done ---------------
    print("=" * 50)
    print("               ✅   SUCCÈS   ✅")
    print("            Compilation Complete!")
    print("=" * 50)


    if has_resources:
        print(f"Program {PRG} with resources successfully compiled and deployed!")
    else:
        print(f"Program {PRG} successfully compiled and deployed!")
    print(f"Deployed to: {AppleDiskPath}{ProdosDir}")
    print("=" * 50 + "\n")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nOperation cancelled by user.")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)
```

### Exemple 2 : programme en C simple, avec de l'assembleur
Cet exemple est présenté sous deux formes différentes dans les répertoires "2.HelloC_1" et "2.HelloC_2".
Le même script DEPLOY.py que dans l'exemple 1 automatise la compilation et le déploiement, il suffit d'adapter les lignes 17 à 20.
le programme HelloC fait appel à des fonctions en assembleur codées dans un fichier séparé. 
Dans "2.HelloC_1", la déclaration "asm" est utilisée et fait appel au mini-assembleur intégré d'ORCA/C, qui permet d'inclure des parties en langage assembleur dans le code C. Dans "2.HelloC_2" le macro assembleur ORCA/M est mis en oeuvre et offre des fonctionnalités beaucoup plus importantes.

NB : L'appel à la fonction "debug" permet d'interrompre le programme, par exemple, pour exécuter pas à pas le code compilé, dès lors que dans l'émulateur, Crossrunner par exemple, un break a été défini avec les conditions : A = $AAAA et X = $BBBB. On aurait pu choisir d'autres valeurs. 

### Exemple 3 : programme simple, avec de l'assembleur
Le répertoire "3.Pasm2" fournit un exemple similaire, en Pascal. Il est adapté d’un exemple fourni dans la documentation ORCA/Pascal, "Chapter 5 – Writing Assembly Language Subroutines". Le macro assembleur ORCA/M est utilisé.

### Exemple 4 : programme en Pascal avec un fichier ressource
Cet exemple est dans le répertoire "4.HelloPascal+Rez".
#### Rappel des étapes d'automatisation :
1. Édition du code : ouvrir le répertoire "4.HelloPascal+Rez" dans Visual Studio Code.
2. Compilation et édition des liens : réalisées automatiquement par le script Python (ORCA via Golden Gate)
3. Traitement du fichier ressource : une étape supplémentaire après l'édition des liens est nécessaire, car Cadius a besoin d'un fichier supplémentaire, sous la forme {programname_name}_ResourceFork.bin contenant les ressources compilées (binaire).
4. Copie sur l’image disque : réalisée automatiquement par le script (Cadius).
5. Test dans l’émulateur : une fois le programme copié, il peut être lancé dans KEGS ou Crossrunner.

L'étape 3 a été ajoutée par rapport aux exemples précédents. Quand la présence d'un fichier .rez est détectée, la commande Golden Gate "iix rexport cadius {programname_name}" extrait la ressource du programme compilé et lié pour créer ce fichier resource binaire séparé nommé {programname_name}_ResourceFork.bin (HelloPascal_ResourceFork.bin dans cet exemple). Ainsi, la commande Cadius ADDFILE pourra écrire sur l'image disque l'exécutable complet, avec sa ressource. Cela n'aurait pas été le cas sans la création du fichier {programname_name}_ResourceFork.bin dans le même répertoire que le fichier {programname_name}.

Grâce à l'option "-i" de la commande "iix rexport -i cadius {programname_name}", le fichier "_FileInformation.txt" est généré. Il est nécessaire pour la commande qui suit : "Cadius ADDFILE {programname_name}".

Dans cet exemple, le fichier "HelloPascal.bat" effectue les mêmes opérations de déploiement que le script Python, de façon beaucoup plus simple et directe, et sans vérifications.

### Exemple 5 : programme en Pascal passage de données avec des fonctions en assembleur
Cet exemple est dans le répertoire "5.Pasm3".
Le programme en Pascal passe des paramètres à des fonctions en langage assembleur, qui à leur tour renvoient des valeurs au programme principal. Ces fonctions illustrent le passage de paramètres entre le code en Pascal compilé par ORCA/Pascal et le code en assembleur compilé par ORCA/M.

### Exemple 6 : programme en C passage de données avec des fonctions en assembleur
Cet exemple est dans le répertoire "6.HelloAsm C", il est très similaire à l'exemple précédent.
Le programme en C passe des paramètres à des fonctions en langage assembleur, qui renvoient ensuite des valeurs au programme principal. Ces fonctions illustrent le passage de paramètres entre le code en C compilé par ORCA/C et le code en assembleur compilé par ORCA/M. 
La fonction uppers met en mettre en majuscule une variable C de type string. Elle est comparée avec son équivalent en C en termes de performances.
Enfin, DEPLOY.py a été complété pour générer le listing du programme "HelloAsmC.lst" (ligne 118), ce qui est souvent nécessaire pour le débogage du code assembleur.

## Conclusion

Ce guide propose une méthode complète pour réaliser du cross-développement d’applications Apple IIGS sur PC, en s’appuyant sur des outils modernes et accessibles. En suivant ces étapes, vous pouvez automatiser efficacement la compilation, la gestion des images disques et le test de vos programmes. 

