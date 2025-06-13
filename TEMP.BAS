SUB SETPORTS
def seg=&h40
poke 0,&hf8  '03F8  sets com1 address irq 4
poke 1,&h03
poke 2,&hf8  '02F8  sets com2 address irq 3
poke 3,&h02
poke 4,&he8  '03E8  sets com3 address irq 4
poke 5,&h03
poke 6,&he8  '02E8  sets com4 address irq 3
poke 7,&h02
def seg
