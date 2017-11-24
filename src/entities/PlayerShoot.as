package entities 
{
	import lit.Light;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import flash.ui.Mouse;
	import net.flashpunk.FP;
	import flash.geom.Point;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.graphics.Spritemap;
	import flash.display.BitmapData;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.motion.QuadMotion;
	import worlds.ShootWorld;
	import worlds.MenuWorld;
	/**
	 * ...
	 * @author 
	 */
	public class PlayerShoot extends Player 
	{
		private var _playerDamageImg:Image;
		private var _fireStart		:Point;
		private var _fireEnd		:Point;
		private var _canshoot		:Boolean;
		private var _sprHandShot	:Spritemap;
		private var _shadowshot		:Light;
		
		public var parentsWorld		:ShootWorld;
		public var torchLightWidth:Number;
		public var playerDamage:Text;
		
		
		public function PlayerShoot(_x:int=0, _y:int=0, _layer:int=0) 
		{
			super(_x, _y, _layer);
		}
		
		override public function added():void 
		{
			_stringWeap = "gun";
			_sprHandShot.play("find" + _stringWeap);
			playerDamage.text = String(int(health / startHealth * 100)) + "%";
			_shadowshot = parentsWorld.shadowShot;
			textGrenades.text = String(grenades);
			textMoney.text = String(money);
			textBatteries.text = String(batteries);
		}
		
		override protected function init():void 
		{
			type = "shoothero";
			alive = true;
			currentWeapon = MenuWorld.ammoGoods[0];
			
			// Define input keys.
			//Input.define("FIRE", Key.E);
			Input.define("CHWEAP", Key.DIGIT_1, Key.DIGIT_2, Key.DIGIT_3);
			
			
			_spdX = 0;
			_fireStart = new Point();
			_fireEnd = new Point();
			_shoottime = 0;	
			torchLightWidth = 0;
		}
		
		
		override protected function addPlayerGraphics():void 
		{
			_sprHandShot = new Spritemap(Assets.WEAPON_SHOOT, 384, 245, animEnd);
			_sprHandShot.add("fire_gun", 	[1, 0], 30);
			_sprHandShot.add("find_gun", 	[0], 	30);
			_sprHandShot.add("fire_Mk", 	[2, 3], 30);
			_sprHandShot.add("find_Mk", 	[2], 	30);
			_sprHandShot.add("fire_Ak", 	[4, 5], 30);
			_sprHandShot.add("find_Ak", 	[4], 	30);
			
			_playerDamageImg = new Image(Assets.DAMAGE);
			_playerDamageImg.alpha = 0;
			_playerDamageImg.centerOrigin();
			_playerDamageImg.x = 70;
			
			playerDamage = new Text("", 170, 50, {font:"orbitron bold", size: 16, color: 0xC0C0C0});
			//_fullHealth = 	new Image(new BitmapData(300, 8, false, 0x00FF00));
			//_emptyHealth = 	new Image(new BitmapData(300, 8, false, 0xFF0000));
			
			graphic = new Graphiclist(_sprHandShot, _playerDamageImg/*, _emptyHealth, _fullHealth*/);
		}
		
		private function animEnd():void 
		{
			_sprHandShot.play("find_"+_stringWeap);
		}
		
		override public function update():void 
		{
			if(Input.mouseY<=80)
			{
				Mouse.show();
				return;
			}
			else 
			{
				Mouse.hide();	
			}
			
			
			shotting();
			torchupdate();
		}
		
		override public function render():void 
		{
			super.render();
			Draw.circlePlus(x + 40, y + 40, 1, 0xFF0000);
			Draw.circle(x + 40, y + 40, 15, 0xEBEBEB);
			torch.y = y;
			torch.x = x-torchLightWidth;
		}
		
		
		override protected function fire():void 
		{
			FP.alarm(0.05, screenShake, ONESHOT);
			
			_sprHandShot.play("fire_" + _stringWeap);
			
			//TODO create bullet
			var bullet:Bullet = parentsWorld.create(Bullet, false) as Bullet;
				bullet.bulletVariety = currentWeapon.ammoVariety;
				bullet.x = x + 40;
				bullet.y = y + 40;
				bullet.isShootWorld = true;
				bullet.visible = false;
			world.add(bullet);
			
			_shadowshot.x = torch.x;
			_shadowshot.y = torch.y;
			_shadowshot.active = true;
			FP.alarm(0.1, endShot);
		}
		
		override protected function setGameOver():void 
		{
			parentsWorld.parentGWorld.parentWorld.setScreenUI(10);
			FP.world = parentsWorld.parentGWorld.parentWorld;
		}
		
		override public function hurtPlayer(oncedamage:Number = 0):void 
		{
			_playerDamageImg.alpha = 1 - health / startHealth + 0.1;
			playerDamage.text = String(int(health / startHealth * 100)) + "%";
	
			super.hurtPlayer(oncedamage);
					
			if (health<=0 && type == "shoothero") 
			{
				//ShootEnemy.playerIsDie = true;
				setGameOver();
			}
		}
		
		private function endShot():void 
		{
			_shadowshot.active = false;
		}
	}

}