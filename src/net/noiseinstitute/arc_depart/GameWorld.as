package net.noiseinstitute.arc_depart {
    import net.flashpunk.World;
    import net.flashpunk.utils.Input;

    public class GameWorld extends World {
        private var music:GameMusic = new GameMusic;

        private var playing:Boolean;

        private var playerShip:PlayerShip = new PlayerShip;

        private var title:Title = new Title;

        public function GameWorld() {
            var arc:Arc = new Arc(playerShip);
            add(arc);

            playerShip.active = false;
            add(playerShip);

            addGraphic(title);

            camera.x = -Main.WIDTH * 0.5;
            camera.y = -Main.HEIGHT * 0.5 - 16;

            music.onBeat = onBeat;
        }

        override public function begin():void {
            title.show();
        }

        override public function update():void {
            if (!playing && Input.pressed(Main.INPUT_THRUST)) {
                playing = true;

                music.play();
                playerShip.active = true;
                title.hide();
            }

            music.update();

            super.update();
        }

        override public function end():void {
            music.stop();
        }

        private function onBeat(beatCount:int):void {
            playerShip.beat(beatCount);
        }
    }
}
