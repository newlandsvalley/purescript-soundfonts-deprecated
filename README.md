purescript-soundfont
====================

This is a PureScript wrapper for danigb's soundfont project: [soundfont-player](https://github.com/danigb/soundfont-player). It is, to a large extent ported from the two previous Elm wrappers of the same library.  It loads soundfonts taken from Benjamin Gleitzman's package of [pre-rendered sound fonts](https://github.com/gleitz/midi-js-soundfonts). It then provides functions which allow you to play either an individual note or a sequence of notes.

Soundfonts can either be loaded from a local server or from Benjamin Gleitzman's github server.

The description of a MIDI note is slightly different from the Elm version:
     
     type MidiNote =
       { id  :: Int               -- the MIDI pitch number
       , timeOffset :: Number     -- the time delay in seconds before the note is played
       , duration :: Number       -- the duration of the note
       , gain :: Number           -- the volume (between 0 and 1)
       }
       
We now specify a duration for the note which will allow you to play staccato sequences (the Elm version, lacking this attribute, allowed each note to fade naturally, enforcing a sustained legato style).

Furthermore, the Elm version allowed a tune to be paced properly in effect by making the note-playing functions synchronous.  Although web-audio produces its effects asynchronously, it was possible to do this by sleeping for the exact duration of the sequence. For the life of me, I've not managed to produce an effective non-blocking sleep function in PureScript.  However, the same result can be obtained with judicious use of the *timeOffset* and *duration* attributes.

## Build

     npm install -g pulp purescript
     pulp install
     pulp build
     
## Examples

The examples directory contains a browser example of how the library might be used.
     
     