﻿package brain.sb{		// import flash.display.Graphics;		public class Vector2D	{		private var _x:Number;		private var _y:Number;				public function Vector2D(x:Number = 0, y:Number = 0)		{			_x = x;			_y = y;		}				/**		 * Метод может быть использован для визуализации вектора. Используется в основном при		 * отладке.		 * @param graphics экземпляр класса Graphics для рисования вектора.		 * @param color цвет вектора.		 */		/*public function draw(graphics:Graphics, color:uint = 0):void		{			graphics.lineStyle(0, color);			graphics.moveTo(0, 0);			graphics.lineTo(_x, _y);		}*/				/**		 * Создает копию данного вектора.		 * @return Vector2D копия данного вектора.		 */		public function clone():Vector2D		{			return new Vector2D(x, y);		}				/**		 * Устанавливает значения х и у, а следовательно и длину		 * вектора равным нулю и возвращает этот вектор.		 * @return Vector2D .		 */		public function zero():Vector2D		{			_x = 0;			_y = 0;			return this;		}				/**		 * Проверяет является ли данный вектор нулевым, т.е. равны ли его х, у и длина нулю		 * @return Boolean True если вектор нулевой, false иначе.		 */		public function isZero():Boolean		{			return _x == 0 && _y == 0;		}				/**		 * Сеттер/геттер для записи/чтения длины вектора. Изменение длины изменит x и y, но не угол этого вектора.		 */		public function set length(value:Number):void		{			var a:Number = angle;			_x = Math.cos(a) * value;			_y = Math.sin(a) * value;		}		public function get length():Number		{			return Math.sqrt(lengthSQ);		}				/**		 * Возвращает квадрат длины вектора		 */		public function get lengthSQ():Number		{			return _x * _x + _y * _y;		}				/**		 * Геттер/сеттер угла этого вектора. Изменение угла изменяет x и y, но сохраняет ту же самую длину.		 */		public function set angle(value:Number):void		{			var len:Number = length;			_x = Math.cos(value) * len;			_y = Math.sin(value) * len;		}		public function get angle():Number		{			return Math.atan2(_y, _x);		}				/**		 * Нормализует вектор (делает его длину равной единице) и возвращает его. 		 * @return Vector2D. 		 */		public function normalize():Vector2D		{			if(length == 0)			{				_x = 1;				return this;			}			var len:Number = length;			_x /= len;			_y /= len;			return this;		}				/**		 * Ограничивает длину вектора, значением которое задается параметром max		 * @param max.		 * @return Vector2D.		 */		public function truncate(max:Number):Vector2D		{			length = Math.min(max, length);			return this;		}				/**		 * Изменяет направление вектора на противоположное.		 * @return Vector2D.		 */		public function reverse():Vector2D		{			_x = -_x;			_y = -_y;			return this;		}				/**		 * Проверяет, является ли вектора нормализованным		 * @return Boolean True - вектор нормализован, false - нет.		 */		public function isNormalized():Boolean		{			return length == 1.0;		}				/**		 * Если угол между векторами меньше 180 градусов, метод возвращает положительное число,		 * если нет - отрицательное.		 * @param v2.		 * @return Number.		 */		public function dotProd(v2:Vector2D):Number		{			return _x * v2.x + _y * v2.y;		}				/**		 * Calculates the cross product of this vector and another given vector.		 * @param v2 Another Vector2D instance.		 * @return Number The cross product of this vector and the one passed in as a parameter.		 */		public function crossProd(v2:Vector2D):Number		{			return _x * v2.y - _y * v2.x;		}				/**		 * Определяет угол между двумя векторами.		 * @param v1 первый вектор.		 * @param v2 второй вектор.		 * @return Number угол между двумя векторами.		 */		public static function angleBetween(v1:Vector2D, v2:Vector2D):Number		{			if(!v1.isNormalized()) v1 = v1.clone().normalize();			if(!v2.isNormalized()) v2 = v2.clone().normalize();			return Math.acos(v1.dotProd(v2));		}				/**		 * Определяет направление вектора перпендикулярного данному.		 * @return int		 */		public function sign(v2:Vector2D):int		{			return perp.dotProd(v2) < 0 ? -1 : 1;		}				/**		 * Возвращает вектор, перпендикулярный данному		 * @return Vector2D.		 */		public function get perp():Vector2D		{			return new Vector2D(-y, x);		}				/**		 * Определяет расстояние между данным вектором и любым другим.		 * @param v2.		 * @return Number.		 */		public function dist(v2:Vector2D):Number		{			return Math.sqrt(distSQ(v2));		}				/**		 * Определяет квадрат расстояния между данным вектором и любым другим.		 * @param v2.		 * @return Number.		 */		public function distSQ(v2:Vector2D):Number		{			var dx:Number = v2.x - x;			var dy:Number = v2.y - y;			return dx * dx + dy * dy;		}				/**		 * Складывает вектор v2 с заданным вектором, возвращает результирующий вектор.		 * @param v2 A Vector2D.		 * @return Vector2D новый вектор - результат сложения двух векторов.		 */		public function add(v2:Vector2D):Vector2D		{			return new Vector2D(_x + v2.x, _y + v2.y);		}				/**		 * Вычитает вектор v2 из заданного вектора, возвращает результирующий вектор.		 * @param v2 Vector2D.		 * @return Vector2D новый вектор - результат вычитания двух векторов.		 */		public function subtract(v2:Vector2D):Vector2D		{			return new Vector2D(_x - v2.x, _y - v2.y);		}		public function subtractTh(xp:Number, yp:Number):Vector2D		{			_x  -= xp;			_y	-= yp;			return this;		}						/**		 * Умножает заданный вектор на число, возвращает результирующий вектор.		 * @param v2 Vector2D.		 * @return Vector2D вектор, полученный умножением заданного вектора на число.		 */		public function multiply(value:Number):Vector2D		{			return new Vector2D(_x * value, _y * value);		}				/**		 * Делит заданный вектор на число, возвращает результирующий вектор.		 * @param v2 Vector2D.		 * @return Vector2D вектор, полученный делением заданного вектора на число.		 */		public function divide(value:Number):Vector2D		{			return new Vector2D(_x / value, _y / value);		}				/**		 * Проверяет равенство двух векторов.		 * @param v2 Vector2D.		 * @return Boolean True - если векторы равны, false - если не равны.		 */		public function equals(v2:Vector2D):Boolean		{			return _x == v2.x && _y == v2.y;		}				/**		 * Сеттер/геттер свойства х вектора.		 */		public function set x(value:Number):void		{			_x = value;		}		public function get x():Number		{			return _x;		}				/**		 * Сеттер/геттер свойства у вектора.		 */		public function set y(value:Number):void		{			_y = value;		}		public function get y():Number		{			return _y;		}				/**		 * Генерирует строковое представление вектора.		 * @return String строковое представление вектора.		 */		public function toString():String		{			return "[Vector2D (x:" + _x + ", y:" + _y + ")]";		}	}}