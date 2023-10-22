# autohotkey-game-record-playback
Tool for record and playback game input based on neural networks image classification. Suitable for autotesting.

# Overview
https://www.youtube.com/watch?v=RrRIE1z0XGw

This tool is a game input recorder and player built using AutoHotKey, a powerful scripting language for Windows automation. The tool allows you to record input sequences while playing a game and later replay them for testing or automation purposes. Work together with TensorFlow based image classification.

# Features
- Capture and record your keystrokes and mouse movements while playing a game.
- Replay the recorded input sequences exactly as they were recorded, simulating the original gameplay.
- Define your own hotkeys to record.
- File of recording can be edited.
- Find visual bugs like black screen stuck and purple missing shader problems.
- Adopted to Assasins Creed Valhala record/playback that analyze screen and do state based logic.
- Neural Network image classification for camera horizon stabilization based on AC Valhalla training set

# Installation
- Download and install AutoHotKey v.1 https://www.autohotkey.com/
- Version 2.0 is not supported
- Put sources to any location you want

NN requirments
- Python 3.10
- pip install tensorflow-cpu==2.10 tensorflow-directml-plugin opencv-python matplotlib
- DX12 support for GPU training and execution acceleration
https://learn.microsoft.com/en-us/windows/ai/directml/gpu-tensorflow-plugin

# Getting Started
1. Run program that you want to record in window mode
1. Run MouseExtendRecord.ahk
1. Make recording window active
1. Hit F5
1. Do actions
1. Hit F12 to stop
1. Save plackback as .ahk file
1. To edit recorded keys open MouseExtendRecord.ahk in any text editor. VS Code with AHK plugin prefarable. Edit keys

# Changlelog
2023.07 
- Initial

2023.10
- Added Tensorflow Keras image classification for stabilize camera horizon
- Added windows auto layout for easier workflow
- Separate classic record and neural networks 

# Contact
For any questions or inquiries, please reach out to kostiantyn.dvornik@gmail.com
