(* variant representing the types of girl *)
type girl = Bloom | Soap | Margarinecup

(* variant representing the types of people *)
type people = Professor| Girl

(* variant representing the types of furniture *)
type furniture = Bed | Walls

(* variant representing the types of pillow *)
type pillow = Regular | Hard | Repeating

(* variant representing the types of objects *)
type obj = People | Furniture | Pillow

(* record storing all the information of the variants *)
type info = {
  max_speed: int;
  throw_power: int;
  recovery_time: int;
  direction: int;
  coordinate: int * int;
  hitbox: (int * int) list;
  layer: int;
}
