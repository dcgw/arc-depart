package net.noiseinstitute.arc_depart {
    import net.flashpunk.World;

    public class GameWorld extends World {
        public function GameWorld() {
            var ship:Ship = new Ship();
            ship.x = Main.WIDTH * 0.5;
            ship.y = Main.HEIGHT * 0.5;
            add(ship);

            add(new Arc);
        }
    }
}
