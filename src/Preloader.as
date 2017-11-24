package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.display.Sprite;
	import flash.text.TextField;
	import net.flashpunk.Engine;
	//import punk.core.*;
	
	[SWF(width = "640", height = "480")]
	
	/**
	 * ...
	 * @author Noel Berry and Rahil Patel
	 * @usage Remember to add "-frame main Main" to additional compiler options
	 */
	public class Preloader extends MovieClip 
	{
		//[Embed(source = 'data/loading.png')] static private var imgLoading:Class;
		//private var loading:Bitmap = new  imgLoading;
		
		private var _square:Sprite = new Sprite();
		private var _border:Sprite = new Sprite();
		private var wd:Number = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * 240;
		private var _text:TextField = new TextField();
		
		[Embed(source="../assets/fonts/Orbitron Bold.ttf",fontName = "orbitronbold", embedAsCFF="false", mimeType="application/x-font")]
		private var orbitronbold:Class;
		
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			this.root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
			addChild(_square);
			_square.x = 200;
			_square.y = stage.stageHeight / 2;
			
			addChild(_border);
			_border.x = 200-4;
			_border.y = stage.stageHeight / 2 - 4;
		
			addChild(_text);
			_text.x = 194;
			_text.y = stage.stageHeight * .5 - 80;
			_text.width = 300;
			_text.embedFonts = true;
			var format:TextFormat = new TextFormat("orbitronbold", 26, 0xFFFFFF);
            _text.defaultTextFormat = format;
  		}
		
		private function progress(e:ProgressEvent):void 
		{
			// update loader
			_square.graphics.beginFill(0xF2F2F2);
			_square.graphics.drawRect(0,0,(loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * 240,20);
			_square.graphics.endFill();
			
			_border.graphics.lineStyle(2,0xFFFFFF);
			_border.graphics.drawRect(0, 0, 248, 28);
			
			_text.textColor = 0xFFFFFF;
			_text.text = "Loading: " + Math.ceil((loaderInfo.bytesLoaded/loaderInfo.bytesTotal)*100) + "%";
			
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			}
		}
		
		private function startup():void 
		{
			// hide loader
			stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			//var mainClass:Engine;
			//addChild(new Main() as DisplayObject);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}