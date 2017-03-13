module Main where

import Prelude
import Audio.SoundFont (AUDIO, LOADFONT,MidiNote,
                   getAudioContext, canPlayOgg, isWebAudioEnabled, getCurrentTime,
                   loadPianoSoundFont, loadRemoteSoundFont, playNote, playNotes)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Timer (TIMER, TimeoutId, setTimeout)


note :: Int -> Number -> Number -> Number -> MidiNote
note id timeOffset duration gain =
  { id : id, timeOffset : timeOffset, duration : duration, gain : gain }

noteSample1 :: MidiNote
noteSample1 = note 60 0.0 0.3 1.0

noteSample2 :: MidiNote
noteSample2 = note 62 0.4 0.3 1.0

noteSample3 :: MidiNote
noteSample3 = note 64 0.8 0.2 1.0

notesSample :: Array MidiNote
notesSample =
 [ note 60 1.0 0.5 1.0
 , note 62 1.5 0.5 1.0
 , note 64 2.0 0.5 1.0
 , note 65 2.5 0.5 1.0
 , note 67 3.0 1.5 1.0
 , note 71 3.0 1.5 1.0
 ]

main :: forall e.
        Eff
          ( au :: AUDIO
          , console :: CONSOLE
          , loadSoundFont :: LOADFONT
          , timer :: TIMER
          , playNote :: AUDIO
          | e
          )
          TimeoutId
main = do
    context <- getAudioContext
    playsOgg <- canPlayOgg
    log ("can I play OGG: " <> show playsOgg)
    audioEnabled <- isWebAudioEnabled
    log ("can I play web-audio: " <> show audioEnabled)
    let time = getCurrentTime context
    log ("current time in audio context: " <> show time)
    loaded <- loadPianoSoundFont context "soundfonts"
    log ("piano soundfonts loaded: " <> show loaded)
    -- the soundfont loads asynchronously so wait for it to load before we play
    setTimeout 1000 do
      played1 <- playNote noteSample1
      log ("note duration: " <> show played1)
      played2 <- playNote noteSample2
      log ("note duration: " <> show played2)
      played3 <- playNote noteSample3
      log ("notes duration: " <> show played3)
      played4 <- playNotes notesSample
      log ("notes duration: " <> show played4)


    -- the remote soundfonts take much longer to load
    setTimeout 2000 do
      loaded1 <- loadRemoteSoundFont context "marimba"
      log ("remote soundfonts loaded: " <> show loaded1)
    setTimeout 8000 do
      played1 <- playNote noteSample1
      log ("note duration: " <> show played1)
      played2 <- playNote noteSample2
      log ("note duration: " <> show played2)
      played3 <- playNote noteSample3
      log ("notes duration: " <> show played3)
      played4 <- playNotes notesSample
      log ("notes duration: " <> show played4)
