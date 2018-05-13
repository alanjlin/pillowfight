open Actors
open State

(* Requires: d1 and d2 are the difference in x and y coordinates *
 * Returns: the distance. *)
let dist d1 d2 =
  int_of_float (sqrt (float_of_int ((d1 * d1) + (d2 * d2))))

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
let move_to_closest_pillow (girl: info) s =
  let cgirl = girl.coordinate in
  let clist =
    List.map (fun p -> match p with Regular i -> i.coordinate) s.pillows in
  let pillow_coord = find_closest_pillow cgirl clist cgirl in
  if fst pillow_coord - fst cgirl > 1 then
    girl.coordinate <- (fst cgirl + girl.move_speed, snd cgirl)
  else if fst pillow_coord - fst cgirl < -1 then
    girl.coordinate <- (fst cgirl - girl.move_speed, snd cgirl)
  else if snd pillow_coord - snd cgirl > 1 then
    girl.coordinate <- (fst cgirl, snd cgirl + girl.move_speed)
  else if snd pillow_coord - snd cgirl < -1 then
    girl.coordinate <- (fst cgirl, snd cgirl - girl.move_speed)
  else ()

let update_ai s =
  let s' = begin match s.bloom with
    | Bloom b ->
      if b.has_pillow then () else move_to_closest_pillow b s;
      begin match s.soap with
        | Soap so ->
          if so.has_pillow then () else move_to_closest_pillow so s; s
        | _ -> s
      end
    | _ -> s
  end in s'
