open Actors
(* The [state] of the game represents all the variables and information
* necessary for any instance of gameplay. [state] is essential in
* gameplay because it is responsible for keeping track of every
* possible mutable objects and interactions in the game. It is updated
* and called on constantly when the game is running. *)

(* The implementation of type will serve to store all information
 * required to run the game. Perhaps a record would be good.*)
 type collision =
   | GirlOnPillow of girl * pillow
   | PillowOnGirl of pillow * girl

type st = {
  mutable bloom: girl;
  mutable soap: girl;
  mutable mcup: girl;
  mutable pillows: pillow list;
  mutable collisions: collision list;
  mutable time: float;
  mutable last_time_of_pillow_spawn: float;
  mutable random_time: float;
  game_start: float;
  mutable game_over: bool;
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

(* Returns: the global timer in the game before game ends.*)
val time: st -> float

(* The REPL that updates the game state after every frame.
 * Checks for statuses of many game methods, increments time, keeps
 * track of score, collisions, girl positions, professor, pillows.*)
val update_st: st -> st

(* effects: [collisionHandler cl st] updates the state depending on the collision.
   For example, if a girl collides with a pillow, the state should be updated
   with the girl holding the pillow. Another example: when the girls collides
   with the bed, the girl should slow down.
  returns: the updated state *)
val collision_handler: collision -> st -> st

(* val update_all: Dom_html.canvasRenderingContext2D Js.t -> unit *)

val is_in_bounds_girl: (int * int) -> bool

val check_still_disabled: info -> unit

val throw_pillow: string -> st -> st

val keydown: Dom_html.keyboardEvent Js.t -> bool Js.t

val keyup: Dom_html.keyboardEvent Js.t -> bool Js.t

val init_st: st

val init_bloom: girl

val init_pillow: pillow

val init_mcup: girl

val init_soap: girl

val highest_score: girl -> girl -> girl -> string
