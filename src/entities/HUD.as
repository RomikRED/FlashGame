package entities 
{
	import flash.system.ImageDecodingPolicy;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import worlds.GameWorld;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.utils.Ease;
	
	public class HUD extends Entity 
	{
		public static const COLL_HUD:String = "hud";
		
		public var achievements:Vector.<Object> = new Vector.<Object>();
		private var _viewAchieve:Boolean;
		private var _sfxAchieve:Sfx;
		private var _earnedNum:int;
		
		public function HUD(x:Number, y:Number, layer:int) 
		{
			this.x = x; 
			this.y = y;
			this.layer = layer;
			//type = COLL_HUD;
			//setHitbox(1920, 80);
			achievements.push(
				{achX:223, achImg:null, achTitle:null, achDesc:null, viewing:false, earned:false},
				{achX:300, achImg:null, achTitle:null, achDesc:null, viewing:false, earned:false},
				{achX:389, achImg:null, achTitle:null, achDesc:null, viewing:false, earned:false}/*,
				{achX:459, achImg:null, achTitle:null, achDesc:null, viewing:false, earned:false}*/);
			_sfxAchieve = new Sfx(Assets.SFX_ACHIEVE, null, "sound");
		}
		
		public function addAchieveToHUD(anAwa:Object, aSlot:int):void
		{
			//trace("add  OBJ  HUD");
			var currentAch:Object = achievements[aSlot - 1];
				currentAch.achImg = anAwa.pic;
				currentAch.achImg.x = 20;
				currentAch.achImg.y = y + 200;
				//trace(this.x, currentAch.achImg.x, this.y, currentAch.achImg.y);
				currentAch.achImg.scale = 0.17;
				currentAch.achImg.visible = true;
				currentAch.earned = false;
			_earnedNum = aSlot - 1;
			
			var txtOpt:Object = {font:"orbitron bold", size: 14, color: 0xFFFFFF, align: "left"};
			currentAch.achTitle = new Text(anAwa.title+"\n"+anAwa.desc, currentAch.achX, 80, txtOpt);
			currentAch.achTitle.smooth = true;
			currentAch.achTitle.visible = false;
			
			addGraphic(new Graphiclist(currentAch.achImg, currentAch.achTitle));
			tweenAchieves(currentAch);
		}
		
		private function tweenAchieves(achieve:Object):void 
		{
			
			var tweenedAch:MultiVarTween = new MultiVarTween(setEarned, 2);
				tweenedAch.tween(achieve.achImg, {x:achieve.achX, y:20}, 1, Ease.backIn);
			achieve.viewing = true;
			FP.world.addTween(tweenedAch, true);
			_sfxAchieve.play(V.soundsVolume*0.2);
		}
		
		private function setEarned():void 
		{
			achievements[_earnedNum].earned = true;
		}
		
		
				
		override public function update():void 
		{
			super.update();
			for each (var slot:Object in achievements) 
			{
				if (slot.viewing)
				{
					_viewAchieve = collideRect(Input.mouseX, Input.mouseY, slot.achX, 20, 50, 50);
					slot.achImg.scale = 0.17;
					
					if (slot.earned) 
					{
						slot.achImg.x = slot.achX;
						slot.achImg.y = 20;
					}
					
					slot.achTitle.visible = _viewAchieve;
				}
			}
		}
		
		override public function render():void 
		{
			super.render();
			//trace(Input.mouseX, Input.mouseY, FP.screen.x, FP.screen.y + 40);
			//if(collideRect(Input.mouseX, Input.mouseY, 0, 40, 40, 40)) Draw.rectPlus(x, y + 40, 40, 40, 0x00FF00, 1, false, 2);
		}
	}

}