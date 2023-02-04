import domready from "domready";
import pkg from "./package.json";
import Game from "./game.js";

console.log(`Arc Depart v${pkg.version}`);

const game = new Game();

domready(() => {
    void game.start();
});
