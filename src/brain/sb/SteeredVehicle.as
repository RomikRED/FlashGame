package brain.sb
{
	public class SteeredVehicle
	{
		protected var _mass:Number = 1.0;
		protected var _maxSpeed:Number = 3;
		protected var _position:Vector2D;
		protected var _velocity:Vector2D;
		
		private var _maxForce:Number = 1;
		private var _steeringForce:Vector2D;
		private var _arrivalThreshold:Number = 100;
		private var _wanderAngle:Number = 0;
		private var _wanderDistance:Number = 10;
		private var _wanderRadius:Number = 10;
		private var _wanderRange:Number = 1;
		private var _pathIndex:int = 0;
		private var _pathThreshold:Number = 20;
		private var _avoidDistance:Number = 100;
		private var _avoidBuffer:Number = 1;
		private var _inSightDist:Number = 200;
		private var _tooCloseDist:Number = 60;
		
		
		
		public function SteeredVehicle(xp:Number = 0, yp:Number = 0)
		{
			_position = new Vector2D(xp, yp);
			_velocity = new Vector2D();
			_steeringForce = new Vector2D();
			super();
		}
		
		public function set maxForce(value:Number):void
		{
			_maxForce = value;
		}
		public function get maxForce():Number
		{
			return _maxForce;
		}
		
		public function set arriveThreshold(value:Number):void
		{
			_arrivalThreshold = value;
		}
		public function get arriveThreshold():Number
		{
			return _arrivalThreshold;
		}
		
		public function set wanderDistance(value:Number):void
		{
			_wanderDistance = value;
		}
		public function get wanderDistance():Number
		{
			return _wanderDistance;
		}
		
		public function set wanderRadius(value:Number):void
		{
			_wanderRadius = value;
		}
		public function get wanderRadius():Number
		{
			return _wanderRadius;
		}
		
		public function set wanderRange(value:Number):void
		{
			_wanderRange = value;
		}
		public function get wanderRange():Number
		{
			return _wanderRange;
		}
		
		public function set wanderAngle(value:Number):void
		{
			_wanderAngle = value;
		}
		public function get wanderAngle():Number
		{
			return _wanderAngle;
		}
		
		public function set pathIndex(value:int):void
		{
			_pathIndex = value;
		}
		public function get pathIndex():int
		{
			return _pathIndex;
		}
		
		public function set pathThreshold(value:Number):void
		{
			_pathThreshold = value;
		}
		public function get pathThreshold():Number
		{
			return _pathThreshold;
		}
		
		public function set avoidDistance(value:Number):void
		{
			_avoidDistance = value;
		}
		public function get avoidDistance():Number
		{
			return _avoidDistance;
		}
		
		public function set avoidBuffer(value:Number):void
		{
			_avoidBuffer = value;
		}
		public function get avoidBuffer():Number
		{
			return _avoidBuffer;
		}
		
		public function set inSightDist(value:Number):void
		{
			_inSightDist = value;
		}
		public function get inSightDist():Number
		{
			return _inSightDist;
		}
		
		public function set tooCloseDist(value:Number):void
		{
			_tooCloseDist = value;
		}
		public function get tooCloseDist():Number
		{
			return _tooCloseDist;
		}
				
		public function seek(target:Vector2D):void
		{
			var desiredVelocity:Vector2D = target.subtract(_position);
			desiredVelocity.normalize();
			desiredVelocity = desiredVelocity.multiply(_maxSpeed);
			//var force:Vector2D = desiredVelocity.subtract(_velocity);
			//_steeringForce = _steeringForce.add(force);
			_steeringForce = desiredVelocity.clone();
		}
		
		public function flee(target:Vector2D):void
		{
			var desiredVelocity:Vector2D = target.subtract(_position);
			desiredVelocity.normalize();
			desiredVelocity = desiredVelocity.multiply(_maxSpeed);
			var force:Vector2D = desiredVelocity.subtract(_velocity);
			_steeringForce = _steeringForce.subtract(force);
		}
		
		public function arrive(target:Vector2D):void
		{
			var desiredVelocity:Vector2D = target.subtract(_position);
			desiredVelocity.normalize();
			
			var dist:Number = _position.dist(target);
			if(dist > _arrivalThreshold)
			{
				desiredVelocity = desiredVelocity.multiply(_maxSpeed);
			}
			else
			{
				desiredVelocity = desiredVelocity.multiply(_maxSpeed * dist / _arrivalThreshold);
			}
			
			var force:Vector2D = desiredVelocity.subtract(_velocity);
			_steeringForce = _steeringForce.add(force);
		}
		
		/*public function pursue(target:Vehicle):void
		{
			var lookAheadTime:Number = position.dist(target.position) / _maxSpeed;
			var predictedTarget:Vector2D = target.position.add(target.velocity.multiply(lookAheadTime));
			seek(predictedTarget);
		}
		
		public function evade(target:Vehicle):void
		{
			var lookAheadTime:Number = position.dist(target.position) / _maxSpeed;
			var predictedTarget:Vector2D = target.position.subtract(target.velocity.multiply(lookAheadTime));
			flee(predictedTarget);
		}*/
		
		public function wander():void
		{
			var center:Vector2D = velocity.clone().normalize().multiply(_wanderDistance);
			var offset:Vector2D = new Vector2D(0);
			offset.length = _wanderRadius;
			offset.angle = _wanderAngle;
			_wanderAngle += Math.random() * _wanderRange - _wanderRange * .5;
			trace(Math.round(_wanderAngle*180/Math.PI));
			var force:Vector2D = center.add(offset);
			_steeringForce = _steeringForce.add(force);
		}
		
		/*public function avoid(circles:Array):void
		{
		    for(var i:int = 0; i < circles.length; i++)
		    {
		        var circle:Circle = circles[i] as Circle;
		        var heading:Vector2D = _velocity.clone().normalize();
		        
		        // ������, �������������� �������� ����� �������� ������� ����������
				// � �������� ������� ���������:
		        var difference:Vector2D = circle.position.subtract(_position);
		        var dotProd:Number = difference.dotProd(heading);
		        
		        // ���� ���������� ����� ����������...
		        if(dotProd > 0)
		        {
		            // ������, �������������� ����� ������
		            var feeler:Vector2D = heading.multiply(_avoidDistance);
		            // �������� ������� difference �� ������ feeler
		            var projection:Vector2D = heading.multiply(dotProd);
		            // ���������� �� ���������� �� �������
		            var dist:Number = projection.subtract(difference).length;
		            
					// ���� ������ ������� ���������� ���������� �������� ������ ������ circle + ������ ������
					// � ����� ������� projection ������ ����� ������� �������
					// �� ����������� � ��� ���������� ����������� �����������
		            if(dist < circle.radius + _avoidBuffer &&
		               projection.length < feeler.length)
		            {
		                // ������������� ������ ��������� �� +/- 90 ��������
		                var force:Vector2D = heading.multiply(_maxSpeed);
		                force.angle += difference.sign(_velocity) * Math.PI / 2;
		                
						// ������������ ������� ����������� � ����������� �� ���������� �� �����������
		                force = force.multiply(1.0 - projection.length /
		                                             feeler.length);
		                
		                // ��������� ����������� �����������
		                _steeringForce = _steeringForce.add(force);
		                
		                // �������� ��������
		                //_velocity = _velocity.multiply(projection.length / feeler.length);
		            }
		        }
		    }
		}*/
		
		public function followPath(path:Array, loop:Boolean = false):void
		{
			//var wayPoint:Vector2D = path[_pathIndex];
			var wayPoint:Vector2D = new Vector2D(path[_pathIndex].x*20, path[_pathIndex].y*20);
			if(wayPoint == null) return;
			if(_position.dist(wayPoint) < _pathThreshold)
			{
				if(_pathIndex >= path.length - 1)
				{
					if(loop)
					{
						_pathIndex = 0;
					}
				}
				else
				{
					_pathIndex++;
				}
			}
			if(_pathIndex >= path.length - 1 && !loop)
			{
				arrive(wayPoint);
			}
			else
			{
				seek(wayPoint);
			}
		}
		
		/*public function flock(vehicles:Array):void
		{
			var averageVelocity:Vector2D = _velocity.clone();
			var averagePosition:Vector2D = new Vector2D();
			var inSightCount:int = 0;
			for(var i:int = 0; i < vehicles.length; i++)
			{
				var vehicle:Vehicle = vehicles[i] as Vehicle;
				if(vehicle != this && inSight(vehicle))
				{
					averageVelocity = averageVelocity.add(vehicle.velocity);
					averagePosition = averagePosition.add(vehicle.position);
					if(tooClose(vehicle)) flee(vehicle.position);
					inSightCount++;
				}
			}
			if(inSightCount > 0)
			{
				averageVelocity = averageVelocity.divide(inSightCount);
				averagePosition = averagePosition.divide(inSightCount);
				seek(averagePosition);
				_steeringForce.add(averageVelocity.subtract(_velocity));
			}
		}
		*/
		/*public function inSight(vehicle:Vehicle):Boolean		
		{
			if(_position.dist(vehicle.position) > _inSightDist) return false;
			var heading:Vector2D = _velocity.clone().normalize();
			var difference:Vector2D = vehicle.position.subtract(_position);
			var dotProd:Number = difference.dotProd(heading);
			
			if(dotProd < 0) return false;
			return true;
		}
		
		public function tooClose(vehicle:Vehicle):Boolean
		{
			return _position.dist(vehicle.position) < _tooCloseDist;
		}
		*/
		
		/**
		 * ������/������ ����� ��������.
		 */
		public function set mass(value:Number):void
		{
			_mass = value;
		}
		public function get mass():Number
		{
			return _mass;
		}
		
		/**
		 * ������/������ ������������ �������� ��������.
		 */
		public function set maxSpeed(value:Number):void
		{
			_maxSpeed = value;
		}
		public function get maxSpeed():Number
		{
			return _maxSpeed;
		}
		
		/**
		 * ������/������ ������� �������� (������������ ��� ������ Vector2D).
		 */
		public function set position(value:Vector2D):void
		{
			_position = value;
			//x = _position.x;
			//y = _position.y;
		}
		public function get position():Vector2D
		{
			return _position;
		}
		
		/**
		 * ������/������ �������� �������� (������������ ��� ������ Vector2D).
		 */
		public function set velocity(value:Vector2D):void
		{
			_velocity = value;
		}
		public function get velocity():Vector2D
		{
			return _velocity;
		}
		
		/**
		 * ������ ���������� � ��������. Overrides Sprite.x to set internal Vector2D position as well.
		 */
		/*public function set x(value:Number):void
		{
			super.x = value;
			_position.x = x;
		}*/
		
		/**
		 * ������ ���������� � ��������. Overrides Sprite.y to set internal Vector2D position as well.
		 */
		/*public function set y(value:Number):void
		{
			super.y = value;
			_position.y = y;
		}*/
		
		public function update():void
		{
			_steeringForce.truncate(_maxForce);
			_steeringForce = _steeringForce.divide(_mass);
			_velocity = _velocity.add(_steeringForce);
			_steeringForce = new Vector2D();
			
			// ����������, ��� �������� �� ������ ����������� ���������� ��������.
			_velocity.truncate(_maxSpeed);
			
			// ��������� �������� � �������
			_position = _position.add(_velocity);
		
		}
	}
}