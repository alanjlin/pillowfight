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
  | GirlOnPillow of girl * pillow
  | PillowOnGirl of pillow * girl

type st = {
  mutable bloom: girl;
  mutable soap: girl;
  mutable mcup: girl;
  mutable pillows: pillow list;
  mutable collisions: collision list;
  mutable time: float;
  mutable last_time_of_pillow_spawn: float;
  mutable random_time: float;
  game_start: float;
  mutable game_over: bool;
}

(* [player_keys] represents the keys that the player presses. *)
let player_keys = {
  up = false;
  down = false;
  left = false;
  right = false;
  space = false;
}

(* [init_bloom] initializes Bloom at the initial state. *)
let init_bloom =  Bloom {
    move_speed = 4;
    fly_speed = 8;
    throw_power = 1;
    recovery_time = 3;
    direction = 1;
    coordinate = (0, int_of_float (_BGSIZE -. _GIRLSIZE));
    has_pillow = false;
    img_src = "./pics/bloom.png";
    who_threw = "na";
    score = 0;
    is_disabled = false;
    last_time_disabled = 0.;
  }

(* [init_soap] initializes Soap at the initial state. *)
let init_soap = Soap {
    move_speed = 4;
    fly_speed = 8;
    throw_power = 1;
    recovery_time = 3;
    direction = 1;
    coordinate = (int_of_float (_BGSIZE -. _GIRLSIZE), 0);
    has_pillow = false;
    img_src = "./pics/soap.png";
    who_threw = "na";
    score = 0;
    is_disabled = false;
    last_time_disabled = 0.;
  }

(* [init_mcup] initializes Margarinecup at the initial state. *)
let init_mcup = Margarinecup {
    move_speed = 4;
    fly_speed = 8;
    throw_power = 1;
    recovery_time = 3;
    direction = 1;
    coordinate = (0, 0);
    has_pillow = false;
    img_src = "./pics/mcup.png";
    who_threw = "na";
    score = 0;
    is_disabled = false;
    last_time_disabled = 0.;
  }

(* [init_pillow] is the initializes a pillow for testing purposes. *)
let init_pillow = Regular {
    move_speed = 0;
    fly_speed = 0;
    throw_power = 0;
    recovery_time = 5;
    direction = 0;
    coordinate = (50, 100);
    has_pillow = false;
    img_src = "./pics/sprite_og.png";
    who_threw = "na";
    score = 0;
    is_disabled = false;
    last_time_disabled = 0.;
  }

(* [reset_last_time] updates any reference to the time of day to current time.
 * [Effects]: sets [lt] to current time of day.*)
let reset_last_time lt = lt := Unix.gettimeofday ()

(* [init_st] is the state when the game first begins. initializes variables.*)
let init_st = {
  bloom = init_bloom;
  soap = init_soap;
  mcup = init_mcup;
  pillows = [];
  collisions = [];
  time = 0.;
  last_time_of_pillow_spawn = 0.;
  random_time = 0.;
  game_start = Unix.gettimeofday ();
  game_over = false;
}

(* [pillows] is a getter method.
 * [Returns]: list of pillows in [s].*)
let pillows s = s.pillows

(* [collisions] is a getter method.
 * [Returns]: list of current collisions in [s].*)
let collisions s = s.collisions

(* [time] is a getter method.
 * [Returns]: current game time.*)
let time s = s.time

(* [Requires]: lt is [last_time]
 * [Returns]: Difference between current time and last time. *)
let get_time_diff lt =
  (Unix.gettimeofday ()) -. lt

(* [is_in_bounds_pillow] Checks if a pillow's coordinates fits within
   the background size.
   [Returns]: true if a pillow is in bounds, false otherwise.*)
let is_in_bounds_pillow coord : bool =
  if fst coord > -5 && fst coord < int_of_float (_BGSIZE -. _PILLOWSIZE +. 5.)
     && snd coord > -5 && snd coord < int_of_float (_BGSIZE -. _PILLOWSIZE +. 5.)
  then true else false

