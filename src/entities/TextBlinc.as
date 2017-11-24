package entities 
{
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;

	
	 
	public class TextBlinc extends Text 
	{
		public var isBlinc:Boolean = true;
		public function TextBlinc(text:String, x:Number=0, y:Number=0, options:Object=null, h:Number=0) 
		{
			super(text, x, y, options, h);
			visible = false;
			if(isBlinc) FP.alarm(1, changeVisibility);
		}
		
		private function changeVisibility():void 
		{
			if (isBlinc == false) return;
			
			visible ? visible = false : visible = true;
			FP.alarm(1, changeVisibility);
		}
		
	}

}