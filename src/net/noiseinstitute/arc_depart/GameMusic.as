package net.noiseinstitute.arc_depart {
    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;

    public final class GameMusic {
        [Embed(source="/ingame-music.mp3")]
        private static const MUSIC:Class;

        private static const BEAT_INTERVAL:int = 60 * 1000 / 140; // Time in ms.

        private var music:Sound = new MUSIC;

        private var soundChannel:SoundChannel;

        private var soundTransform:SoundTransform = new SoundTransform(0.5);

        private var nextBeatCount:int = 0;

        private var nextBeatPosition:int = 0;

        public var onBeat:Function;

        public function play():void {
            if (soundChannel == null) {
                soundChannel = music.play(0, int.MAX_VALUE, soundTransform);

                soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
            }
        }

        private function onSoundComplete(event:Event):void {
            nextBeatPosition = 0;
        }

        public function update():void {
            if (soundChannel != null) {
                var beat:Boolean = false;

                if (soundChannel.position >= nextBeatPosition) {
                    nextBeatPosition += BEAT_INTERVAL;
                    beat = true;
                } else if (soundChannel.position < nextBeatPosition - BEAT_INTERVAL) {
                    nextBeatPosition = BEAT_INTERVAL;
                    beat = true;
                }

                if (beat) {
                    if (onBeat != null) {
                        onBeat(nextBeatCount);
                    }

                    ++nextBeatCount;
                }
            }
        }

        public function stop():void {
            if (soundChannel != null) {
                soundChannel.stop();
                soundChannel = null;
            }
        }
    }
}
