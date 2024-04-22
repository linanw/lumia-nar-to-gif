# Convert Nokia Lumia *.nar file to gif animation
Code is Python embedded in a Windows CMD file. 
## Compatibility
1. *_Cinemegraph.nar
2. *_Smart.nar
## prerequisite
1. Python 3.x
2. ffmpeg 7.x or above
3. Pillow module (optional, help to set output gif file's modification date time as the nar's taken time)
   - pip install Pillow
## Usage
lumia_narto_gif.cmd <file_path\file_name.nar>

Use gif_all.cmd to convert all *.nar files in curretn folder.

## Example
nar file in example folder, was coverted to gif below.

![sample gif](./Sample/WP_20131231_12_20_24_Smart.gif)