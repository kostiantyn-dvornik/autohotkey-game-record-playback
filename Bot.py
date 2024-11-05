from game import playutils
import sys
import keyboard
import pydirectinput
import globals

#[gen]
from States.hit_enemy import state_hit_enemy
from States.horizont import state_horizont
from States.walk import state_walk
from States.stuck import state_stuck
from States.stuck_walk import state_stuck_walk
from States.find_enemy import state_find_enemy
from States.road import state_road
from States.follow_road import state_follow_road
from States.reset import state_reset

#[gen]
states = {
    "hit_enemy" : state_hit_enemy, 
    "horizont" : state_horizont,
    "walk" : state_walk,
    "stuck" : state_stuck, 
    "stuck_walk" : state_stuck_walk,
    "find_enemy" : state_find_enemy,
    "road" : state_road,
    "follow_road" : state_follow_road,
    "reset" : state_reset,
}

paused = False
local_state = ""

def stop_script():
    global paused

    if keyboard.is_pressed("f4"):        
        states[local_state].on_stop()
        
        print("Stopped")
        playutils.keys_up()    
        sys.exit()

    if keyboard.is_pressed("f7"):
        if not paused:
            print("Paused")
            playutils.keys_up()
            paused = True
        else:        
            print("Continue")        
            paused = False

def start():    
    for state in states.values():
        state.start()

def transit_in():
    global local_state

    if local_state != "":
        states[local_state].on_stop()

    states[globals.CURRENT_STATE].on_transit_in()
    
    local_state = globals.CURRENT_STATE

    print("")

def update():
    if globals.CURRENT_STATE != local_state:
        print("Transint to " + globals.CURRENT_STATE)
        transit_in()
    
    states[globals.CURRENT_STATE].update()

def main():

    local_state = globals.CURRENT_STATE
    start()

    while True:
        stop_script()

        if not paused:
            update()

pydirectinput.FAILSAFE = False

print("\nPress ENTER to begin")
print("Press F7 to Play/Pause")
print("Press F4 to stop")

keyboard.wait("enter")
main()