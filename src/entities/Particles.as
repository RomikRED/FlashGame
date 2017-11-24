package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.ParticleType;
	import net.flashpunk.utils.Ease;
	
	public class Particles extends Entity
	{
		/** Particle emitter. */
		//[Embed(source = '../../assets/particle.png')] private const PARTICLE:Class;
		//public var emitter:Emitter = new Emitter(PARTICLE, 11, 11);
		//[Embed(source = "../../assets/emitter.png")]private const PARTICLE:Class;
		[Embed(source="../../assets/particlefire4.png")] private const PARTICLE:Class;
		public var emitter:Emitter = new Emitter(PARTICLE, 8, 8);
		
		/** Constructor, define particles and stuff. */
		public function Particles() 
		{
			graphic = emitter;
			emitter.x = emitter.y = 0;
			layer = 2;
			
			// Create a dust particle
			var p:ParticleType = emitter.newType("blood", [0, 1, 2, 3, 4]);
			//p.setMotion(20, 5, .2, 140, 50, .3, Ease.cubeOut);
			p.setMotion(20, 50, .5, 360, 100, .3, Ease.cubeOut);
			p.setAlpha(1.0, 0.3);
			p.setGravity(100, 10);
			p.setColor(0xFF8080, 0xFF0000, Ease.quadIn);
			
			// Create the trail particle.
			//p = emitter.newType("trail", [0, 1, 2, 3, 4, 5]);
			/*p = emitter.newType("trail", [0, 1, 2, 3, 4]);
			p.setMotion(0, 10, .5, 360, 30, .5, Ease.cubeInOut);
			p.setColor(0xFF3366, 0xFFFFFF);
			p.setAlpha(1, 0);
			*/
			
			// Dual emitters
			
			// Left
			/*p = emitter.newType("fireL", [0]);
			p.setMotion(86, 20, 1.0, 0, 50, 1.0); //Angle slight to right, distance 20-70 (20 + rand(50), time 1-2 sec (1 + (1+1)
			p.setColor(0xF9FF59, 0xFF270A);  // Start with yellow, end with red
			p.setAlpha(0.9, 0.3); // start a little soft but don't end totaly clear
			
			// Right
			p = emitter.newType("fireR", [0]);			
			p.setMotion(94, 20, 1.0, 0, 50, 1.0);
			p.setColor(0xF9FF59, 0xFF270A);
			p.setAlpha(0.9, 0.3);	*/		
			
		}
	}
}
