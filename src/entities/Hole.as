package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;

	public class Hole extends Entity 
	{
		public var holeText:Text;
		
		public function Hole(px:Number, py:Number, alayer:int) 
		{
			this.x = px;
			this.y = py;
			this.type = "hole";
			this.layer = alayer;
			
			holeText = new Text(C.USRTEXT[2],
								0, -100,
								{font:"orbitron light", size: 12, color:0xFFFFFF});
			hideText();
			var img:Image = new Image(Assets.HOLE);
			setHitboxTo(img);
			graphic = new Graphiclist(img, holeText)
			super(x, y, graphic);
		}
		
		public function hideText():void
		{
			holeText.visible = false;
		}
	}

}