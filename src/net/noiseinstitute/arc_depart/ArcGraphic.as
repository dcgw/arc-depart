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

    public final class ArcGraphic extends Graphic {
        [Embed("/arc.swf")]
        private static const SPRITE:Class;

        private static const SPRITE_RADIUS:Number = 192;
        private static const SPRITE_CENTER_X:Number = 208;
        private static const SPRITE_CENTER_Y:Number = 208;

        private var sprite:Sprite = new SPRITE;
        private var matrix:Matrix = new Matrix;

        private var colorTransform:ColorTransform = new ColorTransform;
        private var whiteColorTransform:ColorTransform = new ColorTransform;

        private var noFilters:Array = [];
        private var blurFilters:Array = [new BlurFilter(8, 8, BitmapFilterQuality.HIGH)];

        public var angle:Number = 0;
        public var radius:Number = SPRITE_RADIUS;
        public var color:uint = 0xfb4426;

        public function ArcGraphic() {
            whiteColorTransform.alphaMultiplier = 0.5;
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

            colorTransform.redMultiplier = FP.getRed(color);
            colorTransform.greenMultiplier = FP.getGreen(color);
            colorTransform.blueMultiplier = FP.getBlue(color);

            sprite.filters = blurFilters;

            target.draw(sprite, matrix, colorTransform, BlendMode.ADD, null, true);

            sprite.filters = noFilters;

            target.draw(sprite, matrix, colorTransform, BlendMode.ADD, null, true);
            target.draw(sprite, matrix, whiteColorTransform, BlendMode.ADD, null, true);
        }
    }
}
