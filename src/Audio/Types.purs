module Audio.Types where

-- | A Midi Note 
type MidiNote =
  { id  :: Int               -- the MIDI pitch number
  , timeOffset :: Number     -- the time delay in seconds before the note is played
  , duration :: Number       -- the duration of the note
  , gain :: Number           -- the volume (between 0 and 1)
  }