(* [is_in_bounds_girl] Checks if a girl's coordinates fits within
   the background size.
   [Returns]: true if a girl is in bounds, false otherwise.*)
let is_in_bounds_girl coord : bool =
  if fst coord > -5 && fst coord < int_of_float (_BGSIZE -. _GIRLSIZE +. 5.)
     && snd coord > -5 && snd coord < int_of_float (_BGSIZE -. _GIRLSIZE +. 5.)
  then true else false

  (*[throw_pillow girl state] is the state after the girl has thrown a pillow.
    The pillow takes the speed and direction of the girl. requires: girl is a
    string "bloom" or "soap" or "mcup" indicating which girl threw the pillow
    and state is the state of the game *)
  let throw_pillow girl state =
    if girl = "bloom" then
      match state.bloom with
      | Bloom i -> i.has_pillow <- false;
        let p = Regular ({
            move_speed = 0;
            fly_speed = i.fly_speed;
            throw_power = i.throw_power;
            recovery_time = 0;
            direction = i.direction;
            coordinate = i.coordinate;
            has_pillow = false;
            img_src = "./pics/sprite_og.png";
            who_threw = "bloom";
            score = 0;
            is_disabled = false;
            last_time_disabled = 0.;
          }) in state.pillows <- (p::state.pillows); state
  | _ -> state
    else if girl = "soap" then
      match state.soap with
      | Soap i -> i.has_pillow <- false;
            let p = Regular ({
                move_speed = 0;
                fly_speed = i.fly_speed;
                throw_power = i.throw_power;
                recovery_time = 0;
                direction = i.direction;
                coordinate = i.coordinate;
                has_pillow = false;
                img_src = "./pics/sprite_og.png";
                who_threw = "soap";
                score = 0;
                is_disabled = false;
                last_time_disabled = 0.;
              }) in state.pillows <- (p::state.pillows); state
  | _ -> state
    else
    match state.mcup with
      | Margarinecup i -> i.has_pillow <- false;
            let p = Regular ({
                move_speed = 0;
                fly_speed = i.fly_speed;
                throw_power = i.throw_power;
                recovery_time = 0;
                direction = i.direction;
                coordinate = i.coordinate;
                has_pillow = false;
                img_src = "./pics/sprite_og.png";
                who_threw = "mcup";
                score = 0;
                is_disabled = false;
                last_time_disabled = 0.;
              }) in state.pillows <- (p::state.pillows); state
      | _ -> state

(* helper function for update_state, checks for user press of keys and updates
 * corresponding movement. *)
let update_pmovement (girl:Actors.info) keys =
  let c = girl.coordinate in
  if girl.is_disabled && is_in_bounds_girl girl.coordinate
  then begin match girl.direction with
    | 1 -> girl.coordinate <- (fst c, snd c - girl.fly_speed)
    | 2 -> girl.coordinate <- (fst c + girl.fly_speed, snd c)
    | 3 -> girl.coordinate <- (fst c, snd c + girl.fly_speed)
    | 4 -> girl.coordinate <- (fst c - girl.fly_speed, snd c)
    | _ -> ()
  end
  else if girl.is_disabled && not (is_in_bounds_girl girl.coordinate)
  then ()
  else if keys.up && (snd girl.coordinate >= 0) then (girl.direction <- 1;
                     let c = girl.coordinate in girl.coordinate <- (fst c, snd c - girl.move_speed))
  else if keys.down && (snd girl.coordinate <= int_of_float (_BGSIZE -. _GIRLSIZE)) then (girl.direction <- 3;
                            let c = girl.coordinate in girl.coordinate <- (fst c, snd c + girl.move_speed))
  else if keys.left && (fst girl.coordinate >= 0) then (girl.direction <- 4;
                            let c = girl.coordinate in girl.coordinate <- (fst c - girl.move_speed, snd c))
  else if keys.right && (fst girl.coordinate <= int_of_float (_BGSIZE -. _GIRLSIZE)) then (girl.direction <- 2;
                             let c = girl.coordinate in girl.coordinate <- (fst c + girl.move_speed, snd c))
  else ()

