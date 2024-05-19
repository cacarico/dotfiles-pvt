#!/usr/bin/env fish

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Function to setup fish greeting
# -----------------------------------------------------------------------------


function fish_greeting
    # List of available cowsay animals grouped for readability
    #set animals \
    #beavis.zen bong bud-frogs bunny cheese \
    #cower daemon RRfault dragon dragon-and-cow \
    #elephant elephant-in-snake eyes flaming-sheep ghostbusters \
    #head-in hellokitty kiss kitty koala \
    #kosh luke-koala meow milk moofasa \
    #moose mutilated ren satanic sheep \
    #skeleton small sodomized stegosaurus stimpy \
    #supermilker surgery telebears three-eyes turkey \
    #turtle tux udder vader vader-koala www
    #
    #set animals beavis.zen
    #
    ## Select a random animal
    #set random_index (math (random) % (count $animals) + 1)
    #set random_animal $animals[$random_index]
    #
    ## Use cowsay with the random animal
    #fortune | cowsay -pn -f $random_animal

end
