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

(* [init_ai] initializes the information required to make intervaled
   decisions.*)
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

(* [reset_time] resets the random interval and updates the
 * last time that it has switched of [bot] in [ai]. *)
let reset_time bot ai =
  if bot = "b1"
  then (ai.b1interval <- Random.float 2. +. 1.;
        ai.b1time_of_last_switch <- Unix.gettimeofday ())
  else (ai.b2interval <- Random.float 2. +. 1.;
        ai.b2time_of_last_switch <- Unix.gettimeofday ())

(* [time_to_switch] determines whether or not it is time to switch behavior.
 * Returns: true if time to switch movement, false if not. *)
let time_to_switch bot (ai : ai) : bool =
  if (bot = "b1" && (get_time_diff ai.b1time_of_last_switch) > ai.b1interval)
  then (reset_time bot ai; true)
  else if (bot = "b2" &&
           (get_time_diff ai.b2time_of_last_switch) > ai.b2interval)
  then (reset_time bot ai; true)
  else false

(* [toggle_choice] changes the bot's choice to the other binary. *)
let toggle_choice bot ai =
  if bot = "b1" then ai.b1choice <- not ai.b1choice
  else ai.b2choice <- not ai.b2choice

(* [ai_decision_cycle] is the core of the AI's "deciding" behavior. All
 * choices that this AI makes can be abstracted to a binary choice
 * i.e. whether or not to go on the x or y axis first, which of the two other
 * girls to target, etc.
 * Specifically, ai_decision_cycle changes decisions at a random time
 * from 1-3 seconds. *)
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
 * the nearest pillow. Chooses whether or not to go in the x or y direction
 * randomly after random amounts of time.
 * Requires: [s] is the state of the game, [girl] is the info of the desired
 * girl to automate move.*)
let move_to_closest_pillow bot ai (girl: info) s =
  let cgirl = girl.coordinate in
  let stillpillows = List.filter
      (fun p -> match p with Regular i -> i.fly_speed = 0) s.pillows in
  let clist =
    List.map (fun p -> match p with Regular i -> i.coordinate) stillpillows in
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

(* [move_to_girl] increments [agirl] movement to [tgirl]. The choice of
 * whether or not to move on the x or y axis is handles by the
 * [ai_decision_cycle]. *)
let move_to_girl bot ai agirl tgirl =
  let ctgirl = tgirl.coordinate in
  let cagirl = agirl.coordinate in
  if ai_decision_cycle bot ai then
    (if fst ctgirl - fst cagirl > 1 then
       (agirl.direction <- 2;
        agirl.coordinate <- (fst cagirl + agirl.move_speed, snd cagirl))
     else if fst ctgirl - fst cagirl < -1 then
       (agirl.direction <- 4;
        agirl.coordinate <- (fst cagirl - agirl.move_speed, snd cagirl))
     else toggle_choice bot ai)
  else
    (if snd ctgirl - snd cagirl > 1 then
       (agirl.direction <- 3;
        agirl.coordinate <- (fst cagirl, snd cagirl + agirl.move_speed))
     else if snd ctgirl - snd cagirl < -1 then
       (agirl.direction <- 1;
        agirl.coordinate <- (fst cagirl, snd cagirl - agirl.move_speed))
     else toggle_choice bot ai)

(* [check_throw] checks whether or not a girl should throw a pillow in
 * any given direction. *)
let check_throw s girl ai (agirl: info) (tgirl: info) =
  let ax = fst agirl.coordinate in
  let ay = snd agirl.coordinate in
  let tx = fst tgirl.coordinate in
  let ty = snd tgirl.coordinate in
  let diffx = ax - tx in
  let diffy = ay - ty in
  if (abs diffx < 10 && abs diffy < 250)
  then (if diffy > 0 then (agirl.direction <- 1; ignore (throw_pillow girl s))
        else (agirl.direction <- 3; ignore(throw_pillow girl s)))
  else if (abs diffy < 10 && abs diffx < 250)
  then (if diffx > 0 then (agirl.direction <- 4; ignore(throw_pillow girl s))
        else (agirl.direction <- 2; ignore (throw_pillow girl s) ))
  else ()

(* [attack_girl] targets a girl randomly and goes to her, always checking if
 * she's in range to throw a pillow at her. *)
let attack_girl s ai girl bot agirl=
  match girl with
  | "bloom" -> begin match ai.b1choice with
      | true -> begin match s.mcup with
          | Margarinecup m ->
            if m.is_disabled then toggle_choice bot ai else
            check_throw s girl ai agirl m; move_to_girl bot ai agirl m
          | _ -> ()
        end
      | false -> begin match s.soap with
          | Soap so ->
            if so.is_disabled then toggle_choice bot ai else
            check_throw s girl ai agirl so; move_to_girl bot ai agirl so
          | _ -> ()
        end
    end
  | "soap" -> begin match ai.b2choice with
      | true -> begin match s.mcup with
          | Margarinecup m ->
            if m.is_disabled then toggle_choice bot ai else
            check_throw s girl ai agirl m; move_to_girl bot ai agirl m
          | _ -> ()
        end
      | false -> begin match s.bloom with
          | Bloom b ->
            if b.is_disabled then toggle_choice bot ai else
            check_throw s girl ai agirl b; move_to_girl bot ai agirl b
          | _ -> ()
        end
    end
  | "mcup" -> () (* if bot is ever mcup *)
  | _ -> ()

(* [Disabled_movement] handles girl flying if she is hit by a pillow.
 * Also disables AI movement/behavior if she is disabled.*)
let disabled_movement girl =
  let c = girl.coordinate in
  if is_in_bounds_girl girl.coordinate
  then begin match girl.direction with
    | 1 -> girl.coordinate <- (fst c, snd c - girl.fly_speed)
    | 2 -> girl.coordinate <- (fst c + girl.fly_speed, snd c)
    | 3 -> girl.coordinate <- (fst c, snd c + girl.fly_speed)
    | 4 -> girl.coordinate <- (fst c - girl.fly_speed, snd c)
    | _ -> ()
  end
  else ()

(* [update_ai] consolidates all AI functionality into one method.
 * Returns the AI after one "frame" of the AI. The behavior of an AI can
 * be summarized as follows: If the AI has no pillow, and there is a pillow
 * on the screen, then it randomly chooses a path to get to the pillow.
 * If the AI has a pillow, then it randomly chooses a non-disabled girl to
 * target and attacks her. Otherwise, she does nothing (sits there).*)
let update_ai s ai =
  let s' = begin match s.bloom with
    | Bloom b -> check_still_disabled b;
      if b.is_disabled then disabled_movement b
      else if b.has_pillow then attack_girl s ai "bloom" "b1" b
      else move_to_closest_pillow "b1" ai b s;
      begin match s.soap with
        | Soap so -> check_still_disabled so;
          if so.is_disabled then disabled_movement so
          else if so.has_pillow then attack_girl s ai "soap" "b2" so
          else move_to_closest_pillow "b2" ai so s; s
        | _ -> s
      end
    | _ -> s
  end in s'