(* helper function for update_state, checks for user space and throws pillow.
 * This is a separate function from update_pmovement b/c the player should
 * be able to throw a pillow while he/she is moving. *)
let update_pthrow state (girl: girl) keys =
  if keys.space then
    begin match girl with
      | Bloom i -> if i.has_pillow then throw_pillow "bloom" state else state
      | Soap i -> if i.has_pillow then throw_pillow "soap" state else state
      | Margarinecup i ->
        if i.has_pillow then throw_pillow "mcup" state else state
    end else state

(* [generate_pillow] generates 1 stationary pillow per time it is called. the
 * position at which it is generated is random.
 * [Effects]: adds a pillow to pillow_list in [s]. *)
let generate_pillow s =
  if List.length s.pillows < 7 then
  let new_pillow = Regular ({
      move_speed = 0;
      fly_speed = 0;
      throw_power = 5;
      recovery_time = 0;
      direction = 0;
      coordinate = (Random.int (int_of_float (_BGSIZE -. _PILLOWSIZE)),
                    Random.int (int_of_float (_BGSIZE -. _PILLOWSIZE)));
      has_pillow = false;
      img_src = "./pics/sprite_og.png";
      who_threw = "na";
      score = 0;
      is_disabled = false;
      last_time_disabled = 0.;
    }) in s.pillows <- (new_pillow :: s.pillows) else ()

(* [check_pillow_spawn] spawns a pillow every 1.2 +/- 1 seconds.
 * resets random time after each spawn.
 * [Effects]: spawns a pillow every 1.2 +/- 1 seconds. *)
let check_pillow_spawn s =
  if s.random_time = 0.
  then (s.random_time <- ((Random.float 2.0) +. 0.2))
  else if (s.time -. s.last_time_of_pillow_spawn >= s.random_time)
  then (generate_pillow s; s.last_time_of_pillow_spawn <- s.time )
  else ()

(* [update_time] is a helper method to update the game time.
 * [Effects]: Gets time difference from time of game start and
 * sets time to that.*)
let update_time s =
  s.time <- get_time_diff s.game_start

