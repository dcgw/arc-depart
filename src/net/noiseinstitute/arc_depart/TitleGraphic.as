package net.noiseinstitute.arc_depart {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Point;

    import net.flashpunk.Graphic;

    public final class TitleGraphic extends Graphic {
        [Embed(source="/a.png")]
        private static const A_BITMAP:Class;

        [Embed(source="/r.png")]
        private static const R_BITMAP:Class;

        [Embed(source="/c.png")]
        private static const C_BITMAP:Class;

        [Embed(source="/d.png")]
        private static const D_BITMAP:Class;

        [Embed(source="/e.png")]
        private static const E_BITMAP:Class;

        [Embed(source="/p.png")]
        private static const P_BITMAP:Class;

        [Embed(source="/t.png")]
        private static const T_BITMAP:Class;

        private static const LETTER_COUNT:int = 10;
        private static const LETTER_WIDTH:Number = 40;
        private static const LETTER_HEIGHT:Number = 40;
        private static const LETTER_SPACING:Number = 16;
        private static const LETTER_MARGIN:Number = 16;

        private static const TITLE_WIDTH:Number = LETTER_COUNT * (LETTER_WIDTH + LETTER_SPACING) - LETTER_SPACING;
        private static const TITLE_LEFT:Number = -TITLE_WIDTH * 0.5;

        private var compositeSprite:Sprite = new Sprite;

        private var letterBitmaps:Vector.<Bitmap> = new <Bitmap>[new A_BITMAP, new R_BITMAP, new C_BITMAP, null,
            new D_BITMAP, new E_BITMAP, new P_BITMAP, new A_BITMAP, new R_BITMAP, new T_BITMAP];

        private var matrix:Matrix = new Matrix;

        public function TitleGraphic() {
            for (var i:int = 0; i < LETTER_COUNT; ++i) {
                var letterBitmap:Bitmap = letterBitmaps[i];

                if (letterBitmap != null) {
                    letterBitmap.x = TITLE_LEFT + i * (LETTER_WIDTH + LETTER_SPACING) - LETTER_MARGIN;
                    letterBitmap.y = -LETTER_HEIGHT * 0.5 - LETTER_MARGIN;
                    letterBitmap.blendMode = BlendMode.ADD;

                    compositeSprite.addChild(letterBitmap);
                }
            }
        }

        override public function render(target:BitmapData, point:Point, camera:Point):void {
            matrix.identity();
            matrix.translate(point.x, point.y);
            matrix.translate(-camera.x, -camera.y);

            target.draw(compositeSprite, matrix, null, null, null, true);
        }
    }
}
