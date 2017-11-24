package
{
	import net.flashpunk.*;
	import worlds.MenuWorld;
	
	/** Main game class. */
	public class Main extends Engine
	{
		
		/** Constructor. Start the game and set the starting world. */
		public function Main() 
		{
			// Specify the size of the game (640x480) and the framerate (60 fps.)
			super(640, 480, 60);
			
		}
		
		override public function init():void 
		{
			super.init();
			
			//FP.console.enable();
			FP.world = new MenuWorld();
		}
	}
}
