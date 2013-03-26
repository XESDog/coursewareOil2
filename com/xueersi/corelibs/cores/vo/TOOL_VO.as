package com.xueersi.corelibs.cores.vo
{
	import com.xueersi.corelibs.interfaces.IVo;
	/*
	* 本类是一种复杂数据类型   内部包含多种数据
	*/
	public class TOOL_VO implements IVo
	{
		private var _data:Object;

		public function TOOL_VO()
		{
		}
		
		public function get data():Object
		{
	
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}