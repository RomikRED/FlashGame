package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.tweens.motion.LinearPath;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import utils.signals.AntSignal;
	import worlds.GameWorld;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author ...
	 */
	public class Popup extends Entity 
	{
		public var popupTitle:Text;
		public var popupDesc:Text;
		public var popupImg:Image;
		public var onViewComplete:AntSignal;
		
		//private var _parentGW:GameWorld;
		//private var _visualList:Graphiclist;
		private var _finish:Point;
		private var _achieveSlot:int;
		
		public function Popup(userData:Object, beginP:Point, endP:Point, slot:int=0) 
		{
			
			var txtOpt:Object = { font:"orbitron light", size: 10, color: 0xFF0000};
			
			popupImg = userData.pic;
			
			popupTitle = new Text(userData.title, popupImg.x, popupImg.height + 34, txtOpt);
			popupTitle.smooth = true;
			popupTitle.visible = false
			
			popupDesc = new Text(userData.desc, popupImg.x, popupImg.height + 54, 	txtOpt);
			popupDesc.smooth = true;
			popupDesc.visible = false;
			
			onViewComplete = new AntSignal(Popup, int);
			_achieveSlot = slot;
			
			setHitboxTo(popupImg);
			graphic = new Graphiclist(popupImg, popupTitle, popupDesc);
			setPosition(beginP, endP);
		}
		
		public function setPosition(start:Point, finish:Point):void
		{
			x = start.x;
			y = start.y;
			
			_finish = finish;
		}
		
		override public function added():void 
		{
			tweenPopup();
			super.added();
		}
		
		private function tweenPopup():void 
		{
			var tweenPopup:MultiVarTween;
			tweenPopup = new MultiVarTween(tweenPopOut, ONESHOT);
			tweenPopup.tween(this, {x:_finish.x, y:_finish.y}, 3, Ease.quadIn);
			//tweenPopup.tween(popupImg, {scale:1}, 2, Ease.bounceOut);
			FP.world.addTween(tweenPopup, true);
		}
		
		private function tweenPopOut():void 
		{
			trace("tweenPopOut");
			visible = false;
			//onViewComplete.dispatch(this, _achieveSlot);
			
			FP.alarm(5, kill, ONESHOT);
		}
		
		private function kill():void
		{
			FP.world.remove(this);
		}
			
		override public function update():void 
		{
			super.update();
		}
	}

}