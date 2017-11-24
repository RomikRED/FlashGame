package utils
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.masks.Pixelmask;
	
	public class AntMath extends Object
	{
		
		/**
		 * Возвращает случайное число из заданного диапазона.
		 * 
		 * @param	lower	 Наименьшее значение диапазона.
		 * @param	upper	 Наибольшее значение диапазона.
		 */
		public static function randomRangeInt(lower:int, upper:int):int
		{
			return int(Math.random() * (upper - lower + 1)) + lower;
		}
		
		/**
		 * Вращает точку вокруг заданной оси.
		 * 
		 * @param	x	 Значение X точки которую необходимо повернуть.
		 * @param	y	 Значение Y точки которую необходимо повернуть.
		 * @param	pivotX	 Значение X точки оси (вокруг которой необходимо повернуть).
		 * @param	pivotY	 Значение Y точки оси (вокруг которой необходимо повернуть).
		 * @param	angle	 Угол на который необходимо повернуть (в градусах).
		 * 
		 * @return		Возвращает новые координаты точки с учетом заданного угла.
		 */
		static public function rotatePointDeg(x:Number, y:Number, pivotX:Number, pivotY:Number, angle:Number):Point
		{
			var p:Point = new Point();
			var radians:Number = -angle / 180 * Math.PI;
			var dx:Number = x - pivotX;
			var dy:Number = pivotY - y;
			p.x = pivotX + Math.cos(radians) * dx - Math.sin(radians) * dy;
			p.y = pivotY - (Math.sin(radians) * dx + Math.cos(radians) * dy);
			return p;
		}
		
		/**
		 * Возвращает дистанцию между двумя точками.
		 * 
		 * @param	x1	 Положение первой точки по x.
		 * @param	y1	 Положение первой точки по y.
		 * @param	x2	 Положение второй точки по x.
		 * @param	y2	 Положение второй точки по y.
		 * 
		 * @return		Возвращает дистанцию между двумя точками.
		 */
		public static function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * Возвращает угол между двумя точками.
		 * 
		 * @param	x1	 Положение первой точки по x.
		 * @param	y1	 Положение первой точки по y.
		 * @param	x2	 Положение второй точки по x.
		 * @param	y2	 Положение второй точки по y.
		 * @param	norm	 Нормализация угла.
		 * 
		 * @return		Возвращает угол между двумя точками (в радианах).
		 */
		public static function angle(x1:Number, y1:Number, x2:Number, y2:Number, norm:Boolean = true):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			var angle:Number = Math.atan2(dy, dx);
			
			if (norm)
			{
				if (angle < 0)
				{
					angle = Math.PI * 2 + angle;	
				}
				else if (angle >= Math.PI * 2)
				{
					angle = angle - Math.PI * 2;
				}
			}
			
			return angle;
		}

		/**
		 * Переводит значение из радиан в градусы.
		 * 
		 * @param	radians	 Значение в радианах.
		 * @return		Возвращает значение в градусах.
		 */
		public static function toDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		
		/**
		 * Переводит значение из градусов в радианы.
		 * 
		 * @param	degrees	 Значение в градусах.
		 * @return		Возвращает значение в радианах.
		 */
		public static function toRadians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
		public static function scaleBitmapData(bitmapData:BitmapData, scale:Number):BitmapData 
		{
            scale = Math.abs(scale);
            var width:int = (bitmapData.width * scale) || 1;
            var height:int = (bitmapData.height * scale) || 1;
            var transparent:Boolean = bitmapData.transparent;
            var result:BitmapData = new BitmapData(width, height, transparent);
            var matrix:Matrix = new Matrix();
            matrix.scale(scale, scale);
            result.draw(bitmapData, matrix);
			return result;
        }

		public static function getPixelMask(imageBmd:BitmapData, scaleTo:Number, maskOffsetX:Number = 0, maskOffsetY:Number = 0 ):Pixelmask 
		{
			var matrix:Matrix = new Matrix();
				matrix.scale(scaleTo, scaleTo);
			var result:BitmapData = new BitmapData(
				(imageBmd.width * scaleTo) || 1, 
				(imageBmd.height * scaleTo) || 1,
				imageBmd.transparent,0x000000);
				result.draw(imageBmd, matrix);
			return new Pixelmask(result, maskOffsetX, maskOffsetY);
		}

	}

}