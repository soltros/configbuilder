#!/bin/bash

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install io.kopia.KopiaUI com.valvesoftware.Steam net.davidotek.pupgui2 com.heroicgameslauncher.hgl com.usebottles.bottles io.github.prateekmedia.appimagepool -y
