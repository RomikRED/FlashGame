package 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author 
	 */
	public class Room
	{
		//public static const COLLROOM:String = "room";
		public var spawnPoints		:Array;
		
		
		public function Room(roomData:Class)
		{
			generateMetadata(roomData);
		}
		
		protected function generateMetadata(xmlData:Class):void
		{
			// Get level name from XML
			var xml:XML = FP.getXML(xmlData);
			var node:XML, sprNum:int;
			//Set the respawn points
			spawnPoints = [];
			for each (node in xml.backs.spawnpoint)
			{
				spawnPoints.push({spawnX:int(node.@x), spawnY:int(node.@y), slotfree:true});
			}		
		//	//roomWidth = 1920;
		//	roomHeight = 1080;
		//	haveKey = Boolean(xml.back.key.@haveIt == 1);
		}
		
		/*public static const ROOM_TYPES:Array = 
		[	1	,	//	1
			1	,	//	2
			2	,	//	3
			2	,	//	4
			3	,	//	5
			2	,	//	6
			2	,	//	7
			3	,	//	8
			3	,	//	9
			4	,	//	10
			3	,	//	11
			3	,	//	12
			4	,	//	13
			4	,	//	14
			5	,	//	15
			4	,	//	16
			4	,	//	17
			5	,	//	18
			5	,	//	19
			6	,	//	20
			5	,	//	21
			5	,	//	22
			6	,	//	23
			6	,	//	24
			7	,	//	25
			6	,	//	26
			6	,	//	27
			7	,	//	28
			7	,	//	29
			8	,	//	30
			7	,	//	31
			7	,	//	32
			8	,	//	33
			8	,	//	34
			9	,	//	35
			8	,	//	36
			8	,	//	37
			9	,	//	38
			9	,	//	39
			10	,	//	40
			11	,	//	41
			11	,	//	42
			12	,	//	43
			12	,	//	44
			13	,	//	45
			12	,	//	46
			12	,	//	47
			13	,	//	48
			13	,	//	49
			14	,	//	50
			13	,	//	51
			13	,	//	52
			14	,	//	53
			14	,	//	54
			15	,	//	55
			14	,	//	56
			14	,	//	57
			15	,	//	58
			15	,	//	59
			16	,	//	60
			1	,	//	61
			1	,	//	62
			4	,	//	63
			4	,	//	64
			2	,	//	65
			5	,	//	66
			5	,	//	67
			8	,	//	68
			8	,	//	69
			6	,	//	70
			11	,	//	71
			11	,	//	72
			14	,	//	73
			14	,	//	74
			13	,	//	75
			2	,	//	76
			2	,	//	77
			12	,	//	78
			12	,	//	79
			16	];	//	80*/
		
	}

}