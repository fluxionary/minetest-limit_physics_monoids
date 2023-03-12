# limit_physics_monoids

overrides monoids controlling player physics provided by player_monoids, to limit how big they can grow.

### why

the physics overrides are multiplicative factors controlling player speed, jump strength, and gravity.

it may make sense for one mod, or another, to double the speed of a player. however, there's multiple reasons to *not*
scale them multiplicatively, or even additively.
1. IRL, doubling your speed requires *quadrupling* your energy input.
  doubling your speed twice requires increasing your energy input 16x. these energy requirements get even worse when
  you take air resistance and other friction into consideration.
2. in minetest, you generally accelerate to maximum speed almost instantly.
  i've just discovered the

### how

properties of a limiter:
* continuous
* nondecreasing
* f(0) = 0

  it should remain possible to completely disable the functioning of the physic

* f(1) = 1

  no change should remain no change

* f\'(x) differentiable, decreasing when x > 1

3 limiters are currently provided:
*
