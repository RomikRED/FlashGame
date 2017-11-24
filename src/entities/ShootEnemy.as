package entities
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.masks.Masklist;
	import net.flashpunk.masks.Pixelmask;
	//import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.tweens.misc.VarTween;
	//import net.flashpunk.tweens.motion.LinearMotion;
	//import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Draw;
	import worlds.GameWorld;
	//import brain.pathFinding.*;
	//import brain.sb.*;
	import net.flashpunk.utils.Input;
	import utils.AntMath;
	import worlds.ShootWorld;
	import utils.AntStatistic;
	
	
	public class ShootEnemy extends Entity
	{
		//public static const COLL_SHOOT:String = "shenemy";
		//public static var playerIsDie:Boolean = false;
		public var emitter		:Emitter;
		public var aliveShootEnemy		:Boolean;
		public var scaleEnemy	:Number;
		
		private var _parentWorld:ShootWorld;
		private var _spawnData	:Object;
		private var _damage		:Number;
		private var _motion		:VarTween;
		private var _health		:Number;
		private var _alarmFuncNo:int;
		
		private var _startHealth:Number;
		private var _sprEnemy	:Spritemap;
		private var _fullHealth	:Image;
		private var _emptyHealth:Image;
		//private var _counter	:int;
		private var _counterHeadshots:int;
		
		private var _speed			:int;
		private var _maskBuffer		:BitmapData;
		private var _matrixHitbox	:Matrix;
		private var _scaleTo		:Number;
		private var _scaledLayer	:int;
		private var _txtHeadShot	:Text;
		
		private var _enemyColor:uint;
		private var _blood:Spritemap;
		private var _counterEmitter:int;
			
		public var sfxatt:Sfx;
		public var sfxpurs:Sfx;
		public var sfxdie:Sfx;
		
		public function ShootEnemy(spawnData:Object, variety:int, parent:ShootWorld)
		{
			type = "shenemy";
			x = spawnData.spawnX; 
			y = spawnData.spawnY; 
			scaleEnemy = 1;
			aliveShootEnemy = true;
			layer = 1;
			
			_spawnData = spawnData;
			_spawnData.slotfree = false;
			_parentWorld = parent;
			_scaleTo = 2;
			_speed = 15;
			_counterHeadshots = 0;
				
			addHeroGraphics(variety);	
			//x -= 300;
			//y -= 340;
			
			_maskBuffer = new BitmapData(_sprEnemy.width*_scaleTo, _sprEnemy.height*_scaleTo);
			_matrixHitbox = FP.matrix.clone();
			mask = new Pixelmask(_maskBuffer);
				
			//_txtHeadShot.x = _emptyHealth.x = _fullHealth.x = halfWidth*.5 - _emptyHealth.width * .5;
			//_txtHeadShot.y = _emptyHealth.y = _fullHealth.y = y - halfHeight - 60;
			
			super(x, y, graphic);
		}
		
		override public function added():void 
		{
			_sprEnemy.play("walk");// , false, AntMath.randomRangeInt(0, 7));
			_fullHealth.visible = _emptyHealth.visible = false;
			_txtHeadShot.visible = false;
			emitter = (FP.world.classFirst(Particles) as Particles).emitter;
		}
		
		public function addHeroGraphics(variety:int):void
		{
			var fr:uint = 5;
			_sprEnemy = new Spritemap(Assets.ZOMB, 252, 362, onAnimEnd);
			_sprEnemy.smooth = true;	
			switch (variety)
			{
			case 1: 
				_sprEnemy.add("attack", [13,14,15,16,17], fr);
				_sprEnemy.add("walk", [0,1,2,3,4,5,6,7,8,9,10,11,12], fr);
				_sprEnemy.add("die", [18,19,20,21,22], 30, false);
				_enemyColor = 0xFF8080;
				_damage = 1;
				_health = _startHealth = 20;
				sfxpurs = new Sfx(Assets.SFX_ZOMBPursuit1, null, "sound");
				sfxatt = new Sfx(Assets.SFX_ZOMBATTACK1, null, "sound");
				sfxdie = new Sfx(Assets.SFX_ZOMBDEAD1, null, "sound");
				break;
			case 2: 
				_sprEnemy.add("attack", [39,40,41,42,43], fr);
				_sprEnemy.add("walk", [26,27,28,29,30,31,32,33,34,35,36,37,38], fr);
				_sprEnemy.add("die", [44,45,46,47,48], 30,false);
				_enemyColor = 0x80FFFF;
				_damage = 2;
				_health = _startHealth = 25;
				sfxpurs = new Sfx(Assets.SFX_ZOMBPursuit2, null, "sound");
				sfxatt = new Sfx(Assets.SFX_ZOMBATTACK2, null, "sound");
				sfxdie = new Sfx(Assets.SFX_ZOMBDEAD2, null, "sound");
				break;
			case 3: 
				_sprEnemy.add("attack", [65,66,67,68,69], fr);
				_sprEnemy.add("walk", [52,53,54,55,56,57,58,59,60,61,62,63,64], fr+3);
				_sprEnemy.add("die", [70,71,72,73,74], 30,false);
				_enemyColor = 0xFFFF80;
				_damage = 3;
				_health = _startHealth = 30;
				sfxpurs = new Sfx(Assets.SFX_ZOMBPursuit3, null, "sound");
				sfxatt = new Sfx(Assets.SFX_ZOMBATTACK3, null, "sound");
				sfxdie = new Sfx(Assets.SFX_ZOMBDEAD3, null, "sound");
				break;
			}
			_sprEnemy.color = _enemyColor;
			_txtHeadShot = new Text("HEAD shot!", 0, 0, { font:"orbitron light", size: 12, color: 0xD4D4D4});
			_fullHealth = new Image(new BitmapData(60, 3, false, 0x00FF00));
			_emptyHealth = new Image(new BitmapData(60, 3, false, 0xFF0000));
			
			graphic = new Graphiclist(_sprEnemy, _emptyHealth, _fullHealth, _txtHeadShot);
		}
		
		private function onAnimEnd():void 
		{
			switch (_sprEnemy.currentAnim) 
			{
				case "die":
					_spawnData.slotfree = true;
					_alarmFuncNo = 1;
					FP.alarm(1, alarmedFunc);
				break;
				case "attack":
					_parentWorld.playerS.hurtPlayer(_damage);
					if (_parentWorld.playerS.alive == false)
					{
						sfxatt.stop();
					}
				break;
			}
			//_blood.visible = false;
		}
		
		/**
		 * _alarmed 0 - play Attack
		 * _alarmed 1 - remove from world
		 * _alarmed 2 - heath visible false
		 */
		private function alarmedFunc():void
		{
			switch (_alarmFuncNo) 
			{
				case 0:
					_sprEnemy.play("attack");
					sfxpurs.stop();
					sfxatt.loop();
				break;
				case 1:
					FP.world.remove(this);
				break;
				case 2:
					_txtHeadShot.visible = _fullHealth.visible = _emptyHealth.visible = false;
					//_sprEnemy.color = _enemyColor;
				break;
			 
				_alarmFuncNo = 0;
			}
			//trace("_alarmFuncNo",_alarmFuncNo);
		}
		
		public function hurt(damage:Number, emitX:Number, emitY:Number):void
		{
			if (aliveShootEnemy == false) return;
			
			_txtHeadShot.x = _emptyHealth.x = _fullHealth.x = emitX-x;
			_txtHeadShot.y = _emptyHealth.y = _fullHealth.y = emitY-y-150;
			
			//_sprEnemy.color = 0xFF0000;
			//trace(_emptyHealth.x, _emptyHealth.y, x, y, world.mouseX,world.mouseY, emitX,emitY);
			
			if (emitY < top + height * 0.12 * scaleEnemy) 
			{
				damage *= 3;
				_txtHeadShot.visible = true;
				_counterHeadshots++;
			}
			
			_health -= damage;
			_fullHealth.visible = _emptyHealth.visible = true;
			_alarmFuncNo = 2;
			FP.alarm(0.3, alarmedFunc);
			_fullHealth.scaleX = _health / _startHealth;
			
			_counterEmitter = 5;//AntMath.randomRangeInt(5,10);
			while (_counterEmitter>0) 
			{
				emitter.emit("blood", emitX, emitY);
				_counterEmitter--;
			}
				
			if (_health <= 0)
			{
				collidable = false;
				aliveShootEnemy = false;
				
				_motion.cancel();
				_emptyHealth.visible = false;
				_fullHealth.visible = false;
				_sprEnemy.play("die");
				
				sfxatt.stop();
				sfxpurs.stop();
				sfxdie.play();
				_parentWorld.counterHeadShot = _counterHeadshots;
				
				
				var collecting:CollectThing, collectType:int;
				switch (AntMath.randomRangeInt(0, 10)) 
				{
					case 0: collectType = 0;/*CollectThing.MAGAZINE;*/ 	break;
					case 3: collectType = 2;/*CollectThing.BATTERIES;*/	break;
					case 6: collectType = 0;/*CollectThing.MAGAZINE;*/	break;
					default: collectType = 1;// CollectThing.MONEY;
				}
				
				var player:PlayerShoot = _parentWorld.playerS;
				
				if (collectType == 2 && player.batteries >= 8 ) 
				{
					collectType = 1;
				}
				if (player.money < C.PRICE_MAGAZINE && player.bulletsMagazin == 0)
				{
					collectType = 0;// CollectThing.MAGAZINE;
				}
				
				
				collecting = new CollectThing(x + _sprEnemy.scaledWidth * .5, y + _sprEnemy.scaledHeight * .5, collectType);
				_parentWorld.add(collecting);
				_parentWorld.deadEnemy++;
			}
			
		}
		
		//internal var randomColour:uint = Math.random() * 0xFFFFFF;
		override public function render():void
		{
			setPixelmaskMatrix();
			_maskBuffer.fillRect(_maskBuffer.rect, 0);
			_maskBuffer.draw(_sprEnemy.getBuffer().clone(), _matrixHitbox);
			
			super.render();
		}
		
		private function setPixelmaskMatrix():void
		{
			// render with transformation
			_matrixHitbox.identity();
			_matrixHitbox.scale( _sprEnemy.scale, _sprEnemy.scale);
			_matrixHitbox.tx = -_sprEnemy.originX * _matrixHitbox.a;
			_matrixHitbox.ty = -_sprEnemy.originY * _matrixHitbox.d;
		}
		
		
		override public function update():void
		{
			if (aliveShootEnemy == false) 
			{
				return;
			}
				
			if (_motion)
			{
				layer = 20 - int((scaleEnemy - 1) * 10);
				_sprEnemy.scale = scaleEnemy;
			}
			else if (scaleEnemy < 2)
			{
				setMotion();
			}
		
			
			super.update();
		}
		
		private function setMotion():void
		{
			_motion = new VarTween(alarmedFunc, ONESHOT);
			_motion.tween(this, "scaleEnemy", _scaleTo, _speed);
			addTween(_motion, true);
			sfxpurs.loop();
		}
		
	}
}