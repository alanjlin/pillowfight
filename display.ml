
module Html = Dom_html
let js = Js.string
let document = Html.document

let dims = (400, 400) (* width, height *)

(* [context_of_canvas canvas] returns the context of [canvas] *)
let context_of_canvas canvas = canvas##getContext (Dom_html._2d_)

(* let render sprite (posx,posy) =
  let context = sprite.context in
  let (sx, sy) = sprite.params.src_offset in
  let (sw, sh) = sprite.params.frame_size in
  let (dx, dy) = (posx,posy) in
  let (dw, dh) = sprite.params.frame_size in
  let sx = sx +. (float_of_int !(sprite.frame)) *. sw in
  (*print_endline (string_of_int !(sprite.frame));*)
  (*context##clearRect(0.,0.,sw, sh);*)
   context##drawImage_full(sprite.img, sx, sy, sw, sh, dx, dy, dw, dh) *)

(* [draw_actor context] draws the sprite image *)
let draw_actor context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string "./pics/sprite.png")
  context##drawImage_full(img, 0, 0, 20, 20, 200, 200, 20, 20)

(* [draw_bg context] draws the background *)
let draw_bg context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string "./pics/background.png");
  (* ctx.drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight);
     sx = 0, sy = 0, sWidth = 400, sHeight = 400,
     dx = 0, dy = 0, dWidth = 400, dHeight = 400,
     bg name = background.png
  *)
  context##drawImage_full(img, 0, 0, 400, 400, 0, 0, 400, 400)

(* [draw_state context state] currently hard-coded to work with  *)
let draw_state context state =
  draw_actor context
  draw_bg context
