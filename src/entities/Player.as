package entities 
{
	import brain.pathFinding.Node;
	import brain.sb.Vector2D;
	import flash.events.GameInputEvent;
	import flash.geom.Point;
	import lit.Light;
	import lit.Lighting;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import flash.display.BitmapData;
	import net.flashpunk.graphics.ParticleType;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.motion.LinearPath;
	import net.flashpunk.tweens.motion.QuadMotion;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.*;
	import net.flashpunk.utils.Draw;
	import utils.AntMath;
	import worlds.GameWorld;
	import utils.AntStatistic;
	import worlds.MenuWorld;
	import worlds.ShootWorld;
	
	public class Player extends Entity
	{
		//public static const COLLTYPE:String = "hero";
		
		private const MAXX			:Number = 200;
		private const MAXY			:Number = 200;
		private const GRAV			:Number = 1500;
		private const FLOAT			:Number = 2000;
		private const ACCEL			:Number = 2200;
		private const DRAG			:Number = 800;
		private const JUMP			:Number = -350;
		private const LEAP			:Number = 1.5;
			
		//public static var addmoney		:int = 0;
		//public static var addmagazine	:int = 0;
		//public static var addgrenades	:int = 0;
		//public static var addbattery	:int = 0;
		
		public var parentW:GameWorld;
		
		public var currentWeapon	:Ammo;
		public var currentGrenade	:Ammo;
		public var haveLevelKey		:Boolean;
		public var alive			:Boolean;
		public var currentFloor		:Number;
		public var torch			:Light;
		
		public var money			:uint;
		public var textMoney		:Text;
		
		public var batteries		:uint;
		public var textBatteries	:Text;
		
		public var grenades			:int;
		public var textGrenades		:Text;
		
		public var bulletsMagazin	:int;
		public var textMgznBullet	:Text;
		
		public var bullets			:int;
		public var textBullet		:Text;
		
		public var health			:Number;
		public var startHealth		:Number;
			
		private var _maxX			:Number;
		private var _onSolid		:Boolean;
		private var _onStairs		:Boolean;
		private var _onHole			:Boolean;
		private var _onFall			:Boolean;
		
		protected var _spdX			:Number;
		private var _spdY			:Number;
		private var _accel			:Number;
		private var _accelVertical	:Number;
		private var _faceDirection	:Number;	
		private var _linearStears	:LinearPath;
		
		protected var _sprPlayer	:Spritemap;
		protected var _fullHealth	:Image;
		protected var _emptyHealth	:Image;
		protected var _sprWeapon	:Spritemap;
		protected var _stringWeap	:String;
		protected var _shoottime	:int;
		protected var _recharging	:Boolean;
		protected var _changeWeapon	:Boolean;
		private var _thinktime		:Number;
		private var _handsAngle		:Number;
		
		private var _sfxGrenade:Sfx;
		public var sfxWalk:Sfx;
		private var speed:Number = 120;
		
		private var _alarmed:int;
		private var _currentHole:Hole;
		private var _onceViewHoleInfo:Boolean;
		private var _levNumTeach:int;
		public var teachWitch:int;
		public var teachCompl:String;
		
		private var teachLeft:Boolean;
		private var teachRight:Boolean;
		private var teachJump:Boolean;
		private var teachShot:Boolean;
		private var teachThrow:Boolean;
		private var teachLight:Boolean;
		private var teachStairs:Boolean;
		private var teachDoors:Boolean;
		
		
		public function Player(_x:int = 0, _y:int = 0, _layer:int = 0) 
		{
			super();
			x = _x;
			y = _y;
			layer = _layer;
			type = "hero";
			
			init();		
			addPlayerGraphics();
			
			var fontOptions:Object = {font:"orbitron bold", size: 16, color: 0xC0C0C0};
			textBullet = new Text		("0", 40, 10, fontOptions);
			textMgznBullet = new Text	("0", 40, 50, fontOptions );
			textMoney = new Text		("0", 110, 10, fontOptions );
			textBatteries = new Text	("0", 110, 50, fontOptions );
			textGrenades = new Text		("0", 170, 50, fontOptions );
			
		}
		
		protected function init():void 
		{
			alive = true;
			haveLevelKey = false;	
			
			currentWeapon = MenuWorld.ammoGoods[0];	
			_sprWeapon = currentWeapon.handAmmo;
			_stringWeap = "gun";
			// Define input keys.
			Input.define("R", Key.RIGHT, Key.D);
			Input.define("L", Key.LEFT, Key.A);
			Input.define("UP", Key.UP, Key.W);
			Input.define("DOWN", Key.DOWN, Key.S);
			//Input.define("JUMP", Key.SPACE);
			//Input.define("FIRE", Key.E);
			//Input.define("LIG", Key.L);
			//Input.define("THROW", Key.Q);
			Input.define("CHWEAP", Key.DIGIT_1, Key.DIGIT_2, Key.DIGIT_3);
			Input.define("MOVEMENT", Key.LEFT,Key.A, Key.RIGHT,Key.D, Key.UP,Key.W, Key.DOWN,Key.S);
			
			_thinktime = 0;
			_shoottime = 0;
			_handsAngle = 0;
			_recharging = false;
			_changeWeapon = false;
			
			_maxX = 200;
			_spdX = 0;
			_spdY = 0;
			_accel = 0;
			_accelVertical = 0;
			_faceDirection = 0;	
			_linearStears = new LinearPath();
			
			_onceViewHoleInfo = false;
			
			var torchImg:Image = new Image(Assets.TORCH);
				torchImg.originY = torchImg.height * 0.5;
			torch = new Light(x, y, torchImg, false, 1, 1, 0, false);
			
			
			_sfxGrenade = new Sfx(Assets.SFX_GRENADE,null,"soundShoot");
			sfxWalk = new Sfx(Assets.SFX_PLAYERWALK,null,"sound");
		}
		
		protected function addPlayerGraphics():void
		{
			_sprPlayer = new Spritemap(Assets.PLAYER, 142, 80, onAnimEnd);
			_sprPlayer.add("jumping",[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 11);
			_sprPlayer.add("move",[11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21], 11);
			_sprPlayer.add("throwGr",[22,23,24,25,26,27,28,29,30], 50);
			_sprPlayer.add("stand", [33],1);
			_sprPlayer.add("standback", [34],1);
			_sprPlayer.add("dead", [39,40,41,42], 4, false);
			
			_fullHealth = 	new Image(new BitmapData(_sprPlayer.width*0.2, 2, false, 0x00FF00));
			_emptyHealth = 	new Image(new BitmapData(_sprPlayer.width*0.2, 2, false, 0xFF0000));
			_emptyHealth.x = _fullHealth.x = _sprPlayer.x - _emptyHealth.width*0.5;
			_emptyHealth.y = _fullHealth.y = _sprPlayer.y - 10 - _sprPlayer.height*0.5;
			
			graphic = new Graphiclist(_sprPlayer, _emptyHealth, _fullHealth, _sprWeapon);
			
			_sprPlayer.scale = 1;
			_sprPlayer.centerOrigin();
			_sprPlayer.smooth = true;
			_sprWeapon.originY = _sprWeapon.height * .5;
			_sprWeapon.x = _sprPlayer.x-35;
			_sprWeapon.y = _sprPlayer.y-25;
			
			// Define the user's hitbox.
			setHitbox(40, _sprPlayer.height * 0.5);
			centerOrigin();
		}
		
		private function onAnimEnd():void 
		{
			switch (_sprPlayer.currentAnim) 
			{
				case "throwGr":
					grenades--;
					textGrenades.text = String(grenades);
					currentGrenade.x = x;
					currentGrenade.y = y;
					currentGrenade.img.visible = true;
					currentGrenade.grenadeIsActive = true;
					
					var flyHeight:Number = y - 200; 
					var flyByCurve:QuadMotion = new QuadMotion(grenadeEnd, ONESHOT);
						flyByCurve.object = currentGrenade;
						flyByCurve.setMotionSpeed(x, y, x, flyHeight, world.mouseX, y+halfHeight-5, 750);
					addTween(flyByCurve, true);
					_sfxGrenade.play();
					animPlay("stand", x > world.mouseX);
				break;	
				case "dead":
					setGameOver();
				break;
			}
		}
		
		override public function added():void 
		{
			if (type == "hero")
			{
				_sprPlayer.flipped = true;
				animPlay("stand", true);
				_sprWeapon.play(_stringWeap);
				
				if (parentW.levelN == 1 && V.hints)
				{
					_levNumTeach = 1;
					teachWitch = 1;
					teachCompl = "block";
					teachLeft = false;
					teachRight= false;
					teachJump= false;
					teachShot= false;
					teachThrow= false;
					teachLight= false;
				}
			}
		}
		
		private function teachWalking():void
		{
			var keyHint:Spritemap;
			
			switch (teachWitch) 
			{
				case 0:
					parentW.keyTipsA.visible = parentW.keyTipsB.visible = parentW.keyTipsC.visible =  parentW.keyTipsD.visible = false;
					parentW.hudInfoText.text = C.TEXTBASE[0];
				break;
				case 1:
					if (teachLeft) return;	
					teachLeft = true;
					parentW.keyTipsA.visible = parentW.keyTipsB.visible = parentW.keyTipsC.visible = false;
					keyHint = parentW.keyTipsA;
					keyHint.x = 400;
					keyHint.y = 400;
					keyHint.visible = true;
					keyHint.play("left");
					parentW.hudInfoText.text = C.TEXTBASE[1];
				break;
				case 2:
					if (teachRight) return;
					teachRight = true;
					parentW.keyTipsA.visible = parentW.keyTipsB.visible = parentW.keyTipsC.visible = false;
					keyHint = parentW.keyTipsA;
					keyHint.x = 400;
					keyHint.y = 400;
					keyHint.visible = true;
					keyHint.play("right");
					parentW.hudInfoText.text = C.TEXTBASE[1];
				break;
				case 3:
					if (teachJump) return;
					teachJump = true;
					parentW.keyTipsA.visible = parentW.keyTipsB.visible = parentW.keyTipsC.visible = false;
					keyHint = parentW.keyTipsB;
					keyHint.x = 400;
					keyHint.y = 400;
					keyHint.visible = true;
					keyHint.play("jump");
					parentW.hudInfoText.text = C.TEXTBASE[1];
				break;
				case 4:
					if (teachShot) return;
					teachShot = true;
					parentW.keyTipsA.visible = parentW.keyTipsB.visible = parentW.keyTipsC.visible = false;
					keyHint = parentW.keyTipsA;
					keyHint.x = 400;
					keyHint.y = 400;
					keyHint.visible = true;
					keyHint.play("shoot");
					parentW.hudInfoText.text = C.TEXTBASE[2];
				break;
				case 5:
					if (teachThrow) return;
					teachThrow = true;
					parentW.keyTipsA.visible = parentW.keyTipsB.visible = parentW.keyTipsC.visible = false;
					keyHint = parentW.keyTipsA;
					keyHint.x = 400;
					keyHint.y = 400;
					keyHint.visible = true;
					keyHint.play("throw");		
					parentW.hudInfoText.text = C.TEXTBASE[4];
				break;
				case 6:
					if (teachLight) return;
					teachLight = true;
					parentW.keyTipsA.visible = parentW.keyTipsB.visible = parentW.keyTipsC.visible = false;
					keyHint = parentW.keyTipsA;
					keyHint.x = 400;
					keyHint.y = 400;
					keyHint.visible = true;
					keyHint.play("light");
					teachCompl = "";
					parentW.hudInfoText.text = C.TEXTBASE[5];
				break;
				case 7:
					if (_onStairs)
					{
						keyHint = parentW.keyTipsC;
						keyHint.x = 10;
						keyHint.y = 480;
						//trace(y);
						if (y<=560 && y>=420)
						{
							keyHint.visible = true;
							keyHint.play("stairUP");
							parentW.hudInfoText.text = C.TEXTBASE[7];
						}
						else
						{
							keyHint.visible = true;
							keyHint.play("stairDOWN");
							parentW.hudInfoText.text = C.TEXTBASE[1];
						}
					}
					else
					{
						parentW.hudInfoText.text = C.TEXTBASE[0];
						parentW.keyTipsC.visible = false;
						
					}
				break;
				case 8:
					if (teachDoors) return;
					teachDoors = true;
					parentW.keyTipsA.visible = parentW.keyTipsB.visible = parentW.keyTipsC.visible = false;	
					keyHint = parentW.keyTipsD;
					keyHint.x = 0;
					keyHint.y = -50;
					keyHint.visible = true;
					keyHint.play("up");
				break;
			}
			
			
		}
			
		override public function update():void 
		{
			if (alive == false) return;
			if (Input.mouseY < 85) 
			{
				if (Input.mouseReleased && Input.mouseFlashX >= 460 && V.hints) 
				{
					parentW.hudInfoText.text = C.TEXTBASE[V.textViewNumb];
					V.textViewNumb == C.TEXTBASE.length - 1 ? V.textViewNumb = 0:V.textViewNumb++;
				}
				
				return;
			}
			//--------------------------------slow when enemy collide
			collide("enemy", x, y) 		? _maxX = MAXX * 0.4 	: _maxX = MAXX;
			collide("solid", x, y + 1)	? _onSolid = true		: _onSolid = false;
			collide("step", x, y)		? _onStairs = true		: _onStairs = false;
			collide("hole", x, y)		? _onHole = true		: _onHole = false;
				
			if (_onHole && _onceViewHoleInfo == false)
			{
				_currentHole = collide("hole", x, y) as Hole;
				_onceViewHoleInfo = true;
				FP.alarm(5, _currentHole.hideText, 2);
				if (V.hints) _currentHole.holeText.visible = true;
			}
				
			_handsAngle = FP.angle(x, y-30, world.mouseX, world.mouseY);
				
			gravity();
			acceleration();
			jumping();
			animation();
			shotting();
			grenadeUpd();
			torchupdate();
			
			moveBy(_spdX * FP.elapsed, _spdY * FP.elapsed, ["solid", teachCompl]);
		
			_thinktime++;
			if (_thinktime > 0) 
			{
				_thinktime = -60;
				currentFloor = Math.floor(this.y / 200);
				
				if (_levNumTeach==1) 	teachWalking();
				
				//checkBonus();
				//textGrenades.text = String(grenades);
				//textMoney.text = String(money);
				//textBatteries.text = String(batteries);
				_fullHealth.scaleX = health / startHealth;
			}
			
			if (Input.pressed("MOVEMENT")) sfxWalk.loop(0.2);
			if (Input.released("MOVEMENT")) sfxWalk.stop();
			
		}
	
		public function collected(num:int):void
		{
			//trace("collected", num);
			switch (num) 
			{
				case 0:
					if (currentWeapon) 
					{
						bulletsMagazin++;
						textMgznBullet.text = String(bulletsMagazin);
					}
				break;
				case 1:
					money+=5;
					textMoney.text = String(money);
				break;
				case 2:
					batteries++;
					textBatteries.text = String(batteries);
				break;
				case 3:
					grenades++;
					textGrenades.text = String(grenades);
				break;
			}
		}
		
		public function hurtPlayer(oncedamage:Number=0):void
		{
			if (_onSolid == false) oncedamage *= 0.5;
			health -= oncedamage;
			if(_fullHealth)_fullHealth.scaleX = health / startHealth;
			if (health <= 0)
			{
				torch.active = false;
				collidable = false;
				alive = false;
				if (type == "hero")
				{
					_sprWeapon.visible = false;
					animPlay("dead", x>world.mouseX);
				}
			}
		}
		
		private function grenadeUpd():void 
		{
			if (currentGrenade == null || _onStairs) 
			{
				//trace("currentGrenade == null || _onStairs");
				return;
			}
			if (Input.check(Key.Q) == false) 
			{
				//trace("Input.check(THROW) == false");
				return;
			}
			if (grenades <= 0) 
			{
				//trace("grenades <= 0");
				return;
			}
			if (currentGrenade.grenadeIsActive) 
			{
				//trace("currentGrenade.grenadeIsActive");
				return;
			}
			
			animPlay("throwGr", x > world.mouseX);
			_sprWeapon.visible = false;
			if (teachWitch == 5)
			{
				teachWitch = 6;
			}
		}
		
		private function grenadeEnd():void
		{
			//if (currentGrenade == null) return;
			currentGrenade.img.visible = false;
			currentGrenade.explosion.visible = true;
			currentGrenade.explosion.play("explode", true);
			currentGrenade.collidable = true;
			//shake screen
			_firstShake = 10;
			_secondShake = 15;
			FP.screen.y += AntMath.randomRangeInt(20, 30);
			FP.alarm(0.05, screenShake, ONESHOT);
			//damage enemies
			var meatArr:Array = [];
			world.collideRectInto("enemy", currentGrenade.x -50, currentGrenade.y - 25, 100, 50, meatArr);
			AntStatistic.track("killsGrenade", meatArr.length-1);
			for each (var e:Enemy in meatArr) e.hurt(100);
			//damage doors
			var brokeDoor:Door = world.collideRect("standart", currentGrenade.x -50, currentGrenade.y - 25, 100, 50) as Door;
			if (brokeDoor) 
			{
				brokeDoor.makeOpen(haveLevelKey);
			} 
		}
		
		
		protected var  _firstShake:int;
		protected var  _secondShake:int;
		
		protected function screenShake():void
		{
			FP.screen.y -= AntMath.randomRangeInt(_firstShake, _secondShake);
			AntMath.randomRangeInt(1, 2) == 1 ? 
					FP.screen.x += 0.9 * AntMath.randomRangeInt(_firstShake, _secondShake): 
					FP.screen.x -= 0.7 * AntMath.randomRangeInt(_firstShake, _secondShake);
			FP.alarm(0.1, screenDefault, ONESHOT);
		}
		
		private function screenDefault():void
		{
			FP.screen.x = 0;
			FP.screen.y = 0;
			_firstShake = currentWeapon.shakeStrength;
			_secondShake = _firstShake+2;
		}
		
		protected function shotting():void
		{
			if (_recharging || _spdX != 0) return;
			
			if (Input.mousePressed == false)
			{
				_shoottime++;
				if (_shoottime <= 0) return;
			}
			
			if (bullets > 0)
			{
				if (Input.mouseDown || Input.check(Key.E))
				{
					bullets--;
					_shoottime = currentWeapon.weaponShotDelay;
					fire();
				}
			}
			else if (bulletsMagazin > 0)
			{
				bulletsMagazin--;
				currentWeapon.bulletsMagazinesQnt = bulletsMagazin;
				bullets = currentWeapon.bulletsQnt;
				_recharging = true;
				FP.alarm(currentWeapon.reloading(), switchRecharg);
			}
			else if (money < C.PRICE_MAGAZINE) 
			{
				var next:Ammo = FP.next(currentWeapon, MenuWorld.ammoGoods);
				var previous:Ammo = FP.prev(currentWeapon, MenuWorld.ammoGoods);
				
				if (next.isBought && next.bulletsLeftQnt>0)
				{
					currentWeapon.bulletsLeftQnt = bullets;
					currentWeapon.bulletsMagazinesQnt = bulletsMagazin;
					currentWeapon = next;
					bullets = currentWeapon.bulletsLeftQnt;
					bulletsMagazin = currentWeapon.bulletsMagazinesQnt;
					_stringWeap = currentWeapon.stringWeaponForPlayer;
				}
				else if (previous.isBought && previous.bulletsLeftQnt>0)
				{
					currentWeapon.bulletsLeftQnt = bullets;
					currentWeapon.bulletsMagazinesQnt = bulletsMagazin;
					currentWeapon = previous;
					bullets = currentWeapon.bulletsLeftQnt;
					bulletsMagazin = currentWeapon.bulletsMagazinesQnt;
					_stringWeap = currentWeapon.stringWeaponForPlayer;
				}
				else
				{
					alive = false;
					setGameOver();
				}
			}
			
			if (Input.check("CHWEAP"))  
			{
				currentWeapon.bulletsLeftQnt = bullets;
				currentWeapon.bulletsMagazinesQnt = bulletsMagazin;
				
				switch (Input.lastKey) 
				{
					case Key.DIGIT_1:
						currentWeapon = MenuWorld.ammoGoods[0];
					break;
					case Key.DIGIT_2:
						if (MenuWorld.ammoGoods[1].isBought)
						{	
							currentWeapon = MenuWorld.ammoGoods[1];
						}
					break;
					case Key.DIGIT_3:
						if (MenuWorld.ammoGoods[2].isBought) 
						{
							currentWeapon = MenuWorld.ammoGoods[2];
						}
					break;
				}
				_stringWeap = currentWeapon.stringWeaponForPlayer;
				// change recharging
				bullets = currentWeapon.bulletsLeftQnt;
				bulletsMagazin = currentWeapon.bulletsMagazinesQnt;
			}
			textBullet.text = String(bullets);
			textMgznBullet.text = String(bulletsMagazin);
			
		}
		
		private function switchRecharg():void 
		{
			_recharging = false;
		}
		
		protected function fire():void
		{
			_sprWeapon.play(_stringWeap + "Shoot");
			var bullet:Bullet = parentW.create(Bullet, false) as Bullet;
				bullet.bulletVariety = currentWeapon.ammoVariety;
				bullet.isShootWorld = false;
				bullet.bulletAngle = _handsAngle;
				bullet.bulletFly(new Point(x, y - 30), new Point(world.mouseX, world.mouseY));
				bullet.visible = true;
			world.add(bullet);
			if(teachWitch ==4)teachWitch = 5;	
				//world.add(new Bullet(new Point(x, y-30), new Point(world.mouseX, world.mouseY), _handsAngle, ));
		}
		
		protected function setGameOver():void
		{
			if (type == "hero")
			{
				parentW.parentWorld.setScreenUI(10);
				FP.world = parentW.parentWorld;
			}
		}
		
		
		protected function torchupdate():void 
		{
			if (torch.active) 
			{
				torch.y = y - halfHeight;
				torch.x = x;
				
				if (_spdX == 0) 
				{
					torch.image.angle = _handsAngle; 
				}
				else
				{
					_spdX > 0 ? torch.image.angle = 335: torch.image.angle = 210; 	
				}
			}
			else
			{
				if (Input.check(Key.L) && batteries > 0) 
				{
					if(teachWitch == 6) teachWitch = 0;
					batteries--;
					textBatteries.text = String(batteries);
					torch.alpha = 1;
					torch.active = true;
					if(FP.world is GameWorld) FP.alarm(AntMath.randomRangeInt(5,15), torch.badBattery as Function);
				}
				else if (FP.world is ShootWorld) 
				{
					torch.alpha = 1;
					torch.active = true;
				}
			}
		}
		
		private function animation():void 
		{
			if (_sprPlayer.currentAnim == "throwGr") return;
			if (_spdX != 0 && (_onSolid||_onStairs || _onHole)) 
			{
				animPlay("move", _spdX < 0);
				_sprWeapon.visible = false;
				return;
			}
			else if(!_onSolid && !_onStairs && !_onHole)
			{
				animPlay("jumping", _spdX<0);
				_sprWeapon.visible = false;
				return;
			}
			
			if (_handsAngle >= 45 && _handsAngle < 135) 
			{
				animPlay("standback");
				_sprWeapon.visible = false;
			}
			
			if (_handsAngle >= 135 && _handsAngle <= 270)
			{
				animPlay("stand", true);
				_sprWeapon.x = _sprPlayer.x;
				_sprWeapon.visible = true;
			}
			
			if ((_handsAngle > 270 && _handsAngle <= 360) || (_handsAngle >= 0 && _handsAngle < 45)) 
			{
				animPlay("stand");
				_sprWeapon.x = _sprPlayer.x;
				_sprWeapon.visible = true;
			}
			
			if (_recharging)_sprPlayer.flipped ? _sprWeapon.angle = 90 : _sprWeapon.angle = 270; 
			
		}
		
		private function animPlay(doing:String="", flips:Boolean = false):void
		{
			_sprPlayer.flipped = flips;
			_sprWeapon.flipped = flips;
			if (flips) 
			{
				_sprWeapon.angle = _handsAngle+180;
				_sprWeapon.originX = _sprWeapon.width;
			}
			else
			{
				_sprWeapon.angle = _handsAngle;
				_sprWeapon.originX = 0;
			}
			_sprPlayer.play(doing);
			_sprWeapon.play(_stringWeap);
			//trace(doing, side, ammo, flips);
		}
		
		override public function render():void 
		{
			//Draw.line(x+_sprWeapon.x, y+_sprWeapon.y, world.mouseX, world.mouseY, 0xFF0000);
			super.render();
		}
		
		private function jumping():void 
		{
			if ((_onSolid || _onHole) && !_onStairs && Input.pressed(Key.SPACE))
			{
				_spdY = JUMP;
				_onSolid = false;
				_spdX *= LEAP;
				if(teachWitch ==3)teachWitch = 4;
			}
		}
		
		private function gravity():void 
		{
			if (_onSolid)_spdY = 0;
			
			if (_onHole )//|| _onFall) 
			{
				//if(Input.pressed("DOWN") || _onFall)
				//{
					_onSolid ? _onFall = false: _onFall = true;
					_spdY = MAXY;
				//}
				//else _spdY = 0;
				return;
			}
			if (!_onStairs)
			{
				var g:Number = GRAV;
				if (_spdY < 0 && !Input.check(Key.SPACE)) g += FLOAT;
				_spdY += g * FP.elapsed;
				if (_spdY > MAXY) _spdY = MAXY;
			}
		}
			
		/** Accelerates the player based on input. */
		private function acceleration():void
		{
			// evaluate input
			_accel = 0;
			if (Input.check("R")) 	
			{
				_accel += ACCEL;
				if (teachWitch == 2)teachWitch = 3;
			}
			if (Input.check("L")) 	
			{
				_accel -= ACCEL;
				if (teachWitch == 1)teachWitch = 2;				
			}
			
			// handle acceleration
			if (_accel != 0)
			{
				if (_accel > 0)
				{
					// accelerate right
					if (_spdX < _maxX)
					{
						_spdX += _accel * FP.elapsed;
						if (_spdX > _maxX) _spdX = _maxX;
					}
					else _accel = 0;
				}
				else
				{
					// accelerate left
					if (_spdX > -_maxX)
					{
						_spdX += _accel * FP.elapsed;
						if (_spdX < -_maxX) _spdX = -_maxX;
					}
					else _accel = 0;
				}
			}
			
			// handle decelleration
			if (_accel == 0)
			{
				if (_spdX > 0)
				{
					_spdX -= DRAG * FP.elapsed;
					if (_spdX < 0) _spdX = 0;
				}
				else
				{
					_spdX += DRAG * FP.elapsed;
					if (_spdX > 0) _spdX = 0;
				}
			}
			
			
			if (!_onStairs) return;
				teachWitch = 7;
			_accelVertical = 0;
			if (Input.check("UP"))		
			{
				_accelVertical -= ACCEL * 0.5;
			}
			if (Input.check("DOWN"))	
			{
				_accelVertical += ACCEL * 0.5;
			}
			
			// handle acceleration vertical MY
			if (_accelVertical != 0)
			{
				if (_accelVertical > 0)
				{
					// accelerate up
					if (_spdY < MAXY)
					{
						_spdY += _accelVertical * FP.elapsed;
						if (_spdY > MAXY) _spdY = MAXY;
					}
					else _accelVertical = 0;
				}
				else
				{
					// accelerate down
					if (_spdY > -MAXY)
					{
						_spdY += _accelVertical * FP.elapsed;
						if (_spdY < -MAXY) _spdY = -MAXY;
					}
					else _accelVertical = 0;
				}
			}
			
			// handle decelleration MY
			if (_accelVertical == 0)
			{
				if (_spdY > 0)
				{
					_spdY -= DRAG * FP.elapsed;
					if (_spdY < 0) _spdY = 0;
				}
				else
				{
					_spdY += DRAG * FP.elapsed;
					if (_spdY > 0) _spdY = 0;
				}
			}
		}
	
	}
}
