#!/usr/bin/python3


def order_food(min_order, *args):
"""A function with non-keyworded arguments *args """

    print(f"The args is of {type(args)}")
    print(f"You have ordered: {min_order}")
    if len(args) > 0:
        for i in args:
            print(f"and a {i}")
    print("Your food will be delivered in 30 minutes,")
    print("Enjoy Your party!")


def time_activity(min_order, *args):
"""A function with keyworded arguments *kwargs"""
    

    
order_food("Salad", "Pizza", "Biryani", "Soup")
print("8"*20)
