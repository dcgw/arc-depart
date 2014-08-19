package net.noiseinstitute.arc_depart {
    import net.flashpunk.Entity;
    import net.noiseinstitute.basecode.Static;
    import net.noiseinstitute.basecode.VectorMath;

    public final class Arc extends Entity {
        private static const BASE_SHRINK_RATE:Number = 20 / Main.LOGIC_FPS; // Pixels per frame.

        private var arcGraphic:ArcGraphic = new ArcGraphic;

        private var angle:Number = 0;

        private var radius:Number = 192;

        private var playerShip:PlayerShip;

        private var angularVelocity:Number = 0 / Main.LOGIC_FPS; // Degrees per frame.

        private var shrinkRate:Number = 0;

        private var cleared:Boolean = false;

        public function Arc(playerShip:PlayerShip) {
            this.playerShip = playerShip;
            graphic = arcGraphic;
        }

        override public function update():void {
            if (!cleared && testCleared()) {
                arcGraphic.glow();
                shrinkRate = BASE_SHRINK_RATE;
                cleared = true;
            }

            angle += angularVelocity;

            radius -= shrinkRate;

            if (radius <= 0) {
                radius = 0;
                active = false;
                visible = false;
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
