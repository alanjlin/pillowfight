open Actors

type move = {
  mutable up: bool;
  mutable down: bool;
  mutable left: bool;
  mutable right: bool;
  mutable space: bool;
}

type collision =
  | GirlOnGirl
  | GirlOnBed
  | GirlOnWall
  | GirlOnProfessor
  | PillowOnProfessor
  | GirlOnPillow
  | PillowOnGirl

type st = {
  girls: girl list;
  pillows: pillow list;
  walls: furniture list;
  collisions: collision list;
  scores: (girl * int) list;
  time: float;
}

let player_keys = {
  up = false;
  down = false;
  left = false;
  right = false;
  space = false;
}

let girls (s: st) = s.girls

let pillows s = s.pillows

let walls s = s.walls

let collisions s = s.collisions

let scores s = s.scores

let time s = s.time

let update s = failwith "unimplemented"

let move_handler m s = failwith "unimplemented"

let collisionHandler c s = failwith "unimplemented"

let isColliding o1 o2 = failwith "unimplemented"

(* Keydown event handler translates a key press *)
let keydown event =
  let () = match event##keyCode with
  | 38 -> player_keys.up <- true
  | 39 -> player_keys.right <- true
  | 37 -> player_keys.left <- true
  | 40 -> player_keys.down <- true
  | 32 -> player_keys.space <- true
  | _ -> ()
  in Js._true

(* Keyup event handler translates a key release *)
let keyup event =
  let () = match event##keyCode with
  | 38 -> player_keys.up <- false
  | 39 -> player_keys.right <- false
  | 37 -> player_keys.left <- false
  | 40 -> player_keys.down <- false
  | 32 -> player_keys.space <- false
  | _ -> ()
  in Js._true
