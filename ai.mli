open Actors
open State

(* Updates the movement/behavior of an AI once per iteration. Called by
 * state's update_all function. *)
val update_ai: st -> st
