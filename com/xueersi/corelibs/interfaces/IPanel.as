package com.xueersi.corelibs.interfaces 
{
	/**
	 * 面板接口 
	 * @author Administrator
	 * 
	 */
	public interface IPanel
	{
		/**
		 * 弹出
		 */
		function popup():void;
		/**
		 * 弹回
		 */
		function popdown():void;
		/**
		 * 设置缓动效果
		 * @param	easeIn
		 * @param	easeOut
		 */
		function setEase(easeIn:Class, easeOut:Class):void
	}
}