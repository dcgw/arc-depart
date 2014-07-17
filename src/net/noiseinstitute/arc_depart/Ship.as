package net.noiseinstitute.arc_depart {
    import flash.display.BlendMode;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;

    public final class Ship extends Entity {
        [Embed(source="/ship-mask.png")]
        private static const MASK_IMAGE:Class;

        [Embed(source="/ship-additive.jpg")]
        private static const ADDITIVE_IMAGE:Class;

        public function Ship() {
            var maskImage:Image = new Image(MASK_IMAGE);
            maskImage.centerOrigin();

            var additiveImage:Image = new Image(ADDITIVE_IMAGE);
            additiveImage.centerOrigin();
            additiveImage.blend = BlendMode.ADD;

            graphic = new Graphiclist(maskImage, additiveImage);
        }
    }
}
