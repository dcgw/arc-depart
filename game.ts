import {Color, DisplayMode, Engine} from "excalibur";

export default class Game {
    public readonly width = 640;
    public readonly height = 480;

    public readonly engine = new Engine({
        viewport: {width: this.width, height: this.height},
        resolution: {width: this.width, height: this.height},
        displayMode: DisplayMode.FitScreen,
        antialiasing: true,
        backgroundColor: Color.Black,
        suppressPlayButton: true
    });

    public async start(): Promise<void> {
        return this.engine.start();
    }
}
