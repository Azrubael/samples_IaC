#!/usr/bin/python3

import random


def time_activity(*args, **kwargs):
    """A function with keyworded arguments *kwargs
    Input: Multiple values for minutes and key=value activities
    Output: Return sum of minutes + random minute spect on a random activity
    """
    minutes = sum(args) + random.randint(0,60)
    choice = random.choice(list(kwargs.keys()))
    
    print(args)
    print(kwargs)
    print(f"All the activities take {minutes} minutes")
    print(f"A randomly selected activity is '{choice}'")
    print(f"Today you have to spend {minutes} minutes for {kwargs[choice]}!")
    
    
time_activity(10, 20, 10, \
    hobby="Dance", sport="Boxing", fun="Driving", work="DevOps")
