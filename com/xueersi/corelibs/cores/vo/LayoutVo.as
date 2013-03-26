package com.xueersi.corelibs.cores.vo
{
	import flash.display.DisplayObjectContainer;


	/**
	 * @describe  	布局Vo
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2011-8-23 11:55
	 */
	public class LayoutVo
	{
		/** 位置百分比，0~1之间 */
		public var rateX:Number=0;
		public var rateY:Number=0;

		/** 位置偏移值 */
		public var offsetX:int;
		public var offsetY:int;

		/** 容器 */
		public var contain:DisplayObjectContainer;
	}

}
