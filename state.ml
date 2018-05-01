open Actors

type move = {
  mutable up: bool;
  mutable down: bool;
  mutable left: bool;
  mutable right: bool;
  mutable space: bool;
}

type collision =
  | GirlOnWall of girl * furniture
  | GirlOnPillow of girl * pillow
  | PillowOnGirl of pillow * girl

type st = {
  mutable bloom: girl;
  mutable soap: girl;
  mutable mcup: girl;
  mutable pillows: pillow list;
  walls: furniture list;
  mutable collisions: collision list;
  mutable scores: (girl * int) list;
  mutable time: float;
}

let player_keys = {
  up = false;
  down = false;
  left = false;
  right = false;
  space = false;
}

let init_st = {
  bloom = ref {
    move_speed = ref 1;
    fly_speed = ref 0;
    throw_power = 1;
    recovery_time = 3;
    direction = ref 1;
    coordinate = ref (0, 0);
    has_pillow = ref false;
  };
  soap = ref {
      move_speed = ref 1;
      fly_speed = ref 0;
      throw_power = 1;
      recovery_time = 3;
      direction = ref 1;
      coordinate = ref (0, 0);
      has_pillow = ref false;
  };
  mcup = ref {
      move_speed = ref 1;
      fly_speed = ref 0;
      throw_power = 1;
      recovery_time = 3;
      direction = ref 1;
      coordinate = ref (0, 0);
      has_pillow = ref false;
    };
  pillows = ref [];
  collisions = ref [];
  scores = ref [(bloom, 0); (soap, 0); (mcup, 0)];
  time = ref 0.
}

let pillows s = s.pillows

let walls s = s.walls

let collisions s = s.collisions

let scores s = s.scores

let time s = s.time



let last_time = ref (Unix.gettimeofday ())

(* [Requires]: lt is [last_time]
 * [Returns]: Difference between current time and last time. *)
let get_time_diff lt =
   (Unix.gettimeofday ()) -. !lt

(* [Effects]: Changes last time to current time. *)
let reset_last_time lt = lt := Unix.gettimeofday ()

(* Checks if a given set of coordinates fits within a 400x400 square. *)
let is_in_bounds coord : bool =
  if fst coord >= 0 && fst coord <= 400
     && snd coord >= 0 && snd coord <= 400 then true else false

(* helper function for update, checks for user press of keys and updates
 * corresponding movement. *)
let update_pmovement girl keys =
  if is_in_bounds girl.coordinate then
    if keys.up then girl.direction <- 1;
  let c = girl.coordinate in girl.coordinate <- (fst c + girl.move_speed, snd c)
    else if keys.down then girl.direction <- 3;
  let c = girl.coordinate in girl.coordinate <- (fst c - girl.move_speed, snd c)
    else if keys.left then girl.direction <- 4;
  let c = girl.coordinate in girl.coordinate <- (fst c, snd c - girl.move_speed)
    else if keys.right then girl.direction <- 2;
  let c = girl.coordinate in girl.coordinate <- (fst c, snd c + girl.move_speed)
    else ()
  else ()

let update_st s = let _ = update_pmovement s.mcup player_keys in s

let move_handler m s = failwith "unimplemented"





(*[collision_detector s] determines whether there is a collision given the
  information of the two objects. returns true if there is a collision, false
otherwise. *)
let collision_detector i1 i2 = failwith "unimplemented"


(*[remove_pillow it plst] removes the pillow with info it from plst, if it is
  found in the list, if not found, returns the original plst (helper method
  for collision handler)*)
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
let collisionHandler c s =
  match c with
  | GirlOnPillow (g,p) ->
    begin match g with
      | Bloom i ->
        if i.has_pillow then s
        else
          let _ = i.has_pillow <- true in
          let _ = s.bloom <- Bloom i in
          begin match p with
            | Regular i -> s.pillows <- (remove_pillow i s.pillows); s
          end
      | Soap i ->
        if i.has_pillow then s
        else
          let _ = i.has_pillow <- true in
          let _ = s.soap <- Soap i in
          begin match p with
            | Regular i -> s.pillows <- (remove_pillow i s.pillows); s
          end
      | Margarinecup i ->
        if i.has_pillow then s
        else
          let _ = i.has_pillow <- true in
          let _ = s.soap <- Soap i in
          begin match p with
            | Regular i -> s.pillows <- (remove_pillow i s.pillows); s
          end
    end
  | PillowOnGirl (p, g)->
    begin match p with
      | Regular p_info ->
        let fs = p_info.fly_speed in
        let dir = p_info.direction in
        begin match g with
          | Bloom i ->
            let _ = i.fly_speed <- fs in
            let _ = i.direction <- dir in
            let _ = s.bloom <- Bloom i in
            s
          | Soap i ->
            let _ = i.fly_speed <- fs in
            let _ = i.direction <- dir in
            let _ = s.soap <- Soap i in s
          | Margarinecup i ->
            let _ = i.fly_speed <- fs in
            let _ = i.direction <- dir in
            let _ = s.mcup <- Margarinecup i in s
        end
    end
  | GirlOnWall (g, w) ->
    begin match g with
      | Bloom i ->
        let _ = i.fly_speed <= 0 in
        let _ = s.bloom = Bloom i in s
      | Soap i ->
        let _ = i.fly_speed <= 0 in
        let _ = s.soap = Soap i in s
      | Margarinecup i ->
        let _ = i.fly_speed <= 0 in
        let _ = s.mcup = Margarinecup i in s
    end


let isColliding o1 o2 = failwith "unimplemented"

let rec update_all getContext =
  let loop st =
    let st' = update_st st in
    Display.draw_state context st';
    ignore Html.window##requestAnimationFrame(
      Js.wrap_callback (fun (t:float) -> loop st')
    )
in loop init_st

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
