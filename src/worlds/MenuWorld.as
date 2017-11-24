package worlds 
{
	import entities.*;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import utils.*;
	import net.flashpunk.Sfx;
	import flash.ui.Mouse;
	/**
	 * The main menu of the game.
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public class MenuWorld extends World 
	{
		public static var roomslist:Vector.<Room>;
		public static var stageLevelList:Vector.<LevelData>;
		public static var screenListUI:Vector.<MenuUI>;
		public static var gamesList:Array;
		public static var ammoGoods:Array;
		
		private var _ammoIndex:int;
		private var _ammoPriceTxt:TextBlinc;
		private var _ammoMoneyTxt:Text;
		
		private var _currentGameWorld:GameWorld;
		
		private var _currentScreenUI:MenuUI;
		private var _indexUI:uint;
		private var _prevIndexUI:uint;

		private var _tweenedCurrentButton:Button;
		private var _tweenedNextButton:Button;
		private var _twIsViewBtn:Boolean;
		private var _levelHighlight:Spritemap;
		private var _replay:Boolean;
		private var _nextLev:Boolean;
		
		private var _sfxMenuBack:Sfx;
		private var _sfxGameBack:Sfx;
		private var _sfxWIN:Sfx;
		private var _sfxGameOver:Sfx;
		
		
		public function MenuWorld() 
		{
			AntStatistic.loadData();
			
			roomslist = new Vector.<Room>();
			ammoGoods = [	new Ammo(0, 0, 1, "weapon"), 
							new Ammo(0, 0, 2, "weapon"),
							new Ammo(0, 0, 3, "weapon")];
				
			// set array of entities menu ui
			screenListUI = new Vector.<MenuUI>();
			_prevIndexUI = 0;
			_indexUI = 0;
			
			_sfxWIN = new Sfx(Assets.SFX_GAME_WIN, null, "sound");
			_sfxGameOver= new Sfx(Assets.SFX_GAME_OVER, null, "sound");
			//_sfxGameBack = new Sfx(Assets.SFX_GAME, null, "sound");
			_sfxMenuBack = new Sfx(Assets.SFX_MENU, null, "music");
			
			stageLevelList = new Vector.<LevelData>();
			
			var level:uint = 1;
			while (L[getLevelString(level)] != null)
			{
				stageLevelList.push(new LevelData(L[getLevelString(level)]));
				level++;
			}
				
			var room:uint = 1;
			while (L[getRoomString(room)] != null) 
			{
				roomslist.push(new Room(L[getRoomString(room)]));
				room++;
			}
			
			
			var loadUIxmlParts:Vector.<String> = new Vector.<String>();
			loadUIxmlParts.push(
				"S0_Welcome", "S1_StartLevels",
				"S11_Stage1", "S12_Stage2", "S13_Stage3", "S14_Stage4",	"S15_Achievements","S16_AmmoShop",
				"S2_Credits", "S3_Options", "LOOSE", "WIN");
			
			_ammoPriceTxt = new TextBlinc("", 0, 0, {font:"orbitron bold", size: 16, color: 0xFF0000, align:"center"});
			_ammoMoneyTxt = new Text("", 0, 0, {font:"orbitron bold", size: 16, color: 0xFFFFFF, align:"center"});
			
			_replay = false;
			_nextLev = false;
			
			if (C.MENUXML != null) initialiseUI(C.MENUXML, loadUIxmlParts);
		}
		
		
		
		private function initialiseUI(_menuData:Class, _xmlParts:Vector.<String>):void 
		{
			var menuXML:XML, node:XML, 
				button:*, back:Image, argBtn:uint, text:Text, 
				stringPart:String, xmlPart:XMLList,
				currentUI:MenuUI;
			
			menuXML = FP.getXML(_menuData);
			
			this.addGraphic(new Image(Assets["BCKGR_WELCOME"]));
			
			_levelHighlight = new Spritemap(Assets.STAGES_SLCT, 640, 480);
			_levelHighlight.add("st1", [0], 0);
			_levelHighlight.add("st2", [1], 0);
			_levelHighlight.add("st3", [2], 0);
			_levelHighlight.add("st4", [3], 0);
			_levelHighlight.visible = false;
			this.addGraphic(_levelHighlight);
			
			
			for each (stringPart in _xmlParts) 
			{
				xmlPart = menuXML.descendants(String(stringPart));
				currentUI = new MenuUI();
					
				for each (node in xmlPart.Text) 
				{
					text = new Text(node.@text, int(node.@x), int(node.@y),{font:"orbitron bold", size: int(node.@textSize), color: 0xFFFFFF, wordWrap:true, width:500});
					currentUI.addGraphic(text);
				}
				
				for each (node in xmlPart.Button)
				{
						
					button = new Button(this[node.@callback], uint(node.@argument), int(node.@x), int(node.@y));
					var assetsSprArr:Array = [];
					var labeTxt:String = "";
					var sizeLabelTxt:int = 20;
					var achValue:String;
					var wrapLabel:Boolean = false;
					switch (String(node.@callback)) 
					{
						case "onPlay":
							assetsSprArr = [[0], [1], [2]];
						break;
						case "onCredits":
							assetsSprArr = [[3], [4], [5]];
						break;
						case "onOptions":
							assetsSprArr = [[6], [7], [8]];
						break;
						case "onReturn":
							assetsSprArr = [[9], [10], [11]];
						break;
						case "onAmmoShopNav":
							switch (uint(node.@argument)) 
							{
								case 1: assetsSprArr = [[21], [22], [23]]; break;
								case 2: assetsSprArr = [[12], [13], [14]]; break;
							}
						break;
						case "onAmmoShop":
							assetsSprArr = [[15], [16], [17]];
						break;
						case "onBuyAmmo":
							switch (uint(node.@argument)) 
							{
								case 1: assetsSprArr = [[0], [1], [2]]; break;
								case 2: assetsSprArr = [[3], [4], [5]]; break;
								case 3: assetsSprArr = [[6], [7], [8]]; break;
							}
						break;
						case "onAchieve":
							assetsSprArr = [[18], [19], [20]];
						break;
						case "onAchieveView":
							assetsSprArr = [[108], [109], [110]];
							switch (uint(node.@argument)) 
							{
								case 1:achValue = "AWA01"; break;
								case 2:achValue = "AWA02"; break;
								case 3:achValue = "AWA03"; break;
								case 4:achValue = "AWA04"; break;
								case 5:achValue = "AWA05"; break;
								case 6:achValue = "AWA06"; break;
								case 7:achValue = "AWA07"; break;
								case 8:achValue = "AWA08"; break;
								case 9:achValue = "AWA09"; break;
								case 10:achValue = "AWA10"; break;
								case 11:achValue = "AWA11"; break;
								case 12:achValue = "AWA12"; break;
								case 13:achValue = "AWA13"; break;
								case 14:achValue = "AWA14"; break;
								case 15:achValue = "AWA15"; break;
							}
							labeTxt = Award[achValue].shortDesc;
							sizeLabelTxt = 12;
							wrapLabel = true;
						break;
						case "onStage":
							assetsSprArr = [[0], [1], [2]];
							var stageNo:String;
							switch (uint(node.@argument)) 
							{
								case 1: stageNo = " I"; break;
								case 2: stageNo = " II"; break;
								case 3: stageNo = " III"; break;
								case 4: stageNo = " IV"; break;
							}
							labeTxt = "Stage"+stageNo;	
						break;
						case "onLevel":
							assetsSprArr = [[6], [7], [8]];
							labeTxt = "Level "+String(node.@argument);	
						break;
						case "onSounds":
							button = new Checkbox(this[node.@callback], uint(node.@argument), int(node.@x), int(node.@y));
							assetsSprArr = [[0],[1],[2],[8],[9]];
						break;
						case "onMusics":
							button = new Checkbox(this[node.@callback], uint(node.@argument), int(node.@x), int(node.@y));
							assetsSprArr = [[0],[1],[2],[10],[11]];
						break;
						case "onHints":
							button = new Checkbox(this[node.@callback], uint(node.@argument), int(node.@x), int(node.@y));
							assetsSprArr = [[0],[1],[2],[13],[14]];
						break;
						case "onReplay": 	assetsSprArr = [[0], [1], [2]];		break;
						case "onNextLevel":	assetsSprArr = [[12], [13], [14]];	break;
						
					}
					
					button.setSpritemap(Assets[node.@assetName], uint(node.@assetFrameWidth), uint(node.@assetFrameHeight), assetsSprArr);
					if(button is Button) button.setLabel(labeTxt, false, sizeLabelTxt, wrapLabel);
					if (button is Checkbox) button.setChecked();
					
					
					currentUI.addButtons(button, String(node.@callback));
					
				}
				
				switch (stringPart) 
				{
					case "S0_Welcome":
						currentUI.isMain = true;
						var txtGame:Text = new Text("Bloody floors", 200, 150, {font:"orbitron black", size: 55, color: 0xFFFFFF});
							txtGame.smooth = true;
							txtGame.alpha = 0.08;
						var txtGame2:Text = new Text("Bloody floors", 190, 150, {font:"orbitron black", size: 50, color: 0x800000});
							txtGame.smooth = true;
						currentUI.addGraphic(txtGame);
						currentUI.addGraphic(txtGame2);
					break;
					case "S2_Credits":
						text.text = "autor ROMAN FURDYCHKA\n\n\nHINTS:"
						var txthints:Text = new Text("",text.x,text.y+100,{font:"orbitron bold", size: 15, color: 0xC0C0C0, wordWrap:true, width:500});
						currentUI.addGraphic(txthints);
						
						for (var i:int = 1; i < C.TEXTBASE.length; i++) 
						{
							txthints.text += C.TEXTBASE[i]+"\n";
						}
						
					break;
					case "S16_AmmoShop":
						_ammoMoneyTxt.smooth = _ammoPriceTxt.smooth = true;
						_ammoMoneyTxt.x =_ammoPriceTxt.x = 200;
						_ammoMoneyTxt.y = 400;
						_ammoPriceTxt.y = 360;
						currentUI.addText(_ammoMoneyTxt);
						currentUI.addText(_ammoPriceTxt);
					break;
				}
				screenListUI.push(currentUI);
			}
		}
		
		override public function begin():void 
		{
			super.begin();
			Mouse.show();
			for each (var menuScreen:MenuUI in screenListUI) 
			{
				add(menuScreen);
				menuScreen.visible = false;
				menuScreen.collidable = false;
			}
			
			_currentScreenUI = screenListUI[_indexUI];
			_currentScreenUI.setUI(true);
			
			//_sfxGameBack.loop(V.soundsVolume * 0.2);
			if(_indexUI != 10 || _indexUI != 11)_sfxMenuBack.loop(V.musicsVolume);
			//statistic and awards
			//AntStatistic.clearData();
			//AntStatistic.debugMode = true;
			
			if (AntStatistic.containsStat("killsEnemy") == false)
			{
				AntStatistic.registerStat("killsEnemy", "add");
				AntStatistic.registerAward(String(Award.KILL01)+" kill", "killsEnemy", Award.KILL01, Award.AWA01);
				AntStatistic.registerAward(String(Award.KILL02)+" kill", "killsEnemy", Award.KILL02, Award.AWA02);
				AntStatistic.registerAward(String(Award.KILL03)+" kill", "killsEnemy", Award.KILL03, Award.AWA03);
			}
			
			
			if (AntStatistic.containsStat("killsGrenade") == false)
			{
				AntStatistic.registerStat("killsGrenade", "replace");
				AntStatistic.registerAward(String(Award.GREND01)+" grenade kill", "killsGrenade", Award.GREND01, Award.AWA04);
				AntStatistic.registerAward(String(Award.GREND02)+" grenade kill", "killsGrenade", Award.GREND02, Award.AWA05);
				AntStatistic.registerAward(String(Award.GREND03)+" grenade kill", "killsGrenade", Award.GREND03, Award.AWA06);
			}
			
			if (AntStatistic.containsStat("brokeDoor") == false)
			{
				AntStatistic.registerStat("brokeDoor", "add");
				AntStatistic.registerAward(String(Award.DOOR01)+" DOOR break down", "brokeDoor", Award.DOOR01, Award.AWA07);
				AntStatistic.registerAward(String(Award.DOOR02)+" DOOR break down", "brokeDoor", Award.DOOR02, Award.AWA08);
				AntStatistic.registerAward(String(Award.DOOR03)+" DOOR break down", "brokeDoor", Award.DOOR03, Award.AWA09);
			}
			
			if (AntStatistic.containsStat("brokeLamp") == false)
			{
				AntStatistic.registerStat("brokeLamp", "add");
				AntStatistic.registerAward(String(Award.LAMP01)+" Lamp break down", "brokeLamp", Award.LAMP01, Award.AWA10);
				AntStatistic.registerAward(String(Award.LAMP02)+" Lamp break down", "brokeLamp", Award.LAMP02, Award.AWA11);
				AntStatistic.registerAward(String(Award.LAMP03)+" Lamp break down", "brokeLamp", Award.LAMP03, Award.AWA12);
			}
			
			if (AntStatistic.containsStat("headshot") == false)
			{
				//trace("AntStatistic.containsStat(headshot) == false");
				AntStatistic.registerStat("headshot", "add");
				AntStatistic.registerAward(String(Award.HEAD01)+" cool HeadShots", "headshot", Award.HEAD01, Award.AWA13);
				AntStatistic.registerAward(String(Award.HEAD02)+" cool HeadShots", "headshot", Award.HEAD02, Award.AWA14);
				AntStatistic.registerAward(String(Award.HEAD03)+" cool HeadShots", "headshot", Award.HEAD03, Award.AWA15);
			}
			
			if (AntStatistic.containsStat("levelcompleted") == false)
			{
				AntStatistic.registerStat("levelcompleted", "max");
			}
				
			/*var openedlevel:int = AntStatistic.getStatValue("levelcompleted");
			if (openedlevel > 0)
			{
				while (openedlevel > 0) 
				{
					stageLevelList[openedlevel].opened = true;
					openedlevel--;
					trace("make level opened", openedlevel);
				}
			}
			else
			{
				trace("level ---", openedlevel);
			}*/
			
			/*for each (var levDat:LevelData in stageLevelList) 
			{
				levDat.opened = true;
			}*/
			stageLevelList[0].opened = true;
			///stageLevelList[15].opened = true;
			//AntStatistic.saveData();
		}
		
		override public function end():void 
		{
			super.end();
			//_sfxGameBack.stop();
			_sfxMenuBack.stop();
		}
		override public function update():void 
		{
			super.update();
			
			if (Input.pressed(Key.ENTER)) 
			{
				switch (_indexUI) 
				{
					case 0: onPlay(); break;
					case 1: onStage(1); break;
					case 2:	onLevel(V.currentLevel); break;			
				}	
			}
			if (Input.pressed(Key.ESCAPE)) onReturn();
		}
		
		
		
		/**
		 * Generate the string name of a level based on a provided index.
		 * @param	index The index of the level to generate a string name.
		 * @return The string name of a level.
		 */
		protected function getLevelString(index:int):String
		{
			// This assumes all levels follow the naming structure "LEVEL_xx".
			var s:String = "LEVEL_";
			
			if (index <= 4) {
				s += "1"; 
				s += index.toString();
			}
			else if (index <= 8)  {
				s += "2";
				s += (index-4).toString();
			}
			else if (index <= 12) {
				s += "3";
				s += (index-8).toString();
			}
			else if (index <= 16) {
				s += "4";
				s += (index-12).toString();
			}
			else if (index <= 20) {
				s += "5";
				s += (index-16).toString();
			}
			return s;
		}
		
		protected function getRoomString(index:int):String
		{
			var r:String = "ROOM_";
			r += index.toString();
			return r;
		}
		
		/*public static function loadRoom(currentGame:GameWorld, index:int):ShootWorld
		{
			//var shootworld:ShootWorld =  
			/*if (currentGame.shootWorlds[index-1] == undefined) 
			{
				shootworld = new ShootWorld(currentGame, index);
				currentGame.shootWorlds[index-1] = shootworld;
				return shootworld;
			}
			/*else
			{
				return currentGame.shootWorlds[index - 1];
			}*/
			/*return new ShootWorld(currentGame, index);
		}*/
		
			
		public function setScreenUI(setUIindex:uint):void 
		{
			_prevIndexUI = _indexUI;
			_indexUI = setUIindex;
			
			_currentScreenUI.setUI(false);
			_currentScreenUI = screenListUI[setUIindex];
			
			switch (setUIindex) 
			{
				case 11:	
					_sfxWIN.play();
					//AntStatistic.track("levelcompleted", V.currentLevel+1);
					//AntStatistic.saveData();
				break;
				case 10:	
					_sfxGameOver.play(); 
				break;
				case 6:
					if (V.currentLevel == 16)
					{
						_sfxWIN.play();	
					}
				break;
			}
			
			FP.alarm(0.2, afterAlarm);
		}
		
		private function afterAlarm():void
		{
			_currentScreenUI.setUI(true);
		}
		
		
		public function onPlay():void
		{
			//trace("onPlay() indexUI", _indexUI);
			//AntStatistic.loadData();
			setScreenUI(1);
		}
		
		private function onLevel(levNo:uint):void
		{
			//trace("onLevel() indexUI", _indexUI);
			//trace("onLevel", levNo, "_replay",_replay,"_nextLev",_nextLev);
			Sfx.setVolume("sound", V.soundsVolume);
			Sfx.setVolume("soundShoot", V.soundsVolume * 0.3);
			
			if (_replay) 
			{
				_currentGameWorld = null;
				_currentGameWorld = new GameWorld(stageLevelList[levNo - 1].data, levNo);
				_currentGameWorld.parentWorld = this;
				V.currentLevel = levNo;
				V.playerKeys = 0;
				V.playerHealth = V.playerBaseHealth;
				FP.world = _currentGameWorld;
				return;
			}
			else if (_nextLev) 
			{
				V.currentLevel = levNo+1;
				_currentGameWorld = null;
				_currentGameWorld = new GameWorld(stageLevelList[levNo].data, levNo+1);
				_currentGameWorld.parentWorld = this;
				V.playerKeys = 0;
				FP.world = _currentGameWorld;
				return;
			}
			else if (_currentGameWorld && _currentGameWorld.canGoBackToGame && levNo==_currentGameWorld.levelN && _replay==false)
			{
				//trace("onLevel", levNo, "_currentGameWorld.canGoBackToGame");
				FP.world = _currentGameWorld;
				return;
			}
			else
			{
				_currentGameWorld = null;
				_currentGameWorld = new GameWorld(stageLevelList[levNo-1].data, levNo);
				_currentGameWorld.parentWorld = this;
				V.currentLevel = levNo;
				V.playerKeys = 0;
				FP.world = _currentGameWorld;
				return;
			}
		}
		
		
		private function onReplay():void
		{
			//trace("onReplay() ", V.currentLevel);
			_replay = true;
			onLevel(V.currentLevel);
			_replay = false;
		}
		
		private function onNextLevel():void 
		{
			_nextLev = true;
			if (V.currentLevel < 16) 
			{
				//stageLevelList[V.currentLevel].opened = true;
				//trace("onNextLevel(), currentLevel:",V.currentLevel);
				onLevel(V.currentLevel);
			}
			else
			{
				//TODO add greeting
				//trace("you win this GAME");
				onAchieve();
				var winner:TextBlinc = new TextBlinc("YOU ARE WINNER!!!", 50, 35,
				{font:"orbitron bold", size: 40, color: 0xFFFF00, align:"left", scrollX:1.5});
				_currentScreenUI.addGraphic(winner);
				
			}
			_nextLev = false;
		}
		
		private function onCredits():void
		{
			//trace("onCredits()", _indexUI);
			setScreenUI(8);
		}
		
		private function onOptions():void
		{
			//trace("onOptions()", _indexUI);
			setScreenUI(9);
		}
		
		private function onStage(numStage:uint):void
		{
			//trace("onStage() indexUI", _indexUI);
			
			_indexUI = numStage+1;
			setScreenUI(_indexUI);
			_levelHighlight.visible = true;
			_levelHighlight.play("st" + String(numStage));
		}
		
		private function onReturn():void
		{
			//trace("onReturn()" ,_indexUI);
			switch (_indexUI) 
			{
				case 1: setScreenUI(0);	_levelHighlight.visible = false;	break;
				case 2: setScreenUI(1); _levelHighlight.visible = false;	break;
				case 3: setScreenUI(1); _levelHighlight.visible = false;	break;
				case 4: setScreenUI(1); _levelHighlight.visible = false;	break;
				case 5: setScreenUI(1); _levelHighlight.visible = false;	break;
				case 6: setScreenUI(1);										break;
				case 7: setScreenUI(1);										break;
				case 8: setScreenUI(0);										break;
				case 9: setScreenUI(_prevIndexUI); 							break;
				case 10:setScreenUI(1);	_levelHighlight.visible = false;	break;
				case 11:setScreenUI(1);	_levelHighlight.visible = false;	break;
			}
		}
		
		private function onAchieve():void
		{
			//trace("onAchieve()", _indexUI);
			setScreenUI(6); 
		}
		
		private function onAchieveView(noAchieve:int):void 
		{
			//trace("onAchieve", noAchieve);
			add(new AchView(noAchieve));
		}
		
		
		private function onAmmoShop():void
		{
			//trace("onAmmoShop()");
			setScreenUI(7); 
			_ammoIndex = 0;
			
			setAmmoCanBuy(false, ammoGoods[0]);
			_ammoMoneyTxt.text = "Money: " + String(V.playerMoney) + "$";
		}
		
		
		private function onAmmoShopNav(direction:int):void 
		{
			//trace("onAmmoShopNav", direction);
			var currentGood:Button, nextGood:Button, arrAmmo:Array, ammo:Ammo, canUnlockAmmo:Boolean, n:int;
			
			arrAmmo = _currentScreenUI.shopBtns;
			currentGood = arrAmmo[_ammoIndex];
			currentGood.visible = false;
			currentGood.collidable = false;
			currentGood.active = false;
			
			direction == 1 ? _ammoIndex--: _ammoIndex++;
						
			n = arrAmmo.length-1;
			if (_ammoIndex > n) _ammoIndex = 0;
			if (_ammoIndex < 0) _ammoIndex = n;
			
			nextGood = arrAmmo[_ammoIndex]
			nextGood.visible = true;
			ammo = ammoGoods[_ammoIndex];
			
			setAmmoCanBuy((V.playerMoney >= ammo.price && !ammo.isBought), ammo);
			
		}
		
		private function setAmmoCanBuy(canBuy:Boolean, checkedAmmo:Ammo):void
		{
			_ammoPriceTxt.color = 0xFF0000;
			if (canBuy)
			{
				_ammoPriceTxt.text = "Buy for: " + checkedAmmo.price.toString() + "$";
				_currentScreenUI.shopBtns[_ammoIndex].collidable = true;
				_currentScreenUI.shopBtns[_ammoIndex].active = true;
			}
			else 
			{
				if (checkedAmmo.isBought)
				{
					_ammoPriceTxt.text = "It's Your ammo!";
					_ammoPriceTxt.color = 0xFFFFFF;
					_currentScreenUI.shopBtns[_ammoIndex].collidable = false;
					_currentScreenUI.shopBtns[_ammoIndex].active = false;
					//trace("inAcessibility", _ammoIndex, _currentScreenUI.shopBtns);
				}
				else 
				{
					_ammoPriceTxt.text = "Price: " + checkedAmmo.price.toString() + "$.\nYOU HAVE NOT ENOUGH MONEY!";
				}
			}
		}
		
		
		private function onBuyAmmo(which:int):void 
		{
			//trace("onBuyAmmo", which);
			var ammo:Ammo, ammoBtn:Button;
			
				ammo = ammoGoods[which - 1];
				
			if (!ammo.isBought)
			{
				ammo.isBought = true;
				V.playerMoney -= ammo.price;
				switch (which) 
				{
					case 1:
						V.playerMagazins1 = ammo.bulletsMagazinesQnt;
						V.playerBullets1 = ammo.bulletsQnt;
					break;
					case 2:
						V.playerMagazins2 = ammo.bulletsMagazinesQnt;
						V.playerBullets2 = ammo.bulletsQnt;
					break;
					case 3:
						V.playerMagazins3 = ammo.bulletsMagazinesQnt;
						V.playerBullets3 = ammo.bulletsQnt;
					break;
				}
				
			}
			
			_ammoMoneyTxt.text = "Money: " + String(V.playerMoney)+"$";
			_ammoPriceTxt.text = "It's Your ammo!";
			_ammoPriceTxt.color = 0xFFFFFF;
			
			ammoBtn = _currentScreenUI.shopBtns[_ammoIndex];
			ammoBtn.collidable = false;
			ammoBtn.active = false;
		}
		
		
		

		
		private function onSounds(isOn:Boolean):void
		{
			isOn ? V.soundsVolume = 0: V.soundsVolume = 0.5;
			Sfx.setVolume("sound", V.soundsVolume);
			Sfx.setVolume("soundShot", V.soundsVolume);
		//	trace("function onSounds()", V.soundsVolume);
		}
		
		private function onMusics(isOn:Boolean):void
		{
			
			isOn ? V.musicsVolume = 0: V.musicsVolume = 0.7;
			Sfx.setVolume("music", V.musicsVolume);
			//trace("function onMusics()", V.musicsVolume);
		}
		
		private function onHints(isOn:Boolean):void
		{
			V.hints = !isOn;
		}
	}

}