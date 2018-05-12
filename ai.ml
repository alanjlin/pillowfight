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

let move_to_closest_pillow girl s : info = failwith "unimplemented"
  (* let cgirl = begin match girl with
    | Bloom b -> b.coordinate
    | Soap s -> s.coordinate
    | Margarinecup m -> m.coordinate
  end in
  let clist =
    List.map (fun p -> match p with Regular i -> i.coordinate) s.pillows in
  let pillow_coord = find_closest_pillow cgirl clist cgirl in
  if fst pillow_coord - fst cgirl > 1 then s <-  *)


let update_ai s =
  let s' = begin match s.bloom with
    | Bloom b -> s.bloom <- Bloom (move_to_closest_pillow b s); s
    | _ -> s
  end in s'
