open State
open Actors
open Constants

module Html = Dom_html
let js = Js.string
let document = Html.document

(* [update_draw_actor context] draws the sprite image at its updated coordinates.
   currently hardcoded for just updating the sprite *)
let update_draw_actor info context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string info.img_src);
  context##drawImage_full(img, 0., 0., _GIRLSIZE, _GIRLSIZE,
                          float_of_int (fst info.coordinate),
                          float_of_int (snd info.coordinate),
                          _GIRLSIZE, _GIRLSIZE)

(* [draw_actor context] draws the sprite image. currently hardcoded for just
the sprite *)
(* let draw_actor context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string "./pics/sprite.png");
  context##drawImage_full(img, 0., 0., 20., 20., 200., 200., 20., 20.) *)

let rec draw_pillow (context: Dom_html.canvasRenderingContext2D Js.t) st =
  match st.pillows with
  | [] -> ()
  | h::t -> match h with
    | Regular pillow ->
    let img = (Dom_html.createImg Dom_html.document) in
    img##src <- (Js.string "./pics/sprite_og.png");
    context##drawImage_full(img, 0., 0., _PILLOWSIZE, _PILLOWSIZE,
                            float_of_int (fst pillow.coordinate),
                            float_of_int (snd pillow.coordinate),
                            _PILLOWSIZE, _PILLOWSIZE);
    draw_pillow context {st with pillows = t}

(* [draw_bg context] draws the background *)
let draw_bg context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string "./pics/background.png");
  (* ctx.drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight);
     sx = 0, sy = 0, sWidth = 400, sHeight = 400,
     dx = 0, dy = 0, dWidth = 400, dHeight = 400,
     bg name = background.png
  *)
  context##drawImage_full(img, 0., 0., _BGSIZE, _BGSIZE,0., 0., _BGSIZE, _BGSIZE)

(* [wipe context] resets the context to a blank square context with
   side length [_BGSIZE] *)
let wipe (context: Dom_html.canvasRenderingContext2D Js.t) =
  context##clearRect (0., 0., _BGSIZE, _BGSIZE)

(* [draw_state context state] currently hard-coded to work with  *)
(* We will later need to pass in an argument for which girl. It is hardcoded for now.*)
let draw_state (context: Dom_html.canvasRenderingContext2D Js.t) state=
  wipe context;
  match state.mcup with
  | Margarinecup m ->
    draw_bg context;
    update_draw_actor m context;
    draw_pillow context state;
  | _ -> failwith "not possible"
