open Actors
open Constants

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
  mutable collisions: collision list;
  mutable scores: (string * int) list;
  mutable time: float;
  mutable last_time_of_pillow_spawn: float;
  mutable random_time: float;
  game_start: float
}

let player_keys = {
  up = false;
  down = false;
  left = false;
  right = false;
  space = false;
}

let init_bloom =  Bloom {
    move_speed = 1;
    fly_speed = 0;
    throw_power = 1;
    recovery_time = 3;
    direction = 1;
    coordinate = (0, 0);
    has_pillow = false
  }

let init_soap = Soap {
    move_speed = 1;
    fly_speed = 0;
    throw_power = 1;
    recovery_time = 3;
    direction = 1;
    coordinate = (0, 0);
    has_pillow = false
  }

let init_mcup = Margarinecup {
    move_speed = 1;
    fly_speed = 0;
    throw_power = 1;
    recovery_time = 3;
    direction = 1;
    coordinate = (0, 0);
    has_pillow = false
  }

let reset_last_time lt = lt := Unix.gettimeofday ()

let init_st = {
  bloom = init_bloom;
  soap = init_soap;
  mcup = init_mcup;
  pillows = [];
  collisions = [];
  scores = [("bloom", 0); ("soap", 0); ("mcup", 0)];
  time = 0.;
  last_time_of_pillow_spawn = 0.;
  random_time = 0.;
  game_start = Unix.gettimeofday ()
}

let pillows s = s.pillows

let collisions s = s.collisions

let scores s = s.scores

let time s = s.time

(* [Requires]: lt is [last_time]
 * [Returns]: Difference between current time and last time. *)
let get_time_diff lt =
   (Unix.gettimeofday ()) -. lt

(* Checks if a given set of coordinates fits within a 400x400 square. *)
let is_in_bounds coord : bool =
  if fst coord >= 0 && fst coord <= int_of_float _BGSIZE
     && snd coord >= 0 && snd coord <= int_of_float _BGSIZE
  then true else false

(* helper function for update, checks for user press of keys and updates
 * corresponding movement. *)
let update_pmovement (girl:Actors.info) keys =
  if keys.up && (snd girl.coordinate >= 0) then (girl.direction <- 1;
                     let c = girl.coordinate in girl.coordinate <- (fst c, snd c - girl.move_speed))
  else if keys.down && (snd girl.coordinate <= int_of_float _BGSIZE) then (girl.direction <- 3;
                            let c = girl.coordinate in girl.coordinate <- (fst c, snd c + girl.move_speed))
  else if keys.left && (fst girl.coordinate >= 0) then (girl.direction <- 4;
                            let c = girl.coordinate in girl.coordinate <- (fst c - girl.move_speed, snd c))
  else if keys.right && (fst girl.coordinate <= int_of_float _BGSIZE) then (girl.direction <- 2;
                             let c = girl.coordinate in girl.coordinate <- (fst c + girl.move_speed, snd c))
  else ()

let generate_pillow s =
  let new_pillow = Regular ({
      move_speed = 0;
      fly_speed = 0;
      throw_power = 5;
      recovery_time = 0;
      direction = 0;
      coordinate = (Random.int (int_of_float _BGSIZE),
                    Random.int (int_of_float _BGSIZE));
      has_pillow = false
    }) in s.pillows <- new_pillow :: s.pillows

let check_pillow_spawn s =
  if s.random_time = 0.
  then (s.random_time <- ((Random.float 3.) +. 5.))
  else if (s.time -. s.last_time_of_pillow_spawn >= s.random_time)
  then (generate_pillow s; s.last_time_of_pillow_spawn <- s.time )
  else ()

let update_time s =
  s.time <- get_time_diff s.game_start

let update_st s =
  let _ = update_time s in let _ = check_pillow_spawn s in
    match s.mcup with
    | Margarinecup m -> let _ =  update_pmovement m player_keys in s
    | _ -> s

(*[collision_detector s] determines whether there is a collision given the
  information of the two objects. returns true if there is a collision, false
otherwise. *)
let collision_detector i1 i2 =
  if i1.fly_speed > 0 then false
  else
  match i1.coordinate, i2.coordinate with
  | (x1, y1), (x2, y2) -> if x1 = x2 && y1 = y2 then true else false

(*[collision_creator g p] creates a collision between the girl and pillow with
  given info g and p*)
(* let collision_creator g p =
  if p.fly_speed > 0 then
    PillowOnGirl (Pillow p, Bloom g)
  else
    GirlOnPillow (Girl g, Pillow p) *)

(*[cd_list_girl i plst] is the list of collisions given the girl and all
  pillows in the game *)
let rec cd_list_girl i plst acc = failwith "unimplemented"
  (* match plst with
  | [] -> acc
  | h::t ->
    begin match h with
      | Regular p -> cd_list_girl i t ((if collision_detected i p then
                                         collision_creator i p)::acc) *)

(*[cd_updater s] returns a new state s' with all of the collisions added to the
  state's collision list. *)
let cd_updater s = failwith "unimplemented"
  (* match s.bloom with
  | Bloom of i -> let s1 = s.collisions <- (cd_list_girl i s.pillows) *)

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

(* let rec update_all context =
  let rec loop st =
    let st' = update_st st in
    Display.draw_state context;
    ignore (Dom_html.window##requestAnimationFrame(
      Js.wrap_callback (fun (t:float) -> loop st')
    ))
in loop init_st *)

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
