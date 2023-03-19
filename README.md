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
  (i've just discovered the
  [movement_acceleration_*](https://github.com/minetest/minetest/blob/3e148e2810a2b1bb47cada2bd431df8f0bad2f96/builtin/settingtypes.txt#L767-L777)
  parameters, and there's a pending PR to add these to the physics overrides...)

### how

the composed (folded) result value for the physics trait is passed through a "limiter" function, which scales the
value.

properties of a limiter:
* continuous
* nondecreasing
* f(0) = 0

  it should remain possible to completely disable the functioning of the physic

* f(1) = 1

  no change should remain no change.

* f\'(x) differentiable, decreasing when x > 1

  it should decrease smoothly.

3 limiters are currently provided:
* atanh
  values increase near-linearly at first, but drop off to a constant maximum.
* gamma
  growth is limited by a constant exponent
* log__n
  growth is limited as log^n, which is "flatter" than gamma, but trickier to optimize

| limiter | param_1 | param_2 | 0 | 1 | 2    | 4    | 8    | 12   | 16   | 32   |
| ------- | ------- | ------- | - | - | ---- | ---- | ---- | ---- | ---- | ---- |
| gamma   | 0.57    | N/A     | 0 | 1 | 1.48 | 2.20 | 3.27 | 4.12 | 4.86 | 7.21 |
| log__n  | 2       | 0.1     | 0 | 1 | 1.65 | 2.49 | 3.49 | 4.12 | 4.59 | 5.76 |
| tanh    | 3       | N/A     | 0 | 1 | 2    | 3.37 | 4.05 | 4.11 | 4.11 | 4.11 |
