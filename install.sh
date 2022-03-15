#!/usr/bin/env bash

CONFIG_PATH=$HOME/.config/polybar

[ -e "$CONFIG_PATH" ] && mv $CONFIG_PATH $CONFIG_PATH~

cp -r `pwd`/polybar $HOME/.config

[ ! "$HOME/.bin/polybar" ] && mkdir -p $HOME/.bin/polybar

cp `pwd`/scripts/* $HOME/.bin/polybar

echo 'enjoy.'
