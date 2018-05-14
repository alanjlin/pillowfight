open State
open Actors
open Constants

module Html = Dom_html
let js = Js.string
let document = Html.document

(* effects: [update_girl_imgsrc info context] assigns the proper img_src based
   on if the girl represented by [info] has a pillow or not. If the girl does,
   then the image will be set to the throwing sprite, otherwise it will be
   set to the normal sprite.
   returns: nothing
   raises: nothing
   requires:
    - context : Dom_html.canvasRenderingContext2D Js.t
    - girl : Actors.girl *)
let update_girl_imgsrc info context = match info with
  | Bloom b -> if b.has_pillow then
      (if b.direction = 1 then b.img_src <- _BTHROWSPRITEUP
      else if b.direction = 2 then b.img_src <- _BTHROWSPRITERIGHT
      else if b.direction = 3 then b.img_src <- _BTHROWSPRITEDOWN
      else b.img_src <- _BTHROWSPRITELEFT)
    else if b.is_disabled then b.img_src <- _BSLEEPSPRITE
    else b.img_src <- _BNORMALSPRITE
  | Soap so -> if so.has_pillow then
      (if so.direction = 1 then so.img_src <- _STHROWSPRITEUP
       else if so.direction = 2 then so.img_src <- _STHROWSPRITERIGHT
       else if so.direction = 3 then so.img_src <- _STHROWSPRITEDOWN
       else so.img_src <- _STHROWSPRITELEFT)
    else if so.is_disabled then so.img_src <- _SSLEEPSPRITE
    else so.img_src <- _SNORMALSPRITE
  | Margarinecup m -> if m.has_pillow then
      (if m.direction = 1 then m.img_src <- _MTHROWSPRITEUP
       else if m.direction = 2 then m.img_src <- _MTHROWSPRITERIGHT
       else if m.direction = 3 then m.img_src <- _MTHROWSPRITEDOWN
       else m.img_src <- _MTHROWSPRITELEFT)
    else if m.is_disabled then m.img_src <- _MSLEEPSPRITE
    else m.img_src <- _MNORMALSPRITE

(* effects: [draw_updated_girl context] draws the sprite image at
   its coordinates
  returns: nothing
  raises: nothing
  requires:
   - context : Dom_html.canvasRenderingContext2D Js.t
   - girl : Actors.girl
*)
let draw_updated_girl girl context =
  let _ = update_girl_imgsrc girl context in
  let img = (Dom_html.createImg Dom_html.document) in
  (* added the line below to type check *)
  let girl' = match girl with Bloom b -> b | Soap so -> so | Margarinecup m -> m
  in img##src <- (Js.string girl'.img_src);
  context##drawImage_full(img, 0., 0., _GIRLSIZE, _GIRLSIZE,
                          float_of_int (fst girl'.coordinate),
                          float_of_int (snd girl'.coordinate),
                          _GIRLSIZE, _GIRLSIZE)

(* effects: [draw_pillow st] loops through [st.pillows] to draw each pillow on
   [context]
   returns: nothing
   raises: nothing
   requires:
   - context : Dom_html.canvasRenderingContext2D Js.t *)
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

(* effects: [draw_bg context] draws our background file onto [context].
   returns: nothing
   raises: nothing
   requires:
   - context : Dom_html.canvasRenderingContext2D Js.t *)
let draw_bg context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string "./pics/background.png");
  context##drawImage_full(img, 0., 0., _BGSIZE, _BGSIZE,
                          0., 0., _BGSIZE, _BGSIZE)

(* effects: [draw_scoreboard context] draws the scoreboard onto [context].
   returns: nothing
   raises: nothing
   requires:
   - context : Dom_html.canvasRenderingContext2D Js.t
   - "./pics/scoreboard.png" is a file that exists *)
let draw_scoreboard context =
  let img = (Dom_html.createImg Dom_html.document) in
  img##src <- (Js.string "./pics/scoreboard.png");
  context##drawImage_full(img, 0., 0., _SBWIDTH, _SBHEIGHT,
                          _BGSIZE, 0., _SBWIDTH,  _SBHEIGHT)

(* effects: [draw_score context score name] draws [score] of the girl
   represented by [name] onto [context].
   returns: nothing
   raises: nothing
   requires:
   - context : Dom_html.canvasRenderingContext2D Js.t
   - score : int
   - name : string
*)
let draw_score context score name =
  let score_coord =
    if name = "bloom" then (_BSCORECOORDX, _BSCORECOORDY)
    else if name = "soap" then (_SSCORECOORDX, _SSCORECOORDY)
    else (_MSCORECOORDX, _MSCORECOORDY)
  in
  context##fillStyle <- (Js.string "white");
  context##font <- (Js.string "50px 'Magical'");
  context##fillText (Js.string (string_of_int score), fst score_coord, snd score_coord)

(* effects: [draw_time context time] draws [time] (given by state.time)
   in the time box on the scoreboard.
   returns: nothing
   raises: nothing
   requires:
   - context : Dom_html.canvasRenderingContext2D Js.t
   - time : int *)
let draw_time context time =
  context##fillStyle <- (Js.string "white");
  context##font <- (Js.string "25px 'Magical'");
  context##fillText (Js.string (string_of_int time), _TIMECOORDX, _TIMECOORDY)

(* effects: [wipe context] resets the context to a blank square context with
   side length [_BGSIZE].
   returns: nothing
   raises: nothing
   requires:
   - context: Dom_html.canvasRenderingContext2D Js.t *)
  let wipe context =
    context##clearRect (0., 0., _BGSIZE, _BGSIZE)

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
   - context: Dom_html.canvasRenderingContext2D Js.t
   - state: State.st
*)
let draw_state context state =
  wipe context;
  match state.bloom, state.soap, state.mcup with
  | Bloom b, Soap so, Margarinecup m ->
    draw_bg context;
    draw_scoreboard context;
    draw_score context b.score "bloom";
    draw_score context so.score "soap";
    draw_score context m.score "mcup";
    draw_time context (int_of_float (_GAMETIME -. state.time));
    (* changed from m to state.mcup to type check *)
    draw_updated_girl state.bloom context;
    draw_updated_girl state.soap context;
    draw_updated_girl state.mcup context;
    draw_pillow context state;
  | _ -> failwith "not possible";
