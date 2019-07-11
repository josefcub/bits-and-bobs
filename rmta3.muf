@edit rmta3.muf
1 999 d
i
( RMTA 3: "A Better Way"          BlueDevil - 11/07/2002 )
( ---------------[ Documentation Begins ]--------------- )
( Rathan Mass Transit Authority is a program designed to )
( have a bus follow a specified route.  The only twist   )
( is that a room on the route has to have a property     )
( called "busok?" installed on it in order for the bus   )
( to emit omessages, allow passengers inside the bus to  )
( leave, and allow new passengers to board.  This setup  )
( allows for spam-prevention, and keeps it more extens-  )
( ible, for creation of fast-moving trains, airplanes,   )
( etc.                                                   )
(                                                        )
( *** WARNING ***                                        )
( RMTA.muf is an "infinite loop" program.  It does not   )
( terminate naturally, and requires a manual @kill in    )
( order to shut it down.  Please contact a local Wizard  )
( for permission to use this program in any of your own  )
( projects or areas.  Unauthorized trams will be @killed )
( on sight, and you may be punished.                     )
(                                                        )
( Set these properties on the indicated object:          )
( On the bus object:                                     )
(    bus/arrive - Message displayed to station on bus'   )
(                 arrival.  MPI Aware.                   )
(    bus/depart - Message displayed to station when bus  )
(                 leaves the station.  MPI Aware.        )
(     bus/dests - space-separated list of dbref numbers  )
(                 that comprises the desired route.      )
(    bus/egress - dbref number of the exit which leads   )
(                 from the bus to the outside world.     )
(    bus/ingres - dbref number of the exit which leads   )
(                 to the bus interior                    )
(  bus/interior - dbref number of the room which makes   )
(                 up the bus' interior.                  )
(   bus/passmsg - Message displayed to users when bus    )
(                 is just passing through.  MPI Aware.   )
(   bus/stopmsg - Message displayed to users when bus    )
(                 stops in a bus-ok area.  MPI Aware.    )
(     bus/timer - The time [in seconds] it takes to move )
(                 from room-to-room in the route.        )
(     bus/route - [optional] This prop can be used to    )
(                 store the bus' route name and info,    )
(                 useful when using MPI in the messages. )
(                                                        )
( On the bus stop rooms:                                 )
(    busok?     - Signifies that this room is acceptable )
(                 for bus ingres/egress.  Value is not   )
(                 important.  If you don't want a stop   )
(                 here, then erase this property.        )
( ----------------[ Documentation Ends ]---------------- )
 
( These come in handy for customizing RMTA.              )  
$def arrive   "bus/arrive"
$def depart   "bus/depart"
$def dests    "bus/dests"
$def egress   "bus/egress"
$def ingres   "bus/ingres"
$def interior "bus/interior"
$def passmsg  "bus/passmsg"
$def stopmsg  "bus/stopmsg"
$def route    "bus/route"
$def timer    "bus/timer"
 
( omessage - Notifies the room in which the bus resides  )
(            the specified property's message, but only  )
(            if the room is set "busok?".                )
: omessage ( s -- )
  trig location                       
  dup location "busok?" getpropstr    
  if                                  
    dup rot "" 0 parseprop            
    swap location #-1                 
    rot notify_except                 
  else
    pop pop
  then
;
 
( run_route - The actual run loop, which moves the bus   )
(             from room-to-room based on the "bus/dests" )
(             dbref list.                                )
: run_route ( -- )

  trig location dests getpropstr
  " " explode pop

  ( Only if there IS a route list.     )
  dup "" stringcmp if
    begin depth while                  
 
      ( We need top item as a dbref.   )      
      atoi dbref
 
      ( Notify old room before move.   )
      depart omessage     
      
      ( Move the bus to the new room.  )
      ( I had to jump through hoops to )
      ( avoid a ton of 'trig location' )
      trig location 
      dup rot moveto
 
      ( Notify new room after move.    )
      arrive omessage 
 
      ( Two jobs--One, get either a    )
      ( stop or passthrough message    )
      ( and Two, set the locks on the  )
      ( bus doors--both depending on   )
      ( "busok?" in the new room.      )
      dup location "busok?" getpropstr 
      if                               
        dup stopmsg "" 0 parseprop
        swap dup egress getpropstr 
        atoi dbref "" setlockstr pop      
        dup ingres getpropstr            
        atoi dbref "" setlockstr pop
      else
        dup passmsg "" 0 parseprop
        swap dup egress getpropstr 
        atoi dbref "me&!me" setlockstr pop
        dup ingres getpropstr
        atoi dbref "me&!me" setlockstr pop
      then 
 
      ( Last thing, notify passengers. )
      interior getpropstr
      atoi dbref #-1 rot notify_except
 
      ( Sleep until it's time to move. )
      trig location timer getpropstr
      atoi sleep
    repeat 
  then
;
 
( messageedit - Edit a message string property.          )
: messageedit ( -- s )
  "Enter value, or type '.' to abort entry." me @ swap notify
  read
  dup "." stringcmp not if
    pop "" exit
  then
;
 
( bus_setup - Provides a user-friendly way to set up a   )
(             mass-transit vehicle for its route.  Feat- )
(             ures runtime range and bounds checking,    )
(             and an abort feature for editing.          )
: bus_setup ( -- )
  begin
    "Transit Vehicle Editor            RMTA-3" me @ swap notify
    "----------------------------------------" me @ swap notify
    " 1.            Description: '" 
    trig location route getpropstr "'." strcat strcat me @ swap notify
 
    " 2.       Route DBRef List: '"
    trig location dests getpropstr "'." strcat strcat me @ swap notify
 
    " 3.     Vehicle Exit DBRef: '"
    trig location egress getpropstr "'." strcat strcat me @ swap notify
 
    " 4. Vehicle Entrance DBRef: '" 
    trig location ingres getpropstr "'." strcat strcat me @ swap notify
 
    " 5. Vehicle Interior DBRef: '"
    trig location interior getpropstr "'." strcat strcat me @ swap notify
 
    " 6.        Arrival Message: [...]" me @ swap notify
    " 7.      Departure Message: [...]" me @ swap notify
    " 8.       Stopping Message: [...]" me @ swap notify
    " 9.        Transit Message: [...]" me @ swap notify
    "10.           Transit Time: "
    trig location timer getpropstr " seconds." strcat strcat me @ swap notify
    "----------------------------------------" me @ swap notify
    "'The Better Way'       (C)2002 BlueDevil" me @ swap notify
    "----------------------------------------" me @ swap notify
    "Enter '1' to '10', or 'Q' to QUIT." me @ swap notify
    read
    dup "Q" stringcmp not if 
      "----------------------------------------" me @ swap notify
      "Please make sure all vehicle settings" me @ swap notify
      "are correct before activating your" me @ swap notify
      "mass transit vehicle." me @ swap notify
      "----------------------------------------" me @ swap notify
      "Done." me @ swap notify
      exit
    then
    dup "1" stringcmp not if
      "Description" me @ swap notify
      "-----------" me @ swap notify
      me @ trig location route getpropstr notify
      "-----------" me @ swap notify
      messageedit
      dup if
        trig location route rot setprop
      else
        pop
      then
    then
    dup "2" stringcmp not if
      "Routing DBRef List" me @ swap notify
      "------------------" me @ swap notify
      "This vehicle goes to the following rooms: "
      trig location dests getpropstr strcat
      "." strcat me @ swap notify
      "------------------" me @ swap notify
      messageedit
      dup if
        trig location dests rot setprop
      else
        pop
      then
    then
    dup "3" stringcmp not if
      "Vehicle Exit DBRef" me @ swap notify
      "------------------" me @ swap notify
      "This vehicle's exit is number '"
      trig location egress getpropstr strcat
      "'." strcat me @ swap notify
      "------------------" me @ swap notify
      messageedit
      dup if
        trig location egress rot setprop
      else
        pop
      then
    then
    dup "4" stringcmp not if
      "Vehicle Entrance DBRef" me @ swap notify
      "----------------------" me @ swap notify
      "This vehicle's entrace is dbref '"
      trig location ingres getpropstr strcat
      "'." strcat me @ swap notify
      "----------------------" me @ swap notify
      messageedit
      dup if
        trig location ingres rot setprop
      else
        pop
      then
    then
    dup "5" stringcmp not if
      "Vehicle Interior" me @ swap notify
      "----------------" me @ swap notify
      "This vehicle's passenger cabin is dbref number '"
      trig location interior getpropstr strcat
      "'." strcat me @ swap notify
      "----------------" me @ swap notify
      messageedit
      dup if
        trig location interior rot setprop
      else
        pop
      then
    then
    dup "6" stringcmp not if
      "Vehicle Arrival Message" me @ swap notify
      "-----------------------" me @ swap notify
      me @ trig location arrive getpropstr notify
      "-----------------------" me @ swap notify
      messageedit
      dup if
        trig location arrive rot setprop
      else
        pop
      then
    then
    dup "7" stringcmp not if
      "Vehicle Departure Message" me @ swap notify
      "-------------------------" me @ swap notify
      me @ trig location depart getpropstr notify
      "-------------------------" me @ swap notify
      messageedit
      dup if
        trig location depart rot setprop
      else
        pop
      then
    then
    dup "8" stringcmp not if
      "Vehicle Stopping Message" me @ swap notify
      "------------------------" me @ swap notify
      me @ trig location stopmsg getpropstr notify
      "------------------------" me @ swap notify
      messageedit
      dup if
        trig location stopmsg rot setprop
      else
        pop
      then
    then
    dup "9" stringcmp not if
      "Vehicle In Transit Message" me @ swap notify
      "--------------------------" me @ swap notify
      me @ trig location passmsg getpropstr notify
      "--------------------------" me @ swap notify
      messageedit
      dup if
        trig location passmsg rot setprop
      else
        pop
      then
    then
    "10" stringcmp not if
      "Transit Time" me @ swap notify
      "------------" me @ swap notify
      "This vehicle waits " trig location timer getpropstr strcat
      " seconds in each room of the route." strcat me @ swap notify
      "------------" me @ swap notify
      messageedit
      dup if
        trig location timer rot setprop
      else
        pop
      then
    then
  repeat  
;
 
( setup - Wrapper for bus_setup that checks for a Wizard )
(         bit and/or ownership of the vehicle involved.  )
: setup ( -- )
 
  ( Wizards always have access. )
  me @ "W" flag? if
    bus_setup
    exit
  then  
 
  ( Otherwise, only the owner. )
  trig location owner int
  me @ int = if
    bus_setup
  else
    "You are not the owner of this vehicle." me @ swap notify
    exit
  then
;  

( showhelp - Shows the user an appropriate help screen.  )
: showhelp ( -- )
 "----------------------------------------"
 "          this program in your project. "
 "          Wizards' blessing before using"
 "          Make SURE you have your local "
 "          uired to stop a running bus.  "
 "          inite loop, and @kill is req- "
 "WARNING - This program runs in an inf-  "
 "----------------------------------------"
 "           route."
 "  #start - Starts the bus object on its "
 "           service."
 "  #setup - Sets up the bus object for   "

 "   #help - This screen."
 "Command-line parameters:"
 "----------------------------------------"
 " RMTA Mass Transit    (C)2002 BlueDevil"
 "----------------------------------------"
 begin depth while me @ swap notify repeat
;
 
( main - Main word executed.  This throws the program    )
(        into the background, and executes run_route     )
(        repetitively.                                   )
: main 
  dup "#help" stringcmp not if
    pop showhelp exit
  then
  dup "#start" stringcmp not if
    pop
    background
    begin 
      run_route 
    repeat
  then
  "#setup" stringcmp not if
    setup
    exit 
  then
  "RMTA: Try '" trig name strcat " #help' for help." strcat
  me @ swap notify
;
.
c
q
