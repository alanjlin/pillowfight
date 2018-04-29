type info = {
  max_speed: int;
  throw_power: int;
  recovery_time: int;
  direction: int;
  coordinate: int * int;
  hitbox: (int * int) list;
  layer: int;
}

type girl = Bloom of info | Soap of info | Margarinecup of info

type people = Professor| Girl

type furniture = Bed | Walls

type pillow = Regular | Hard | Repeating

type obj = People | Furniture | Pillow
