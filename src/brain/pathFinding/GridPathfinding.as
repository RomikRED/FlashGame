package brain.pathFinding
{
	/**
	 * Содержит двухмерный массив узлов, методы для управления им, начальным узлом, конечным узлом для поиска пути.
	 */
	public class GridPathfinding
	{
		private var _startNode:Node;
		private var _endNode:Node;
		private var _nodes:Array;
		private var _numCols:int;
		private var _numRows:int;
		
		/**
		 * Конструктор.
		 */
		public function GridPathfinding(numCols:int, numRows:int)
		{
			_numCols = numCols;
			_numRows = numRows;
			_nodes = new Array();
			
			for(var i:int = 0; i < _numCols; i++)
			{
				_nodes[i] = new Array();
				for(var j:int = 0; j < _numRows; j++)
				{
					_nodes[i][j] = new Node(i, j);
				}
			}
		}
		
		
		////////////////////////////////////////
		// открытые методы
		////////////////////////////////////////
		
		/**
		* Loads the grid data from a string.
		* @param str			The string data, which is a set of tile values (0 or 1) separated by the columnSep and rowSep strings.
		* @param columnSep		The string that separates each tile value on a row, default is ",".
		* @param rowSep			The string that separates each row of tiles, default is "\n".
		*/
		public function loadFromString(str:String, columnSep:String = ",", rowSep:String = "\n"):void
		{
			var row:Array = str.split(rowSep),
				rows:int = row.length-1,
				col:Array, cols:int, x:int, y:int;
			for (y = 0; y < rows; y ++)
			{
				if (row[y] == '') continue;
				col = row[y].split(columnSep),
				cols = col.length-1;
				for (x = 0; x < cols; x ++)
				{
					if (col[x] == '') continue;
					//setWalkable(x, y, uint(col[x]) == 0);
					setWalkable(x, y, col[x] == 1);
				}
			}
		}
		
		/**
		 * Возвращает узел с данными координатами.
		 * @param x координата х.
		 * @param y координата у.
		 */
		public function getNode(x:int, y:int):Node
		{
			return _nodes[x][y] as Node;
		}
		
		/**
		 * устанавливает узел с данными координатами в качестве конечного.
		 * @param x координата х.
		 * @param y координата у.
		 */
		public function setEndNode(x:int, y:int):void
		{
			_endNode = _nodes[x][y] as Node;
		}
		
		/**
		 * устанавливает узел с данными координатами в качестве начального.
		 * @param x координата х.
		 * @param y координата у.
		 */
		public function setStartNode(x:int, y:int):void
		{
			_startNode = _nodes[x][y] as Node;
		}
		
		/**
		 * устанавливает узел с данными координатами в качестве непроходимого/проходимого.
		 * @param x координата х.
		 * @param y координата у.
		 */
		public function setWalkable(x:int, y:int, value:Boolean):void
		{
			_nodes[x][y].walkable = value;
		}
		
		
		
		////////////////////////////////////////
		// геттеры/сеттеры
		////////////////////////////////////////
		
		/**
		 * Возвращает конечный узел.
		 */
		public function get endNode():Node
		{
			return _endNode;
		}
		
		/**
		 * Возвращает количество колонок в сетке.
		 */
		public function get numCols():int
		{
			return _numCols;
		}
		
		/**
		 * Возвращает количество строк в сетке.
		 */
		public function get numRows():int
		{
			return _numRows;
		}
		
		/**
		 * Возвращает начальный узел.
		 */
		public function get startNode():Node
		{
			return _startNode;
		}
		
	}
}