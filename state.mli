open Actors
open Collisions

(* The [state] of the game represents all the variables and information
 * necessary for any instance of gameplay. [state] is essential in
 * gameplay because it is responsible for keeping track of every
 * possible mutable objects and interactions in the game. It is updated
 * and called on constantly when the game is running. *)
module type State = sig
  (* The implementation of type will serve to store all information
   * required to run the game. Perhaps a record would be good.*)
  type state

  (* Returns: a list of girl objects. *)
  val girls: state -> Actors.girl list

  (* Returns: a list of pillows currently on the map*)
  val pillows: state -> Actors.pillow list

  (* Returns: the professor in the game. *)
  val prof: state -> Actors.people

  (* Returns: the bed object*)
  val bed: state -> Actors.furniture

  (* Returns: the walls, or "parameters" of the game.*)
  val walls: state -> Actors.furniture list

  (* Returns: a list of collisions that are taking place in [state]*)
  val collisions: state -> Collision.collision list

  (* Returns: An association list with each girl and her score.*)
  val scores: state -> (Actors.girl * int) list

  (* Returns: the global timer in the game before game ends.*)
  val time: state -> float

  (* The REPL that updates the game state after every frame.
   * Checks for statuses of many game methods, increments time, keeps
   * track of score, collisions, girl positions, professor, pillows.*)
  val update: state -> state
end
