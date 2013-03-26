package com.xueersi.corelibs.interfaces
{
	import flash.display.Stage;

	/**
	 * @describe	布局管理
	 * @author 		Mr.zheng
	 * @time 		2011-8-23 12:06
	 */
	public interface ILayoutManager
	{
		function init(gameStage:Stage):void;
		function registerLayoutObj(layoutInstance:ILayoutAble):void;
		function removeLayoutObj(layoutInstance:ILayoutAble):void;
	}

}
