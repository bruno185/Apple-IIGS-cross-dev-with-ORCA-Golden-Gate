# A Configuration for Cross-Development on PC for Apple IIGS Applications

## Table of Contents
1. Introduction
2. Basic Prerequisites on the PC
3. Specific Prerequisites for Apple IIGS Cross-Development
4. Compilation Process
5. Examples
6. Conclusion

## 1. Introduction
This document is intended for developers wishing to use their PC for cross-development for the Apple IIGS. Its goal is to provide a detailed feedback on one solution, among others, for cross-development in third-generation languages (Pascal and C), using a Windows PC and ORCA. It is not an introduction to these programming languages on Apple IIGS, nor to the ORCA environment, but a description of the tools and their automated use via a Python or batch script. Prior knowledge of ORCA tools, Pascal or C languages, and the Apple II environment is required.

Note: There are other cross-development solutions from PC to Apple IIGS, especially with the Merlin32 compiler for assembler projects: https://brutaldeluxe.fr/products/crossdevtools/merlin


## 2. Basic Prerequisites on the PC
- **Windows 10 or 11**: The configuration has been tested on Windows 11 and is compatible with Windows 10.

- **Visual Studio Code**: The core of the proposed solution. Free, powerful, modular, extensible, easy to use, also available on Mac and Linux. The code editor is particularly powerful: http://www.visualstudio.com

- **Python**: Used to compile and link source files via a script, but not mandatory (batch or PowerShell possible, see example 4). https://www.python.org


## 3. Specific Prerequisites for Apple IIGS Cross-Development

- **Apple IIGS Emulator**:

        - Crossrunner: very good emulator (French keyboard mapping, integrated debugger, efficient UI): https://www.crossrunner.gs

        - KEGS: https://kegs.sourceforge.net (option: Cyrene from Brutal Deluxe for debugging: https://www.brutaldeluxe.fr/products/crossdevtools/cyrene/)

Note: Testing on a real Apple IIGS remains essential.

- **ORCA (Byte Works)**: Complete development environment for Apple II, compilers for several languages (Assembler, C, Pascal, Modula, Basic, etc.). Available in the OPUS II package: https://juiced.gs/store/opus-ii-software, paid. Allows compiling and linking all types of programs for Apple IIGS.

- **Golden Gate (Kelvin Sherlock)**: Compatibility layer for ORCA (and GNO/ME), allows running ORCA programs on PC for Apple IIGS: https://juiced.gs/store/golden-gate/, paid. Installing Golden Gate automatically updates the Windows PATH environment variable. Serves as an interface between ORCA tools and the Windows environment, thus enabling cross-development.

- **Ciderpress II (faddenSoft)**: Free Windows application to create and work with Apple II disk images in various formats: https://ciderpress2.com

- **Cadius (Brutal Deluxe)**: Command-line tool to manage Apple II disk image files on Windows. Notably allows adding, deleting, or modifying files on a disk image: https://www.brutaldeluxe.fr/products/crossdevtools/cadius
It is much more convenient if the "Cadius.exe" file is in the Windows PATH to be executable from any directory. There is no installer; the user must ensure this if desired.

- **A disk image with an OS (GS/OS)**: Necessary to start the emulator and launch the software in its target environment (ProDOS, GS/OS, etc.). Can be created with Ciderpress II, or downloaded from an Apple II disk image site, such as Asimov: https://mirrors.apple2.org.za/ftp.apple.asimov.net. The system disk image can be loaded here: https://www.macintoshrepository.org/57822-apple-iigs-system-6-0-x for example, or here: https://www.macintoshrepository.org/30859-apple-iigs-hard-drive-image


## 4. Compilation Process
The general principle is as follows:

| Step | Description                             | Tool(s)                |
|------|-----------------------------------------|------------------------|
| 1    | Code editing                            | Visual Studio Code     |
| 2    | Compilation                             | Golden Gate / ORCA     |
| 3    | Linking                                 | Golden Gate / ORCA     |
| 4    | Resource compilation (if needed)        | Golden Gate / ORCA     |
| 5    | Copy to disk image                      | Cadius                 |
| 6    | Test/run in emulator                    | KEGS or Crossrunner    |

Step 4 is only necessary if the code uses a resource file (see example 4).


## Examples
### Example 1: Simple Pascal Program
#### Steps:
- Code editing: Open Visual Studio Code, then select File/Open Folder and choose the "1.HelloPascal" directory.

- Compilation: Adjust the configuration variables (see below).

- Linking: Performed automatically by the script.
Copy to disk image: Performed automatically by the script.

- Test in emulator: Once the program is copied, it can be launched in KEGS or Crossrunner.

#### The Apple IIGS program code (HelloPascal.pas):
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

#### Compilation:

- First, adjust the configuration variables in the Python script DEPLOY.py:

    - Modify line 19 by replacing "C:\\Apple IIgs\\Disks\\System.po" with the full path to your own disk image containing a GS/OS system.

    - Modify line 20 by replacing /SYSTEM/ with the destination prefix on this disk image.

    - Lines 17 and 18 respectively designate the main program file name and the extension (.pas, .c, .cc, etc., which tells ORCA which language and thus which compiler to use). These 2 lines are already correctly set for the HelloPascal example.

- In the "TERMINAL" window of Visual Studio Code, run the Python script with the command: "python DEPLOY.py"

**The Python script compiles and links the HelloPascal code, then copies the executable in OMF (Object Module Format) to the disk image you selected.**

For subsequent compilations, simply rerun the command: "python DEPLOY.py"

#### What does the DEPLOY.py Python script do?
- Checks that Cadius.exe and iix.exe (Golden Gate executable) are accessible, i.e., in the Windows PATH. Otherwise, the program stops with a message.

