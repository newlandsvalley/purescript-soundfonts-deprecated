module Audio.SoundFont
  ( AUDIO
  , MidiNote
  , canPlayOgg
  , isWebAudioEnabled
  , getCurrentTime
  , loadPianoSoundFont
  , loadRemoteSoundFont
  , playNote
  , playNotes
  ) where

import Prelude (Unit, map, ($))
import Data.Traversable (sequenceDefault)
import Data.Maybe (fromMaybe)
import Data.Array (head, reverse)
import Control.Monad.Eff (kind Effect, Eff)
import Control.Monad.Aff (Aff, makeAff)

-- | Audio Effect
foreign import data AUDIO :: Effect

-- | A Midi Note
type MidiNote =
  { id  :: Int               -- the MIDI pitch number
  , timeOffset :: Number     -- the time delay in seconds before the note is played
  , duration :: Number       -- the duration of the note
  , gain :: Number           -- the volume (between 0 and 1)
  }

-- | can the browser play ogg format ?
foreign import canPlayOgg
  :: forall eff. (Eff (au :: AUDIO | eff) Boolean)

-- |  is the browser web-audio enabled ?
foreign import isWebAudioEnabled
  :: forall eff. (Eff (au :: AUDIO | eff) Boolean)

-- |  Get the audio context's current time
foreign import getCurrentTime
  :: forall eff. (Eff (au :: AUDIO | eff) Number)

foreign import loadPianoSoundFontImpl :: forall e. String -> (Boolean -> Eff e Unit) -> Eff e Unit

foreign import loadRemoteSoundFontImpl :: forall e. String -> (Boolean -> Eff e Unit) -> Eff e Unit

-- | play a note asynchronously
-- | return the (time offset + duration) of the note
foreign import playNote :: forall eff. MidiNote -> Eff (au :: AUDIO | eff) Number

-- | load the piano soundfont from the local server
loadPianoSoundFont :: forall e. String -> Aff e Boolean
loadPianoSoundFont dir =
  makeAff (\error success -> (loadPianoSoundFontImpl dir) success)

-- | load a soundfont for a particular instrument from the remote Gleitz Github server
loadRemoteSoundFont :: forall e. String -> Aff e Boolean
loadRemoteSoundFont instrument =
  makeAff (\error success -> (loadRemoteSoundFontImpl instrument) success)

-- | play a bunch of notes asynchronously
-- | return the duration of the phrase
-- | (i.e. the time offset plus duration of the last note in the phrase)
playNotes :: forall eff. Array MidiNote -> Eff (au :: AUDIO | eff) Number
playNotes ns =
  let
    pns = map playNote ns
  in
    map lastDuration (sequenceDefault pns)

-- | return the overall duration of the last note played from a sequence of notes
lastDuration :: Array Number -> Number
lastDuration fs =
  let
    last = head $ reverse fs
  in
    fromMaybe 0.0 last
