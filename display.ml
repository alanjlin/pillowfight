open State
open Actors

module Html = Dom_html
let js = Js.string
let document = Html.document

(* [update_draw_actor context] draws the sprite image at its updated coordinates.
   currently hardcoded for just updating the sprite *)
let update_draw_actor info context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string "./pics/sprite.png");
  let dx = float_of_int (fst info.coordinate) in
  let dy = float_of_int (snd info.coordinate) in
  context##drawImage_full(img, 0., 0., 20., 20., dx, dy, 20., 20.)

(* [draw_actor context] draws the sprite image. currently hardcoded for just
the sprite *)
let draw_actor context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string "./pics/sprite.png");
  context##drawImage_full(img, 0., 0., 20., 20., 200., 200., 20., 20.)

(* [draw_bg context] draws the background *)
let draw_bg context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string "./pics/background.png");
  (* ctx.drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight);
     sx = 0, sy = 0, sWidth = 400, sHeight = 400,
     dx = 0, dy = 0, dWidth = 400, dHeight = 400,
     bg name = background.png
  *)
  context##drawImage_full(img, 0., 0., 400., 400., 0., 0., 400., 400.)

(* [draw_state context state] currently hard-coded to work with  *)
(* We will later need to pass in an argument for which girl. It is hardcoded for now.*)
let draw_state (context: Dom_html.canvasRenderingContext2D Js.t) state=
  match state.mcup with
  | Margarinecup i -> draw_bg context;
    update_draw_actor i context;
  | _ -> failwith "not possible"
