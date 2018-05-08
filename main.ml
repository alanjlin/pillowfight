open Js
open Js_of_ocaml
module Html = Dom_html

let rec update_all context =
  let rec loop st =
    let st' = State.update_st st in
    (* NOTE: add st back into draw_state once we actually update for movement *)
    Display.draw_state context;
    ignore (Html.window##requestAnimationFrame(
      Js.wrap_callback (fun (t:float) -> loop st')
    ))
in loop State.init_st

let initialize () =
  let canvas = Opt.get(
      Opt.bind(Dom_html.document##getElementById(string "canvas"))
        Dom_html.CoerceTo.canvas) (fun _ -> assert false) in
  let context = canvas##getContext (Dom_html._2d_) in
  let _ = Dom_html.addEventListener Dom_html.document Dom_html.Event.keydown
      (Dom_html.handler State.keydown) _true in
  let _ = Dom_html.addEventListener Dom_html.document Dom_html.Event.keyup
      (Dom_html.handler State.keyup) _true in
  let _ = update_all context in print_endline "hello"

let _ = initialize ()
