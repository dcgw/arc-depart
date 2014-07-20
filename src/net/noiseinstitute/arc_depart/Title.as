package net.noiseinstitute.arc_depart {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.filters.BlurFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;

    import net.flashpunk.Graphic;
    import net.flashpunk.Tweener;
    import net.flashpunk.tweens.misc.MultiVarTween;
    import net.flashpunk.utils.Ease;

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
        private var letterTweens:Vector.<MultiVarTween> = new <MultiVarTween>[];
        private var letterTweenStates:Vector.<Object> = new <Object>[];

        private var matrix:Matrix = new Matrix;

        private var colorTransform:ColorTransform = new ColorTransform;

        private var hideTween:MultiVarTween = new MultiVarTween(onHideComplete);

        private var hideTweenState:Object = {
            alpha: 1,
            yOffset: 0
        };

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

                    var letterTween:MultiVarTween = new MultiVarTween;
                    tweener.addTween(letterTween);
                    letterTweens[i] = letterTween;

                    letterTweenStates[i] = {
                        blur: 0,
                        scale: 0,
                        alpha: 0
                    };
                } else {
                    blurFilters[i] = null;
                    filters[i] = null;
                    matrices[i] = null;
                    letterTweens[i] = null;
                    letterTweenStates[i] = null;
                }
            }

            visible = false;
        }

        public function show():void {
            if (hideTween.active) {
                hideTween.cancel();

                tweener.addTween(hideTween);

                hideTween.tween(hideTweenState, {
                    alpha: 1,
                    yOffset: 0
                }, 0.3 * Main.LOGIC_FPS, Ease.cubeIn);
            } else {
                for (var i:int = 0; i < LETTER_COUNT; ++i) {
                    var tween:MultiVarTween = letterTweens[i];
                    var letterTweenState:Object = letterTweenStates[i];

                    if (tween != null && letterTweenState != null) {
                        letterTweenState.blur = 32;
                        letterTweenState.scale = 0.8;
                        letterTweenState.alpha = 0;

                        tween.tween(letterTweenState, {
                            blur: 0,
                            scale: 1,
                            alpha: 1
                        }, 0.8 * Main.LOGIC_FPS, Ease.cubeOut, 60 / 140 * 0.125 * i * Main.LOGIC_FPS);
                    }
                }
            }

            visible = true;
        }

        public function hide():void {
            if (!hideTween.active) {
                tweener.addTween(hideTween);

                hideTween.tween(hideTweenState, {
                    alpha: 0,
                    yOffset: 32
                }, 0.3 * Main.LOGIC_FPS, Ease.cubeOut);
            }
        }

        private function onHideComplete():void {
            visible = false;
        }

        override public function render(target:BitmapData, point:Point, camera:Point):void {
            tweener.updateTweens();

            for (var i:int = 0; i < LETTER_COUNT; ++i) {
                var letterBitmap:Bitmap = letterBitmaps[i];
                var bitmapFilters:Array = filters[i];
                var blurFilter:BlurFilter = blurFilters[i];
                var matrix:Matrix = matrices[i];
                var tweenState:Object = letterTweenStates[i];

                if (letterBitmap != null && bitmapFilters != null && blurFilter != null
                        && matrix != null && tweenState != null) {
                    blurFilter.blurX = tweenState.blur;
                    blurFilter.blurY = tweenState.blur;

                    letterBitmap.filters = bitmapFilters;

                    matrix.identity();
                    translateLetterPosition(matrix, i);
                    matrix.scale(tweenState.scale, tweenState.scale);

                    letterBitmap.transform.matrix = matrix;

                    letterBitmap.alpha = tweenState.alpha;
                }
            }

            this.matrix.identity();
            this.matrix.translate(point.x, point.y);
            this.matrix.translate(x, y);
            this.matrix.translate(0, hideTweenState.yOffset);
            this.matrix.translate(-camera.x, -camera.y);

            colorTransform.alphaMultiplier = hideTweenState.alpha;

            target.draw(compositeSprite, this.matrix, colorTransform, null, null, true);
        }

        private static function translateLetterPosition(matrix:Matrix, letterIndex:int):void {
            var x:Number = TITLE_LEFT + letterIndex * (LETTER_WIDTH + LETTER_SPACING) - LETTER_MARGIN;
            var y:Number = TITLE_Y - LETTER_HEIGHT * 0.5 - LETTER_MARGIN;

            matrix.translate(x, y);
        }
    }
}