package com.xueersi.corelibs.interfaces
{

	/**
	 * @ 描述			可回收对象
	 * @ 作者			郑子华
	 * @ 版本			version 1.0
	 * @ 创建日期		2011-4-13上午11:51:32
	 */
	public interface IRecyclable extends IDispose
	{
		//重新初始化
		function reInit():void;
		//回收
		function readyRecycle():void;
		
		//该对象存放在对象池中
		function get inObjectPool():Boolean;
		function set inObjectPool(value:Boolean):void;
	}
}
