package net.noiseinstitute.arc_depart {
    import flash.geom.Point;

    import net.noiseinstitute.basecode.Static;
    import net.noiseinstitute.basecode.VectorMath;

    public class CameraMovement {
        private static const VELOCITY_ADJUSTMENT_MULTIPLIER:int = 32;
        private static const MAX_VELOCITY_ADJUSTMENT:int = 144;
        private static const VELOCITY_ADJUSTMENT_SMOOTHING_FACTOR:Number = 0.04;

        private static const HEADING_ADJUSTMENT_MAGNITUDE:Number = 96;
        private static const HEADING_ADJUSTMENT_SMOOTHING_FACTOR:Number = 0.04;

        private var camera:Point;
        private var playerShip:PlayerShip;
        private var arcSystem:ArcSystem;

        private var velocityAdjustment:Point = new Point;
        private var headingAdjustment:Point = new Point;

        public function CameraMovement(camera:Point, playerShip:PlayerShip, arcSystem:ArcSystem) {
            this.camera = camera;
            this.playerShip = playerShip;
            this.arcSystem = arcSystem;
        }

        public function update():void {
            Static.point.x = playerShip.velocity.x * VELOCITY_ADJUSTMENT_MULTIPLIER;
            Static.point.y = playerShip.velocity.y * VELOCITY_ADJUSTMENT_MULTIPLIER;

            if (VectorMath.magnitude(Static.point) > MAX_VELOCITY_ADJUSTMENT) {
                VectorMath.setMagnitudeInPlace(Static.point, MAX_VELOCITY_ADJUSTMENT);
            }

            velocityAdjustment.x += (Static.point.x - velocityAdjustment.x) * VELOCITY_ADJUSTMENT_SMOOTHING_FACTOR;
            velocityAdjustment.y += (Static.point.y - velocityAdjustment.y) * VELOCITY_ADJUSTMENT_SMOOTHING_FACTOR;

            VectorMath.becomePolar(Static.point, playerShip.angle, HEADING_ADJUSTMENT_MAGNITUDE);

            headingAdjustment.x += (Static.point.x - headingAdjustment.x) * HEADING_ADJUSTMENT_SMOOTHING_FACTOR;
            headingAdjustment.y += (Static.point.y - headingAdjustment.y) * HEADING_ADJUSTMENT_SMOOTHING_FACTOR;

            camera.x = playerShip.x + velocityAdjustment.x - Main.CENTER_X + velocityAdjustment.x;
            camera.y = playerShip.y + velocityAdjustment.y - Main.CENTER_Y + velocityAdjustment.y;
        }
    }
}
