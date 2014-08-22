package net.noiseinstitute.arc_depart {
    import net.flashpunk.Entity;
    import net.noiseinstitute.basecode.Static;
    import net.noiseinstitute.basecode.VectorMath;

    public final class Arc extends Entity {
        public var onCleared:Function;

        public var onClosed:Function;

        private var arcGraphic:ArcGraphic = new ArcGraphic;

        private var angle:Number = 0;

        private var playerShip:PlayerShip;

        private var cleared:Boolean = false;

        public var radius:Number = 192;

        public var shrinkRate:Number = 0; // Pixels per frame.

        public var angularVelocity:Number = 0; // Degrees per frame.

        public function Arc(playerShip:PlayerShip) {
            this.playerShip = playerShip;
            graphic = arcGraphic;
        }

        override public function update():void {
            if (!cleared && testCleared()) {
                arcGraphic.glow();
                cleared = true;

                if (onCleared != null) {
                    onCleared();
                }
            }

            angle += angularVelocity;

            radius -= shrinkRate;

            if (radius <= 0) {
                radius = 0;
                active = false;
                visible = false;

                if (onClosed != null) {
                    onClosed();
                }
            }
        }

        override public function render():void {
            arcGraphic.angle = angle;
            arcGraphic.radius = radius;

            super.render();
        }

        private function testCleared():Boolean {
            VectorMath.becomePolar(Static.point, 30, radius);
            VectorMath.becomeUnitVector(Static.point2, 0);

            var exitDistance:Number = VectorMath.dot(Static.point, Static.point2);

            Static.point.x = playerShip.x;
            Static.point.y = playerShip.y;

            Static.point2.x = x;
            Static.point2.y = y;

            VectorMath.subtractFrom(Static.point, Static.point2);

            if (VectorMath.magnitude(Static.point) > radius) {
                return true;
            }

            VectorMath.becomeUnitVector(Static.point2, angle);

            return VectorMath.dot(Static.point, Static.point2) > exitDistance;
        }
    }
}
