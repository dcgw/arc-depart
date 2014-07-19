package net.noiseinstitute.arc_depart {
    import flash.display.BlendMode;
    import flash.geom.Point;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.utils.Input;
    import net.noiseinstitute.basecode.Static;
    import net.noiseinstitute.basecode.VectorMath;

    public final class Ship extends Entity {
        [Embed(source="/ship-mask.png")]
        private static const MASK_IMAGE:Class;

        [Embed(source="/ship-additive.png")]
        private static const ADDITIVE_IMAGE:Class;

        private static const TURN_RATE:Number = 180 / Main.LOGIC_FPS; // degrees per frame
        private static const THRUST:Number = 4 / Main.LOGIC_FPS; // pixels per frame per frame
        private static const GRAVITY:Number = 40 / Main.LOGIC_FPS / Main.LOGIC_FPS; // pixels per frame per frame

        private var maskImage:Image;
        private var additiveImage:Image;

        private var angle:Number = 0;
        private var velocity:Point = new Point;

        public function Ship() {
            maskImage = new Image(MASK_IMAGE);
            maskImage.centerOrigin();
            maskImage.smooth = true;

            additiveImage = new Image(ADDITIVE_IMAGE);
            additiveImage.centerOrigin();
            additiveImage.blend = BlendMode.ADD;
            additiveImage.smooth = true;

            graphic = new Graphiclist(maskImage, additiveImage);
        }

        override public function update():void {
            if (Input.check(Main.INPUT_LEFT)) {
                angle += TURN_RATE;
            }

            if (Input.check(Main.INPUT_RIGHT)) {
                angle -= TURN_RATE;
            }

            if (Input.check(Main.INPUT_THRUST)) {
                VectorMath.becomePolar(Static.point, angle, THRUST);
                VectorMath.addTo(velocity, Static.point);
            }

            velocity.y += GRAVITY;

            maskImage.angle = angle;
            additiveImage.angle = angle;

            x += velocity.x;
            y += velocity.y;
        }
    }
}
