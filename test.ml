open OUnit2
open State
open Actors

let state1 = init_st

let bloom1 = Bloom {
    move_speed = 1;
    fly_speed = 0;
    throw_power = 1;
    recovery_time = 3;
    direction = 1;
    coordinate = (200, 200);
    has_pillow = false;
    img_src = "./pics/bloom.png";
  }

let soap1 = Soap {
    move_speed = 1;
    fly_speed = 0;
    throw_power = 1;
    recovery_time = 3;
    direction = 1;
    coordinate = (400, 400);
    has_pillow = false;
    img_src = "./pics/soap.png";
  }

let state2 = {init_st with
  soap = soap1;
  bloom = bloom1;
  collisions = [GirlOnPillow (init_bloom, init_pillow)]
  }

let state3 = update_st state2

let state_tests = [
  "remove_pillow" >:: (fun _ -> assert_equal [] state3.pillows);
]

let tests =
  "test suite for finasl project" >:::
    state_tests


let _ = run_test_tt_main tests
