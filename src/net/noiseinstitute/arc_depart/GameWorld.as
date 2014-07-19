package net.noiseinstitute.arc_depart {
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;

    import net.flashpunk.World;

    public class GameWorld extends World {
        [Embed("/ingame-music.mp3")]
        private static const MUSIC:Class;

        private var music:Sound = new MUSIC;
        private var musicSoundTransform:SoundTransform = new SoundTransform(0.5);
        private var musicSoundChannel:SoundChannel;

        public function GameWorld() {
            var arc:Arc = new Arc;
            add(arc);

            var ship:Ship = new Ship;
            add(ship);

            var title:Title = new Title;
            title.y = -212;
            add(title);

            camera.x = -Main.WIDTH * 0.5;
            camera.y = -Main.HEIGHT * 0.5 - 16;
        }

        override public function begin():void {
            musicSoundChannel = music.play(0, int.MAX_VALUE, musicSoundTransform);
        }

        override public function end():void {
            if (musicSoundChannel != null) {
                musicSoundChannel.stop();
            }
        }
    }
}
