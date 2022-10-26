# Breadbin Engine

A project to create a third person Action RPG framework in Godot 4, aiming for a similar feel to Dark Souls/Bloodborne, with a focus on being as easily extendible as possible.

## Project Goals

* Highly softcoded weapon movesets (a la Dark Souls II) based on getting animation names from a String array and passing them to a main AnimationPlayer loaded with numerous attack AnimationLibraries
> This will let creators construct new weapons with unique movesets easily by simply entering which attack should happen at each combo length
* Movement that feels as similar as possible to DS/BB
* AI customizable from Inspector by adjusting numerous chance values - e.g. how likely they are to deviate from their current target if hit by someone else, whether they're likely to stay nearby or roll away after attacking, etc.

## Credits:

[Pemguin005's Godot Souls-like Controller](https://github.com/pemguin005/Third-Person-Controller---Godot-Souls-like)
