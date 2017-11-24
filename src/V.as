package  
{
	import worlds.MenuWorld;
	public class V 
	{
		/*private static var _currentLevel:uint = 0;
		
		public static function get CurrentLevel():uint { return _currentLevel; }
		public static function set CurrentLevel(value:uint):void
		{
			_currentLevel = value;
		}*/
		
		public static var playerBullets1	:int = MenuWorld.ammoGoods[0].bulletsQnt;
		public static var playerMagazins1	:int = MenuWorld.ammoGoods[0].bulletsMagazinesQnt;
		public static var playerBullets2	:int = MenuWorld.ammoGoods[1].bulletsQnt;
		public static var playerMagazins2	:int = MenuWorld.ammoGoods[1].bulletsMagazinesQnt;
		public static var playerBullets3	:int = MenuWorld.ammoGoods[2].bulletsQnt;
		public static var playerMagazins3	:int = MenuWorld.ammoGoods[2].bulletsMagazinesQnt;
		
		public static var playerHealth		:Number = 20;
		public static var playerBaseHealth	:Number = 20;
		public static var playerMoney		:int = 100;
		public static var playerGrenade		:int = 1;
		public static var playerBatteries	:int = 1;
		
		public static var playerKeys		:int = 0;
		
		public static var currentLevel		:int = 1;
		public static var textViewNumb		:int = 1;
		
		//public static var 
		
		public static var soundsVolume		:Number =0.30;
		public static var musicsVolume		:Number = 0;//.30;
		public static var hints				:Boolean = true;
	}

}