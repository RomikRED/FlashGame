package worlds 
{
	import entities.Ammo;
	import entities.Button;
	import entities.PlayerShoot;
	import entities.ShootEnemy;
	import flash.display.Graphics;
	//import flash.display.Sprite;
	import flash.geom.Rectangle;
	//import flash.system.ImageDecodingPolicy;
	import lit.Lighting;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	//import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	//import net.flashpunk.masks.Grid;
	import net.flashpunk.utils.Draw;
	import entities.Bullet;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	//import net.flashpunk.graphics.Anim;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import entities.Particles;
	import utils.AntMath;
	import flash.ui.Mouse;
	import entities.Player;
	import entities.HUD;
	import lit.Light;
	import flash.display.BitmapData;
	import net.flashpunk.Sfx;
	import utils.AntStatistic;
	
	/**
	 * ...
	 * @author 
	 */
	public class ShootWorld extends World 
	{
		public var shadowShot	:Light;
		public var wait			:Boolean;
		public var playerS		:PlayerShoot;
		public var parentGWorld		:GameWorld;
		public var enemiesSW	:Array;
		public var counterHeadShot:int;
		
		private var _roomData	:Room;
		
		private var _spawnShootEnemy	:int;
		//private var _enemies			:Vector.<ShootEnemy>;
		private var _targetView			:Point;
		
		private var _coefX			:Number;
		private var _coefY			:Number;
		private var _clampX			:Number;
		private var _clampY			:Number;
		private var _shadowLight	:Lighting;
		private var _hudSW			:HUD;
		private var _enemyQuant		:int;
		private var _enemyStartQuant:int;
		public var deadEnemy		:int; 
		
		private var _hudBtnMagazinS	:Button;
		private var _hudBtnBatteryS	:Button;
		private var _blackBack		:Image;
		private var _wallBack		:Image;
		private var _waweEmpty:Image;
		private var _waweFull:Image;
		private var _sfxBack:Sfx;
		private var _spawnRand1:int;
		private var _spawnRand2:int;
			
		public function ShootWorld(parent:GameWorld) 
		{
			parentGWorld = parent;
			var index:int = AntMath.randomRangeInt(0, 9);
			
			_roomData = MenuWorld.roomslist[index];
			_blackBack = new Image(new BitmapData(1920, 1080, false, 0x000000));
			_wallBack = new Image(Assets.ROOM_BACK, new Rectangle(1920 * index, 0, 1920, 1080));
			
			playerS = new PlayerShoot(FP.halfWidth, FP.height,0);
			playerS.parentsWorld = this;
			
			var torchLightS:Image = new Image(Assets.TORCHROOM);
				torchLightS.originY = torchLightS.height * .5;
			playerS.torch = new Light(playerS.x, playerS.y, torchLightS, false, 1, 1, 0, false);	
			playerS.torchLightWidth = torchLightS.width * .5; 
				
			_shadowLight = new Lighting(FP.screen.width, FP.screen.height, 0xFFFFFF, playerS.layer - 1);
			shadowShot = new Light(0, 0, torchLightS, false, 2.5, 0.35, 0, false);
			_shadowLight.add(shadowShot);
			_shadowLight.add(new Light(0, 0, new Image(new BitmapData(1920, 1080, false, 0x000000)), false, 1, C.DARKNESS_ROOM));
			_shadowLight.add(playerS.torch);
			
			_spawnShootEnemy = -60;
			
			
			_spawnRand1 = C.SHOOTENDELAY[V.currentLevel - 1];
			_spawnRand2 = _spawnRand1 * 1.3; 
			_enemyQuant = C.ROOMENEMIES[V.currentLevel-1];
			_enemyStartQuant = C.ROOMENEMIES[V.currentLevel-1];
			
			_coefX = 1920/ C.GAME_WIDTH;
			_coefY = 1080/ C.GAME_HEIGHT;
			
			_clampX = 1920- C.GAME_WIDTH;
			_clampY = 1080- C.GAME_HEIGHT-100;
			
			_sfxBack = new Sfx(Assets.SFX_GAME, null, "sound");
			_hudSW = new HUD(0, 0, playerS.layer - 2);
			
			var hearth:Image = new Image(Assets.HEARTH);
				hearth.x = 125;
				hearth.y = 30,
			
			_waweEmpty = 	new Image(new BitmapData(300, 20, false, 0xFFFFFF));
			_waweFull = 	new Image(new BitmapData(296, 16, false, 0x800000));
			
			_waweEmpty.x = 300;
			_waweFull.x = 302;
			_waweEmpty.y = 40;
			_waweFull.y = 42;
				
			_hudSW.addGraphic(new Graphiclist(new Image(Assets.HUDBAR),
				playerS.textMgznBullet, playerS.textBullet, 
				playerS.textBatteries, playerS.textMoney,
				hearth, playerS.playerDamage, _waweEmpty,_waweFull));
			
			_hudBtnMagazinS = new Button(onAddAmmo, 1, 0, 0);
			_hudBtnMagazinS.setSpritemap(Assets.HUDMAG, 46, 52,[]);
			_hudBtnMagazinS.layer = _hudSW.layer - 1;
			_hudBtnMagazinS.setLabel("buy\n"+String(C.PRICE_MAGAZINE)+"$",true,10,true);
					
			_hudBtnBatteryS = new Button(onAddAmmo, 2, 0, 0);
			_hudBtnBatteryS.setSpritemap(Assets.HUDMAG, 46, 52,[[3],[4],[5]]);
			_hudBtnBatteryS.layer = _hudSW.layer - 1;
			_hudBtnBatteryS.setLabel("buy\n"+String(C.PRICE_BATTERY)+"$", true,10,true);		
				
			_targetView = new Point(FP.screen.width * .5, FP.screen.height * .5);
			super();
		}
		

		
		override public function begin():void 
		{
			if (playerS.currentWeapon == null) 
			{
				playerS.currentWeapon = parentGWorld.playerG.currentWeapon;;
				add(playerS.currentWeapon);
			}
			
				
			switch (playerS.currentWeapon.stringWeaponForPlayer) 
			{
				case "gun":
					playerS.bulletsMagazin = 	V.playerMagazins1;
					playerS.bullets = 			V.playerBullets1;
				break;
				case "Mk":
					playerS.bulletsMagazin = 	V.playerMagazins2;
					playerS.bullets = 			V.playerBullets2;
				break;
				case "Ak":
					playerS.bulletsMagazin = 	V.playerMagazins3;
					playerS.bullets = 			V.playerBullets3;
				break;
			}
			
			
			playerS.health = 			V.playerHealth;
			playerS.batteries =			V.playerBatteries;
			playerS.startHealth = 		V.playerBaseHealth;
			playerS.money = 			V.playerMoney;
			
			deadEnemy = 0;
			counterHeadShot = 0;
			
			
			for each (var obj:Object in _roomData.spawnPoints) 
			{
				obj.slotfree = true;
			}
			
			Sfx.setVolume("sound", V.soundsVolume);
			Sfx.setVolume("soundShoot", V.soundsVolume * 0.5);
			_sfxBack.loop(V.soundsVolume);
			wait = false;
			
			//ADD---ENTYTIES
			add(_shadowLight);
			addGraphic(_blackBack, 1082);
			addGraphic(_wallBack, 1081);
			
			add(playerS);
			addList(_hudSW, _hudBtnMagazinS,_hudBtnBatteryS);
			enemiesSW = [];
			Mouse.hide();
			FP.screen.angle = 0;
			add(new Particles);
			super.begin();
		}
		
		override public function end():void 
		{
			if (playerS.alive)
			{
				switch (playerS.currentWeapon.stringWeaponForPlayer) 
				{
					case "gun":
						V.playerMagazins1 = playerS.bulletsMagazin;
						V.playerBullets1 = playerS.bullets;
					break;
					case "Mk":
						V.playerMagazins2 = playerS.bulletsMagazin;
						V.playerBullets2 = playerS.bullets;
					break;
					case "Ak":
						V.playerMagazins3 = playerS.bulletsMagazin;
						V.playerBullets3 = playerS.bullets;
					break;
				}
				
				V.playerBatteries = playerS.batteries;
				V.playerHealth = 	playerS.health;
				V.playerMoney = 	playerS.money;
				AntStatistic.track("headshot", counterHeadShot);
			}
		
				
			//trace("ShootWorld end");
		_sfxBack.stop();
		for each (var e:ShootEnemy in enemiesSW) 
		{
			if (e && e.aliveShootEnemy) 
			{
				e.sfxatt.stop();
				e.sfxdie.stop();
				e.sfxpurs.stop();
			}
		}
			
		//deadEnemy		= null; 
		shadowShot 		= null;
		playerS			= null;
		parentGWorld	= null;
		
		_roomData		= null;
		//_spawnShootEnemy= null;
		_targetView		= null;
		//_coefX			= null;
		//_coefY			= null;
		//_clampX			= null;
		//_clampY			= null;
		_shadowLight	= null;
		_hudSW			= null;
		//_enemyQuant		= null;
		//_enemyStartQuant= null;
		_hudBtnMagazinS	= null;
		_hudBtnBatteryS	= null;
		_blackBack		= null;
		_wallBack		= null;
		_waweEmpty		= null;
		_waweFull		= null;
		_sfxBack 		= null;
			
			super.end();
		}
		
		
		private function onAddAmmo(witch:int):void 
		{
			switch (witch) 
			{
				case 1:
					//trace("addMagazinnnnn");
					if (playerS.money >= C.PRICE_MAGAZINE)
					{
						playerS.money -= C.PRICE_MAGAZINE;
						playerS.collected(0);//Player.addmagazine++;
					}
				break;
				case 2:
					//trace("addBatteryyyyyy");
					if (playerS.money >= C.PRICE_BATTERY)
					{
						playerS.money -= C.PRICE_BATTERY;
						playerS.collected(2);//Player.addbattery++;
					}
				break;
			}
			playerS.textMoney.text = String(playerS.money);
		}
		
		override public function focusGained():void 
		{
			this.active = true;
		}
		override public function focusLost():void 
		{
			this.active = false;
		}
		
		override public function update():void 
		{
			super.update();
			//FP.world.focusGained
			/*if (Input.pressed(Key.ESCAPE))
			{
				Mouse.show();
				FP.world = parentGWorld;
			}*/
				
			//cameraFollow();
			if (!wait) 
			{
				// make camera follow the player
				_targetView.x = Input.mouseX*_coefX;
				_targetView.y = Input.mouseY*_coefY;
				
				FP.camera.x = int(_targetView.x);
				FP.camera.y = int(_targetView.y);
				
				// keep camera in room bounds
				FP.camera.x = FP.clamp(FP.camera.x, 0, _clampX);
				FP.camera.y = FP.clamp(FP.camera.y, 0, _clampY);
				//trace(FP.camera);
			}
			
			playerS.x  =_hudSW.x = FP.camera.x + 250;// C.GAME_WIDTH * 0.5;
			playerS.y  =_hudSW.y = FP.camera.y + 240;// C.GAME_HEIGHT * 0.5;
			_hudSW.x -= 250;
			_hudSW.y -= 240;
			
			_hudBtnMagazinS.x = _hudSW.x+20;
			_hudBtnMagazinS.y = _hudSW.y+60;
			
			_hudBtnBatteryS.x = _hudSW.x + 90;
			_hudBtnBatteryS.y = _hudBtnMagazinS.y;
			
			_spawnShootEnemy++;
			if (_spawnShootEnemy > 0)
			{
				if (_enemyQuant > 0)
				{
					var spawnpoint:Object = FP.choose(_roomData.spawnPoints);
					if (spawnpoint.slotfree)
					{
						enemiesSW.push(add(new ShootEnemy(spawnpoint, FP.choose(1, 2, 3), this)) as ShootEnemy);
						_spawnShootEnemy = -AntMath.randomRangeInt(_spawnRand1,_spawnRand2);
						_enemyQuant--;
						
						_waweFull.scaleX = _enemyQuant / _enemyStartQuant;
					}
					else
					{
						_spawnShootEnemy = 1;
					}
				}
				else 
				{
					if(deadEnemy == _enemyStartQuant)
					{
						//trace("World is clean");
						AntStatistic.track("killsEnemy", _enemyStartQuant);
						V.playerKeys++;
						Mouse.show();
						FP.world = parentGWorld;
						
					}
				}
			}
			
		}		
	}

}