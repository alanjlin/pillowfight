(* [ai] will be used to give functionality and define behavior for the
   characters not controlled by human players, i.e. the AI. *)

(* this function will take in a state [st] and a reference point girl [g1] and
 return the girl [g2] who is closest in distance to [g1],
 excluding [g1] herself. *)
val nearest_girl : State.st -> Actor.girl -> Actor.girl

(* this function will take in a state [st] and a reference point girl [g1] and
 return the pillow [p] that is closest in distance to [g1]. If there are
 multiple equidistant pillows, then the first one in the list of pillows
 will be returned.
*)
val nearest_pillow: State.st -> Actor.girl -> pillow

(* [do' st g1 ] assigns girl [g1] what to do based on her current actions in [st].
 - If [g1] does not have a pillow, then she will find the nearest pillow and
 go towards it. If there are currently no pillows on the map, she will do
 nothing.
 - If [g1] does have a pillow and hasn't found a girl to throw it at, then
 she will find the nearest girl and go towards that girl to throw the pillow.
*)
val do': State.st -> Actor.girl -> State.st
