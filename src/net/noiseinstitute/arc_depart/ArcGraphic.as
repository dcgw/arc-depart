package net.noiseinstitute.arc_depart {
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;

    import net.flashpunk.Graphic;

    public final class ArcGraphic extends Graphic {
        [Embed("/arc.swf")]
        private static const SPRITE:Class;

        private var sprite:Sprite = new SPRITE;

        override public function render(target:BitmapData, point:Point, camera:Point):void {
            target.draw(sprite);
        }
    }
}
