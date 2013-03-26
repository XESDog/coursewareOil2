package com.xueersi.corelibs.interfaces
{
	import flash.events.IEventDispatcher;
	
	/**
	 * @describe	缓动效果
	 * @author 		zihua.zheng
	 * @time 		2012-3-28 16:39
	 */
	public interface IEase extends IEventDispatcher
	{
		function executeEase(obj:Object):void;
	}
	
}