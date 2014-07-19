package net.noiseinstitute.arc_depart {
    import flash.display.BlendMode;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;

    public final class Title extends Entity {
        [Embed(source="/a.png")]
        private static const A_SPRITE:Class;

        [Embed(source="/r.png")]
        private static const R_SPRITE:Class;

        [Embed(source="/c.png")]
        private static const C_SPRITE:Class;

        [Embed(source="/d.png")]
        private static const D_SPRITE:Class;

        [Embed(source="/e.png")]
        private static const E_SPRITE:Class;

        [Embed(source="/p.png")]
        private static const P_SPRITE:Class;

        [Embed(source="/t.png")]
        private static const T_SPRITE:Class;

        private static const LETTER_COUNT:int = 10;
        private static const LETTER_WIDTH:Number = 40;
        private static const LETTER_HEIGHT:Number = 40;
        private static const LETTER_SPACING:Number = 16;
        private static const LETTER_MARGIN:Number = 16;

        private static const TITLE_WIDTH:Number = LETTER_COUNT * (LETTER_WIDTH + LETTER_SPACING) - LETTER_SPACING;
        private static const TITLE_LEFT:Number = -TITLE_WIDTH * 0.5;

        private var letters:Vector.<Image> = new <Image>[new Image(A_SPRITE), new Image(R_SPRITE), new Image(C_SPRITE),
            null, new Image(D_SPRITE), new Image(E_SPRITE), new Image(P_SPRITE), new Image(A_SPRITE),
            new Image(R_SPRITE), new Image(T_SPRITE)];

        public function Title() {
            var graphicList:Graphiclist = new Graphiclist;

            for (var i:int = 0; i < LETTER_COUNT; ++i) {
                var letter:Image = letters[i];

                if (letter != null) {
                    letter.x = Title.TITLE_LEFT + i * (Title.LETTER_WIDTH + Title.LETTER_SPACING) - Title.LETTER_MARGIN;
                    letter.y = -Title.LETTER_HEIGHT * 0.5 - Title.LETTER_MARGIN;
                    letter.blend = BlendMode.ADD;
                    graphicList.add(letter);
                }
            }

            graphic = graphicList;
        }
    }
}
