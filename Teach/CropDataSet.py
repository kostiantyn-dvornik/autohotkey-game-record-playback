import os
import cv2
from matplotlib import pyplot as plt
import numpy as np
import sys
from PIL import Image
import keyboard

nnsize = 256
nn_outputs = 0

posx = 0
posy = 0
grabsize = 0

dataset_dir = ""

#[use]
state = "stuck"

script_directory = os.path.dirname(os.path.abspath(sys.argv[0]))
state_dir = os.path.join(script_directory, "..", "States", state)
sys.path.append(state_dir)

global_dir = os.path.join(script_directory, "..")
sys.path.append(global_dir)

#[gen]
import state_stuck as st

params = st.params
nnsize = params.get('nnsize', 256)
nn_outputs = 0
posx = params.get('posx', 0)
posy = params.get('posy', 0)
grabsize = params.get('grabsize', 0)

processed_images = 0

def set_global_params():
    global dataset_dir, nn_outputs
    
    for folder_name in os.listdir(state_dir):

        folder_path = os.path.join(state_dir, folder_name)

        # Check if the folder is actually a directory and contains the state value
        if os.path.isdir(folder_path) and "dataset" in folder_name:                                           
            dataset_dir = folder_path

            # List all items in the specified folder
            items = os.listdir(folder_path)

            # Count subfolders
            nn_outputs = sum(1 for item in items if os.path.isdir(os.path.join(folder_path, item)))

            return

# Function to check resolution of an image
def get_image_resolution(image_path):
    with Image.open(image_path) as img:
        return img.size  # (width, height)

def crop_image(image_path, crop_point=(0, 0), target_size=(128, 128)):
    global processed_images
    with Image.open(image_path) as img:
        width, height = img.size
        x, y = crop_point

        # Ensure the crop area doesn't exceed image bounds
        if x + target_size[0] > width:
            x = width - target_size[0]
        if y + target_size[1] > height:
            y = height - target_size[1]
        
        # Crop the image
        cropped_img = img.crop((x, y, x + target_size[0], y + target_size[1]))
        
        if processed_images == 0:
            processed_images += 1
             # Show preview of cropped image
            cropped_img.show()  # This will open the image in the default viewer
            
            # Ask user if they want to save the cropped image
            save_choice = input(f"Do you want to save the cropped image {image_path}? (y/n): ").strip().lower()
            if save_choice == 'y':
                cropped_img.save(image_path)  # Overwrites the original image
                print(f"Cropped image saved at {image_path}")
            else:
                print(f"Cropped image not saved for {image_path}")
        else:
            cropped_img.save(image_path)  # Overwrites the original image
            processed_images += 1

# Function to iterate through files in folder recursively
def check_images_resolution(folder_path):        
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp', '.gif', '.tiff')):
                image_path = os.path.join(root, file)
                try:
                    resolution = get_image_resolution(image_path)
                    print(f"Image: {file}, Resolution: {resolution}")

                    # Check if resolution is wrong
                    if resolution != (grabsize, grabsize):
                        print(f"Cropping {file} from point {(posx,posy)}")
                        crop_image(image_path, (posx,posy), (grabsize,grabsize))

                except Exception as e:
                    print(f"Could not open {file}: {e}")

# Specify the folder path you want to check
set_global_params()
if grabsize ==0:
    print("Dataset have full image size")
    sys.exit()
else:
    print("Press F7 to start State: " + state + " " + str(grabsize))
    keyboard.wait("f7")    
    check_images_resolution(dataset_dir)