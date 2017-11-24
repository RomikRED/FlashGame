package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Draw;
	import utils.AntStatistic;
	import net.flashpunk.graphics.Text;
	
	public class Door extends Entity 
	{
		public var doorbreak:Spritemap;
		
		public static const COLLDOOR:String = "standart";
		public var doorSpritemap:Spritemap;
		public var doorLockPosition:Object;
		
		public var isOpen:Boolean;
		public var isEnemyDoor:Boolean;
		public var goToRoom:int;
		
		//private var _doorHardness:int;
		public var doorStatusTxT:Text;
		public static var sfxDoorLocked:Sfx;
		public static var sfxDoorBreak:Sfx;
		
		public function Door(px:Number, py:Number, colisionType:String, renderlayer:int, toRoom:int = 0) 
		{
			this.x = px;
			this.y = py;
			this.type = colisionType;
			this.layer = renderlayer;
			
			goToRoom = toRoom;
			//_doorHardness = 1;
			isOpen = false;
			isEnemyDoor = false;
			
			doorSpritemap = new Spritemap(Assets.DOORS_STAND, 40, 80);
			doorSpritemap.add("open", [1], 1, false);
			doorSpritemap.add("block", [2], 1, false);
			
			doorbreak = new Spritemap(Assets.BOMB,96, 96, removeExplosion);
				doorbreak.add("expldoor", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 30, false);
				doorbreak.visible = false;
				doorbreak.scaleY = 1.5;
				doorbreak.scaleX = 1.5;
				doorbreak.y = 10;
				doorbreak.x = 15;
				doorbreak.centerOrigin();
				doorbreak.color = 0x000000;
			
			
			var textStatus:String;
			if (goToRoom == 0)
			{
				textStatus = C.USRTEXT[0];
				doorSpritemap.play("block");
				//sfxDoorLocked = new Sfx(Assets.SFX_DOORDESTROYED,null,"sound");
			}
			else
			{
				textStatus = C.USRTEXT[1];
				
			}
			sfxDoorLocked = new Sfx(Assets.SFX_DOORLOCKED, null, "sound");	
			sfxDoorBreak = new Sfx(Assets.SFX_BREAKDOOR, null, "sound");
			
			doorStatusTxT = new Text(textStatus, 20, -20, 
									{ font:"orbitron light", size: 12, color:0xFFFFFF});// , align: "center"});
			doorStatusTxT.smooth = true;
			doorStatusTxT.visible = false;
			
			
			setHitboxTo(doorSpritemap);
			doorLockPosition = {xpos:x + halfWidth * .5, ypos:y + halfHeight * .5, lwidth:20, lheight:10};
			
			graphic = new Graphiclist(doorSpritemap, doorStatusTxT, doorbreak);
			super(x, y, graphic);
		}
		
		private function removeExplosion():void 
		{
			doorbreak.visible = false;
			doorbreak.active = false;
		}
		
		override public function update():void 
		{
			super.update();
		}
		override public function render():void 
		{
			super.render();
			if (!isOpen)
			{
				Draw.rectPlus(	doorLockPosition.xpos, doorLockPosition.ypos, 
								doorLockPosition.lwidth, doorLockPosition.lheight,
								0x00FF00, 1,false,1,3);
			}
		}
		
		public function makeOpen(key:Boolean = false):void
		{
			if (goToRoom == 0 && !key)
			{
				viewLockStatus();
				return;
			}
			if (isOpen == false)
			{
				doorbreak.visible = true;
				doorbreak.play("expldoor");
				doorSpritemap.play("open");
				sfxDoorBreak.play(V.soundsVolume);
				isOpen = true;
				AntStatistic.track("brokeDoor", 1);
			}
		}
		
		public function viewLockStatus():void 
		{
			doorStatusTxT.visible = true;
			FP.alarm(3, changeLockStatus, ONESHOT);
		}
		
		private function changeLockStatus():void 
		{
			doorStatusTxT.visible = false;
		}
	}

}