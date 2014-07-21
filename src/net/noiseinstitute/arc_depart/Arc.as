package net.noiseinstitute.arc_depart {
    import net.flashpunk.Entity;
    import net.noiseinstitute.basecode.Static;
    import net.noiseinstitute.basecode.VectorMath;

    public final class Arc extends Entity {
        private static const BASE_SHRINK_RATE:Number = 20 / Main.LOGIC_FPS; // Pixels per frame.
        private var arcGraphic:ArcGraphic = new ArcGraphic;

        private var radius:Number = 192;

        private var ship:Ship;

        private var shrinkRate:Number = 0;

        public function Arc(ship:Ship) {
            this.ship = ship;
            graphic = arcGraphic;
        }

        override public function update():void {
            Static.point.x = ship.x;
            Static.point.y = ship.y;

            Static.point2.x = x;
            Static.point2.y = y;

            VectorMath.subtractFrom(Static.point, Static.point2);

            if (VectorMath.magnitude(Static.point) > radius) {
                cleared();
            }

            radius -= shrinkRate;

            if (radius <= 0) {
                radius = 0;
                active = false;
                visible = false;
            }
        }

        override public function render():void {
            arcGraphic.radius = radius;

            super.render();
        }

        private function cleared():void {
            shrinkRate = BASE_SHRINK_RATE;
        }
    }
}
