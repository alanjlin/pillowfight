open State

(* Display will handle all of the GUI and the actual pictures, sprites, etc.
   for all objects. Many of these functions return type unit because
   they are purely "side effects"
*)

(* effects: [draw_state context state] draws the following items based on info
   from [state]:
   - background
   - score for each girl
   - time
   - pillows
   - each girl
   returns: nothing
   raises: Failure "not possible" if [state.bloom, state.soap, state.mcup]
   somehow, for some god forsaken reason, doesn't have type
   [Bloom * Soap * Margarinecup]
   requires:
   - [context] : Dom_html.canvasRenderingContext2D Js.t
   - [state] : State.st
*)
val draw_state: Dom_html.canvasRenderingContext2D Js.t -> st -> unit

(* effects: [draw_winscreen context name] draws the win screen text onto
   [context] based on who had the highet score (given by [name]).
   returns: nothing
   raises: nothing
   requires:
   - [context] : Dom_html.canvasRenderingContext2D Js.t
   - [name] is either "bloom", "soap", "mcup", or "tie"*)
val draw_winscreen: Dom_html.canvasRenderingContext2D Js.t -> string -> unit