(* [check_game_over] updates time (adds to the game's timer) and toggles
 * game_over indication to tell the main game loop to exit loop. *)
let check_game_over st =
  update_time st; if st.time >= 120. then
  st.game_over <- true

(*[collision_detector s] determines whether there is a collision given the
  information of the two objects. returns true if there is a collision, false
otherwise. *)
let collision_detected i1 i2 =
  match i1.coordinate, i2.coordinate with
  | (x1, y1), (x2, y2) -> if ((abs(x2 - x1) < int_of_float _PILLOWSIZE) &&
                              (abs(y2 - y1) < int_of_float _PILLOWSIZE))
    then true else false

(*[collision_creator g p] creates a collision between the girl and pillow with
  given info g and p*)
let collision_creator g p name =
  if p.fly_speed = 0 then
    GirlOnPillow ((if name = "bloom" then Bloom g
                   else if name = "soap" then Soap g
                   else Margarinecup g), Regular p)
  else
    PillowOnGirl (Regular p, (if name = "bloom" then Bloom g
                             else if name = "soap" then Soap g
                             else Margarinecup g))

(*[cd_list_girl i plst] is the list of collisions given the girl and all
  pillows in the game *)
let rec cd_list_girl i plst acc name =
  match plst with
  | [] -> acc
  | h::t ->
    begin match h with
      | Regular p -> cd_list_girl i t (if collision_detected i p then
                                         (collision_creator i p name)::acc else acc) name
    end

(*[cd_updater s] returns a new state s' with all of the collisions added to the
  state's collision list. *)
let cd_updater s =
  match s.bloom with
  | Bloom b -> let c1 = cd_list_girl b s.pillows [] "bloom" in
    begin match s.soap with
      | Soap b -> let c2 = cd_list_girl b s.pillows c1 "soap" in
        begin match s.mcup with
          | Margarinecup b -> let c3 = cd_list_girl b s.pillows c2 "mcup" in
            s.collisions <- c3; s
          | _ -> s
        end
      | _ -> s
    end
  | _ -> s

(*[remove_pillow it plst] removes the pillow with info it from plst, if it is
  found in the list, if not found, returns the original plst (helper method
  for collision handler)*)
let rec remove_pillow it plst =
  match plst with
  | [] -> []
  | h::t ->
    match h with
    | Regular i ->
      if fst it.coordinate = fst i.coordinate &&
         snd i.coordinate = snd i.coordinate
      then remove_pillow it t
        else (Regular i)::(remove_pillow it t)

(* effects: [collisionHandler cl st] updates the state depending on the collision.
   For example, if a girl collides with a pillow, the state should be updated
   with the girl holding the pillow. If a moving pillow collides with a girl,
   then she flies backwards and gets disabled (no player controls).
   returns: the updated state *)
let collision_handler c s =
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
          let _ = s.mcup <- Margarinecup i in
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
          | Bloom i -> if i.is_disabled then s else
            let _ = i.fly_speed <- fs in
            let _ = i.direction <- dir in
            let _ = s.bloom <- Bloom i in
            let _ = begin match p_info.who_threw with
              | "soap" -> begin match s.soap with
                  | Soap so -> if i.is_disabled then ()
                    else so.score <- so.score + 1;
                    i.is_disabled <- true;
                    i.last_time_disabled <- Unix.gettimeofday ();
                    i.has_pillow <- false;
                  | _ -> ()
                end
              | "mcup" -> begin match s.mcup with
                  | Margarinecup m -> if i.is_disabled then ()
                    else m.score <- m.score + 1;
                    i.is_disabled <- true;
                    i.last_time_disabled <- Unix.gettimeofday ();
                    i.has_pillow <- false;
                  | _ -> ()
                end
              | _ -> () (* if collision is with itself *)
            end in s
          | Soap i -> if i.is_disabled then s else
            let _ = i.fly_speed <- fs in
            let _ = i.direction <- dir in
            let _ = s.soap <- Soap i in
            let _ = begin match p_info.who_threw with
              | "bloom" -> begin match s.bloom with
                  | Bloom b -> if i.is_disabled then () else
                      b.score <- b.score + 1;
                      i.is_disabled <- true;
                      i.last_time_disabled <- Unix.gettimeofday ();
                      i.has_pillow <- false;
                  | _ -> ()
                end
              | "mcup" -> begin match s.mcup with
                  | Margarinecup m -> if i.is_disabled then () else
                      m.score <- m.score + 1;
                      i.is_disabled <- true;
                      i.last_time_disabled <- Unix.gettimeofday ();
                      i.has_pillow <- false;
                  | _ -> ()
                end
              | _ -> () (* if collision is with itself *)
            end in s
          | Margarinecup i -> if i.is_disabled then s else
            let _ = i.fly_speed <- fs in
            let _ = i.direction <- dir in
            let _ = s.mcup <- Margarinecup i in
            let _ = begin match p_info.who_threw with
              | "soap" -> begin match s.soap with
                  | Soap so -> if i.is_disabled then () else
                      so.score <- so.score + 1;
                      i.is_disabled <- true;
                      i.last_time_disabled <- Unix.gettimeofday ();
                      i.has_pillow <- false;
                  | _ -> ()
                end
              | "bloom" -> begin match s.bloom with
                  | Bloom b -> if i.is_disabled then () else
                      b.score <- b.score + 1;
                      i.is_disabled <- true;
                      i.last_time_disabled <- Unix.gettimeofday ();
                      i.has_pillow <- false;
                  | _ -> ()
                end
              | _ -> () (* if collision is with itself *)
            end in s
        end
    end

(*[coll_list_proc clist state] is the state with the collisions in state
  processed *)
let rec coll_list_proc clist state =
  match clist with
  | [] -> state
  | h::t -> state.collisions <- t; let s' = collision_handler h state in coll_list_proc t s'

(*[update_collisions state] is the new state of the game after all collisions
  have been detected and processed. returns a new state to be called by the
  update all function. *)
let update_collisions state =
  let st1 = cd_updater state in
  let st2 = coll_list_proc st1.collisions st1 in st2

let rec update_pillow_movement s plist =
  match plist with
  | [] -> plist
  | h :: t -> begin match h with
      | Regular p -> let coord = begin match p.direction with
          | 1 -> ((fst p.coordinate), (snd p.coordinate) - p.fly_speed)
          | 2 -> ((fst p.coordinate) + p.fly_speed, (snd p.coordinate))
          | 3 -> ((fst p.coordinate), (snd p.coordinate) + p.fly_speed)
          | 4 -> ((fst p.coordinate) - p.fly_speed, (snd p.coordinate))
          | _ -> p.coordinate
        end in let _ = p.coordinate <- coord in
        if is_in_bounds_pillow p.coordinate then
          update_pillow_movement s t
        else
          (s.pillows <- remove_pillow p s.pillows; update_pillow_movement s t)
    end

(* [Check_still_disabled] constantly checks if it's been more than [girl]'s'
 * recovery since the last time she's been disabled.
 * [Effects]: toggles is_disabled to false if girl is disabled and it's been
 * more than her recovery time. *)
let check_still_disabled (girl: Actors.info) =
  if girl.is_disabled &&
     (get_time_diff girl.last_time_disabled > float_of_int girl.recovery_time)
  then girl.is_disabled <- false
  else ()

(* [update_st] updates the state after every frame of the game. It consolidates
 * all helper functions above into a nice, readable, state-in-state-out
 * function that will be used by update_all to coordinate with the frontend. *)
let update_st s =
  let _ = check_game_over s in let _ = check_pillow_spawn s in
  let _ = update_pillow_movement s s.pillows in
    match s.mcup with
    | Margarinecup m -> let _ = check_still_disabled m in
      let _ = update_pmovement m player_keys
      in let s' = update_pthrow s (Margarinecup m) player_keys
      in update_collisions s'
    | _ -> s

(* [Requires]: [mcup], [bloom], and [soap] are girl components in the state
 * after the game is over.
 * [Returns]: "mcup" if mcup has the highest score, "bloom" if bloom has the
 * highest score, and "soap" if soap has the highest score. If two people
 * have the same score, then returns "tie"*)
let highest_score mcup bloom soap =
  begin
    match mcup, bloom, soap with
    | Margarinecup m, Bloom b, Soap s ->
      if m.score > b.score && m.score > s.score then "mcup"
      else if b.score > m.score && b.score > s.score then "bloom"
      else if s.score > m.score && s.score > b.score then "soap"
      else "tie"
    |_, _, _ -> failwith "shouldn't happen"
  end

(* [keydown] translates a keycode from the eventlistener to player_keys
 * for a pressed key. *)
let keydown event =
  let () = match event##keyCode with
  | 38 -> player_keys.up <- true
  | 39 -> player_keys.right <- true
  | 37 -> player_keys.left <- true
  | 40 -> player_keys.down <- true
  | 32 -> player_keys.space <- true
  | _ -> ()
  in Js._true

(* [keydown] translates a keycode from the eventlistener to player_keys
 * for a released key. *)
let keyup event =
  let () = match event##keyCode with
  | 38 -> player_keys.up <- false
  | 39 -> player_keys.right <- false
  | 37 -> player_keys.left <- false
  | 40 -> player_keys.down <- false
  | 32 -> player_keys.space <- false
  | _ -> ()
in Js._true
