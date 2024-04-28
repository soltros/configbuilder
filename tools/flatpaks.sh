#!/bin/bash

/run/current-system/sw/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

/run/current-system/sw/bin/flatpak install io.kopia.KopiaUI com.valvesoftware.Steam net.davidotek.pupgui2 com.heroicgameslauncher.hgl com.usebottles.bottles io.github.prateekmedia.appimagepool -y
