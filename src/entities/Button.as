package entities 
{
	import adobe.utils.CustomActions;
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.graphics.Text;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author r
	 */
	public class Button extends Entity 
	{
		
		public var scaleBtn:int = 1;
		public var labelTxt:Text;
		public var hideLabel:Boolean = false;
		protected var _btn:Spritemap;
		protected var _sfxClick:Sfx;
		protected var _sfxOver:Sfx;
		protected var _callback:Function;
		protected var _argument:*;
		protected var _btnBackground:Image;
		//public static var btnColor:Number = 0x000000;
		
		public function Button(callback:Function, argum:*, x:Number, y:Number)
		{
			super(x, y);
			
			_callback = callback;
			if(argum !=0) _argument = argum;
			_sfxClick = new Sfx(Assets.SFX_BTNCLICK,null,"sound");
			_sfxOver = new Sfx(Assets.SFX_MouseOver, null, "sound");
			
		}
		
		public function get argument():* { return _argument; }
		
		public function setSpritemap(assets:*, frameW:uint, frameH:uint, framesA:Array):void
        {
            _btn = new Spritemap(assets, frameW, frameH);
             if (framesA.length == 0)
			 {
				_btn.add("Up", [0]);
				_btn.add("Over", [1]);
				_btn.add("Down", [2]);
			 }
			 else
			 {
				_btn.add("Up", framesA[0]);
				_btn.add("Over", framesA[1]);
				_btn.add("Down", framesA[2]);
			 }
			graphic = _btn;//new Graphiclist(_btnBackground, _btn );
            
            setHitbox(frameW, frameH);
			centerOrigin();
			_btn.centerOrigin();
        }
        
		public function setLabel(text:String, hidelabel:Boolean = false, sizeLabel:int = 20, wrapText:Boolean = false, labelColour:uint=0xFFFFFF):void
		{
			labelTxt = new Text(text, 0, 0, { font:"orbitron black", size: sizeLabel, color: labelColour, wordWrap: wrapText, align: "center", width:width*0.8 } );//width: width - 30,
				labelTxt.centerOrigin();
				addGraphic(labelTxt);
			hideLabel = hidelabel;
		}
		
		
		public function addBackground(back:*, rectX:int, rectY:int, rectW:int, rectH:int):void
		{
			_btnBackground = new Image(back,new Rectangle(rectX,rectY,rectW,rectH));
			_btnBackground.centerOrigin();
			addGraphic(_btnBackground);
		}
		
		protected var _over:Boolean;
		protected var _clicked:Boolean;
 
		override public function update():void
		{
			if (!world)
			{
				return;
			}
			
			_over = false;
			_clicked = false;
			//_btnBackground.color = btnColor;
			
			if (collidePoint(x - world.camera.x, y - world.camera.y, Input.mouseX, Input.mouseY))
			{
				if (Input.mouseReleased)
				{
					clicked();
				}
				else if (Input.mouseDown)
				{
					mouseDown();
				}
				else
				{
					mouseOver();
				}
			}
			
			_btn.scale = scaleBtn;
		}
		
		
		protected function clicked():void
		{
			//_sfxClick.play();
			if (!_argument)
			{
				_callback();
				
			}
			else
			{
				_callback(_argument);
	
			}
		}
		
		protected function mouseOver():void
		{
			
			_over = true;
			
		}
		
		protected function mouseDown():void
		{
			if(_sfxClick.playing == false) _sfxClick.play(V.soundsVolume*0.1);
			_clicked = true;
		}
		
		override public function render():void
		{
			if (_clicked)
			{
				_btn.play("Down");
			}
			else if (_over)
			{
				_btn.play("Over");
				labelTxt.visible = true;
			}
			else
			{
				_btn.play("Up");
				if(hideLabel) labelTxt.visible = false;
			}
			
			super.render();
		}
		
			
	}

}