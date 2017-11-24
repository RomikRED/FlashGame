package entities
{
	import brain.ConditionList;
	import brain.Schedule;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.motion.CubicMotion;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.tweens.motion.LinearPath;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Draw;
	import worlds.GameWorld;
	import brain.pathFinding.*;
	import brain.sb.*;
	import net.flashpunk.utils.Input;
	import utils.*;
	import net.flashpunk.Sfx;
	
	public class Enemy extends Entity
	{
		//состояния
		public const STATE_STAND:uint = 1;
		public const STATE_MOVE:uint = 2;
		public const STATE_PURSUIT:uint = 3;
		public const STATE_ATTACK:uint = 4;
		//условия
		public const CONDITION_STAND:uint = 1;
		public const CONDITION_MOVE:uint = 2;
		public const CONDITION_SEE_ENEMY:uint = 3;
		public const CONDITION_CAN_ATTACK:uint = 4;
		public const CONDITION_OBSTACLE:uint = 5;
		//действия
		public const SCHEDULE_STAND:String = "stand";
		public const SCHEDULE_MOVE:String = "move";
		public const SCHEDULE_PURSUIT:String = "pursuit";
		public const SCHEDULE_ATTACK:String = "attack";
		//public const COLLTYPE:String = "enemy";
		
		public const THINKDELAY:uint = FP.frameRate *.25;
		//public static var cellSize:int;
		
		public var path:Vector.<Node> = new Vector.<Node>();
		public var parentWorld:GameWorld;
		public var grid:GridPathfinding;
		
			
		private var _alive:Boolean;
		
		/**Список всех наборов действий*/
		protected var _schedulesList:Array;
		/**Текущий набор действий*/
		protected var _schedule:Schedule;
		/** Интервал между мозговым штурмом*/
		protected var _thinkInterval:int;
		/** Текущее состояние*/
		protected var _state:uint;
		/** Условия на основе которых принимается решение*/
		protected var _conditions:ConditionList;
		/**Задержка между действиями*/
		protected var _actionDelay:int;
		protected var _actionDelayBase:int;
		
		protected var _targetPlayer:Player;	//Ціль 
		protected var _vision:Player;
		protected var _sense:Player;
		protected var _floor:int;
		
		protected var _damage:Number = 0;
		protected var _sensor:Number = 0;
		protected var _startHealth:Number = 0;
		protected var _fullHealth:Image;
		protected var _emptyHealth:Image;
		protected var _enemySpr:Spritemap;
		private var _txtHeadShot:Text;
		
		//movement vars
		private var _motion:LinearPath;
		private var _speed:Number;
		private var _health:Number;
		public  var variety:int;		
		private var _direction:Number = 0;
		private var _currentDirection:Number = 0;
		private var _pathLength:int;

		private var _entImgScale:Number;
		//private var _revers:Boolean;
	
		private var _prevMotion:Number;
		private var _flipinterval:int;
		private var _flipDelay:int = FP.frameRate;
		private var _isDead:Boolean;
		
		public var headShot:Boolean = false;
		public var multiplify:Number = 1;
		public var sprColor:uint;
		
		//private var _endNodeId:int;
		//private var _startNodeId:int;
		//private var _currentpath:Vector.<Point> = new Vector.<Point>;
		protected var _sfxZombVoice:Sfx;
		protected var _sfxZombAttack:Sfx;
		protected var _sfxZombDie:Sfx;
		
		
		
		public function Enemy()
		{
			
			_enemySpr = new Spritemap(Assets.ENEMY, 142, 80, onAnimEnd);
			_fullHealth = new Image(new BitmapData(15, 2, false, 0x00FF00));
			_emptyHealth = new Image(new BitmapData(15, 2, false, 0xFF0000));	
			_txtHeadShot = new Text("HEAD\nSHOT", 0, 0, { font:"orbitron light", size: 9, color: 0xD4D4D4, align: "center"});
		}
		
		public function setPosition(x:int, y:int):void
		{
			// Set starting position.
			this.x = x;
			this.y = y;
		}
		
		override public function added():void 
		{
			initShedules();
			setHeroGraphics();
			
			type = "enemy";
			collidable = true;
			layer = 7;
			
			_alive = true;
			_isDead = false;
			_speed = 70;
			_actionDelay = 0;
			_thinkInterval = 0;
			//_revers = false;
			_pathLength = path.length-1;
			_conditions = new ConditionList();
			_actionDelayBase = int(FP.frameRate * .5);
			
			_fullHealth.visible = _emptyHealth.visible = false;
			
		}
		
		private function initShedules():void
		{
			/**набор действий Ожидание*/
			var stand:Schedule = new Schedule(SCHEDULE_STAND);
			stand.addFewTasks([onInitStand, onStand]);
			stand.addFewInterrupts([CONDITION_SEE_ENEMY, CONDITION_CAN_ATTACK]);
			/**набор действий Перемещение*/
			var move:Schedule = new Schedule(SCHEDULE_MOVE);
			move.addFewTasks([onInitMove, onMove]);
			move.addFewInterrupts([CONDITION_OBSTACLE, CONDITION_CAN_ATTACK, CONDITION_SEE_ENEMY]);
			/**набор действий Преследование*/
			var pursuit:Schedule = new Schedule(SCHEDULE_PURSUIT);
			pursuit.addFewTasks([onInitPursuit, onPursuit]);
			pursuit.addFewInterrupts([CONDITION_OBSTACLE, CONDITION_CAN_ATTACK]);
			/**набор действий Атака*/
			var attack:Schedule = new Schedule(SCHEDULE_ATTACK);
			attack.addFewTasks([onInitAttack, onAttack]);
			/**список наборів дій*/
			_schedulesList = [stand, move, pursuit, attack];//Помещаем наборы действий в список			
			setSchedule(SCHEDULE_STAND);
		}
		
		private function setHeroGraphics():void
		{
			var fr:uint = 9;
			switch (variety)
			{
				case 1: 
					_enemySpr.add("stand", [11], 1);
					_enemySpr.add("pursuit", [0, 1, 2, 3, 4,5,6,7,8,9,10], fr);
					_enemySpr.add("attack", [11, 12,13,14,15,16,17], fr);
					_enemySpr.add("die", [22,23,24,25,25,25,26,27], fr,false);
					_damage = 1*multiplify;
					_health = _startHealth = 20*multiplify;
					_sfxZombVoice = new Sfx(Assets.SFX_ZOMBPursuit1, null, "sound");
					_sfxZombAttack = new Sfx(Assets.SFX_ZOMBATTACK1, null, "sound");
					_sfxZombDie = new Sfx(Assets.SFX_ZOMBDEAD1, null, "sound");
					break;
				case 2: 
					_enemySpr.add("stand", [44], 1);
					_enemySpr.add("pursuit", [33,34,35,36,37,38,39,40,41,42,43], fr);
					_enemySpr.add("attack", [44,45,46,47,48,49,50,51], fr);
					_enemySpr.add("die", [55,56,57,58,59,60,61], fr,false);
					_damage = 2*multiplify;
					_health = _startHealth = 25*multiplify;
					_sfxZombVoice = new Sfx(Assets.SFX_ZOMBPursuit2, null, "sound");
					_sfxZombAttack = new Sfx(Assets.SFX_ZOMBATTACK2, null, "sound");
					_sfxZombDie = new Sfx(Assets.SFX_ZOMBDEAD2, null, "sound");
					break;
				case 3: 
					_enemySpr.add("stand", [77], 1);
					_enemySpr.add("pursuit", [66,67,68,69,70,71,72,73,74], fr-2);
					_enemySpr.add("attack", [77,78,79,80,81,82,83], fr);
					_enemySpr.add("die", [88,89,90,91,92,93,94], fr+3,false);
					_damage = 3*multiplify;
					_health = _startHealth = 30*multiplify;
					_sfxZombVoice = new Sfx(Assets.SFX_ZOMBPursuit3, null, "sound");
					_sfxZombAttack = new Sfx(Assets.SFX_ZOMBATTACK3, null, "sound");
					_sfxZombDie = new Sfx(Assets.SFX_ZOMBDEAD3, null, "sound");
					break;
			}		
			
			_enemySpr.color = sprColor;
			_emptyHealth.x = _fullHealth.x = _txtHeadShot.x = _enemySpr.x - _emptyHealth.width*.5;
			_emptyHealth.y = _fullHealth.y = _enemySpr.y - _enemySpr.height * 0.5 - 5;
			_txtHeadShot.y = _emptyHealth.y - 30;
			
			_fullHealth.scaleX = _health / _startHealth;
			
			_enemySpr.visible = true;
			_emptyHealth.visible = true;
			_fullHealth.visible = true;
			_txtHeadShot.visible = false;
			_enemySpr.play("stand");
			_enemySpr.scale = 1;
			_enemySpr.centerOrigin();
			setHitbox(30, 60);
			centerOrigin();
			
			graphic = new Graphiclist(_enemySpr, _emptyHealth, _fullHealth, _txtHeadShot);
		}
		
		protected function getConditions():void
		{
			_conditions.clear();
			vision();
			sense();
			_conditions.set(CONDITION_STAND);
			_conditions.set(CONDITION_MOVE);
		}
		
		protected function selectNewSchedule():void
		{
			switch (_state)
			{
			case STATE_STAND: 
				// Могу атаковать!
				if (_conditions.contains(CONDITION_CAN_ATTACK))
				{
					setSchedule(SCHEDULE_ATTACK);
				}
				else
					// Вижу врага, но не могу атаковать.
					if (_conditions.contains(CONDITION_SEE_ENEMY) && !_conditions.contains(CONDITION_CAN_ATTACK))
					{
						setSchedule(SCHEDULE_PURSUIT);
					}
					else
						// Могу идти и нет препятствия.
						if (_conditions.contains(CONDITION_MOVE) && !_conditions.contains(CONDITION_OBSTACLE))
						{
							setSchedule(SCHEDULE_MOVE);
						}
						else
							// Стоим.
						{
							setSchedule(SCHEDULE_STAND);
						}
				break;
			
			case STATE_MOVE: 
			case STATE_PURSUIT: 
			case STATE_ATTACK: 
				// Могу атаковать!
				if (_conditions.contains(CONDITION_CAN_ATTACK))
				{
					setSchedule(SCHEDULE_ATTACK);
				}
				else
					// Вижу врага, не могу атаковать и нет препятствия.
					if (_conditions.contains(CONDITION_SEE_ENEMY) && !_conditions.contains(CONDITION_CAN_ATTACK) && !_conditions.contains(CONDITION_OBSTACLE))
					{
						setSchedule(SCHEDULE_PURSUIT);
					}
					else if (_conditions.contains(CONDITION_STAND))
					{
						setSchedule(SCHEDULE_STAND);
					}
				break;
			}
		}
		
		protected function setSchedule(value:String):void
		{
			for each (var s:Schedule in _schedulesList)
			{
				if (s != null && s.name == value)
				{
					_schedule = s;
					_schedule.reset();
					break;
				}
			}
			
			switch (value) // Переключение состояния.
			{
			case SCHEDULE_STAND: 
				_state = STATE_STAND;
				break;
			case SCHEDULE_MOVE: 
				_state = STATE_MOVE;
				break;
			case SCHEDULE_PURSUIT: 
				_state = STATE_PURSUIT;
				break;
			case SCHEDULE_ATTACK: 
				_state = STATE_ATTACK;
				break;
			}
		}
		
		protected function vision():void
		{
			//get nearest enemy
			if(_vision == null /*|| _vision.currentFloor == _floor*/) _vision = world.classFirst(Player) as Player;
			else if (_vision.alive)
			{
				//if (_vision.currentFloor <= _floor+1 && _vision.currentFloor >= _floor-1)
				if(_vision.currentFloor == _floor || FP.distance(x,y,_vision.x,_vision.y) <= 60)
				{
					_targetPlayer = _vision;
					//_sensor = _target.halfWidth;
					_sensor = 35;
					_conditions.set(CONDITION_SEE_ENEMY);
				}
			}
		}
		
		protected function sense():void
		{
			_sense = collide("hero", x, y) as Player;
			if (!_sense) return;
			_conditions.set(CONDITION_CAN_ATTACK);
		}
		
		protected function getPath():Vector.<Point>
		{
			var xpos:int, ypos:int,
				startNodeId:int = 0, endNodeId:int = 0,
				//pathTarget:Vector.<Point>,
				sign:Number, randomSteps:int;
				
			xpos = Math.floor(x / 20/*cellSize*/);
			ypos = Math.floor(y / 20/*cellSize*/);
				startNodeId = grid.getNode(xpos, ypos).id;
			
			switch (_state) 
			{
				case STATE_MOVE:
					AntMath.randomRangeInt(1, 2) > 1 ? sign = 1 : sign =-1;	
					randomSteps = AntMath.randomRangeInt(10, 25) * sign;
					endNodeId = startNodeId +  randomSteps;
					//FP.clamp(endNodeId, 0, _pathLength);
					if (endNodeId < 0) endNodeId = 0;
					if (endNodeId > _pathLength) endNodeId = _pathLength;
				break;
				case STATE_PURSUIT:
					xpos = Math.floor(_targetPlayer.x / 20/*cellSize*/);
					ypos = Math.floor(_targetPlayer.y / 20/*cellSize*/);
					endNodeId = grid.getNode(xpos, ypos).id;
				break;
			}
			
			if (endNodeId && startNodeId && startNodeId != endNodeId) 
			{
				//pathTarget = fillPath(startNodeId, endNodeId);
				return fillPath(startNodeId, endNodeId);//pathTarget;
			}
			else return null;
		}
		
		private function fillPath(startIndex:int, endIndex:int):Vector.<Point>
		{
			var vectorPoints:Vector.<Point> = new Vector.<Point> ,
				i:int = startIndex, j:int = endIndex, rev:Boolean;
			
			rev = (i > j);
			//if (i > j) 	{/*_revers = true;*/ rev = true;}
			//else		{/*_revers = false;*/ rev = false;}
					
			while (i != j) 
			{
				rev ? i--: i++;
				vectorPoints.push(new Point(path[i].x * 20, path[i].y * 20));
			
			}
			//if (vectorPoints.length >= 2) _enemySpr.flipped = vectorPoints[0].x > vectorPoints[1].x;
			
			return vectorPoints;
		}
		
		protected function followPath(currentPath:Vector.<Point>):LinearPath
		{
			var motion:LinearPath = new LinearPath(null, ONESHOT);
			for each (var p:Point in currentPath) 
			{
				motion.addPoint(p.x, p.y);
			}
			return motion;
		}
		
		
		protected function onAnimEnd():void
		{
			switch (_enemySpr.currentAnim) 
			{
				case "attack":
					if (_sense && _sense.alive) _sense.hurtPlayer(_damage);
				//	trace("attack animation");
				break;
				case "die":
					if (_isDead == false) 
					{
						_isDead = true;
						FP.alarm(5, makeDead);
					}
				break;
				
			}
			
		}
		
		private function makeDead():void
		{
			parentWorld.deadEnemies.push(this);
			_enemySpr.visible = false;
		}
		
		protected function onInitStand():Boolean
		{
			if (_motion != null) _motion.cancel();
			_actionDelay = FP.frameRate * AntMath.randomRangeInt(1, 3);//60 * (15-30)
			return true;
		}
		
		protected function onStand():Boolean
		{
			_enemySpr.play("stand");
			_actionDelay--;
			if (_actionDelay <= 0) return true;
			return false;
		}
		
		protected function onInitMove():Boolean
		{
			if (_motion != null) _motion.cancel();
			_actionDelay = FP.frameRate * AntMath.randomRangeInt(_actionDelayBase, int(_actionDelayBase*4));
			var points:Vector.<Point> = getPath();
			_motion = followPath(points);
			if (_motion.pointCount >= 1)
			{
				_motion.object = this;
				_motion.setMotionSpeed(AntMath.randomRangeInt(int(_speed-_speed*0.25), int(_speed-_speed*0.5)));
				addTween(_motion, true);
				_enemySpr.play("pursuit");
				//_zombVoice.play(V.soundsVolume*0.5);
				return true;
			}
			return false;
		}
		
		protected function onMove():Boolean
		{
			if (_motion.percent == 1) 
			{
				_motion.cancel();
				return true;
			}
			
			_actionDelay--;
			if (_actionDelay <= 0) return true;
			return false;
		}
		
		protected function onInitPursuit():Boolean
		{
			if (_motion != null) _motion.cancel();
			_actionDelay = FP.frameRate * AntMath.randomRangeInt(_actionDelayBase, int(_actionDelayBase * 5));
			var pointsPursuit:Vector.<Point> = getPath();
			_motion = followPath(pointsPursuit);
			if (_motion.pointCount >= 2)
			{
				_motion.object = this;
				_motion.setMotionSpeed(AntMath.randomRangeInt(int(_speed-_speed*0.25),_speed));
				addTween(_motion, true);
				_enemySpr.play("pursuit");
				return true;
			}
			
			
			return false;
		}
		
		protected function onPursuit():Boolean
		{
			if (_targetPlayer == null || _sense) return true;
			
			var d:Number = distanceFrom(_targetPlayer);
			if (d <= _sensor || _motion.percent == 1 ||_targetPlayer.alive == false) 
			{
				_motion.cancel();
				return true;
			}
			
			
			if (d <= 150 && _sfxZombVoice.playing == false )
			{
				//trace("d <= 100");
				_sfxZombVoice.play();
			}
			
			_actionDelay--;
			if (_actionDelay <= 0) return true;
			return false;
		}
		
		protected function onInitAttack():Boolean
		{
			if (_motion != null) _motion.cancel();
			return true;
		}
		
		protected function onAttack():Boolean
		{
			if (_sense == null || _sense.alive == false) return true;
			if(_sfxZombAttack.playing == false)_sfxZombAttack.play();
			_enemySpr.play("attack");
			return false;
		}
		
		public function hurt(damage:Number = 0):void
		{
			if (_alive == false) return;
			if (onCamera == false) return;
			//trace(this, _health, damage);
//			trace(_health);
			_health -= damage;
			_fullHealth.scaleX = _health / _startHealth;
			_fullHealth.visible = _emptyHealth.visible = true;
			
			if (headShot) 
			{
				_txtHeadShot.visible = true;
				if(_health <= 0) AntStatistic.track("headshot", 1);
				headShot = false;
			}
				
			FP.alarm(1, hideHealth);
			
			if (_health <= 0)
			{
				_sfxZombDie.play();
				collidable = false;
				layer = 9;
				
				_emptyHealth.visible = false;
				_fullHealth.visible = false;
				_enemySpr.play("die");
				_alive = false;
				_vision = null;
				_sense = null;
				_schedulesList.length = 0;
				_conditions.clear();
				_motion.cancel();
				
				AntStatistic.track("killsEnemy", 1);
				
				var lottery:int = AntMath.randomRangeInt(0, 20);
				var collecting:CollectThing, collectType:int;
				switch (lottery) 
				{
					case 0: collectType = 0;	/* CollectThing.MAGAZINE;*/ break;
					case 5: collectType = 2;	/* CollectThing.BATTERIES; */ break;
					case 10: collectType = 3;	/*CollectThing.GRENAD; */ break;
					default: collectType = 1; 	//CollectThing.MONEY;
				}
				//HELP PLAYER
				var player:Player = parentWorld.playerG;
				if (player.bulletsMagazin == 0)
				{
					collectType = 0;//CollectThing.MAGAZINE;
				}
				if (player.money < C.PRICE_GRENADE) 
				{
					if (player.haveLevelKey && player.grenades == 0)
					{
						collectType = 3;//CollectThing.GRENAD;
					}
					
				}
				
				
				collecting = new CollectThing(x, y, collectType);
				parentWorld.add(collecting);
			}
		}
		
		private function hideHealth():void 
		{
			_fullHealth.visible = _emptyHealth.visible = false;
			_txtHeadShot.visible = false;
		}
		
		
		//internal var randomColour:uint = Math.random() * 0xFFFFFF;
		override public function render():void
		{
			/*if (st && fn)
			{
				Draw.circle(st.x, st.y, 3, 0x00FF00);
				Draw.circle(fn.x, fn.y, 3, 0xFFFF00);
			}*/
			
			/*if (_enemyleader) 
			{
				Draw.linePlus(x, y, _enemyleader.x, _enemyleader.y, 0x00FF00);
			}*/
			
			//Draw.linePlus(x, y, x + _sensor * _direction, y);
			//Draw.circle(x + _sensor * _direction, y, 2,0x0000FF);
			super.render();
		}
		
		override public function update():void
		{
			if (_alive == false) return;
			//thinking
			_thinkInterval++;
			if (_thinkInterval > THINKDELAY)
			{
				_thinkInterval = 0;
				getConditions();
				if (_schedule.isCompleted(_conditions)) selectNewSchedule();
				
				if (x != _prevMotion)
				{
					_enemySpr.flipped = (x < _prevMotion);
					_prevMotion = x;
				}
				
				//set floor
				_floor = Math.floor(this.y / 200);//Math.floor(this.y / 200);
				
				/*if (collidePoint(x, y, FP.world.mouseX, FP.world.mouseY)) 
				{
					
					if (_motion) 
					{
						trace("_schedule", _schedule, _motion.percent);
					}
				}*/
			}
			
			//EVERY TICK!!
			if (_schedule != null) _schedule.update();
			super.update();
		}
	}
}