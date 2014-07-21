package net.noiseinstitute.arc_depart {
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;

    import net.flashpunk.World;
    import net.flashpunk.utils.Input;

    public class GameWorld extends World {
        [Embed("/ingame-music.mp3")]
        private static const MUSIC:Class;

        private var music:Sound = new MUSIC;
        private var musicSoundTransform:SoundTransform = new SoundTransform(0.5);
        private var musicSoundChannel:SoundChannel;

        private var playing:Boolean;

        private var ship:Ship = new Ship;

        private var title:Title = new Title;

        public function GameWorld() {
            var arc:Arc = new Arc(ship);
            add(arc);

            ship.active = false;
            add(ship);

            addGraphic(title);

            camera.x = -Main.WIDTH * 0.5;
            camera.y = -Main.HEIGHT * 0.5 - 16;
        }

        override public function begin():void {
            title.show();
        }

        override public function update():void {
            if (!playing && Input.pressed(Main.INPUT_THRUST)) {
                playing = true;

                musicSoundChannel = music.play(0, int.MAX_VALUE, musicSoundTransform);
                ship.active = true;
                title.hide();
            }

            super.update();
        }

        override public function end():void {
            if (musicSoundChannel != null) {
                musicSoundChannel.stop();
            }
        }
    }
}
