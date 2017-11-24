package entities {
	import flash.geom.Point;
	import flash.display.BitmapData;
	import lit.LightCollidableBase;
	import net.flashpunk.Sfx;
	import net.flashpunk.masks.Pixelmask;
	import worlds.ShootWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import worlds.GameWorld;
	import net.flashpunk.utils.Draw;
	import utils.AntStatistic;
	

	/**
	 * @author redefy
	 */
	public class Bullet extends Entity {
		
		public var isShootWorld:Boolean;
		public var bulletVariety:int;
		public var bulletAngle:Number;
		private var _bulletBitmap:Image; 
		private var _bulletStrenth:Number;
		private var _position:Point;
		private var _velocity:Point;
		private var _start:Point;
		private var _sfxShoot:Sfx
		
		public function Bullet()
		{
			type = "bullet";
		}

		private function createBullet(abulletVariety:int):void 
		{
			var bulletColour:uint, hbxData:BitmapData;
			switch (abulletVariety) 
			{ 
				case 1:
					_bulletStrenth = 4;
					_sfxShoot = new Sfx(Assets.SFX_SHOOT1,shootEnd,"soundShoot");
					break;
			
				case 2:
					_bulletStrenth = 6;
					_sfxShoot = new Sfx(Assets.SFX_SHOOT2,shootEnd,"soundShoot");
					break;
				
				case 3:
					_bulletStrenth = 9;
					_sfxShoot = new Sfx(Assets.SFX_SHOOT3,shootEnd,"soundShoot");
					break;
			}
			bulletColour = 0xFFFFFF;
			hbxData = new BitmapData(20, 1, false, bulletColour);
			graphic =_bulletBitmap = new Image(hbxData);
			
		}
		
		public function bulletFly(start:Point, finish:Point, speedBullet:Number = 30):void
		{
			_start = start.clone();
			_position = start;
			_velocity = finish.subtract(_position);
			_velocity.normalize(speedBullet);
		}
		
		private function shootEnd():void 
		{
			if (isShootWorld) 
			{
				//trace("isShootWorld");
				FP.world.recycle(this);
			}
		}
		
		override public function added():void 
		{
			createBullet(bulletVariety); 
			setHitboxTo(_bulletBitmap);
			_bulletBitmap.angle = bulletAngle;
			_sfxShoot.play();
			super.added();
		}
		
		private var _bullet_collided:Entity;
		override public function update():void 
		{
			//if (GV.paused){}
			if (isShootWorld)
			{
				_bullet_collided = collide("shenemy", x, y);
				if (_bullet_collided is ShootEnemy) 
				{
					//trace("is ShootEnemy");
					var shootenemy:ShootEnemy;
						shootenemy = _bullet_collided as ShootEnemy;
						shootenemy.hurt(_bulletStrenth, x,y);
				}
				FP.world.remove(this);
				return;
			}
			
			_position.x += _velocity.x;
			_position.y += _velocity.y;
						
			x = _position.x;
			y = _position.y;
				
			
			//for Gameworld to prevent fast moving throuth solid 
			_bullet_collided = world.collideRect("solid", x, y - 40, 5, 40);
			if ( _bullet_collided ) 
			{
				FP.world.recycle(this);
				return;
			}
			
			
			_bullet_collided = collideTypes(["standart", "enemy", "light"], x, y);
			if (_bullet_collided is Door) 
			{
				var door:Door = _bullet_collided as Door;
				if (door.isOpen) return;
				var lockPos:Object = door.doorLockPosition;
				//var toDoordist:Number = FP.distance(_start.x, _start.y, x, y);
				//var chekDist:Number = door.height * 2;
				if (FP.distance(_start.x, _start.y, x, y) <= door.height * 2 && collideRect(x,y,lockPos.xpos,lockPos.ypos, lockPos.lwidth, lockPos.lheight))
				{
					door.makeOpen();
					FP.world.recycle(this);
					return;
				}
			}
			
			if (_bullet_collided is Enemy)
			{
				var enemy:Enemy;
					enemy = _bullet_collided as Enemy;
				var damage:Number;
				var damageDistance:Number;
				damageDistance = FP.width / distanceFrom(enemy) / 10;
				
				if (y < enemy.y - enemy.halfHeight*0.6) 
				{	
					damage = _bulletStrenth * 3 + damageDistance;
					enemy.headShot = true;
				}
				else {	damage = _bulletStrenth + damageDistance; }
				
				enemy.hurt(damage);
				FP.world.recycle(this);
				return;
			}
				
			if (_bullet_collided is LightCollidableBase) 
			{
				var light:LightCollidableBase;
				light = _bullet_collided as LightCollidableBase;
				light.parent.blink();
				FP.world.recycle(this);
				return;
			}
		}
		
		override public function render():void 
		{
			//Draw.rect(x, y-60, 20, 60, 0x00FF00);
			super.render();
		}
	}
}