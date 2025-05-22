#!/bin/bash

echo ">>> [1/5] Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo ">>> [2/5] Installing audio dependencies..."
sudo apt install -y \
  jackd2 qjackctl \
  calf-plugins \
  mplayer ffmpeg \
  alsa-utils \
  libasound2-plugins \
  libgtk2.0-0

echo ">>> [3/5] Adding current user to the 'audio' group..."
sudo usermod -aG audio $USER

echo ">>> [4/5] Enabling analog audio output (jack)..."
sudo raspi-config nonint do_audio 0

echo ">>> [5/5] Creating working directory for scripts and presets..."
mkdir -p ~/fm_audio_chain
echo "(You can place your Calf presets and bash scripts here.)"

echo ""
echo "✅ Installation complete."
echo "ℹ️ Please reboot your Raspberry Pi to apply changes."
