package net.noiseinstitute.arc_depart {
    import flash.display.BlendMode;
    import flash.geom.Point;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;

    import net.flashpunk.Entity;
    import net.flashpunk.Tweener;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.tweens.misc.MultiVarTween;
    import net.flashpunk.utils.Ease;
    import net.flashpunk.utils.Input;
    import net.noiseinstitute.basecode.Range;
    import net.noiseinstitute.basecode.Static;
    import net.noiseinstitute.basecode.VectorMath;

    public final class PlayerShip extends Entity {
        [Embed(source="/ship-mask.png")]
        private static const MASK_IMAGE:Class;

        [Embed(source="/ship-additive.png")]
        private static const ADDITIVE_IMAGE:Class;

        [Embed(source="/ship-beat-glow.png")]
        private static const BEAT_GLOW_IMAGE:Class;

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

        private static const BEAT_GLOW_TIME:Number = 2 * 60 / 140 * Main.LOGIC_FPS; // Time in frames.

        private var maskImage:Image = new Image(MASK_IMAGE);
        private var beatGlowImage:Image = new Image(BEAT_GLOW_IMAGE);
        private var additiveImage:Image = new Image(ADDITIVE_IMAGE);

        private var thrustSound:Sound = new THRUST_SOUND;
        private var thrustSoundTransform:SoundTransform = new SoundTransform;
        private var thrustSoundChannel:SoundChannel;

        public var angle:Number = 0;
        public var velocity:Point = new Point;

        private var tweener:Tweener = new Tweener;
        private var beatGlowTween:MultiVarTween = new MultiVarTween;

        public function PlayerShip() {
            maskImage.centerOrigin();
            maskImage.smooth = true;

            beatGlowImage.centerOrigin();
            beatGlowImage.blend = BlendMode.ADD;
            beatGlowImage.alpha = 0;
            beatGlowImage.smooth = true;

            additiveImage.centerOrigin();
            additiveImage.blend = BlendMode.ADD;
            additiveImage.smooth = true;

            graphic = new Graphiclist(maskImage, beatGlowImage, additiveImage);

            tweener.addTween(beatGlowTween);
        }

        override public function added():void {
            thrustSoundTransform.volume = 0;
            thrustSoundChannel = thrustSound.play(0, int.MAX_VALUE, thrustSoundTransform);
        }

        public function beat(beatCount:int):void {
            if (beatCount % 2 == 1) {
                beatGlowImage.alpha = 1;
                beatGlowImage.scale = 0.5;

                beatGlowTween.tween(beatGlowImage, {
                    alpha: 0,
                    scale: 1
                }, BEAT_GLOW_TIME, Ease.cubeOut);
            }
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
            beatGlowImage.angle = angle;
            additiveImage.angle = angle;

            x += velocity.x;
            y += velocity.y;

            tweener.updateTweens();
        }

        override public function removed():void {
            thrustSoundChannel.stop();
        }
    }
}
