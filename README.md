FM Audio Processing Chain for Raspberry Pi (Bookworm)
=====================================================

This project sets up a full audio processing chain for FM broadcasting using a Raspberry Pi running Debian Bookworm (64-bit). It includes:

- JACK audio server
- Calf plugins (Emphasis + Compressor)
- Silence detection and stream recovery
- MPlayer for radio playback
- A clean Bash-based startup system
- Optional GUI via QJackCtl

Features
--------
- Auto-start audio chain with JACK, Calf plugins, and MPlayer
- Live silence detection with FFmpeg (if the stream becomes silent, MPlayer is restarted)
- Calf preset support: Load your pre-configured Calf audio plugin chain
- Custom working directory: All scripts and presets are stored in ~/fm_audio_chain

Installation
------------
Run the setup script on a fresh Raspberry Pi OS (Bookworm):

    chmod +x install_fm_audio_chain.sh
    ./install_fm_audio_chain.sh

This will install:
- jackd2, qjackctl, calf-plugins, mplayer, ffmpeg
- All needed audio dependencies
- Configure the analog audio jack
- Create the folder ~/fm_audio_chain/

Usage
-----
1. Place your Calf preset XML file in:

    ~/fm_audio_chain/fm-preset.xml

2. Start the chain manually:

    ~/fm_audio_chain/fm_chain_auto.sh

This will:
- Launch JACK
- Load Calf plugins with your preset
- Start MPlayer with the radio stream
- Auto-connect all JACK ports
- Restart MPlayer if silence is detected in the stream

Stream
------
The default stream used is:

    https://ouifm6.ice.infomaniak.ch/collector-rnt.mp3

You can change this URL in fm_chain_auto.sh.

Optional
--------
- Create a .desktop launcher to run the script from the desktop
- Use qjackctl to manage JACK visually if needed

License
-------
MIT. Use freely, modify, and share.

Author
------
Built and tested on Raspberry Pi 3 using Raspberry Pi OS Bookworm (64-bit).
