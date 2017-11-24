package  lit
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.Tween;
	import utils.AntMath;
	import net.flashpunk.FP;
	
	import utils.AntStatistic;
	/**
	 * ...
	 * @author Noel Berry
	 */
	public class Light
	{
		
		public var x:int = 0;
		public var y:int = 0;
		public var scale:Number = 1;
		public var alpha:Number = 1;
		public var image:Image = null;
		public var rotate:Number = 0;
		public var active:Boolean = true;
		public var base:LightCollidableBase;
		private var _blinks:int;
		
		public function Light(lx:int, ly:int, limage:Image, lightBaseActive:Boolean = false, lscale:Number = 1, lalpha:Number = 1, lrotate:Number = 0, lactive:Boolean = true) 
		{
			x = lx;
			y = ly;
			scale = lscale;
			alpha = lalpha;
			image = limage;
			rotate = lrotate;
			active = lactive;
			
			if (lightBaseActive) 
			{
				base = new LightCollidableBase(x + image.width * 0.4, y);
				base.parent = this;
			}
		}
		
		public function badBattery():void
		{
			var lightSrtength:VarTween = new VarTween(deactivate, Tween.ONESHOT);
			lightSrtength.tween(this, "alpha", 0, Number(AntMath.randomRangeInt(5, 10)));
			FP.world.addTween(lightSrtength, true);
		}
		
		private function deactivate():void
		{
			this.active = false;
		}
		
		public function blink():void
		{
			_blinks++;
			switch (_blinks) 
			{
				case 1:
					blinkFirsth();
				break;
				case 2:
					blinkTwise();
				break;
			}
			if (_blinks == 3) 
			{
				active = false;
				AntStatistic.track("brokeLamp", 1);
			}
			trace(_blinks);
		}
		
		private function blinkFirsth():void 
		{
			active = false;
			FP.alarm(FP.random * 2, blinkOn as Function, 2);
		}
		
		private function blinkTwise():void 
		{
			active = false;
			FP.alarm(FP.random * 0.1, blinkOn as Function, 2);
		}
		
		private function blinkOn():void
		{
			active = true;
			if (_blinks == 1)
			{
				FP.alarm(FP.random * 2, blinkFirsth as Function, 2);
			}
			if (_blinks == 2)
			{
				FP.alarm(FP.random * 0.2, blinkTwise as Function, 2);
			}
			if (_blinks >= 3) active = false;
		}
		
		
	}

}