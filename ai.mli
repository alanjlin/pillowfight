open Actors
open State

type ai

val init_ai: ai

(* Updates the movement/behavior of an AI once per iteration. Called by
 * state's update_all function. *)
val update_ai: st -> ai -> st
