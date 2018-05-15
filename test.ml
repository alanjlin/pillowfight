open OUnit2
open State
open Actors
open Js
open Js_of_ocaml
open Constants
module Html = Dom_html

let state1 = {init_st with
  collisions = [GirlOnPillow (init_bloom, init_pillow)]
  }

let state2 = update_st state1


let p = Regular {
    move_speed = 0;
    fly_speed = 0;
    throw_power = 0;
    recovery_time = 5;
    direction = 0;
    coordinate = (0, 0);
    has_pillow = false;
    img_src = "./pics/sprite_og.png";
    who_threw = "na";
    score = 0;
    is_disabled = false;
    last_time_disabled = 0.;
  }

let s = {
  bloom = init_bloom;
  soap = init_soap;
  mcup = init_mcup;
  pillows = [p];
  collisions = [];
  time = 0.;
  last_time_of_pillow_spawn = 0.;
  random_time = 0.;
  game_start = Unix.gettimeofday ();
  game_over = false;
}


let s' = {
  bloom = init_bloom;
  soap = init_soap;
  mcup = Margarinecup {
      move_speed = 4;
      fly_speed = 8;
      throw_power = 1;
      recovery_time = 3;
      direction = 1;
      coordinate = (0, 0);
      has_pillow = false;
      img_src = "./pics/bloom.png";
      who_threw = "na";
      score = 0;
      is_disabled = false;
      last_time_disabled = 0.;
    };
  pillows = [];
  collisions = [];
  time = 0.;
  last_time_of_pillow_spawn = 0.;
  random_time = 0.;
  game_start = Unix.gettimeofday ();
  game_over = false;
}


let canvas = Opt.get(
    Opt.bind(Dom_html.document##getElementById(string "canvas"))
      Dom_html.CoerceTo.canvas) (fun _ -> assert false)
let context = canvas##getContext (Dom_html._2d_)

let state_tests = [
  "remove_pillow" >:: (fun _ -> assert_equal [] state2.pillows);
  "soap_same" >:: (fun _ -> assert_equal state1.soap state2.soap);
  "mcup_same" >:: (fun _ -> assert_equal state1.mcup state2.mcup);
  "draw_st" >:: (fun _ -> assert_equal state1
                    (Display.draw_state context state1; state1));
  "gp1" >:: (fun _ -> assert_equal s'.bloom
                (update_st s).bloom);
  "gp2" >:: (fun _ -> assert_equal s'.mcup
                (update_st s).mcup);
]

let tests =
  "test suite for final project" >::: state_tests

let _ = run_test_tt_main tests
