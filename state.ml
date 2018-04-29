open Actors
open Collisions
type state = {
  girls: Actors.girl list;
  pillows: Actors.pillow list;
  walls: Actors.furniture list;
  collisions: Collision.collision list;
  scores: (Actors.girl * int) list;
  time: float;
}
