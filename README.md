purescript-soundfont
====================

This is a PureScript wrapper for danigb's soundfont project: [soundfont-player](https://github.com/danigb/soundfont-player). It is, to a large extent ported from the two previous Elm wrappers of the same library.  It loads soundfonts taken from Benjamin Gleitzman's package of [pre-rendered sound fonts](https://github.com/gleitz/midi-js-soundfonts). It then provides functions which allow you to play either an individual note or a sequence of notes. It is entirely monophonic - only one instrument soundfont may reside in memory at any time.

Soundfonts can either be loaded from a local server or from Benjamin Gleitzman's github server.

The description of a MIDI note is slightly different from the Elm version:
     
     type MidiNote =
       { channel :: Int           -- the MIDI channel (ignored)
       , id  :: Int               -- the MIDI pitch number
       , timeOffset :: Number     -- the time delay in seconds before the note is played
       , duration :: Number       -- the duration of the note
       , gain :: Number           -- the volume (between 0 and 1)
       }
       
We now specify a duration for the note which will allow you to play staccato sequences (the Elm version, lacking this attribute, allowed each note to ring for a pre-alloted time and then to fade naturally, enforcing a sustained legato style which was awkward with a succession of short notes).  This version allows each note to 'ring' for 10% more than its alloted time.  This gives a legato feel, but still allows each note to be started accurately at tempo.  Purescript-aff now incorporates a [delay](https://github.com/slamdata/purescript-aff/blob/master/src/Control/Monad/Aff.purs) function and this can be used to pace the notes correctly.

## Build

     npm install -g pulp purescript
     bower install
     pulp build
     
## Example

To build an example that runs in the browser:

     ./buildExample.sh

and then navigate to /examples/basic/dist/index.html
     
     