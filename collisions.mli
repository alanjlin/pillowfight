open State
open Actors

module type Collisions = sig
  (* invariant representing the types of collisions *)
  type collision =
    | GirlOnGirl
    | GirlOnBed
    | GirlOnWall
    | GirlOnProfessor
    | PillowOnProfessor
    | GirlOnPillow
    | PillowOnGirl

  (* effects: [collisionHandler cl st] updates the state depending on the collision.
     For example, if a girl collides with a pillow, the state should be updated
     with the girl holding the pillow. Another example: when the girls collides
     with the bed, the girl should slow down.
    returns: the updated state *)
    val collisionHandler: collision -> State.state -> State.state

  (* effects: [isColliding ob1 ob2] checks if two objects [ob1] and [ob2] are
      colliding or not.
      returns: true if [ob1] and [ob2] are colliding, and false otherwise *)
    val isColliding: Actors.obj -> Actors.obj -> bool

end
