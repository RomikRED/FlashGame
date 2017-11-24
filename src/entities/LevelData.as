package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	
	/**
	 * A menu item in the level select menu.
	 * @author Zachary Lewis (http://zacharylew.is)
	 */
	public class LevelData 
	{
		protected var _name:String;
		protected var _data:Class;
		public var opened:Boolean;
		
		public function get levelName():String { return _name; }
		public function get data():Class { return _data; }
				
		public function LevelData(levelData:Class)
		{
			generateMetadata(levelData);
			//_text = new Text(levelName, 0, 0, { font:"orbitron black", size:20 } );
			opened = false;
		}
		
		protected function generateMetadata(xmlData:Class):void
		{
			_data = xmlData;
			// Get level name from XML
			var xml:XML = FP.getXML(xmlData);
			_name = xml.@Name;
		}
		/*
		public function get opened():Boolean { return opened; }
		public function set opened(value:Boolean):void
		{
			opened = value;
		}*/
		
	}

}