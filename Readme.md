# A configuration for cross-development of Apple IIGS applications on PC

## Table of Contents
1. Introduction
2. Basic prerequisites on the PC
3. Specific prerequisites for Apple IIGS cross-development
4. Compilation process
5. Examples

## 1. Introduction
This document is intended for developers wishing to use their PC for cross-development for the Apple IIGS. Its purpose is to provide detailed feedback on one solution, among others, for cross-developing Apple IIGS applications in third-generation languages (Pascal and C), using a Windows PC and ORCA. It is not an introduction to these programming languages or to the ORCA environment, but a description of the tools and their configuration. Prior knowledge of ORCA tools and Pascal or C languages is required.

Note: There are other cross-development solutions from PC to Apple IIGS, especially with the Merlin32 compiler for assembly language projects.

## 2. Basic prerequisites on the PC
- **Windows 10 or 11**: tested on Windows 11, but compatible with Windows 10.
- **Visual Studio Code**: the core of the proposed solution. Free, powerful, modular, extensible, easy to use, also available on Macintosh and Linux. The code editor is particularly powerful.
- **Python**: used to compile source files via a script, but not mandatory (batch or PowerShell possible).
- **Apple IIGS Emulator**: preference for Crossrunner (French keyboard mapping, debugger, presentation, etc.), KEGS is an alternative (with Cyrene from Brutal Deluxe for debugging). Testing on a real Apple IIGS remains essential.

## 3. Specific prerequisites for Apple IIGS cross-development
- **ORCA (Byte Works)**: development environment for Apple II, compilers for several languages (Assembler, C, Pascal, Modula, Basic, etc.). Available in the OPUS II package on juiced.com, paid. Allows you to compile and link programs for Apple IIGS.
- **Golden Gate (Kelvin Sherlock)**: compatibility layer for ORCA (and GNO/ME), allows ORCA programs to run on PC for Apple IIGS. Available on juiced.com, paid. Installing Golden Gate automatically updates the Windows PATH environment variable. Acts as an interface between ORCA tools and the Windows environment to facilitate cross-development.
- **Ciderpress II (faddenSoft)**: free Windows application for working with disk images.
- **Cadius (Brutal Deluxe)**: command-line tool for managing Apple II disk image files on Windows. Allows you to add, delete, or modify files on a disk image. It is much more convenient if the "Cadius.exe" file is in the Windows PATH so it can be run from any directory. There is no installer; the user must ensure this if desired.
- **A disk image with an OS (GS/OS)**: required to start the emulator and run the software in its target environment (ProDOS, GS/OS, etc.).

## 4. Compilation process
The general principle is as follows:

| Step | Description                              | Tool(s)                |
|------|------------------------------------------|------------------------|
| 1    | Code editing                             | Visual Studio Code     |
| 2    | Compilation                             | Golden Gate / ORCA     |
| 3    | Linking                                  | Golden Gate / ORCA     |
| 4    | Resource compilation (if needed)         | Golden Gate / ORCA     |
| 5    | Copy to disk image                       | Cadius                 |
| 6    | Test/run in emulator                     | KEGS or Crossrunner    |

Step 4 is only necessary if the code uses a resource file.

## Examples
### Example 1: Pascal program without resource file
### Steps:
- Code editing: open Visual Studio Code, then select File/Open Folder and choose the "1.HelloPascal" directory.
- Compilation: adapt the configuration variables (see below).
- Linking: performed automatically by the script.
- Copy to disk image: performed automatically by the script.
- Test in emulator: once the program is copied, it can be launched in KEGS or Crossrunner.

### The code (HelloPascal.pas):
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
- First, adapt the configuration variables:
    - Edit line 19 by replacing "C:\\Apple IIgs\\Disks\\System.po" with the full path to your own disk image containing a GS/OS system.
    - Edit line 20 by replacing /SYSTEM/ with the destination prefix on this disk image.
    - Lines 17 and 18 respectively designate the name of the main program file and the extension (.pas, .c, .cc, etc., which tells ORCA which language and thus which compiler to use). These two lines are already correctly set for the HelloPascal example.
- In the "TERMINAL" window of Visual Studio Code, run the Python script with the command: python DEPLOY.py

**The Python script compiles and links the HelloPascal code, then copies the executable in OMF (Object Module Format) to the disk image you have chosen.**

For subsequent compilations, simply rerun the command: python DEPLOY.py

#### What does the python DEPLOY.py program do?
- It checks that Cadius.exe and iix.exe (Golden Gate executable) are accessible, i.e., in the Windows PATH. Otherwise, the program stops with a message.
- It recalls the configuration variables, defined in lines 17 to 20, to be adapted for each project. These are the only pieces of information the Python program needs.
- It checks that the main file is present, as well as the disk image. Otherwise, the program stops with a message. The absence of a resource file is not blocking (just a warning); there is none in the HelloPascal example.
- It compiles using the ORCA/Pascal compiler, through the Golden Gate emulation layer with the command: "iix compile HelloPascal.pas keep=HelloPascal"
- It performs linking of the application, in the same way with the command: "iix -DKeepType=S16 link HelloPascal keep=HelloPascal". This step produces the executable in Apple IIGS format (OMF)
- It deletes intermediate files (.a and .root files)
- It detects the presence of a resource file HelloPascal.rez, and compiles it with the command: "iix compile HelloPascal.rez keep=HelloPascal", and extracts the compiled resource into the file HelloPascal_ResourceFork.bin (see example 4)
- It copies the executable to the disk image specified in the configuration variables, after deleting any existing file. Note: Cadius needs a "_FileInformation.txt" file to define the attributes of the file copied to the disk image. In this case, you must inform Cadius that HelloPascal is a GS/OS Application. The "_FileInformation.txt" file therefore begins with "HelloPascal=Type(B3)...". The HelloPascal program is now on the disk image and can be run in an emulator or on an Apple IIGS.

### Example 2: C program without resource file
This example is in the "2.HelloC" directory.
The principle is the same. The only difference is that the HelloC program calls assembler functions coded in a separate file, asm.h. In addition to ORCA/C, the ORCA/M macro assembler is required to compile this program.

Note: In the asm.s module, calling the "debug" function allows you to interrupt the program, for example, to step through the compiled code, as soon as a break is set in the emulator (Crossrunner, for example) with the conditions: A = $AAAA and X = $BBBB. Other values could have been chosen.

### Example 3: Pascal program without resource file, with assembler
The "3.Pasm2" directory provides a similar example in Pascal. It is taken from an example given in the ORCA/Pascal documentation, "Chapter 5 – Writing Assembly Language Subroutines".

### Example 4: Pascal program with a resource file
#### Steps:
1. Code editing: open the "4.HelloPascal+Rez" directory in Visual Studio Code.
2. Compilation and linking: performed automatically by the Python script (ORCA via Golden Gate)
3. Resource file handling: an additional step after linking is necessary because Cadius needs an extra file, in the form {programname_name}_ResourceFork.bin containing the compiled resources (binary).
4. Copy to disk image: performed automatically by the script (Cadius).
5. Test in emulator: once the program is copied, it can be launched in KEGS or Crossrunner.

Step 3 is added compared to previous examples. The Golden Gate command "iix export cadius {programname_name}" extracts the resource from the compiled and linked program to create this separate binary resource file. Thus, the Cadius ADDFILE command can write the complete executable with its resource to the disk image. This would not have been possible without creating the {programname_name}_ResourceFork.bin file in the same directory as the {programname_name} file.

In this example, the "rez1.bat" file performs the same deployment operations as the Python script, in a simpler way but without checks.
