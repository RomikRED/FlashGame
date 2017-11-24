package  
{
	import flash.display.BitmapData;
	import net.flashpunk.graphics.Image;
	/**
	 * Game constants for OgmoDash.
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public class C 
	{
		
		public static const GAME_WIDTH:int = 640;
		public static const GAME_HEIGHT:int = 480;
		
		[Embed(source = "../levels/menuXML.oel", mimeType = "application/octet-stream")]
		public static const MENUXML:Class;
		
		/**
		 * Image for Rooms background
		 */
		//public static const ROOM_IMG:Image = new Image(Assets.ROOM_BACK);
		
		public static const PRICE_MAGAZINE:int = 20*5;
		public static const PRICE_BATTERY:int = 10*5;
		public static const PRICE_GRENADE:int = 30*5;
		
		public static const PRICE_GUN:int = 100;
		public static const PRICE_MP5:int = 350;
		public static const PRICE_AK:int = 550;
		
		public static const DARKNESS:Number = 0.83;
		public static const DARKNESS_ROOM:Number = 0.83;
		
		
		public static const TEXTBASE:Array = 
		[
		"<ESC> to exit \nClick HERE to the next hint",
		"Use arrow keys or <WASD> to move \n<SPACE> for jump",
		"<E> or <MOUSE LEFT> for fire",
		"<1>, <2>, <3> for choice weapon",
		"<Q> for throw grenade",
		"<L> for use flashlight",
		"Go inside the room by press key <UP> near the door",
		"On stairs press <LEFT> + <UP>, then <RIGHT> + <UP>",
		"Buy ammo on the top of screen",
		"On/off hints in the game settings"
		];
		
		public static const USRTEXT:Array = 
		[
		//door
		"This entrance is blocked.\nYou need to clear rooms",
		 "This door is closed.\nTry to use your weapon.\nTarget is green area on the door.",
		//hole
	//	"You stand near hole.\nPress <DOWN> or <S> to go to the lower floor\nor <SPACE> for jump",
		"You stand near hole.\nPress <SPACE> for jump",
		//gameworls
		"You can destroy door\nby use grenade <Q>",
		"Already done!"
		];
		
		public static const ROOMENEMIES:Array = 
		[
			//0		1		2		3
			///1,1,1,1,
			3,		4,		5,		5,
			//4		5		6		7
			7,		7,		8,		8,
			///1,1,1,1,
			//8		9		10		11
			10,		10,		12,		12,
			///1,1,1,1,
			//12	13		14		15
			14,		14,		16,		16		
			///1,1,1,1
		];
		
		public static const VARIETIES:Array = 
		[0xFFFFFF, 0x8000FF, 0x808000, 0x800040,,
		0x000080, 0x804000, 0xC0C0C0, 0x800080,
		0x008040, 0x800000, 0x400080, 0x008080,
		0x804040,0x0080C0,0x613030,0x161616];
		
		public static const MULTIPLIFY:Array = 
		[
		1, 1.1, 1.2, 1.3,
		1.4, 1.5, 1.6, 1.7,
		1.8, 1.9, 2, 2.1,
		2.2, 2.3, 2.4, 2.5,
		2.6, 2.7, 2.8, 3	
		];
		
		public static const SHOOTENDELAY:Array =
		[
		240, 200, 180, 160,
		140, 120, 120, 100,
		100, 100, 90, 80,
		85, 70, 70, 60
		];
		
		
		
	}

}