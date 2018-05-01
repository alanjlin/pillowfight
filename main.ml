open Js
open Js_of_ocaml

(*let initialize _ =
  let canvas = Opt.get(
      Opt.bind(Dom_html.document##getElementById(string "canvas"))
        Dom_html.CoerceTo.canvas) in
  let _ = canvas##getContext(Dom_html._2d_) in
  let _ = Dom_html.addEventListener Dom_html.document Dom_html.Event.keydown
      (Dom_html.handler State.keydown) _true in
  let _ = Dom_html.addEventListener Dom_html.document Dom_html.Event.keyup
      (Dom_html.handler State.keyup) _true in
  let _ = State.update_all canvas in
    ()*)
