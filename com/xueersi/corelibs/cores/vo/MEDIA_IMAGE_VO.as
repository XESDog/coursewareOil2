package com.xueersi.corelibs.cores.vo 
{
	
	import com.xueersi.corelibs.interfaces.IVo;
	import flash.display.DisplayObject;
	
	/**
	 * @describe  	...
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012/7/18 13:22
	 */
	public class MEDIA_IMAGE_VO implements IVo
	{
		
		public var url:String = "";
		public var title:String = "";
		public var dp:DisplayObject;
		private var _data:Object;
		
		/* INTERFACE com.xueersi.corelibs.interfaces.IVo */
		
		public function get data():Object 
		{
			return _data;
		}
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
		/* public function */
		
		/* override function */
		
		/* private function */
	}
	
}