package net.noiseinstitute.arc_depart {
    import net.flashpunk.World;

    public class GameWorld extends World {
        public function GameWorld() {
            var ship:Ship = new Ship;
            add(ship);

            var arc:Arc = new Arc;
            add(arc);

            camera.x = -Main.WIDTH * 0.5;
            camera.y = -Main.HEIGHT * 0.5;
        }
    }
}
