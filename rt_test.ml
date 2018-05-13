(*

Ryan's test filezz

let init_bloom =  Bloom {
    move_speed = 2;
    fly_speed = 3;
    throw_power = 1;
    recovery_time = 3;
    direction = 1;
    coordinate = (0, 0);
    has_pillow = false;
    img_src = "./pics/bloom.png";
  }

let init_soap = Soap {
    move_speed = 2;
    fly_speed = 3;
    throw_power = 1;
    recovery_time = 3;
    direction = 1;
    coordinate = (200, 200);
    has_pillow = false;
    img_src = "./pics/soap.png";
  }

let init_mcup = Margarinecup {
    move_speed = 2;
    fly_speed = 3;
    throw_power = 1;
    recovery_time = 3;
    direction = 1;
    coordinate = (200, 200);
    has_pillow = true;
    img_src = "./pics/mcup.png";
  }

let init_pillow = Regular {
    move_speed = 1;
    fly_speed = 0;
    throw_power = 1;
    recovery_time = 3;
    direction = 1;
    coordinate = (0, 0);
    has_pillow = false;
    img_src = "./pics/sprite_og.png";
  }

let init_st = {
  bloom = init_bloom;
  soap = init_soap;
  mcup = init_mcup;
  pillows = [init_pillow];
  collisions = [];
  scores = [("bloom", 0); ("soap", 0); ("mcup", 0)];
  time = 0.;
  last_time_of_pillow_spawn = 0.;
  random_time = 0.;
  game_start = Unix.gettimeofday ()
} *)
