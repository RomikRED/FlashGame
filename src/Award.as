package 
{
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class Award 
	{
		[Embed(source="../assets/UI/achs.png")]
		public static const ACH:Class;
		/////------KILLS -------
		public static const KILL01:int = 1;
		public static const AWA01:Object = {
			title:	"KILLS", 
			desc:	"First Blood.\nYou killed "+KILL01+" enemy!", 
			pic:	new Image(ACH,new Rectangle(0,0,300,300)),
			shortDesc:"First Blood"
		};
		
		public static const KILL02:int = 100;
		public static const AWA02:Object = {
			title:	"KILLS", 
			desc:	"Killer.\nYou killed "+KILL02+" enemies!", 
			pic:	new Image(ACH,new Rectangle(300,0,300,300)),
			shortDesc:"Killer"
		};
			
		public static const KILL03:int = 500;
		public static const AWA03:Object = {
			title:	"KILLS", 
			desc:	"Destroyer.\nYou killed "+KILL03+" enemies!", 
			pic:	new Image(ACH,new Rectangle(600,0,300,300)),
			shortDesc:"Destroyer"
		};
			
		/////------GRENADE -------
		public static const GREND01:int = 4;
		public static const AWA04:Object = {
			title:	"GRENADE KILLS", 
			desc:	"First strike.\nYou killed by grenade first "+GREND01+" enemies!", 
			pic:	new Image(ACH,new Rectangle(0,300,300,300)),
			shortDesc:"First strike"
		};
		
		public static const GREND02:int = 5;
		public static const AWA05:Object = {
			title:	"GRENADE KILLS",  
			desc:	"Shock precision.\nYou killed by grenade "+GREND02+" enemies!", 
			pic:	new Image(ACH,new Rectangle(300,300,300,300)),
			shortDesc:"Shock precision"
		};
			
		public static const GREND03:int = 7;
		public static const AWA06:Object = {
			title:	"GRENADE KILLS",  
			desc:	"Amazing hit.\nYou killed by grenade "+GREND03+" enemies!", 
			pic:	new Image(ACH,new Rectangle(600,300,300,300)),
			shortDesc:"Amazing hit"
		};
			
		/////------DOORS -------
		public static const DOOR01:int = 1;
		public static const AWA07:Object = {
			title:	"BREAK DOORS", 
			desc:	"Hard knock.\nYou destroy "+ DOOR01+" door!", 
			pic:	new Image(ACH,new Rectangle(0,600,300,300)),
			shortDesc:"Hard knock"
		};
		
		public static const  DOOR02:int = 5;
		public static const AWA08:Object = {
			title:	"BREAK DOORS", 
			desc:	"Hammer.\nYou destroy "+DOOR02+" doors!", 
			pic:	new Image(ACH,new Rectangle(300,600,300,300)),
			shortDesc:"Hammer"
		};
			
		public static const DOOR03:int = 15;
		public static const AWA09:Object = {
			title:	"BREAK DOORS", 
			desc:	"Door kicker.\nYou destroy "+ DOOR03+" doors!", 
			pic:	new Image(ACH,new Rectangle(600,600,300,300)),
			shortDesc:"Door kicker"
		};
		
		/////------LAMPS -------
		public static const LAMP01:int = 1;
		public static const AWA10:Object = {
			title:	"BREAK LAMPS", 
			desc:	"Darkness.\nYou destroy "+ LAMP01+" lamp!", 
			pic:	new Image(ACH,new Rectangle(0,900,300,300)),
			shortDesc:"Darkness"
		};
		
		public static const  LAMP02:int = 5;
		public static const AWA11:Object = {
			title:	"BREAK LAMPS",
			desc:	"Lamp destroyer.\nYou destroy "+ LAMP02+" lamps!", 
			pic:	new Image(ACH,new Rectangle(300,900,300,300)),
			shortDesc:"Lamp destroyer"
		};
			
		public static const LAMP03:int = 15;
		public static const AWA12:Object = {
			title:	"BREAK LAMPS", 
			desc:	"Dark knight.\nYou destroy "+ LAMP03+" lamps!", 
			pic:	new Image(ACH,new Rectangle(600,900,300,300)),
			shortDesc:"Dark knight"
		};
			
		/////------HEAD SHOTS -------
		public static const HEAD01:int = 5;
		public static const AWA13:Object = {
			title:	"HEADSHOTS", 
			desc:	"Beginner.\nYou crush "+ HEAD01+" heads!", 
			pic:	new Image(ACH,new Rectangle(0,1200,300,300)),
			shortDesc:"Beginner"
		};
		
		public static const  HEAD02:int = 50;
		public static const AWA14:Object = {
			title:	"HEADSHOTS", 
			desc:	"Sniper.\nYou crush "+ HEAD02+" heads!", 
			pic:	new Image(ACH,new Rectangle(300,1200,300,300)),
			shortDesc:"Sniper"
		};
			
		public static const HEAD03:int = 100;
		public static const AWA15:Object = {
			title:	"HEADSHOTS",  
			desc:	"Head hunter.\nYou crush "+ HEAD03+" heads!", 
			pic:	new Image(ACH,new Rectangle(600,1200,300,300)),
			shortDesc:"Head hunter"
		};
	}

}