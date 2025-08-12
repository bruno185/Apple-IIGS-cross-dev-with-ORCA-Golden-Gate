
#
# Script Python to comile and deploy a program for Apple IIGS 
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
PRG = "pasm2"  # Program name without extension
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
                if not run_command(f"iix export cadius {PRG}", "Exporting resource with Cadius format"):
                    print("WARNING: Export failed, will copy executable directly")
                    has_resources = False
    
    # Delete intermediate files
    print("\nCleaning intermediate files...")
    intermediate_files = [f"{PRG}.a", f"{PRG}.root", f"{PRG}.sym"]
    for file in intermediate_files:
        if os.path.exists(file):
            os.remove(file)
            print(f"Deleted: {file}")
    
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
    subprocess.run(f'Cadius.exe DELETEFILE "{AppleDiskPath}" {ProdosDir}{file_to_copy}', 
                  shell=True, capture_output=True)
    # Add new file to disk
    if not run_command(f'Cadius.exe ADDFILE "{AppleDiskPath}" {ProdosDir} .\\{file_to_copy}', 
                      "Adding executable file to Apple disk"):
        sys.exit(1)
    
    # --------------- Done ---------------
    print("=" * 50)
    print("           Compilation Complete!")
    print("=" * 50)

    if has_resources:
        print(f"Program {PRG} with resources successfully compiled and deployed!")
    else:
        print(f"Program {PRG} successfully compiled and deployed!")

    print(f"Deployed to: {AppleDiskPath}{ProdosDir}")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nOperation cancelled by user.")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)
