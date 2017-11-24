package entities 
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author ...
	 */
	public class AchView extends Entity 
	{
		private static var textOpt:Object = {font:"orbitron bold", size: 20, color: 0xFFFFFF, wordWrap: true, align: "center"};
		private static var back:Image = new Image(new BitmapData(300, 300, false, 0x808080));
		private var _achImage:Image;
		public function AchView(num:int) 
		{
			var achTextTitle:Text, achTextTitle2:Text, achTextDesc:Text, achObj:Object, addValue:String,
				graph:Graphiclist;
			
			num > 9 ? addValue = "" : addValue = "0";
			
			setHitboxTo(back);
			centerOrigin();
			back.centerOrigin();
			
			achObj = Award[String("AWA") + String(addValue) + String(num)];
			_achImage = achObj.pic;
				_achImage.scale = 1;
				//_achImage.centerOrigin();
				//_achImage.scaleX = 6;
				//_achImage.scaleY = 4;
				_achImage.x = -150;
				_achImage.y = -150;
				achTextTitle = new Text(achObj.title+"\n \n"+achObj.desc, 0, 25, textOpt);
				achTextTitle.width = 295;// _achImage.scaledWidth - 5;
				achTextTitle.height = 195;//_achImage.scaledHeight - 5;
				achTextTitle.smooth = true;
				achTextTitle.centerOrigin();
				//trace(_achImage.x, _achImage.y);
			/*achTextDesc = new Text(achObj.desc, 0, achImage.height*2, textOpt);
				achTextDesc.width = width - 5;
				achTextDesc.centerOrigin();*/
				achTextTitle2 = new Text(achTextTitle.text, 0, 25, textOpt);
				achTextTitle2.width = 295;// _achImage.scaledWidth - 5;
				achTextTitle2.height = 195;//_achImage.scaledHeight - 5;
				achTextTitle2.centerOrigin();
				achTextTitle2.color = 0x800000;
				achTextTitle2.smooth = true;
				achTextTitle2.x -= 1;
				achTextTitle2.y -= 2; 
			
			graph = new Graphiclist(back, _achImage, achTextTitle2, achTextTitle/*, achTextDesc*/);
			
			
			
			super(320, 240, graph);
		}
		
		override public function update():void 
		{
			if (Input.mouseDown || Input.pressed(Key.ESCAPE)) 
			{
				//_achImage.scaleX = _achImage.scaleY = 1;
				//_achImage.x = _achImage.y = 0;
				_achImage.scale = 0.17;
				
				FP.world.remove(this);
			}
			super.update();
		}
	}

}