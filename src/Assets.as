package  
{
	/**
	 * Game assets for OgmoDash
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public class Assets 
	{
		/** The player graphic. */

		[Embed(source = "../assets/heroSide.png")] public static const PLAYER:Class;
		[Embed(source = "../assets/ZombSideScaled.png")] public static const ENEMY:Class;;
		[Embed(source = "../assets/boom.png")] public static const BOMB:Class;

		
		[Embed(source="../assets/ZombFaceScaled.png")] public static const ZOMB:Class;
		[Embed(source = "../assets/rooms.PNG")] public static const ROOM_BACK:Class;
		[Embed(source = "../assets/damageOverlay.png")] public static const DAMAGE:Class;
		[Embed(source = "../assets/UI/health.png")] public static const HEARTH:Class;
		
		/** The star pickup. */
		[Embed(source = "../assets/weapons.png")] public static const WEAPON:Class;
		[Embed(source = "../assets/grenade.png")] public static const GRENADE:Class;
		[Embed(source = "../assets/battery.png")] public static const BATTERY:Class;
		
		
		[Embed(source = "../assets/ammo.png")] public static const AMMO:Class;
		[Embed(source = "../assets/money.png")] public static const MONEY:Class;
		//[Embed(source = "../assets/floorBar.png")] public static const FLOORBAR:Class;
		
		
		[Embed(source = "../assets/doors.png")] 	public static const DOORS_STAND:Class;
		//[Embed(source="../assets/doubledoors.png")]	public static const DOORS_AUTOM:Class;
		[Embed(source = "../assets/holeBig.png")]	public static const HOLE:Class;
		
		/** The tilesheet. */
		//[Embed(source = "../assets/tiles1.png")] public static const TILESHEET:Class;
		[Embed(source = "../assets/lvl0.png")] public static const BK:Class;
		//[Embed(source = "../assets/lvl1.png")] public static const BLOODS:Class;
		//[Embed(source = "../assets/lvl2.png")] public static const FLOORS:Class;
		[Embed(source = "../assets/brokenStairs.png")] public static const BROKEN_Stairs:Class;
		[Embed(source = "../assets/weapwhands.png")] public static const WEAPON_SHOOT:Class;
		
		/** The fonts. */
		[Embed(source = '../assets/fonts/Orbitron Black.ttf', embedAsCFF = "false", fontFamily = 'orbitron black')] public static const FONT_ORBITRON_BLACK:Class;
		[Embed(source = '../assets/fonts/Orbitron Bold.ttf', embedAsCFF = "false", fontFamily = 'orbitron bold')] public static const FONT_ORBITRON_BOLD:Class;
		[Embed(source = '../assets/fonts/Orbitron Medium.ttf', embedAsCFF = "false", fontFamily = 'orbitron medium')] public static const FONT_ORBITRON_MEDIUM:Class;
		[Embed(source = '../assets/fonts/Orbitron Light.ttf', embedAsCFF = "false", fontFamily = 'orbitron light')] public static const FONT_ORBITRON_LIGHT:Class;
		
		/** Lights */
		[Embed(source = "../assets/torch.png")] 	public static const TORCH:Class;
		[Embed(source = "../assets/torchRoom.png")] 	public static const TORCHROOM:Class;
		//[Embed(source = "../assets/lig1600.png")] 	public static const BRIGHTNESS:Class;//TEMP
		[Embed(source = "../assets/spot2.png")]		public static const LAMPS:Class;
		[Embed(source="../assets/shotInRoom.png")]  public static const SHOOT_InROOM:Class;
		
		[Embed(source="../assets/menuBack.png")] public static const BCKGR_WELCOME:Class;
				
		[Embed(source = "../assets/UI/selectStgsSpr.png")] public static const STAGES_SLCT:Class;
		[Embed(source = "../assets/UI/selectt.png")] public static const	ICOS_SEL:Class;
		[Embed(source = "../assets/UI/icoS.png")] public static const ICOS:Class;
		
		[Embed(source = "../assets/UI/ammoshop.png")] public static const BTN_AMMO:Class;
		[Embed(source = "../assets/UI/magazineHud.png")] public static const HUDMAG:Class;
		
		[Embed(source = "../assets/UI/hudBar.png")] public static const HUDBAR:Class;
		[Embed(source="../assets/UI/keys.png")]public static const KEYS:Class;
		
		
		///SFXXXXXXXXXXXXXXXXX
			[Embed(source = "../assets/sfx/menuBack.mp3")]
		public static const SFX_MENU:Class;
			[Embed(source = "../assets/sfx/gameback.mp3")]
		public static const SFX_GAME:Class;
			[Embed(source = "../assets/sfx/gameWin.mp3")]
		public static const SFX_GAME_WIN:Class;
			[Embed(source = "../assets/sfx/gameOver.mp3")]
		public static const SFX_GAME_OVER:Class;
			[Embed(source = "../assets/sfx/doorlock.mp3")] 
		public static const SFX_DOORLOCKED:Class;
			[Embed(source = "../assets/sfx/plWalk.mp3")]
		public static const SFX_PLAYERWALK:Class;
		
			
			[Embed(source = "../assets/sfx/shot1.mp3")]
		public static const SFX_SHOOT1:Class;
			[Embed(source = "../assets/sfx/shot2.mp3")] 
		public static const SFX_SHOOT2:Class;
			[Embed(source = "../assets/sfx/shot3.mp3")]
		public static const SFX_SHOOT3:Class;
			[Embed(source = "../assets/sfx/reload1.mp3")]
		public static const SFX_RELOAD1:Class;
			[Embed(source = "../assets/sfx/reload2.mp3")]
		public static const SFX_RELOAD2:Class;
			[Embed(source = "../assets/sfx/reload3.mp3")]
		public static const SFX_RELOAD3:Class;
			[Embed(source = "../assets/sfx/grenade.mp3")]
		public static const SFX_GRENADE:Class;
			[Embed(source = "../assets/sfx/doorbreak.mp3")]
		public static const SFX_BREAKDOOR:Class;
		
		
			[Embed(source="../assets/sfx/addmoney.mp3")]
		public static const SFX_ADDMONEY:Class;
			[Embed(source = "../assets/sfx/addThing.mp3")] 
		public static const SFX_ADD:Class;
			[Embed(source = "../assets/sfx/btnClick.mp3")] 
		public static const SFX_BTNCLICK:Class;
			[Embed(source = "../assets/sfx/mouseOver.mp3")]
		public static const SFX_MouseOver:Class;
			[Embed(source = "../assets/sfx/ach.mp3")]
		public static const SFX_ACHIEVE:Class;
		
		
			[Embed(source = "../assets/sfx/zdead1.mp3")]
		public static const SFX_ZOMBDEAD1:Class;
			[Embed(source = "../assets/sfx/zdead2.mp3")]
		public static const SFX_ZOMBDEAD2:Class;
			[Embed(source = "../assets/sfx/zdead3.mp3")]
		public static const SFX_ZOMBDEAD3:Class;
			[Embed(source = "../assets/sfx/zatt1.mp3")]
		public static const SFX_ZOMBATTACK1:Class;
			[Embed(source = "../assets/sfx/zatt2.mp3")]
		public static const SFX_ZOMBATTACK2:Class;
			[Embed(source = "../assets/sfx/zatt3.mp3")]
		public static const SFX_ZOMBATTACK3:Class;
			[Embed(source = "../assets/sfx/zpursuit1.mp3")]
		public static const SFX_ZOMBPursuit1:Class;
			[Embed(source = "../assets/sfx/zpursuit2.mp3")]
		public static const SFX_ZOMBPursuit2:Class;
			[Embed(source = "../assets/sfx/zpursuit3.mp3")]
		public static const SFX_ZOMBPursuit3:Class;
	}	
	

}