package net.noiseinstitute.arc_depart {
    import flash.geom.Point;

    import net.noiseinstitute.basecode.Static;
    import net.noiseinstitute.basecode.VectorMath;

    public class CameraMovement {
        private static const VELOCITY_ADJUSTMENT_MULTIPLIER:int = 32;
        private static const MAX_VELOCITY_ADJUSTMENT:int = 144;
        private static const VELOCITY_ADJUSTMENT_SMOOTHING_FACTOR:Number = 0.04;

        private static const HEADING_ADJUSTMENT_MAGNITUDE:Number = 32;
        private static const HEADING_ADJUSTMENT_SMOOTHING_FACTOR:Number = 0.04;

        private static const EXIT_ADJUSTMENT_MAGNITUDE:Number = 32;
        private static const EXIT_ADJUSTMENT_SMOOTHING_FACTOR:Number = 0.04;

        private static const TITLE_ADJUSTMENT:Point = new Point(0, -16);

        private var camera:Point;
        private var playerShip:PlayerShip;
        private var arcSystem:ArcSystem;

        private var velocityAdjustment:Point = new Point;
        private var headingAdjustment:Point = new Point(TITLE_ADJUSTMENT.x, TITLE_ADJUSTMENT.y);
        private var exitAdjustment:Point = new Point;

        public var title:Boolean = true;

        public function CameraMovement(camera:Point, playerShip:PlayerShip, arcSystem:ArcSystem) {
            this.camera = camera;
            this.playerShip = playerShip;
            this.arcSystem = arcSystem;

            camera.x = -Main.CENTER_X;
            camera.y = -Main.CENTER_Y - HEADING_ADJUSTMENT_MAGNITUDE;
        }

        public function update():void {
            updateVelocityAdjustment();
            updateHeadingAdjustment();
            updateExitAdjustment();

            camera.x = playerShip.x + velocityAdjustment.x + headingAdjustment.x + exitAdjustment.x - Main.CENTER_X;
            camera.y = playerShip.y + velocityAdjustment.y + headingAdjustment.y + exitAdjustment.y - Main.CENTER_Y;
        }

        private function updateVelocityAdjustment():void {
            if (title) {
                Static.point.x = 0;
                Static.point.y = 0;
            } else {
                Static.point.x = playerShip.velocity.x * VELOCITY_ADJUSTMENT_MULTIPLIER;
                Static.point.y = playerShip.velocity.y * VELOCITY_ADJUSTMENT_MULTIPLIER;

                if (VectorMath.magnitude(Static.point) > MAX_VELOCITY_ADJUSTMENT) {
                    VectorMath.setMagnitudeInPlace(Static.point, MAX_VELOCITY_ADJUSTMENT);
                }
            }

            velocityAdjustment.x += (Static.point.x - velocityAdjustment.x) * VELOCITY_ADJUSTMENT_SMOOTHING_FACTOR;
            velocityAdjustment.y += (Static.point.y - velocityAdjustment.y) * VELOCITY_ADJUSTMENT_SMOOTHING_FACTOR;
        }

        private function updateHeadingAdjustment():void {
            if (title) {
                Static.point.x = TITLE_ADJUSTMENT.x;
                Static.point.y = TITLE_ADJUSTMENT.y;
            } else {
                VectorMath.becomePolar(Static.point, playerShip.angle, HEADING_ADJUSTMENT_MAGNITUDE);
            }

            headingAdjustment.x += (Static.point.x - headingAdjustment.x) * HEADING_ADJUSTMENT_SMOOTHING_FACTOR;
            headingAdjustment.y += (Static.point.y - headingAdjustment.y) * HEADING_ADJUSTMENT_SMOOTHING_FACTOR;
        }

        private function updateExitAdjustment():void {
            if (title) {
                Static.point.x = 0;
                Static.point.y = 0;
            } else {
                VectorMath.copyTo(Static.point, arcSystem.computeCurrentExitPosition());

                Static.point.x -= playerShip.x;
                Static.point.y -= playerShip.y;

                if (VectorMath.magnitude(Static.point) > EXIT_ADJUSTMENT_MAGNITUDE) {
                    VectorMath.setMagnitudeInPlace(Static.point, EXIT_ADJUSTMENT_MAGNITUDE);
                }
            }

            exitAdjustment.x += (Static.point.x - exitAdjustment.x) * EXIT_ADJUSTMENT_SMOOTHING_FACTOR;
            exitAdjustment.y += (Static.point.y - exitAdjustment.y) * EXIT_ADJUSTMENT_SMOOTHING_FACTOR;
        }
    }
}
