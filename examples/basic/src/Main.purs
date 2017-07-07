module Main where

import Prelude
import Audio.SoundFont (AUDIO, MidiNote,
                   canPlayOgg, isWebAudioEnabled, getCurrentTime,
                   loadPianoSoundFont, loadRemoteSoundFont, playNote, playNotes)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Exception (EXCEPTION, throwException)
import Data.Time.Duration (Milliseconds(..))
import Control.Monad.Aff (runAff, launchAff, delay)

note :: Int -> Int -> Number -> Number -> Number -> MidiNote
note channel id timeOffset duration gain =
  { channel : channel, id : id, timeOffset : timeOffset, duration : duration, gain : gain }

noteSample1 :: MidiNote
noteSample1 = note 0 60 0.0 0.3 1.0

noteSample2 :: MidiNote
noteSample2 = note 0 62 0.4 0.3 1.0

noteSample3 :: MidiNote
noteSample3 = note 0 64 0.8 0.2 1.0

notesSample :: Array MidiNote
notesSample =
 [ note 0 60 1.0 0.5 1.0
 , note 0 62 1.5 0.5 1.0
 , note 0 64 2.0 0.5 1.0
 , note 0 65 2.5 0.5 1.0
 , note 0 67 3.0 1.5 1.0
 , note 0 71 3.0 1.5 1.0
 ]

main :: forall e.
        Eff
          ( au :: AUDIO
          , console :: CONSOLE
          , exception :: EXCEPTION
          | e
          )
          Unit
main = do
    playsOgg <- canPlayOgg
    log ("can I play OGG: " <> show playsOgg)
    audioEnabled <- isWebAudioEnabled
    log ("can I play web-audio: " <> show audioEnabled)
    time <- getCurrentTime
    log ("current time in audio context: " <> show time)
    _ <- runAff throwException playSequence (loadPianoSoundFont "soundfonts")
    -- delay loading the marimba until we think the first sequence has just about finished playing
    -- note this is wrrong - delay only works within Aff
    _ <- launchAff $ delay (Milliseconds 3000.0)
    _ <- runAff throwException playSequence (loadRemoteSoundFont "marimba")
    log "finished"

-- | play a sequence of notes on whatever instrument
playSequence :: forall e. Boolean ->
        Eff
          ( au :: AUDIO
          , console :: CONSOLE
          | e
          )
          Unit
playSequence loaded = do
  log $ "fonts loaded: " <> show loaded
  played1 <- playNote noteSample1
  log ("note duration: " <> show played1)
  played2 <- playNote noteSample2
  log ("note duration: " <> show played2)
  played3 <- playNote noteSample3
  log ("notes duration: " <> show played3)
  played4 <- playNotes notesSample
  log ("notes duration: " <> show played4)
