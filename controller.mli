open State

(*[controller] represents a player input on the keyboard. controller will
  handle the user input, allowing the user to controll their character and
  interact with the other game*)

(* Controls correspond to keyboard input *)
type move = Space | Left | Right | Up | Down

(*[move_handler m s] is the new state produced after a move m is processed on
  state s the new state represents new state regardless of whether the move was
  possible or not. For example, [move_handler space state] would return a new
  state regardless of whether a girl currently has pillow to throw or not *)
val move_handler : move -> State.state -> State.state
