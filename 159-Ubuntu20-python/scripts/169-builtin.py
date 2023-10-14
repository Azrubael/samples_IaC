#!/usr/bin/python3

seq = ('192', '168', '56', '19')
print(".".join(seq))

num = [':','32']
addr = list(seq).extend(num)
print(addr)
print()

level = ((1,1,1,1,1,1),
         (1,0,0,0,0,1),
         (1,0,0,0,0,1),
         (1,0,0,0,0,1),
         (1,0,0,0,0,1),
         (1,1,1,1,1,1))
print(level)
print()
# list of lists
newlist = [list(i) for i in level]
print(newlist)
print()
# --- OR ---
L = [[*row] for row in level]
print(L)
print()
# --- OR ---
mylist = map(list, level)
print(list(mylist))