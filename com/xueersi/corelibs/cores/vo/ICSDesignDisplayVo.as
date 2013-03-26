package com.xueersi.corelibs.cores.vo 
{
	
	import com.xueersi.corelibs.interfaces.IVo;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * @describe  	前端设计师使用的VO
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012/7/27 11:18
	 */
	public class ICSDesignDisplayVo implements IVo
	{
		private var _data:Object;
		/**
		 * 元件的标题
		 */
		public var title:String = "";
		/**
		 * 元件对象
		 */
		public var display:Sprite;
		
		/* INTERFACE com.xueersi.corelibs.interfaces.IVo */
		
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