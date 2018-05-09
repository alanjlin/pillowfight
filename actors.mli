(* record storing all the information of the variants *)
type info = {
  mutable move_speed: int; (*only applies to girls, when player moving*)
  mutable fly_speed: int; (*speed of projectiles*)
  throw_power: int; (**)
  recovery_time: int;
  mutable direction: int; (*no direction = 0; up = 1; right = 2; down = 3; left = 4*)
  mutable coordinate: int * int;
  mutable has_pillow: bool;
  mutable img_src : string ;
}

(* variant representing the types of girl *)
type girl = Bloom of info | Soap of info | Margarinecup of info

(* variant representing the types of furniture *)
type furniture = Walls of info

(* variant representing the types of pillow *)
type pillow = Regular of info
