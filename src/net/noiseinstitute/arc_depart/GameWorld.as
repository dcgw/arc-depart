package net.noiseinstitute.arc_depart {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;

    import net.flashpunk.FP;

    import net.flashpunk.World;
    import net.flashpunk.utils.Input;

    public class GameWorld extends World {
        private var music:GameMusic = new GameMusic;

        private var playing:Boolean;

        private var cameraMovement:CameraMovement;

        private var playerShip:PlayerShip = new PlayerShip;

        private var title:Title = new Title;

        private var blurBitmapData:BitmapData = new BitmapData(Main.WIDTH, Main.HEIGHT);
        private var blurBitmap:Bitmap = new Bitmap(blurBitmapData);

        private var bigBlurBitmapData:BitmapData = new BitmapData(Main.WIDTH, Main.HEIGHT);
        private var bigBlurBitmap:Bitmap = new Bitmap(bigBlurBitmapData);

        public function GameWorld() {
            blurBitmap.filters = [new BlurFilter(10, 10, BitmapFilterQuality.HIGH)];
            bigBlurBitmap.filters = [new BlurFilter(20, 20, BitmapFilterQuality.MEDIUM)];

            var arcSystem:ArcSystem = new ArcSystem(playerShip, blurBitmapData, bigBlurBitmapData);

            for each (var arc:Arc in arcSystem.arcs) {
                add(arc);
            }

            playerShip.active = false;
            add(playerShip);

            addGraphic(title);

            cameraMovement = new CameraMovement(camera, playerShip, arcSystem);
            cameraMovement.update();

//            camera.x = -Main.WIDTH * 0.5;
//            camera.y = -Main.HEIGHT * 0.5 - 16;

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

            cameraMovement.update();
        }

        override public function render():void {
            blurBitmapData.fillRect(blurBitmapData.rect, 0);
            bigBlurBitmapData.fillRect(bigBlurBitmapData.rect, 0);

            super.render();

            FP.buffer.draw(blurBitmap, null, null, BlendMode.ADD);
            FP.buffer.draw(bigBlurBitmap, null, null, BlendMode.ADD);
        }

        override public function end():void {
            music.stop();
        }

        private function onBeat(beatCount:int):void {
            playerShip.beat(beatCount);
        }
    }
}
