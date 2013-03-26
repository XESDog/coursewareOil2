package com.xueersi.corelibs.interfaces 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	/**
	 * @describe	拖拽管理
	 * @author 	Mr.zheng
	 * @time 		2012/5/28 15:44
	 */
	public interface IDragManager 
	{
		/**
		 * 
		 * @param	dragContainer
		 * @param	obj	DisplayObject|String|Class
		 * @param	mouseP	mouse按下时相对contextView的位置
		 * @param	hits	需要检测碰撞的对象集合
		 * @param	stopType0：停止拖拽
		 * 					1：remove显示对象
		 */
		function startDrag(obj:*,dragContainer:DisplayObjectContainer,mouseP:Point,hits:Array,stopType:int=0):void;
	}
	
}