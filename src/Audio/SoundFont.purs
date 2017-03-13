module Audio.SoundFont
  ( AudioContext
  , AUDIO
  , LOADFONT
  , MidiNote
  , canPlayOgg
  , isWebAudioEnabled
  , getAudioContext
  , getCurrentTime
  , loadPianoSoundFont
  , loadRemoteSoundFont
  , playNote
  , playNotes
  ) where

import Prelude (map, ($))
import Data.Traversable (sequenceDefault)
import Data.Maybe (fromMaybe)
import Data.Array (head, reverse)
import Control.Monad.Eff (Eff)

-- |  Audio Context
foreign import data AudioContext :: *

-- | Audio Effect
foreign import data AUDIO :: !

-- |  Load Font Effect
foreign import data LOADFONT :: !

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

foreign import getAudioContext
  :: forall eff. (Eff (au :: AUDIO | eff) AudioContext)

-- |  Get the audio context's current time
foreign import getCurrentTime :: AudioContext -> Number

-- | load a piano soundfont from the local server
foreign import loadPianoSoundFont :: forall eff. AudioContext -> String -> Eff (loadSoundFont :: LOADFONT | eff) Boolean

-- | load a soundfont for a particular instrument from the remote Gleitz Github server
foreign import loadRemoteSoundFont :: forall eff. AudioContext -> String -> Eff (loadSoundFont :: LOADFONT | eff) Boolean

-- | play a note asynchronously
-- | return the duration of the note
foreign import playNote :: forall eff. MidiNote -> Eff (playNote :: AUDIO | eff) Number

-- | play a bunch of notes asynchronously
-- | return the duration of the phrase (i.e. that of the last note in the phrase)
playNotes :: forall eff. Array MidiNote -> Eff (playNote :: AUDIO | eff) Number
playNotes ns =
  let
    pns = map playNote ns
  in
    map lastDuration (sequenceDefault pns)

-- | return the duration of the last note played from a sequence of notes
lastDuration :: Array Number -> Number
lastDuration fs =
  let
    last = head $ reverse fs
  in
    fromMaybe 0.0 last
