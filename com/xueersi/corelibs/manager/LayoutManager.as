package com.xueersi.corelibs.manager 
{
	import com.xueersi.corelibs.interfaces.ILayoutAble;
	import com.xueersi.corelibs.interfaces.ILayoutManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * 布局管理
	 * 单例模式类
	 * @author 郑子华
	 * @time	2011-8-23 12:00
	 */
	public class LayoutManager implements ILayoutManager
	{
		private static var _instance:LayoutManager = null;
		public function LayoutManager(single:Single) 
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		/**
		 * 单例引用
		 */
		public static function get instance():LayoutManager
		{
			if(_instance == null)
			{
				_instance = new LayoutManager(new Single());
			}
			return _instance;
		}
		/**
		 * 参与布局的集合
		 */
		private var _layoutArr:Array;
		private var _stage:Stage;
		
		public function init(gameStage:Stage):void {
			_layoutArr = [];
			_stage = gameStage;
			_stage.addEventListener(Event.RESIZE, onStageSize);
		}
		
		public function registerLayoutObj(layoutInstance:ILayoutAble):void {
			var index:int = _layoutArr.indexOf(layoutInstance);
			if (index == -1) {
				_layoutArr.push(layoutInstance);
				reposition(layoutInstance);
			}else {
				DebugManagerSingle.instance.trace(this+"layoutInstance已经注册。");
			}
		}
		public function removeLayoutObj(layoutInstance:ILayoutAble):void {
			var index:int = _layoutArr.indexOf(layoutInstance);
			if (index == -1) {
				DebugManagerSingle.instance.trace(this+"没有该对象");
			}else {
				_layoutArr.splice(index, 1);
			}
		}
		/** private function */
		/**
		 * 舞台大小改变
		 * @param	e
		 */
		private function onStageSize(e:Event):void {
			for each (var item:ILayoutAble in _layoutArr) 
			{
				reposition(item);
			}
		}
		/**
		 * 重新布局
		 * @param	layoutObj
		 */
		private function reposition(layoutInstance:ILayoutAble):void {
			var contain:DisplayObjectContainer = layoutInstance.layoutObj.contain || _stage;
			var containW:int = contain is Stage?Stage(contain).stageWidth:contain.width;
			var containH:int = contain is Stage?Stage(contain).stageHeight:contain.height;
			var rateX:Number = layoutInstance.layoutObj.rateX;
			var rateY:Number = layoutInstance.layoutObj.rateY;
			var offsetX:int = layoutInstance.layoutObj.offsetX;
			var offsetY:int = layoutInstance.layoutObj.offsetY;
			(layoutInstance as DisplayObject).x = rateX * containW + offsetX;
			(layoutInstance as DisplayObject).y = rateY * containH + offsetY;
		}
	}
}
class Single{}