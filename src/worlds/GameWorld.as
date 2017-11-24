package worlds 
{
	import entities.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	import flash.system.ImageDecodingPolicy;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.*;
	import brain.pathFinding.*;
	import lit.Lighting;
	import lit.Light;
	import net.flashpunk.tweens.motion.LinearMotion;
	import utils.*;
	
	/**
	 * Core game world logic.
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public class GameWorld extends World 
	{
		//public static const COLL_GRIDTYPE	:String = "solid";
		//public static const COLL_STEPSTYPE	:String = "step";
		
		public var playerG		:Player;
				
		/** Camera following information. */
		public const FOLLOW_TRAIL		:Number = 50;
		public const FOLLOW_RATE		:Number = .9;
		
		public var parentWorld			:MenuWorld;
		public var isCompeted			:Boolean;
		
		private var _finish				:Point;
		private var _start				:Point;
		private var _gamepath			:Vector.<Node>;
		
		protected var _map				:Entity;
		protected var _stairs			:Entity;
			
		protected var _mapGrid			:Grid;
		protected var _mapGridStairs	:Grid;
		protected var _mapImage			:Graphic;
		protected var _mapStairs		:Graphic;
		protected var _mapData			:Class;
		
		protected var _hudGW			:HUD;	
		
		public var enemies				:Vector.<Enemy> = new Vector.<Enemy>();
		public var deadEnemies			:Vector.<Enemy> = new Vector.<Enemy>();
		public var doors				:Vector.<Door> = new Vector.<Door>();
		public var holes				:Vector.<Hole> = new Vector.<Hole>();
		public var lights				:Vector.<Light> = new Vector.<Light>();
		public var shootWorlds			:Array = [];
		
		/** Size of the level (so it knows where to keep the player + camera in). */
		public var width				:uint;
		public var height				:uint;
		
		private var _lighting			:Lighting;
		private var _mapGridPathfinding	:GridPathfinding;
		private var _cellSizes			:int = 20;
		private var _cameraFollowDist	:Number;
		private var _spanwDoor			:Door;
		private var _currentDoor		:Door;
		private var _currentShootW		:ShootWorld;
		
		private var _reSpawnDelay		:int = 600;//10 seconds
		private var _slotInHUD			:int = 0;
		
		private var _hudBtnMagazin		:Button;
		private var _hudBtnBattery		:Button;
		private var _hudBtnGrenade		:Button;
		
		private var _onceViewDoorInfo	:Boolean;
		public var hudInfoText			:Text;
		public var canGoBackToGame		:Boolean;
		public var levelN				:int;
		
		private var _sfxBaseBacks:Sfx;
		private var _sfxMenuBacks:Sfx;
		private var _sfxAchieve:Sfx;
		private var _levText:Entity;
		
		//TIPS
		public var keyTipsA:Spritemap;
		public var keyTipsB:Spritemap;
		public var keyTipsC:Spritemap;
		public var keyTipsD:Spritemap;
			
		public function GameWorld(mapData:Class = null, numLevel:int=0) 
		{
			super();			
			_mapData = mapData;
			levelN = numLevel;
			//trace("levelN", levelN);
			if (mapData != null) loadMap(_mapData);
			
			// Read the level dimensions from the level.
			width = _mapGrid.width;
			height = _mapGrid.height;
			
			_sfxBaseBacks = new Sfx(Assets.SFX_GAME, null, "sound");
			_sfxMenuBacks = new Sfx(Assets.SFX_MENU, null, "music");
			// Create a player at the player start.
			playerG = new Player(_start.x, _start.y, 8);
			playerG.parentW = this;
			
			_lighting = new Lighting(FP.screen.width, FP.screen.height, 0xFFFFFF);// , _playerG.layer - 1);
			_lighting.add(playerG.torch);
			
			// Create a map entity to render and check collision with.
			_map = new Entity(0, 0, _mapImage, _mapGrid);
			_map.layer = 10;
			_map.type = "solid";
				
			var stairs:Image = new Image(Assets.BROKEN_Stairs);
				stairs.flipped = ((levelN & 1) == 0);

			_stairs = new Entity(0, 0, stairs, _mapGridStairs);
			_stairs.layer = playerG.layer-1;
			_stairs.type = "step";
			
			if (stairs.flipped)
			{
				_levText.graphic.x = 160;
			}
			else
			{
				_levText.graphic.x = -160;
			}
			
			_hudGW = new HUD(0, 0, playerG.layer - 1);
			_hudGW.addGraphic(new Graphiclist(new Image(Assets.HUDBAR),
								playerG.textMgznBullet, playerG.textBullet, 
								playerG.textMoney, playerG.textBatteries, 
								playerG.textGrenades));
			
			_hudBtnMagazin = new Button(onAddAmmo, 1, 0, 0);
			_hudBtnMagazin.setSpritemap(Assets.HUDMAG, 46, 52,[]);
			_hudBtnMagazin.layer = _hudGW.layer - 1;
			_hudBtnMagazin.setLabel("buy\n" + String(C.PRICE_MAGAZINE)+"$",true,10,true);
					
			_hudBtnBattery = new Button(onAddAmmo, 2, 0, 0);
			_hudBtnBattery.setSpritemap(Assets.HUDMAG, 46, 52,[[3],[4],[5]]);
			_hudBtnBattery.layer = _hudGW.layer - 1;
			_hudBtnBattery.setLabel("buy\n" + String(C.PRICE_BATTERY)+"$",true,10,true);
			
			_hudBtnGrenade = new Button(onAddAmmo, 3, 0, 0);
			_hudBtnGrenade.setSpritemap(Assets.HUDMAG, 46, 52,[[6],[7],[8]]);
			_hudBtnGrenade.layer = _hudGW.layer - 1;
			_hudBtnGrenade.setLabel("buy\n" + String(C.PRICE_GRENADE)+"$", true,10,true);
			
			hudInfoText = new TextBlinc	(C.TEXTBASE[0], 460, 10, {font:"orbitron bold", size: 12, color: 0xC0C0C0, width:160, wordWrap:true});
			_hudGW.addGraphic(hudInfoText);
			
			if (levelN == 1)
			{
				keyTipsA = new Spritemap(Assets.KEYS, 90, 90);
				keyTipsA.scale = 0.5;
				keyTipsA.visible = false;
				keyTipsA.add("up", [0, 4], 2);
				keyTipsA.add("left", [1, 4], 2);
				keyTipsA.add("down", [2, 4], 2);
				keyTipsA.add("right", [3, 4], 2);
				keyTipsA.add("shoot", [5, 4], 2);
				keyTipsA.add("light", [6, 4], 2);
				keyTipsA.add("throw", [7, 4], 2);
				_hudGW.addGraphic(keyTipsA);
					
				keyTipsB = new Spritemap(Assets.KEYS, 180, 90);
				keyTipsB.scale = 0.5;
				keyTipsB.visible = false;
				keyTipsB.add("jump", [6, 7], 2);
				_hudGW.addGraphic(keyTipsB);
				
				keyTipsC = new Spritemap(Assets.KEYS, 180, 180);
				keyTipsC.scale = 0.5;
				keyTipsC.visible = false;
				keyTipsC.add("stairUP", [6, 4, 6, 4, 7, 4, 7, 4], 2);
				keyTipsC.add("stairDOWN", [9, 4, 9, 4, 10, 4, 10, 4], 2);
				_stairs.addGraphic(keyTipsC);
				
				keyTipsD = new Spritemap(Assets.KEYS, 90, 90);
				keyTipsD.scale = 0.5;
				keyTipsD.visible = false;
				keyTipsD.add("up", [0, 4], 2);
				
				/*var block:Entity = new Entity(playerG.x - 100, playerG.y-60);
					block.setHitbox(20, 60);
					block.type = "block";
					add(block);*/
			}
			
			_gamepath = getAstarPath();
			
			// Add the game entities to GameWorld.
			for each (var e:Enemy in enemies)	
			{	
				e.parentWorld = this;
				e.grid = _mapGridPathfinding;
				e.path = _gamepath;
				add(e);				
			}
			
			for each (var d:Door in doors )		{add(d);}
			for each (var h:Hole in holes)		{add(h);}
			
			for each (var l:Light in lights)			
			{
				_lighting.add(l); 
				if (l.base != null) 
				{
					add(l.base);
					l.base.layer = playerG.layer;
				}
			}
			
			_lighting.add(new Light(0, 0, 
				new Image(new BitmapData(width, height, false, 0x000000)), 
				false, 1, C.DARKNESS)); 
			
			add(_lighting);
			add(_stairs);
			add(_map);
			add(_levText);
			add(playerG); 
		
			addList(_hudGW, _hudBtnMagazin, _hudBtnBattery, _hudBtnGrenade);
			
			
		}
		
		private function onAddAmmo(witch:int):void 
		{
			switch (witch) 
			{
				case 1:
					//trace("addMagazinnnnn");
					if (playerG.money >= C.PRICE_MAGAZINE)
					{
						playerG.money -= C.PRICE_MAGAZINE;
						playerG.collected(0);
						//Player.addmagazine++;
					}
				break;
				case 2:
					//trace("addBatteryyyyyy");
					if (playerG.money >= C.PRICE_BATTERY)
					{
						playerG.money -= C.PRICE_BATTERY;
						playerG.collected(2);
						//Player.addbattery++;
					}
				break;
				case 3:
					//trace("addGrenadesssss");
					if (playerG.money >= C.PRICE_GRENADE)
					{
						playerG.money -= C.PRICE_GRENADE;
						//Player.addgrenades++;
						playerG.collected(3);
					}
				break;
			}
			playerG.textMoney.text = String(playerG.money);
		}
		
		/** Called when World is switch to, and set to the currently active world. */
		override public function begin():void 
		{
			//add events when earned 
			AntStatistic.eventAwardEarned.add(onAwardEarned); 
			//AntStatistic.eventUpdateAward.add(onUpdateAward);
			//AntStatistic.eventUpdateState.add(onUpdateStatistic);
			
			switch (playerG.currentWeapon.stringWeaponForPlayer) 
			{
				case "gun":
					playerG.bulletsMagazin = 	V.playerMagazins1;
					playerG.bullets = 			V.playerBullets1;
				break;
				case "Mk":
					playerG.bulletsMagazin = 	V.playerMagazins2;
					playerG.bullets = 			V.playerBullets2;
				break;
				case "Ak":
					playerG.bulletsMagazin = 	V.playerMagazins3;
					playerG.bullets = 			V.playerBullets3;
				break;
			}
			
			playerG.batteries = 		V.playerBatteries;
			playerG.health = 			V.playerHealth;
			playerG.startHealth = 		V.playerBaseHealth;
			playerG.money = 			V.playerMoney;
			playerG.grenades = 			V.playerGrenade;
			
			playerG.textGrenades.text = String(V.playerGrenade);
			playerG.textMoney.text = String(V.playerMoney);
			playerG.textBatteries.text = String(V.playerBatteries);
			
			playerG.textBullet.text = String(playerG.bullets);
			playerG.textMgznBullet.text = String(playerG.bulletsMagazin);
			
			if (V.playerKeys >= 5) playerG.haveLevelKey = true;
			
			if (!V.hints) hudInfoText.text = "";
			else hudInfoText.text = C.TEXTBASE[0];
			
			V.currentLevel = levelN;
			_onceViewDoorInfo = false;
			canGoBackToGame = false;
				
			if (playerG.currentGrenade == null) 
			{
				playerG.currentGrenade = new Ammo(0, 0, 0, "grenade");
				add(playerG.currentGrenade); 
			}
				
			Sfx.setVolume("sound", V.soundsVolume);
			Sfx.setVolume("soundShoot", V.soundsVolume * 0.2);
			_sfxBaseBacks.loop(V.soundsVolume);
			_sfxMenuBacks.loop(V.musicsVolume * .035);
			
			_currentShootW = null;
			
			for each (var slot:Object in _hudGW.achievements) 
			{
				if (slot.earned) 
				{
					slot.achImg.x = slot.achX;
					slot.achImg.y = 20;
				}
			}
			

			//trace("gameworld Begin");
			super.begin();
		}
		
	
		private function onAwardEarned(aAward:AntAwardData):void
		{
			//get popup
			_slotInHUD++;
			if (_slotInHUD > 3) _slotInHUD = 1;
			if(FP.world is GameWorld) _hudGW.addAchieveToHUD(aAward.userData, _slotInHUD);
			
			var earnedAwa:String = aAward.userData.shortDesc;
			var uiMenu:MenuUI = MenuWorld.screenListUI[6];
				for each (var b:Button in uiMenu.menuButtons) 
				{
					if (b.labelTxt.text == earnedAwa) 
					{
						b.addBackground(Assets.ICOS, 0, 1480, 120, 40);
						break;
					}
				}
		}
		
		override public function end():void
		{
			super.end();
			if (playerG.alive)
			{
				switch (playerG.currentWeapon.stringWeaponForPlayer) 
				{
					case "gun":
						V.playerMagazins1 = playerG.bulletsMagazin;
						V.playerBullets1 = playerG.bullets;
					break;
					case "Mk":
						V.playerMagazins2 = playerG.bulletsMagazin;
						V.playerBullets2 = playerG.bullets;
					break;
					case "Ak":
						V.playerMagazins3 = playerG.bulletsMagazin;
						V.playerBullets3 = playerG.bullets;
					break;
				}
				
				
				V.playerBatteries = playerG.batteries;
				V.playerHealth = playerG.health;
				V.playerMoney = playerG.money;
				V.playerGrenade = playerG.grenades;
				//trace("gameworld end", "V.playerMagazins", V.playerMagazins, "V.playerBullets",  V.playerBullets);
			}
			_sfxBaseBacks.stop();
			_sfxMenuBacks.stop();
			if(_sfxAchieve)_sfxAchieve.stop();
			playerG.sfxWalk.stop();
		}
		
		/** Performed by the game loop, updates all contained Entities. */
		override public function update():void 
		{
			super.update();
			
			if (Input.pressed(Key.ESCAPE)) 
			{
				canGoBackToGame = true;
				FP.world = parentWorld;
				parentWorld.onPlay();
				_sfxBaseBacks.stop();
				return;
			}			
			
			cameraFollow();
			handleDoors();
			reSpawn();
		}
			
		/** Makes the camera follow the player object. */

		private function cameraFollow():void
		{
			// camera follow the player
			FP.point.x = FP.camera.x - targetX;
			FP.point.y = FP.camera.y - targetY;
			_cameraFollowDist = FP.point.length;
			if (_cameraFollowDist > FOLLOW_TRAIL) _cameraFollowDist = FOLLOW_TRAIL;
			FP.point.normalize(_cameraFollowDist * FOLLOW_RATE);
			FP.camera.x = int(targetX + FP.point.x);
			FP.camera.y = int(targetY + FP.point.y);
			
			// keep camera in room bounds
			FP.camera.x = FP.clamp(FP.camera.x, 0, width - FP.width);
			FP.camera.y = FP.clamp(FP.camera.y, 0, height - FP.height);
			_hudGW.x = FP.camera.x;
			_hudGW.y = FP.camera.y;
			
			_hudBtnMagazin.x = _hudGW.x+20;
			_hudBtnMagazin.y = _hudGW.y+60;
			
			_hudBtnBattery.x = _hudGW.x + 90;
			_hudBtnBattery.y = _hudBtnMagazin.y;
			
			_hudBtnGrenade.x = _hudGW.x + 150;
			_hudBtnGrenade.y = _hudBtnMagazin.y;
		}
		
		/** The player's X location. */
		private function get targetX():Number { return playerG.x - FP.width / 2; }
		
		/** The player's Y location. */
		private function get targetY():Number { return playerG.y - FP.height / 2; }
		
		
		private function handleDoors():void
		{
			_currentDoor = Door(playerG.collide(Door.COLLDOOR, playerG.x, playerG.y));
			if (_currentDoor == null) return;
			
			if (!_onceViewDoorInfo && levelN == 1)
			{
				_onceViewDoorInfo = true;
				if (V.hints) hudInfoText.text = C.TEXTBASE[6];
				_currentDoor.addGraphic(keyTipsD);
				playerG.teachWitch = 8;
			}
			
			if(Input.check("UP"))
			{
				playerG.teachWitch = 0;
				if (V.hints) hudInfoText.text = C.TEXTBASE[0];
				if (_currentDoor.isOpen ) 
				{
					//trace("goToRoom", _currentDoor.goToRoom);
					if (_currentDoor.goToRoom > 0 && _currentDoor.isEnemyDoor == false)	
					{
						_currentShootW = new ShootWorld(this);
						if (_currentShootW)
						{
							FP.world = _currentShootW;
							_currentDoor.isEnemyDoor = true;
						}	
					}
					else if (_currentDoor.goToRoom == 0 && playerG.haveLevelKey)		
					{
						if(levelN < 16) MenuWorld.stageLevelList[levelN].opened = true;
						parentWorld.setScreenUI(11);
						FP.world = parentWorld;
					}
					else
					{
						_currentDoor.doorStatusTxT.text = C.USRTEXT[4];
						_currentDoor.viewLockStatus();
					}
				}
				else
				{
					if(Door.sfxDoorLocked.playing == false) Door.sfxDoorLocked.play();
					if (playerG.haveLevelKey && _currentDoor.goToRoom == 0) _currentDoor.doorStatusTxT.text = C.USRTEXT[3]; 
					if(V.hints)_currentDoor.viewLockStatus();
				}
			}
			else if (_currentDoor.isEnemyDoor) _spanwDoor = _currentDoor;
		}

		private function reSpawn():void
		{
			_reSpawnDelay--
			if (_reSpawnDelay > 0) return;
				
			_reSpawnDelay = AntMath.randomRangeInt(360, 540);
			if (_spanwDoor == null) return;
			
			var dLength:int, randEnemy:int,  spawnEnemy:Enemy;
			
			dLength = deadEnemies.length;
			if (dLength <= 0) return;
			randEnemy = AntMath.randomRangeInt(0, dLength-1);
			spawnEnemy = deadEnemies[randEnemy]; 
			deadEnemies.splice(randEnemy, 1);
			spawnEnemy.setPosition(_spanwDoor.x, _spanwDoor.y+60);
			spawnEnemy.added();
			spawnEnemy.layer = playerG.layer;
		}
		
		private function getAstarPath():Vector.<Node>
		{
			var xpos:int, ypos:int, astar:AStar, pf:Vector.<Node>;
			
			xpos = Math.floor(_finish.x / _cellSizes);
			ypos = Math.floor(_finish.y / _cellSizes);
			_mapGridPathfinding.setEndNode(xpos, ypos);
			
			xpos = Math.floor(_start.x / _cellSizes);
			ypos = Math.floor(_start.y / _cellSizes);
			_mapGridPathfinding.setStartNode(xpos, ypos);
			
			astar = new AStar();
			pf = new Vector.<Node>();
			if (astar.findPath(_mapGridPathfinding)) 
			{
				for each (var n:Node in astar.path) 
				{
					n.id = pf.length;
					pf.push(n);
				}
				return pf;
			}
			return null;
		}
		
		/**
		 * Loads a map from provided map data.
		 * @param	mapData The map data to load.
		 */
		protected function loadMap(mapData:Class):void
		{
			var mapXML:XML = FP.getXML(mapData);
			var node:XML;
			
			// Create our map grid.
			_mapGrid = new Grid(uint(mapXML.@width), uint(mapXML.@height), _cellSizes, _cellSizes, 0, 0);
			_mapGrid.loadFromString(String(mapXML.GridColllision), "", "\n");
			
			_mapGridStairs = new Grid(uint(mapXML.@width), uint(mapXML.@height), _cellSizes, _cellSizes, 0, 0);
			_mapGridStairs.loadFromString(String(mapXML.GridStairs), "", "\n");
			
			//set walkable for Pathfinding
			_mapGridPathfinding = new GridPathfinding(_mapGrid.width / _cellSizes, _mapGrid.height / _cellSizes);
			_mapGridPathfinding.loadFromString(String(mapXML.GridPathFind), "", "\n");
			
			_mapImage =  new Graphiclist(new Image(Assets.BK));
			//Create start/finish area.
			_finish = new Point(int(mapXML.Entities.Finish.@x), int(mapXML.Entities.Finish.@y));
			_start = new Point(int(mapXML.Entities.PlayerStart.@x), int(mapXML.Entities.PlayerStart.@y));		
			
			var text:Text = new Text(String(mapXML.@Name), 0, -160,  {font:"orbitron black", size: 16, color: 0xFFFFFF});
				text.smooth = true;
			_levText = new Entity(int(mapXML.Entities.PlayerStart.@x), int(mapXML.Entities.PlayerStart.@y), text);
			
			
			//Create Enemies.
			var enemy:Enemy;
			for each (node in mapXML.Entities.Enemies)
			{
				enemy = new Enemy();
				enemy.setPosition(int(node.@x), int(node.@y));
				enemy.variety = AntMath.randomRangeInt(1,3);
				enemy.multiplify = C.MULTIPLIFY[levelN - 1];
				enemy.sprColor = C.VARIETIES[levelN - 1];
				enemies.push(enemy);
			}			
			
			//Create Lights.
			var lightimage:Image = new Image(Assets.LAMPS);
			for each (node in mapXML.Entities.Lamps)
			{
				lights.push(new Light(int(node.@x), int(node.@y), lightimage, true));
			}	
			
			//DOORS
			for each (node in mapXML.Entities.Doors)
			{
				doors.push(new Door(int(node.@x), int(node.@y), String(node.@collType), 9, int(node.@gotoroom)));
			}
			
			//HOLES
			for each (node in mapXML.Entities.Holes) 
			{
				holes.push(new Hole(int(node.@x), int(node.@y), 9));
			}
			//trace("holes.length", holes);
		}
	}
}