affirm_set = set(affirm.lower() for affirm in ("yes", "si", "ne", "oo"))
deny_set = set(deny.lower() for deny in ("no","ani","hindi"))
while True:
    response = input("Are you human?: ")
    if response.lower() in affirm_set: 
        print("Are you sure?")
        print()
    elif response.lower() in deny_set: 
        print("Peharps, are you sure?")
        print()
    elif response.lower() == "xmd bypass":
        print("Affirmative")
        print()
        break
    else :
        print("We don't get that. Please answer correctly")
        print()
    

  

