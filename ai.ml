open Actors
open State

type ai = {
  mutable b1time_of_last_switch: float;
  mutable b1interval: float;
  mutable b1choice: bool;
  mutable b2time_of_last_switch: float;
  mutable b2interval: float;
  mutable b2choice: bool;
}

let init_ai = {
    b1time_of_last_switch = Unix.gettimeofday ();
    b1interval = 0.;
    b1choice = true;
    b2time_of_last_switch = Unix.gettimeofday ();
    b2interval = 0.;
    b2choice = false
  }

(* [Requires]: lt is [last_time]
 * [Returns]: Difference between current time and last time. *)
let get_time_diff lt =
   (Unix.gettimeofday ()) -. lt

(* Requires: d1 and d2 are the difference in x and y coordinates *
 * Returns: the distance. *)
let dist d1 d2 =
  int_of_float (sqrt (float_of_int ((d1 * d1) + (d2 * d2))))

(* Returns: true half of the time, false half of the time. *)
let twochoice u =
  let i = Random.int 2 in
  if i = 0 then true else false

let reset_time bot ai =
  if bot = "b1"
  then (ai.b1interval <- Random.float 2. +. 1.;
        ai.b1time_of_last_switch <- Unix.gettimeofday ())
  else (ai.b2interval <- Random.float 2. +. 1.;
        ai.b2time_of_last_switch <- Unix.gettimeofday ())

(* Returns: true if time to switch movement, false if not. *)
let time_to_switch bot (ai : ai) : bool =
  if (bot = "b1" && (get_time_diff ai.b1time_of_last_switch) > ai.b1interval)
  then (reset_time bot ai; true)
  else if (bot = "b2" &&
           (get_time_diff ai.b2time_of_last_switch) > ai.b2interval)
  then (reset_time bot ai; true)
  else false

let toggle_choice bot ai =
  if bot = "b1" then ai.b1choice <- not ai.b1choice
  else ai.b2choice <- not ai.b2choice

let ai_decision_cycle bot ai : bool =
  if (bot = "b1" && time_to_switch bot ai)
  then (let c = twochoice () in ai.b1choice <- c; c)
  else if (bot = "b2" && time_to_switch bot ai)
  then (let c = twochoice () in ai.b2choice <- c; c)
  else if bot = "b1" then ai.b1choice
  else ai.b2choice

(* [find_closest_pillow] returns the coordinate of the closest pillow.
 * Requires: acc is the coordinates of the girl
 * Returns: coordinate of closest pillow, if no pillows then coordinate
 * of girl herself.*)
let rec find_closest_pillow cgirl clist acc =
  match clist with
  | [] -> acc
  | (x, y) :: t -> let dacc = (dist (fst acc - fst cgirl) (snd acc - snd cgirl)) in
    if dacc = 0 || (dist (x - fst cgirl) (y - snd cgirl)) < dacc
    then find_closest_pillow cgirl t (x, y)
    else find_closest_pillow cgirl t acc

(* [move_to_closest_pillow] moves a girl with info [girl] in the state s to
 * the nearest pillow. For now, this function gets x right first, then y.
   NOTE: consider choosing x or y first randomly, or switching after a random
   amount of time.
 * Requires: [s] is the state of the game, [girl] is the info of the desired
 * girl to automate move.*)
let move_to_closest_pillow bot ai (girl: info) s =
  let cgirl = girl.coordinate in
  let clist =
    List.map (fun p -> match p with Regular i -> i.coordinate) s.pillows in
  let pillow_coord = find_closest_pillow cgirl clist cgirl in
  if ai_decision_cycle bot ai then
    (if fst pillow_coord - fst cgirl > 1 then
      (girl.direction <- 2;
      girl.coordinate <- (fst cgirl + girl.move_speed, snd cgirl))
    else if fst pillow_coord - fst cgirl < -1 then
      (girl.direction <- 4;
       girl.coordinate <- (fst cgirl - girl.move_speed, snd cgirl))
    else toggle_choice bot ai)
  else
    (if snd pillow_coord - snd cgirl > 1 then
      (girl.direction <- 3;
       girl.coordinate <- (fst cgirl, snd cgirl + girl.move_speed))
    else if snd pillow_coord - snd cgirl < -1 then
      (girl.direction <- 1;
       girl.coordinate <- (fst cgirl, snd cgirl - girl.move_speed))
    else toggle_choice bot ai)

(* let move_to_girl agirl tgirl =

let attack_girl (agirl: info) (tgirl: info) =
  let acoord = agirl.coordinate in let tcoord = tgirl.coordinate in
   if *)

let update_ai s ai =
  let s' = begin match s.bloom with
    | Bloom b ->
      if b.has_pillow then () else move_to_closest_pillow "b1" ai b s;
      begin match s.soap with
        | Soap so ->
          if so.has_pillow then () else move_to_closest_pillow "b2" ai so s; s
        | _ -> s
      end
    | _ -> s
  end in s'
