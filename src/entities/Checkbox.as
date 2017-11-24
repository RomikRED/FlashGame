package entities 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.Entity;
	
	public class Checkbox extends Entity 
	{
		protected const NORMAL:int = 0;
		protected const HOVER:int = 1;
		protected const DOWN:int = 2;
		
		public var clicked:Boolean = false;
		
		protected var _normalChecked:Graphic;
		protected var _hoverChecked:Graphic;
		protected var _downChecked:Graphic;
		
		protected var _normal:Graphic;
		protected var _hover:Graphic;
		protected var _down:Graphic;
		
		protected var _label:Text;
		
		
		protected var checked:Boolean = false;
		protected var callback:Function;
		protected var params:*;
		
		
		public function Checkbox(callbackFunc:Function, parameters:*, x:Number, y:Number) 
		{
			super(x, y);
			
			this.callback = callbackFunc;
			if(params !=0) this.params = parameters;
			
			
		}
		public function setChecked(check:Boolean = false):void
		{
			checked = check;
		}
		 
		public function setSpritemap(assets:*, frameW:uint, frameH:uint, framesA:Array):void
        {
			_normal = 	new Image(assets, new Rectangle(framesA[0] * frameW, framesA[3] * frameH, frameW, frameH));
			_hover = 	new Image(assets, new Rectangle(framesA[1] * frameW, framesA[3] * frameH, frameW, frameH));
			_down = 	new Image(assets, new Rectangle(framesA[2] * frameW, framesA[3] * frameH, frameW, frameH));
			
			
			_normalChecked = 	new Image(assets, new Rectangle(framesA[0] * frameW, framesA[4] * frameH, frameW, frameH));
			_hoverChecked = 	new Image(assets, new Rectangle(framesA[1] * frameW, framesA[4] * frameH, frameW, frameH));
			_downChecked = 		new Image(assets, new Rectangle(framesA[2] * frameW, framesA[4] * frameH, frameW, frameH));
			
			graphic = _normal;
			setHitboxTo(_normal);
			
			
		}
		protected function click():void 
		{
			checked = !checked;
			
			if (callback != null)
			{
				//trace("notNUUUUULLLL");
				/*/if (params != null) callback(checked, params);
				else */callback(checked);
			}
		}
		
		
		override public function update():void 
		{
			super.update();
			
			if (collidePoint(x, y, world.mouseX, world.mouseY))
			{	
				if (Input.mousePressed) clicked = true;
				
				if (clicked) changeState(DOWN);
				else changeState(HOVER);
				
				if (clicked && Input.mouseReleased) click();
			}
			else
			{
				if (clicked) changeState(HOVER);
				else changeState(NORMAL);
			}
			
			if (Input.mouseReleased) clicked = false;
		}
		
		protected function changeState(state:int = 0):void 
		{
			if (checked)
			{
				switch(state)
				{
					case NORMAL:
						graphic = _normalChecked;
						break;
					case HOVER:
						graphic = _hoverChecked;
						break;
					case DOWN:
						graphic = _downChecked;
						break;
				}
			}
			else
			{
				switch(state)
				{
					case NORMAL:
						graphic = _normal;
					break;
					case HOVER:
						graphic = _hover;
					break;
					case DOWN:
						graphic = _down;
					break;
				}
			}
		}
	}
}