package net.noiseinstitute.arc_depart {
    import flash.display.BlendMode;
    import flash.geom.Point;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.utils.Input;
    import net.noiseinstitute.basecode.Range;
    import net.noiseinstitute.basecode.Static;
    import net.noiseinstitute.basecode.VectorMath;

    public final class Ship extends Entity {
        [Embed(source="/ship-mask.png")]
        private static const MASK_IMAGE:Class;

        [Embed(source="/ship-additive.png")]
        private static const ADDITIVE_IMAGE:Class;

        [Embed(source="/thrust.mp3")]
        private static const THRUST_SOUND:Class;

        private static const TURN_RATE:Number = 180 / Main.LOGIC_FPS; // degrees per frame
        private static const THRUST:Number = 4 / Main.LOGIC_FPS; // pixels per frame per frame
        private static const GRAVITY:Number = 40 / Main.LOGIC_FPS / Main.LOGIC_FPS; // pixels per frame per frame

        private static const THRUST_VOLUME:Number = 0.6;
        private static const THRUST_FADE_IN_TIME:Number = 2 / 60 * Main.LOGIC_FPS;
        private static const THRUST_FADE_OUT_TIME:Number = 12 / 60 * Main.LOGIC_FPS;
        private static const THRUST_FADE_IN_RATE:Number = THRUST_VOLUME / THRUST_FADE_IN_TIME; // volume per frame
        private static const THRUST_FADE_OUT_RATE:Number = THRUST_VOLUME / THRUST_FADE_OUT_TIME; // volume per frame

        private var maskImage:Image;
        private var additiveImage:Image;

        private var thrustSound:Sound = new THRUST_SOUND;
        private var thrustSoundTransform:SoundTransform = new SoundTransform;
        private var thrustSoundChannel:SoundChannel;

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

        override public function added():void {
            thrustSoundTransform.volume = 0;
            thrustSoundChannel = thrustSound.play(0, int.MAX_VALUE, thrustSoundTransform);
        }

        override public function update():void {
            var thrusting:Boolean = false;

            if (Input.check(Main.INPUT_LEFT)) {
                angle += TURN_RATE;
                thrusting = true;
            }

            if (Input.check(Main.INPUT_RIGHT)) {
                angle -= TURN_RATE;
                thrusting = true;
            }

            if (Input.check(Main.INPUT_THRUST)) {
                VectorMath.becomePolar(Static.point, angle, THRUST);
                VectorMath.addTo(velocity, Static.point);
                thrusting = true;
            }

            if (thrusting) {
                thrustSoundTransform.volume = Range.clip(thrustSoundTransform.volume + THRUST_FADE_IN_RATE, 0, THRUST_VOLUME);
            } else {
                thrustSoundTransform.volume = Range.clip(thrustSoundTransform.volume - THRUST_FADE_OUT_RATE, 0, THRUST_VOLUME);
            }
            thrustSoundChannel.soundTransform = thrustSoundTransform;

            velocity.y += GRAVITY;

            maskImage.angle = angle;
            additiveImage.angle = angle;

            x += velocity.x;
            y += velocity.y;
        }

        override public function removed():void {
            thrustSoundChannel.stop();
        }
    }
}
