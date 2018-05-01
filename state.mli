open Actors
(* The [state] of the game represents all the variables and information
* necessary for any instance of gameplay. [state] is essential in
* gameplay because it is responsible for keeping track of every
* possible mutable objects and interactions in the game. It is updated
* and called on constantly when the game is running. *)

(* The implementation of type will serve to store all information
 * required to run the game. Perhaps a record would be good.*)
 type collision =
   | GirlOnWall of girl * furniture
   | GirlOnPillow of girl * pillow
   | PillowOnGirl of pillow * girl

type st = {
  mutable bloom: girl;
  mutable soap: girl;
  mutable mcup: girl;
  mutable pillows: pillow list;
  mutable collisions: collision list;
  mutable scores: (string * int) list;
  mutable time: float;
}

type move = {
  mutable up: bool;
  mutable down: bool;
  mutable left: bool;
  mutable right: bool;
  mutable space: bool;
}

(* The following methods are accessors *)

(* Returns: a list of pillows currently on the map*)
val pillows: st -> pillow list

(* Returns: the professor in the game. *)
(* val prof: state -> Actors.people *)

(* Returns: the bed object*)
(* val bed: state -> Actors.furniture *)

(* Returns: a list of collisions that are taking place in [state]*)
val collisions: st -> collision list

(* Returns: An association list with each girl and her score.*)
val scores: st -> (string * int) list

(* Returns: the global timer in the game before game ends.*)
val time: st -> float

(* The REPL that updates the game state after every frame.
 * Checks for statuses of many game methods, increments time, keeps
 * track of score, collisions, girl positions, professor, pillows.*)
val update_st: st -> st

(*[move_handler m s] is the new state produced after a move m is processed on
  state s the new state represents new state regardless of whether the move was
  possible or not. For example, [move_handler space state] would return a new
  state regardless of whether a girl currently has pillow to throw or not *)
val move_handler : move -> st -> st

(* effects: [collisionHandler cl st] updates the state depending on the collision.
   For example, if a girl collides with a pillow, the state should be updated
   with the girl holding the pillow. Another example: when the girls collides
   with the bed, the girl should slow down.
  returns: the updated state *)
val collisionHandler: collision -> st -> st

val update_all: Dom_html.canvasRenderingContext2D Js.t -> unit

val keydown: Dom_html.keyboardEvent Js.t -> bool Js.t

val keyup: Dom_html.keyboardEvent Js.t -> bool Js.t
