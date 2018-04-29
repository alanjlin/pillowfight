open Actors

type move = Space | Left | Right | Up | Down

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
