(* record storing all the information of the variants *)
type info = {
  move_speed: int; (*only applies to girls, when player moving*)
  fly_speed: int; (*speed of projectiles*)
  throw_power: int; (**)
  recovery_time: int;
  direction: int; (*no direction = 0; up = 1; right = 2; down = 3; left = 4*)
  coordinate: int * int;
  hitbox: (int * int) list;
  has_pillow: bool
}

(* variant representing the types of girl *)
type girl = Bloom | Soap | Margarinecup

(* variant representing the types of furniture *)
type furniture = Walls

(* variant representing the types of pillow *)
type pillow = Regular
