package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.FP;
	import utils.AntMath;
	import worlds.MenuWorld;
	/**
	 * ...
	 * @author ...
	 */
	public class MenuUI extends Entity 
	{
		public static var uiDELAY:Number = 0.1;
		
		private var _menuTxt:Vector.<Text>
		//private var _menuTween:LinearMotion;
		//private var _isActive:Boolean;
		
		public var isMain:Boolean;
		public var shopBtns:Array;
		public var lvlBtns:Array;
		public var menuButtons:Array;
		
		
		public function MenuUI() 
		{
			shopBtns = [];
			lvlBtns = [];
			menuButtons = [];
			_menuTxt = new Vector.<Text>();
			
			//_menuTween = new LinearMotion(setButtonsActiv, ONESHOT);
			//_menuTween.object = this;
			//addTween(_menuTween, false);
			
			//graphic = uiImg;
			
			super();
		}
		
		override public function added():void 
		{
			world.addList(menuButtons);
			world.addList(shopBtns);
			world.addList(lvlBtns);
			for each (var t:Text in _menuTxt) addGraphic(t);
			
			super.added();
		}
		
		public function addButtons(b:*, whichBtns:String):void 
		{
			b.collidable = false;
			b.visible = false;
			b.active = false;
			
			switch (whichBtns) 
			{
				case "onBuyAmmo": shopBtns.push(b); break;
				case "onLevel": lvlBtns.push(b); break;
				default:  menuButtons.push(b); break;
			}
		}
		
		public function addText(t:Text):void
		{
			t.visible = false;
			t.active = false;
			_menuTxt.push(t);
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		public function setUI(isOn:Boolean):void
		{
			collidable = isOn;
			active = isOn;
			visible = isOn;
			
			for each (var b:* in menuButtons) {setActivityBtn(b, isOn);}
			
			if (_menuTxt.length > 0)
			{
				for each (var t:Text in _menuTxt) {t.active = isOn;	t.visible = isOn;}
			}
			
			if (shopBtns.length > 0) 
			{
				for each (var bs:Button in shopBtns) {setActivityBtn(bs, false); }
				setActivityBtn(shopBtns[0], isOn);
			}
			
			if (lvlBtns.length > 0) 
			{
				for each (var bl:Button in lvlBtns) 
				{
					setActivityBtn(bl, isOn);
					if(isOn) bl.active = MenuWorld.stageLevelList[bl.argument-1].opened;
				}
			}
		}
		
		
		
		
		private function setActivityBtn(b:*, activity:Boolean):void
		{
			b.active = activity;
			b.visible = activity;
			b.collidable = activity;
		}
		
	}

}