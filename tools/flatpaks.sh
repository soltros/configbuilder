#!/bin/bash

/nix/store/dsr3dbvxkl51164q9r35sw8ya94pf88j-system-path/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

/nix/store/dsr3dbvxkl51164q9r35sw8ya94pf88j-system-path/bin/flatpak install io.kopia.KopiaUI com.valvesoftware.Steam net.davidotek.pupgui2 com.heroicgameslauncher.hgl com.usebottles.bottles io.github.prateekmedia.appimagepool -y
