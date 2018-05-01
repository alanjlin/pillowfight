open Actors

type move = Space | Left | Right | Up | Down

type collision =
  | GirlOnGirl of girl*girl
  | GirlOnWall of girl*furniture
  | GirlOnPillow of girl*pillow
  | PillowOnGirl of pillow*girl


type st = {
  bloom: girl;
  soap: girl;
  mcup: girl;
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


    (**)
let rec remove_pillow it plst =
  match plst with
  | [] -> []
  | h::t ->
    match h with
    | Regular i ->
        if it = i then remove_pillow it t
        else (Regular i)::(remove_pillow it t)


(* effects: [collisionHandler cl st] updates the state depending on the collision.
   For example, if a girl collides with a pillow, the state should be updated
   with the girl holding the pillow. Another example: when the girls collides
   with the bed, the girl should slow down.
   returns: the updated state *)
(* let collisionHandler c s =
  match c with
  | GirlOnPillow g, p ->
    begin match g with
      | Bloom i ->
        if i.has_pillow then s
        else
          i.has_pillow <- true;
          s.bloom <- Bloom of i;
          begin match p with
            | Regular of i -> s <- (remove_pillow i s.pillows); s
          end
      | Soap of i ->
        if i.has_pillow then s
        else
          i.has_pillow <- true;
          s.soap <- Soap of i;
          begin match p with
            | Regular of i -> s <- (remove_pillow i s.pillows); s
          end
      | Margarinecup of i ->
        if i.has_pillow then s
        else
          i.has_pillow <- true;
          s.icbinbc <- Margarinecup of i;
          begin match p with
            | Regular of i -> s <- (remove_pillow i s.pillows); s
          end
    end
  | PillowOnGirl p, g ->
  | GirlOnWall g, w ->
    begin match g with
      | Bloom i -> *)


let isColliding o1 o2 = failwith "unimplemented"
