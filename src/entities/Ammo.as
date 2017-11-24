package entities 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import lit.Light;
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.tweens.motion.CircularMotion;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.tweens.motion.LinearPath;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Ease;
	
	
	public class Ammo extends Entity 
	{
		//public static const COLL_WEAPON:String = "weapon";
		//public static const COLL_BATTERY:String = "battery";
		//public static const COLL_GRENADE:String = "grenade";
		//public static const COLL_DIGIKEY:String = "digitkey";
		//public static var pickedTypes:Vector.<String> = new <String>[COLL_WEAPON, COLL_DIGIKEY];
		
		public var grenadeIsActive	:Boolean;
		//public var flippedDirection	:Number;
		public var ammoVariety	:int;
		public var img				:Image;
		public var handAmmo	:Spritemap;
		public var explosion		:Spritemap;
		//public var thingLight		:Light;
		public var price			:int;
		public var isBought			:Boolean;
		public var bulletsQnt		:int;
		public var bulletsMagazinesQnt	:int;
		public var bulletsLeftQnt	:int;
		public var weaponShotDelay	:int;
		public var weaponRecharging	:int;
		//public var bulletPosition	:Point;
		//private var _thingsLightBlinc:VarTween;
		private var _sfxreload		:Sfx;
		public var shakeStrength	:int;
		public var stringWeaponForPlayer:String;
		
		public function Ammo(_x:Number, _y:Number, variety:int, colisionType:String) 
		{
			x = _x;
			y = _y;
			type = colisionType;
			ammoVariety = variety;
			handAmmo = new Spritemap(Assets.WEAPON, 36, 22);
			switch (type) 
			{
				case "weapon":
					switch (ammoVariety) 
					{
						case 1:
							price = C.PRICE_GUN;
							bulletsMagazinesQnt = 3;
							bulletsQnt = 30;
							bulletsLeftQnt = 30;
							weaponShotDelay = -20;
							weaponRecharging = 5;
							//bulletPosition = new Point( -20, -20);
							_sfxreload = new Sfx(Assets.SFX_RELOAD1, null, "soundShoot");
							isBought = true;
							shakeStrength = 3;
							stringWeaponForPlayer = "gun";
						break;
						case 2:
							price = C.PRICE_MP5;
							bulletsMagazinesQnt = 4;
							bulletsQnt = 20;
							bulletsLeftQnt = 20;
							weaponShotDelay = -10;
							weaponRecharging = 3;
							_sfxreload = new Sfx(Assets.SFX_RELOAD2, null, "soundShoot");
							isBought = false;
							shakeStrength = 5;
							stringWeaponForPlayer = "Mk";
						break;
						case 3:
							price = C.PRICE_AK;
							bulletsMagazinesQnt = 5;
							bulletsQnt = 50;
							bulletsLeftQnt = 50;
							weaponShotDelay = -7;
							weaponRecharging = 2;
							_sfxreload = new Sfx(Assets.SFX_RELOAD3, null, "soundShoot");
							isBought = false;
							shakeStrength = 7;
							stringWeaponForPlayer = "Ak";
						break;
						
					}
					
					handAmmo.add("gun", [0],1);
					handAmmo.add("gunShoot", [1], 1);
					handAmmo.add("Mk", [4], 1);
					handAmmo.add("MkShoot", [5], 1);
					handAmmo.add("Ak", [2], 1);
					handAmmo.add("AkShoot", [3], 1);
					
					
				break;
				case "battery":
					img = new Image(Assets.BATTERY);
					graphic = img;
				break;
				case "grenade":
					img = new Image(Assets.GRENADE);
					img.visible = false;
					explosion = new Spritemap(Assets.BOMB, 96, 96, remove);
					explosion.add("explode", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 19, false);
					explosion.centerOrigin();
					explosion.visible = false;
					grenadeIsActive = false;
					graphic = new Graphiclist(img, explosion);
				break;
				/*case COLL_DIGIKEY:
					img = new Image(Assets.DIGIKEY);
					graphic = img;
				break;*/
			}
			
			//centerOrigin();
			
			/*var thingLightImg:Image = new Image(new BitmapData(20, 20, false, 0x000000));
			thingLightImg.originX = thingLightImg.width * 0.5;
			thingLightImg.originY = thingLightImg.height * 0.5;
			thingLight = new Light(x, y, thingLightImg);*/
			
			/*_thingsLightBlinc = new VarTween(changeVarTween, ONESHOT);
			_thingsLightBlinc.tween(thingLight, "scale", 0.8, 1.5);
			addTween(_thingsLightBlinc);*/
			super(x, y, graphic);
		}
		
		
		
		
		/**
		 * play reloading sound
		 */
		public function reloading():Number 
		{
			_sfxreload.play();
			return _sfxreload.length;
		}
		
		/*private function changeVarTween():void
		{
			_thingsLightBlinc.start();
		}*/
		
		override public function update():void 
		{
			super.update();
		}
		
		public function remove():void
		{
			switch (type) 
			{
				case "weapon":
					world.remove(this);
				break;
				case "grenade":
					img.visible = false;
					explosion.visible = false;
					grenadeIsActive = false;
					collidable = false;
				break;
			}
		}
	}

}