package entities 
{
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.FP;
	import worlds.GameWorld;
	import worlds.ShootWorld;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CollectThing extends Entity 
	{
		/*public static const MAGAZINE:int = 0;
		public static const MONEY:int = 1;
		public static const BATTERIES:int = 2;
		public static const GRENAD:int = 3;*/
		
		
		private var _flyThingImg:Stamp;
		private var _variety:int;
		private var _sfxScopes:Sfx;
		
		public function CollectThing(_x:Number=0, _y:Number=0, variety:int = 0) 
		{
			_variety = variety;
			
			setPosition(_x, _y);
			setGraphics(_variety);
		}
		
		override public function added():void 
		{
			super.added();
			flyAnim();
		}
		public function setPosition(x:Number=0, y:Number=0):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function setGraphics(variety:int=0):void
		{
			_sfxScopes = new Sfx(Assets.SFX_ADD,null,"soundShoot");
			switch (variety) 
			{
				case 0/*MAGAZINE*/:
					_flyThingImg = new Stamp(Assets.AMMO);
				break;
				case 1/*MONEY*/:
					_flyThingImg = new Stamp(Assets.MONEY);
					_sfxScopes = new Sfx(Assets.SFX_ADDMONEY,null,"sound");
				break;
				case 2/*BATTERIES*/:
					_flyThingImg = new Stamp(Assets.BATTERY);
				break;
				case 3/*GRENAD*/:
					_flyThingImg = new Stamp(Assets.GRENADE);
				break;
				
			}
			
			graphic = _flyThingImg;
		}
		
		public function flyAnim():void
		{
			var flyAnimation:MultiVarTween = new MultiVarTween(disapear, ONESHOT);
			flyAnimation.tween(this, {x:FP.camera.x+20, y:FP.camera.y}, 1, Ease.backIn);
			FP.world.addTween(flyAnimation, true);
			_sfxScopes.volume = V.soundsVolume* 0.2;
			_sfxScopes.play();
		}
	
		private function disapear():void
		{
			_flyThingImg.visible = false;
			
			if (world is GameWorld)
			{
				var gw:GameWorld = world as GameWorld;
				gw.playerG.collected(_variety);
			}
			else if (world is ShootWorld)
			{
				var sw:ShootWorld = world as ShootWorld;
				sw.playerS.collected(_variety);
			}
			
			/*switch (_variety )
			{
				case MAGAZINE:
					Player.addmagazine++;
				break;
				case MONEY:
					Player.addmoney++;
				break;
				case BATTERIES:
					Player.addbattery++;
				break;
				case GRENAD:
					Player.addgrenades++;
				break;
			}*/
			FP.world.remove(this);
		}
		
	}

}