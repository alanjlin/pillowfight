open State
open Actors
open Constants

module Html = Dom_html
let js = Js.string
let document = Html.document

(* [update_girl_imgsrc info context] assigns the proper img_src based on
   if the girl represented by [info] has a pillow or not. If the girl does,
   then the image will be set to the throwing sprite, otherwise it will be
set to the normal sprite.*)
let update_girl_imgsrc info context = match info with
  | Bloom b -> if b.has_pillow then b.img_src <- _BTHROWSPRITE
               else b.img_src <- _BNORMALSPRITE
  | Soap so -> if so.has_pillow then so.img_src <- _STHROWSPRITE
               else so.img_src <- _SNORMALSPRITE
  | Margarinecup m -> if m.has_pillow then m.img_src <- _MTHROWSPRITE
                      else m.img_src <- _MNORMALSPRITE

(* [update_draw_actor context] draws the sprite image at its updated coordinates. *)
let update_draw_actor info context =
  let _ = update_girl_imgsrc info context in
  let img = (Dom_html.createImg Dom_html.document) in
  (* added the line below to type check *)
  let info' = match info with Bloom b -> b | Soap so -> so | Margarinecup m -> m in
  img##src <- (Js.string info'.img_src);
  context##drawImage_full(img, 0., 0., _GIRLSIZE, _GIRLSIZE,
                          float_of_int (fst info'.coordinate),
                          float_of_int (snd info'.coordinate),
                          _GIRLSIZE, _GIRLSIZE)

(* [draw_actor context] draws the sprite image. currently hardcoded for just
the sprite *)
(* let draw_actor context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string "./pics/sprite.png");
  context##drawImage_full(img, 0., 0., 20., 20., 200., 200., 20., 20.) *)

(* [draw_pillow st] loops through [st.pillows] to draw each pillow *)
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

(* [draw_bg context] draws the background onto [context].
   static, never does anything else *)
let draw_bg context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string "./pics/background.png");
  (* ctx.drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight);
     sx = 0, sy = 0, sWidth = 400, sHeight = 400,
     dx = 0, dy = 0, dWidth = 400, dHeight = 400,
     bg name = background.png
  *)
  context##drawImage_full(img, 0., 0., _BGSIZE, _BGSIZE,0., 0., _BGSIZE, _BGSIZE)

(* [draw_scoreboard context] draws the scoreboard onto [context].
   static, never does anything else *)
let draw_scoreboard context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string "./pics/scoreboard.png");
  context##drawImage_full(img, 0., 0., _SBWIDTH, _SBHEIGHT, 600., 0., _SBWIDTH,  _SBHEIGHT)

let draw_score context score name =
  let score_coord =
    if name = "bloom" then (_BSCORECOORDX, _BSCORECOORDY)
    else if name = "soap" then (_SSCORECOORDX, _SSCORECOORDY)
    else (_MSCORECOORDX, _MSCORECOORDY)
  in
  context##fillStyle <- (Js.string "white");
  context##font <- (Js.string "50px 'Magical'");
  context##fillText (Js.string (string_of_int score), fst score_coord, snd score_coord)

(* [draw_time context time] draws [time] (given by state.time) in the time box
on the scoreboard *)
let draw_time context time =
  context##fillStyle <- (Js.string "white");
  context##font <- (Js.string "25px 'Magical'");
  context##fillText (Js.string (string_of_int time), _TIMECOORDX, _TIMECOORDY)

(* [wipe context] resets the context to a blank square context with
   side length [_BGSIZE] *)
let wipe (context: Dom_html.canvasRenderingContext2D Js.t) =
  context##clearRect (0., 0., _BGSIZE, _BGSIZE)

(* [draw_state context state] currently hard-coded to work with  *)
(* We will later need to pass in an argument for which girl. It is hardcoded for now.*)
let draw_state (context: Dom_html.canvasRenderingContext2D Js.t) state =
  wipe context;
  match state.bloom, state.soap, state.mcup with
  | Bloom b, Soap so, Margarinecup m ->
    draw_bg context;
    draw_scoreboard context;
    draw_score context b.score "bloom";
    draw_score context so.score "soap";
    draw_score context m.score "mcup";
    draw_time context (int_of_float (120. -. state.time));
    (* changed from m to state.mcup to type check *)
    update_draw_actor state.bloom context;
    update_draw_actor state.soap context;
    update_draw_actor state.mcup context;
    draw_pillow context state;
  | _ -> failwith "not possible";
