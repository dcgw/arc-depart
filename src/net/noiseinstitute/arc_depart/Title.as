package net.noiseinstitute.arc_depart {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.filters.BlurFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;

    import net.flashpunk.Graphic;
    import net.flashpunk.Tween;
    import net.flashpunk.Tweener;
    import net.flashpunk.tweens.misc.MultiVarTween;
    import net.flashpunk.tweens.misc.NumTween;
    import net.flashpunk.tweens.misc.VarTween;
    import net.flashpunk.utils.Ease;
    import net.noiseinstitute.basecode.Range;
    import net.noiseinstitute.basecode.Static;
    import net.noiseinstitute.basecode.VectorMath;

    public final class Title extends Graphic {
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
        private static const TITLE_Y:Number = -212;

        private var compositeSprite:Sprite = new Sprite;

        private var letterBitmaps:Vector.<Bitmap> = new <Bitmap>[new A_BITMAP, new R_BITMAP, new C_BITMAP, null,
            new D_BITMAP, new E_BITMAP, new P_BITMAP, new A_BITMAP, new R_BITMAP, new T_BITMAP];

        private var filters:Vector.<Array> = new <Array>[];
        private var blurFilters:Vector.<BlurFilter> = new <BlurFilter>[];
        private var matrices:Vector.<Matrix> = new <Matrix>[];

        private var tweener:Tweener = new Tweener;
        private var fadeInTweens:Vector.<NumTween> = new <NumTween>[];

        private var matrix:Matrix = new Matrix;

        public function Title() {
            for (var i:int = 0; i < LETTER_COUNT; ++i) {
                var letterBitmap:Bitmap = letterBitmaps[i];

                if (letterBitmap != null) {
                    letterBitmap.blendMode = BlendMode.ADD;
                    letterBitmap.smoothing = true;

                    var blurFilter:BlurFilter = new BlurFilter(0, 0);
                    blurFilters[i] = blurFilter;

                    letterBitmap.filters = filters[i] = [blurFilter];

                    matrices[i] = new Matrix;

                    compositeSprite.addChild(letterBitmap);

                    var fadeInTween:NumTween = new NumTween;
                    tweener.addTween(fadeInTween);
                    fadeInTweens[i] = fadeInTween;
                } else {
                    blurFilters[i] = null;
                    filters[i] = null;
                    matrices[i] = null;
                    fadeInTweens[i] = null;
                }
            }

            visible = false;
        }

        public function show():void {
            if (visible) {
                return;
            }

            for (var i:int = 0; i < LETTER_COUNT; ++i) {
                var fadeInTween:NumTween = fadeInTweens[i];

                if (fadeInTween != null) {
                    fadeInTween.tween(0, 1, 0.8 * Main.LOGIC_FPS);
                    fadeInTween.delay = 60 / 140 * 0.25 * i * Main.LOGIC_FPS;
                }
            }

            visible = true;
        }

        override public function render(target:BitmapData, point:Point, camera:Point):void {
            tweener.updateTweens();

            for (var i:int = 0; i < LETTER_COUNT; ++i) {
                var letterBitmap:Bitmap = letterBitmaps[i];
                var bitmapFilters:Array = filters[i];
                var blurFilter:BlurFilter = blurFilters[i];
                var matrix:Matrix = matrices[i];
                var fadeInTween:NumTween = fadeInTweens[i];

                if (letterBitmap != null && blurFilter != null && bitmapFilters != null && fadeInTween != null) {
                    blurFilter.blurX = (1 - Ease.cubeInOut(fadeInTween.value)) * 16;
                    blurFilter.blurY = (1 - Ease.cubeInOut(fadeInTween.value)) * 16;

                    letterBitmap.filters = bitmapFilters;
                }

                if (letterBitmap != null && matrix != null && fadeInTween != null) {
                    matrix.identity();
                    translateLetterPosition(matrix, i);

                    var scale:Number = 0.8 + (0.2 * Ease.cubeOut(fadeInTween.value));
                    matrix.scale(scale, scale);

                    letterBitmap.transform.matrix = matrix;
                }

                if (letterBitmap != null && fadeInTween != null) {
                    letterBitmap.alpha = Ease.cubeOut(fadeInTween.value);
                }
            }

            this.matrix.identity();
            this.matrix.translate(point.x, point.y);
            this.matrix.translate(x, y);
            this.matrix.translate(-camera.x, -camera.y);

            target.draw(compositeSprite, this.matrix, null, null, null, true);
        }

        private static function translateLetterPosition(matrix:Matrix, letterIndex:int):void {
            var x:Number = TITLE_LEFT + letterIndex * (LETTER_WIDTH + LETTER_SPACING) - LETTER_MARGIN;
            var y:Number = TITLE_Y - LETTER_HEIGHT * 0.5 - LETTER_MARGIN;

            matrix.translate(x, y);
        }
    }
}
