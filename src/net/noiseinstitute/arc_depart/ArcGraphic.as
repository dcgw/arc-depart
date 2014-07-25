package net.noiseinstitute.arc_depart {
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;

    import net.flashpunk.FP;

    import net.flashpunk.Graphic;
    import net.flashpunk.Tweener;
    import net.flashpunk.tweens.misc.MultiVarTween;
    import net.flashpunk.tweens.misc.NumTween;
    import net.flashpunk.tweens.misc.VarTween;
    import net.flashpunk.utils.Ease;
    import net.noiseinstitute.basecode.Range;

    public final class ArcGraphic extends Graphic {
        [Embed("/arc.swf")]
        private static const ARC_SPRITE:Class;

        private static const SPRITE_RADIUS:Number = 192;
        private static const SPRITE_CENTER_X:Number = 208;
        private static const SPRITE_CENTER_Y:Number = 208;

        private static const FADE_START_RADIUS:Number = 32;

        private static const ANIMATED_GLOW_DURATION:Number = 4 * 60 / 140 * Main.LOGIC_FPS; // Time in frames.

        private var compositeSprite:Sprite = new Sprite;
        private var animatedGlowSprite:Sprite = new ARC_SPRITE;
        private var glowSprite:Sprite = new ARC_SPRITE;
        private var colorSprite:Sprite = new ARC_SPRITE;

        private var matrix:Matrix = new Matrix;
        private var animatedGlowMatrix:Matrix = new Matrix;

        private var colorTransform:ColorTransform = new ColorTransform;
        private var animatedGlowColorTransform:ColorTransform = new ColorTransform;
        private var compositeColorTransform:ColorTransform = new ColorTransform;

        private var tweener:Tweener = new Tweener;
        private var animatedGlowAlphaTween:NumTween = new NumTween;
        private var animatedGlowScaleTween:NumTween = new NumTween;

        public var angle:Number = 0;
        public var radius:Number = SPRITE_RADIUS;
        public var color:uint = 0x3a94e1;

        public function ArcGraphic() {
            var whiteSprite:Sprite = new ARC_SPRITE;

            glowSprite.filters = [new BlurFilter(10, 10, BitmapFilterQuality.HIGH)];
            animatedGlowSprite.filters = [new BlurFilter(20, 20)];
            whiteSprite.transform.colorTransform = new ColorTransform(1, 1, 1, 0.5);

            compositeSprite.addChild(glowSprite);
            compositeSprite.addChild(animatedGlowSprite);
            compositeSprite.addChild(colorSprite);
            compositeSprite.addChild(whiteSprite);

            animatedGlowAlphaTween.value = 1;
            animatedGlowScaleTween.value = 0;
        }

        override public function render(target:BitmapData, point:Point, camera:Point):void {
            var scale:Number = radius / SPRITE_RADIUS;

            matrix.identity();
            matrix.translate(-SPRITE_CENTER_X, -SPRITE_CENTER_Y);
            matrix.rotate(angle * FP.RAD);
            matrix.scale(scale, scale);
            matrix.translate(x, y);
            matrix.translate(point.x, point.y);
            matrix.translate(-camera.x, -camera.y);

            colorTransform.redMultiplier = animatedGlowColorTransform.redMultiplier = FP.getRed(color) / 256;
            colorTransform.greenMultiplier = animatedGlowColorTransform.greenMultiplier = FP.getGreen(color) / 256;
            colorTransform.blueMultiplier = animatedGlowColorTransform.blueMultiplier = FP.getBlue(color) / 256;

            tweener.updateTweens();

            animatedGlowColorTransform.alphaMultiplier = animatedGlowAlphaTween.value;

            glowSprite.transform.colorTransform = colorTransform;
            animatedGlowSprite.transform.colorTransform = animatedGlowColorTransform;
            colorSprite.transform.colorTransform = colorTransform;

            animatedGlowMatrix.identity();
            animatedGlowMatrix.translate(-SPRITE_CENTER_X, -SPRITE_CENTER_Y);
            animatedGlowMatrix.scale(animatedGlowScaleTween.value, animatedGlowScaleTween.value);
            animatedGlowMatrix.translate(SPRITE_CENTER_X, SPRITE_CENTER_Y);

            animatedGlowSprite.transform.matrix = animatedGlowMatrix;

            compositeColorTransform.alphaMultiplier = Range.clip(radius / FADE_START_RADIUS, 0, 1);

            target.draw(compositeSprite, matrix, compositeColorTransform, BlendMode.ADD, null, true);
        }

        public function glow():void {
            animatedGlowAlphaTween.cancel();
            animatedGlowScaleTween.cancel();

            tweener.addTween(animatedGlowAlphaTween);
            tweener.addTween(animatedGlowScaleTween);

            animatedGlowAlphaTween.tween(1, 0, ANIMATED_GLOW_DURATION, Ease.cubeOut);
            animatedGlowScaleTween.tween(1, 1.2, ANIMATED_GLOW_DURATION, Ease.cubeOut);
        }
    }
}
