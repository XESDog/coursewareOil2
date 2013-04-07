package com.xesDog.coursewareOil2.managers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * 
	 * 单例模式类
	 * @describe		初始resize事件
	 * @author			Mr.zheng
	 * @time 			2012/11/27 17:11
	 */
	public class ResizeManager
	{
		private static var _instance:ResizeManager = null;
		public function ResizeManager(single:Single){
			
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		/**
		 * 单例引用
		 */
		public static function get instance():ResizeManager
		{
			if(_instance == null)
			{
				_instance = new ResizeManager(new Single());
			}
			return _instance;
		}
		
		//start-----------------------------------------------------------------------------
		private var _contextView:DisplayObjectContainer;
		private var _resizes:Array = [];
		/* public function */
		public function init(contextView:DisplayObjectContainer):void {
			_contextView = contextView;
			_contextView.stage.addEventListener(Event.RESIZE, onResize);
		}
		public function addResizeObj(obj:MovieClip):void {
			if(_resizes.indexOf(obj)==-1){
				_resizes.push(obj);
				resizeObj(obj);
			}
		}
		public function removeResizeObj(obj:MovieClip):void {
			var index:int = _resizes.indexOf(obj);
			if(index!=-1){
				_resizes.splice(index,1);
			}
		}
		
		/* private function */
		private function onResize(e:Event):void 
		{
			//ApplicationFacad.instance.sendNotification(Event.RESIZE);
			for each (var item:MovieClip in _resizes) 
			{
				resizeObj(item);
			}
		}
		/**
		 * 重设对象的位置
		 * @param	uiMenuList
		 */
		private function resizeObj(obj:MovieClip):void 
		{
			if (obj.offsetX == null) {
				obj.offsetX = 0;
			}
			if (obj.offsetY == null) {
				obj.offsetY = 0;
			}
			if (obj.percentX == null) {
				obj.percentX = 0;
			}
			if (obj.percentY == null) {
				obj.percentY = 0;
			}
			DisplayObject(obj).x = obj.percentX * _contextView.stage.stageWidth + obj.offsetX;
			DisplayObject(obj).y = obj.percentY * _contextView.stage.stageHeight + obj.offsetY;
			if(/**obj.stage&& 去掉该判断，避免对象不在舞台，resize事件触发后，
			再将对象放入舞台，尺寸不正确的问题*/obj.onResize)obj.onResize();
		}
	}
}
class Single{}