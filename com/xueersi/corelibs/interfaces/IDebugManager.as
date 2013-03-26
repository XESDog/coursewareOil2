package com.xueersi.corelibs.interfaces 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * @describe	Debug
	 * @author 		Mr.zheng
	 * @time 		2011-9-18 13:49
	 */
	public interface IDebugManager 
	{
		/**
		 * 初始化
		 * @param	gameStage
		 */
		function init(contextView:DisplayObjectContainer):void;
		/**
		 * trace信息
		 * @param	...args
		 */
		function trace(...args):void;
		/**
		 * 按照频道trace信息
		 * @param	channcel
		 * @param	...args
		 */
		function traceCh(channcel:*, ...args):void;
		/**
		 * 观察对象
		 * @param	obj
		 */
		function inspect(obj:Object):void;
	}
	
}