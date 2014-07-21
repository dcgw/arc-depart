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
    import net.noiseinstitute.basecode.Range;

    public final class ArcGraphic extends Graphic {
        [Embed("/arc.swf")]
        private static const ARC_SPRITE:Class;

        private static const SPRITE_RADIUS:Number = 192;
        private static const SPRITE_CENTER_X:Number = 208;
        private static const SPRITE_CENTER_Y:Number = 208;

        private static const FADE_START_RADIUS:Number = 32;

        private var compositeSprite:Sprite = new Sprite;
        private var glowSprite:Sprite = new ARC_SPRITE;
        private var colorSprite:Sprite = new ARC_SPRITE;

        private var matrix:Matrix = new Matrix;

        private var colorTransform:ColorTransform = new ColorTransform;
        private var compositeColorTransform:ColorTransform = new ColorTransform;

        public var angle:Number = 0;
        public var radius:Number = SPRITE_RADIUS;
        public var color:uint = 0x3a94e1;

        public function ArcGraphic() {
            var whiteSprite:Sprite = new ARC_SPRITE;

            glowSprite.filters = [new BlurFilter(8, 8, BitmapFilterQuality.HIGH)];
            whiteSprite.transform.colorTransform = new ColorTransform(1, 1, 1, 0.5);

            compositeSprite.addChild(glowSprite);
            compositeSprite.addChild(colorSprite);
            compositeSprite.addChild(whiteSprite);
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

            colorTransform.redMultiplier = FP.getRed(color) / 256;
            colorTransform.greenMultiplier = FP.getGreen(color) / 256;
            colorTransform.blueMultiplier = FP.getBlue(color) / 256;

            glowSprite.transform.colorTransform = colorTransform;
            colorSprite.transform.colorTransform = colorTransform;

            compositeColorTransform.alphaMultiplier = Range.clip(radius / FADE_START_RADIUS, 0, 1);

            target.draw(compositeSprite, matrix, compositeColorTransform, BlendMode.ADD, null, true);
        }
    }
}