- Recalls the configuration variables, defined in lines 17 to 20, to be adapted for each project. These are the only pieces of information the Python program needs.
    - Checks that the main file and the disk image are present. Otherwise, the program stops with a message. The absence of a resource file is not blocking (just a warning); there isn't one in the HelloPascal example.
- Runs the compilation by the ORCA/Pascal compiler, through the Golden Gate emulation layer with the command: "iix compile HelloPascal.pas keep=HelloPascal"
    - Runs the linking of the application, similarly with the command: "iix -DKeepType=S16 link HelloPascal keep=HelloPascal". This step produces the executable in Apple IIGS format (OMF).
- Deletes intermediate files (.a and .root files)
- Detects the presence of a HelloPascal.rez resource file, and compiles it with the command: "iix compile HelloPascal.rez keep=HelloPascal", and extracts the compiled resource into the file HelloPascal_ResourceFork.bin (see example 4)
    - Copies the executable to the disk image specified in the configuration variables, after deleting any existing file with the command: "Cadius ADDFILE HelloPascal". Note: Cadius needs a "_FileInformation.txt" file to define the attributes of the file copied to the disk image. In this case, you must inform Cadius that HelloPascal is a GS/OS Application, type B3 (see Apple documentation). The "_FileInformation.txt" file therefore starts with "HelloPascal=Type(B3)...". The HelloPascal program is now on the disk image and can be run in an emulator or on an Apple IIGS.

The DEPLOY.py Python code is as follows:
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
    
    # Check required files
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
                if not run_command(f"iix export cadius {PRG}", "Exporting resource with Cadius format"):
                    print("WARNING: Export failed, will copy executable directly")
                    has_resources = False


    # --------------- Cadius Disk Operations ---------------
    print("=" * 50)
    print("           Cadius Disk Operations")
    print("=" * 50)
    
    # Determine which file to copy based on whether resources were processed
    file_to_copy = PRG
    print(f"Copying executable to disk: {file_to_copy}")
    # Check that the executable file exists
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
        print("Error detected in Cadius output (DELETEFILE).")
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
        print("Error detected in Cadius output (ADDFILE).")
        cleanup_intermediate_files()
        sys.exit(1)

    cleanup_intermediate_files()
    print()

    # --------------- Done ---------------
    print("=" * 50)
    print("               ✅   SUCCESS   ✅")
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

### Example 2: Simple C Program with Assembly
This example is presented in two different forms in the directories "2.HelloC_1" and "2.HelloC_2".
The same DEPLOY.py script as in example 1 automates compilation and deployment; just adjust lines 17 to 20.
The HelloC program calls assembly functions coded in a separate file.
In "2.HelloC_1", the "asm" declaration is used and calls the mini-assembler integrated in ORCA/C, which allows including assembly parts in the C code. In "2.HelloC_2" the ORCA/M macro assembler is used and offers much more functionality.

Note: The call to the "debug" function allows interrupting the program, for example, to step through the compiled code, as soon as a break is set in the emulator (e.g., Crossrunner) with the conditions: A = $AAAA and X = $BBBB. Other values could have been chosen.

### Example 3: Simple Program with Assembly
The "3.Pasm2" directory provides a similar example in Pascal. It is adapted from an example given in the ORCA/Pascal documentation, "Chapter 5 – Writing Assembly Language Subroutines". The ORCA/M macro assembler is used.

### Example 4: Pascal Program with a Resource File
This example is in the "4.HelloPascal+Rez" directory.
#### Automation steps reminder:
1. Code editing: open the "4.HelloPascal+Rez" directory in Visual Studio Code.
2. Compilation and linking: performed automatically by the Python script (ORCA via Golden Gate)
3. Resource file processing: an extra step after linking is needed because Cadius requires an additional file, in the form {programname_name}_ResourceFork.bin containing the compiled resources (binary).
4. Copy to disk image: performed automatically by the script (Cadius).
5. Test in emulator: once the program is copied, it can be launched in KEGS or Crossrunner.

Step 3 was added compared to previous examples. When a .rez file is detected, the Golden Gate command "iix export cadius {programname_name}" extracts the resource from the compiled and linked program to create this separate binary resource file named {programname_name}_ResourceFork.bin (HelloPascal_ResourceFork.bin in this example). Thus, the Cadius ADDFILE command can write the complete executable, with its resource, to the disk image. This would not have been the case without creating the {programname_name}_ResourceFork.bin file in the same directory as the {programname_name} file.

Moreover, the command "iix export cadius {programname_name}" can generate the required "_FileInformation.txt" file for the "Cadius ADDDFILE {programname_name}" command, thanks to the "-i" option in the command line.

In this example, the "HelloPascal.bat" file performs the same deployment operations as the Python script, in a much simpler and more direct way, and without checks.

### Example 5: Pascal Program Passing Data with Assembly Functions
This example is in the "5.Pasm3" directory.
The Pascal program passes parameters to assembly language functions, which in turn return values to the main program. These functions illustrate parameter passing between code in C compiled by ORCA/Pascal and code in assembly compiled by ORCA/M.

### Example 6: C Program Passing Data with Assembly Functions
This example is in the "6.HelloAsm C" directory.
The C program passes parameters to assembly language functions, which in turn return values to the main program. These functions illustrate parameter passing between code in C compiled by ORCA/C and code in assembly compiled by ORCA/M.



## Conclusion

This guide offers a complete method for cross-developing Apple IIGS applications on PC, relying on modern and accessible tools. By following these steps, you can automate compilation, disk image management, and testing of your programs efficiently.
