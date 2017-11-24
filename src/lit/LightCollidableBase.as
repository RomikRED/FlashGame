package lit 
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author 
	 */
	public class LightCollidableBase extends Entity 
	{
		public var parent:Light;
		//public static const COLL_LIGHT:String = "light";
		public function LightCollidableBase(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			
			type = "light";
			var image:Image =  new Image(new BitmapData(40, 5, false, 0x800000));
			setHitboxTo(image);
			graphic = image;
			super(x, y, graphic, mask);
			
		}
		
	}

}