open OUnit2
open State
open Actors
open Js
open Js_of_ocaml
module Html = Dom_html

let state1 = {init_st with
  collisions = [GirlOnPillow (init_bloom, init_pillow)]
  }

let state2 = update_st state1

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
]

let tests =
  "test suite for final project" >::: state_tests

let _ = run_test_tt_main tests
