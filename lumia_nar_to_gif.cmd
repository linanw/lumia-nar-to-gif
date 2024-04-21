@SETLOCAL ENABLEDELAYEDEXPANSION & python -x "%~f0" %* & EXIT /B !ERRORLEVEL!

# The first line is to allow the script to be run from a batch file

import os
import shutil
import sys
import subprocess
import zipfile
import time
import xml.etree.ElementTree as ET

# Get the command line argument
source_file = sys.argv[1]
# Print the argument
print(f"The source_file is: {source_file}")

# Get the current time tick
current_tick = int(time.time())

# Print the current time tick
destination_folder = f'./temp_{current_tick}/'

output_file = os.path.splitext(os.path.basename(source_file))[0] + '.gif'

# Extract the zip file
with zipfile.ZipFile(source_file, 'r') as zip_ref:
    zip_ref.extractall(destination_folder)

# Create the destination folder if it doesn't exist
if not os.path.exists(destination_folder):
    os.makedirs(destination_folder)

file_type = os.path.splitext(os.path.basename(source_file))[0].split('_')[-1]

pose = '4'
framerate = '5'
if file_type == 'Cinemagraph':
    # Path to the XML file
    xml_file = os.path.join(destination_folder,'cinemagraph.xml')
    # Parse the XML file
    tree = ET.parse(xml_file)
    # Get the root element
    root = tree.getroot()
    # Find the framerate_field you want to read
    framerate_field = root.find('application_specific/captureFrameRate')
    # Check if the framerate_field exists
    if framerate_field is not None:
        # Get the value of the framerate_field
        framerate = framerate_field.text
        
        # Print the framerate_field value
        print(f"The value of the framerate_field is: {framerate}")
    else:
        print("framerate_field not found in the XML file.")

    # Find the captureOrientation_field you want to read
    captureOrientation_field = root.find('captureOrientation')
    # Check if the captureOrientation_field exists
    if captureOrientation_field is not None:
        # Get the value of the captureOrientation_field
        captureOrientation = captureOrientation_field.text
        
        # Print the captureOrientation_field value
        print(f"The value of the captureOrientation_field is: {captureOrientation}")
    else:
        print("captureOrientation_field not found in the XML file.")

    # Use switch case to set the value of pose based on captureOrientation
    if captureOrientation == 'PortraitUp':
        pose = '1'
    elif captureOrientation == 'PortraitDown':
        pose = '3'
    elif captureOrientation == 'LandscapeLeft':
        pose = '4'
    elif captureOrientation == 'LandscapeRight':
        pose = '2'

druation = 1/int(framerate)

# Get a list of all files in the source folder
files = os.listdir(destination_folder)

# Loop through each file and check if it's a JPG file
# and find the maximum length of the file name
max_length = 0
for file in files:
    if not file.endswith('.jpg'): continue
    
    # Get the file name without extension
    file_name = os.path.splitext(file)[0]
    
    # Check if the file name is a number
    if not file_name.isdigit(): continue
    
    # Find the maximum length of the file name
    max_length = max(len(file_name), max_length)

# Loop through each file and rename it to a fixed length
for file in files:
    if not file.endswith('.jpg'): continue
    
    # Get the file name without extension
    file_name = os.path.splitext(file)[0]
    
    # Check if the file name is a number
    if not file_name.isdigit(): continue

    # Construct the source and destination paths
    source_path = os.path.join(destination_folder, file)
    destination_path = os.path.join(destination_folder, file_name.zfill(max_length) + '.jpg')

    # Rename the file
    os.rename(source_path, destination_path)

# generate file list to a file
files = os.listdir(destination_folder)
file_list_file = os.path.join(destination_folder, 'file_list.txt')
with open(file_list_file, 'w') as f:
    files.sort()
    for file in files:
        if not file.endswith('.jpg'): continue        
        # Get the file name without extension
        file_name = os.path.splitext(file)[0]
        # Check if the file name is a number
        if not file_name.isdigit(): continue
        f.write(f"file '{file}'\n")
        f.write(f"duration {druation}\n")

# Print the destination folder
print(f"The destination folder is: {destination_folder}")

# Print the pose
print(f"The pose is: {pose}")

# Print the framerate
print(f"The framerate is: {framerate}")

# Print the output file
print(f"The output file is: {output_file}")

# Print the file list file
print(f"The file list file is: {file_list_file}")

# Call the command
command = f'ffmpeg -y -f concat -safe 0 -i {file_list_file} -an -b:v 1M -vf "transpose={pose}" -r {framerate} {output_file}'
result = subprocess.run(command, shell=True, capture_output=True, text=True)

# Print the output
print(result.stdout)

# Remove the temp folder
shutil.rmtree(destination_folder)

# Print the output file
print(f"The output file is: {output_file}")