package com.xueersi.corelibs.cores.vo
{
	import com.xueersi.corelibs.interfaces.IVo;
	import flash.display.DisplayObjectContainer;

	/*
	 * 本类是一种复杂数据类型   内部包含多种数据
	*/
	public class MEDIA_VIDEO_VO implements IVo
	{
		private var _data:Object;
		public var url:String;
		public var width:Number;
		public var height:Number;
		public var needPlayer:Boolean;
		public var container:DisplayObjectContainer;
		public function MEDIA_VIDEO_VO()
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