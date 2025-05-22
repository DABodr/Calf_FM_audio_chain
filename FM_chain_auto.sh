#!/bin/bash

# [CONFIG]
STREAM_URL="https://ouifm6.ice.infomaniak.ch/collector-rnt.mp3"
WORKDIR="/home/$USER/fm_audio_chain"
CALF_PRESET="$WORKDIR/fm-preset.xml"

# [1] Start JACK on analog output
jackd -R -dalsa -dhw:0 -r44100 -p1024 -n2 &
sleep 4

# [2] Launch Calf plugins with preset from fm_audio_chain
calfjackhost --load "$CALF_PRESET" &
sleep 2

# [3] Setup JACK connections
connect_jack_ports() {
  jack_connect "MPlayer:out_0" "Calf Studio Gear:Emphasis In #1"
  jack_connect "MPlayer:out_1" "Calf Studio Gear:Emphasis In #2"
  jack_connect "Calf Studio Gear:Emphasis Out #1" "Calf Studio Gear:Compressor In #1"
  jack_connect "Calf Studio Gear:Emphasis Out #2" "Calf Studio Gear:Compressor In #2"
  jack_connect "Calf Studio Gear:Compressor Out #1" "system:playback_1"
  jack_connect "Calf Studio Gear:Compressor Out #2" "system:playback_2"
}

# [4] Launch MPlayer with stream
start_stream() {
  echo "[STREAM] Launching stream..."
  mplayer -ao jack "$STREAM_URL" &
  MPLAYER_PID=$!
  sleep 2
  connect_jack_ports
}

# [5] Detect silence using ffmpeg
check_silence() {
  echo "[CHECK] Checking for silence in stream..."
  max_volume=$(ffmpeg -t 10 -i "$STREAM_URL" -af "volumedetect" -f null /dev/null 2>&1 | grep max_volume | awk '{print $5}')
  volume_int=$(echo "$max_volume" | sed 's/-//' | cut -d'.' -f1)
  [[ -z "$volume_int" || "$volume_int" -ge 30 ]]
}

# [6] Initial stream launch (only if not silent)
if check_silence; then
  echo "[WAIT] Stream silent. Will retry automatically..."
else
  start_stream
fi

# [7] Recheck every 2 minutes, restart MPlayer if silent
while true; do
  sleep 120
  if check_silence; then
    echo "[RESTART] Silence detected. Restarting MPlayer..."
    kill $MPLAYER_PID 2>/dev/null
    sleep 1
    start_stream
  else
    echo "[OK] Stream is active."
  fi
done
