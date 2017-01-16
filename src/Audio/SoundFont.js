"use strict";


var sf = function() {

  var buffers = [];

  var context = null;

  return {
      /* can the browser play ogg format? */
      canPlayOgg : function () {
         var audioTester = document.createElement("audio");
         if (audioTester.canPlayType('audio/ogg')) {
           return true;
         }
         else {
           return false;
         }
      },
      /* Get the audio context */
      getAudioContext : function() {
         sf.context = new (window.AudioContext || window.webkitAudioContext)();
         return sf.context;
      },
      /* is web audio enabled ? */
      isWebAudioEnabled : function() {
        if (sf.getAudioContext) {
          return true;
        }
        else {
          return false;
        }
      },
      /* Get the current time from the audio context */
      getCurrentTime : function(context) {
           return context.currentTime;
      },
      /* load and decode the soundfont */
      loadSoundFont : function (context) {
         return function(dirname) {
           return function() {
             return sf._loadSoundFont (context, dirname);
           }
         }
       },
       _loadSoundFont : function (context, dirname) {
           var name = 'acoustic_grand_piano';
           var dir = dirname + '/';
           var extension = null;
           if (sf.canPlayOgg()) {
             extension = '-ogg.js';
           }
           else {
             extension = '-mp3.js';
           }
           Soundfont.nameToUrl = function (name) { return dir + name + extension }
           Soundfont.loadBuffers(context, name)
               .then(function (buffers) {
                 // console.log("buffers:", buffers);
                 sf.buffers = buffers;
                 console.log("buffers:", sf.buffers);
                 return true;
               })
      },
      // play a midi note
      playNote :  function (midiNote) {
          return function() {
            return sf._playNote(midiNote);
          }
      },
      _playNote : function (midiNote) {
          if (sf.buffers) {
            // console.log("playing buffer at time: " + midiNote.timeOffset + " with gain: " + midiNote.gain + " for note: " + midiNote.id)
            var buffer = sf.buffers[midiNote.id]
            var source = sf.context.createBufferSource();
            var gainNode = sf.context.createGain();
            var timeOn = sf.context.currentTime + midiNote.timeOffset;
            var timeOff = sf.context.currentTime + midiNote.timeOffset + midiNote.duration;
            gainNode.gain.value = midiNote.gain;
            source.buffer = buffer;
            source.connect(gainNode);
            gainNode.connect(sf.context.destination)
            source.start(timeOn);
            source.stop(timeOff);
            return midiNote.timeOffset + midiNote.duration;
          }
          else {
            // console.log("buffers are empty");
            // console.log("buffers:", sf.buffers);
            return 0.0;
          }
      }
    };


}();

exports.isWebAudioEnabled = sf.isWebAudioEnabled;
exports.canPlayOgg = sf.canPlayOgg;
exports.getAudioContext = sf.getAudioContext;
exports.getCurrentTime = sf.getCurrentTime;
exports.loadSoundFont = sf.loadSoundFont;
exports.playNote = sf.playNote;
