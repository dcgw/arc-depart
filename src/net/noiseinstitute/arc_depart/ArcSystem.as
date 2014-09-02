package net.noiseinstitute.arc_depart {
    import flash.display.BitmapData;

    public class ArcSystem {
        private static const BASE_SHRINK_RATE:Number = 20 / Main.LOGIC_FPS; // Pixels per frame.
        private static const SHRINK_RATE_INCREMENT:Number = 0.1 / Main.LOGIC_FPS; // Pixels per frame per arc cleared.

        private var _arcs:Vector.<Arc> = new <Arc>[];

        public function ArcSystem(playerShip:PlayerShip, blurTarget:BitmapData, bigBlurTarget:BitmapData) {
            for (var i:int = 0; i < 4; ++i) {
                addArc(playerShip, blurTarget, bigBlurTarget);
            }
        }

        public function get arcs():Vector.<Arc> {
            return _arcs;
        }

        private function addArc(playerShip:PlayerShip, blurTarget:BitmapData, bigBlurTarget:BitmapData):void {
            var arc:Arc = new Arc(playerShip, blurTarget, bigBlurTarget);
            var arcIndex:int = _arcs.length;

            arc.radius = 192 * (arcIndex + 1);

            arc.onCleared = function ():void {
                onArcCleared(arcIndex, arc);
            };

            arc.onClosed = function ():void {
                onArcClosed(arcIndex, arc);
            };

            this._arcs[arcIndex] = arc;
        }

        private function onArcCleared(arcIndex:int, arc:Arc):void {
            if (arcIndex == 0) {
                for (var i:int = 0; i < _arcs.length; ++i) {
                    _arcs[i].shrinkRate = BASE_SHRINK_RATE;
                    _arcs[i].angularVelocity = Math.PI * 0.01 * i;

                    if (i % 2 == 0) {
                        _arcs[i].angularVelocity *= -1;
                    }
                }
            }
        }

        private function onArcClosed(arcIndex:int, arc:Arc):void {

        }
    }
}
