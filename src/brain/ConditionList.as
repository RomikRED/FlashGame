package brain 
{
	/**
	 * ...
	 * @author r
	 */
	public class ConditionList extends Object
	{
		public var members:Array;
		
		
		public function ConditionList() 
		{
		super();
		members = [];	
		}
		
		
		/**
		 * Добавляет новое условие в список.
		 * 
		 * @param	value	 Добавляемое условие.
		 */
		public function set(value:uint):void
		{
			members[members.length] = value;
		}
	
		/**
		 * Проверяет наличие указанного условия в списке.
		 * 
		 * @param	value	 Состояние наличие которого необходимо проверить.
		 * @return		Возвращает true если указанное состояние существует в списке.
		 */
		public function contains(value:uint):Boolean
		{
			return (members.indexOf(value) > -1) ? true : false;
		}
		
		/**
		 * Очищает список условий.
		 */
		public function clear():void
		{
			members.length = 0;
		}
		
		/**
		 * Проверяет совпадение условий текущего списка из указанного.
		 * 
		 * @param	conditionList	 Список условий с которыми надо проверить совпадения.
		 * @return		Возвращает true если одно или более условий совпадают.
		 */
		public function isIntersects(conditionList:ConditionList):Boolean
		{
			if (members.length == 0 || conditionList.members.length == 0)
			{
				return false;
			}
			
			/*var n1:int = members.length;
			var n2:int = conditionList.members.length;
			for (var i:int = 0; i < n1; i++)
			{
				for (var j:int = 0; j < n2; j++)
				{
					if (members[i] == conditionList.members[j])
					{
						return true;
					}
				}
			}*/
			
			for each (var i:uint in members) 
			{
				for each (var j:uint in conditionList.members) 
				{
					if (i == j) 
					{
						return true;
					}
				}
			}
			return false;
		}
		
		
	}

}