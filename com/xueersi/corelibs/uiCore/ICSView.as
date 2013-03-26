package com.xueersi.corelibs.uiCore 
{
	
	import com.bit101.components.Component;
	import com.xueersi.corelibs.interfaces.IRecyclable;
	import com.xueersi.corelibs.interfaces.IVo;
	import com.xueersi.corelibs.manager.DebugManagerSingle;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @describe  	notice:如果第一帧上有帧标签，第一帧上的事件在第一次是无法侦听的
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012/7/11 16:05
	 * 
	 * @version 2012-8-2	将控制动画的代码分离出去，形成新的类 ICSTimeLineView
	 * 
	 * @version 2012/8/27   ICS2项目中，不考虑回收的问题，所有的视图组件一概销毁
	 */
	public class ICSView extends MovieClip implements IRecyclable
	{
		
		/**
		 * 是否在对象池 
		 */
		private var _inObjectPool:Boolean;

		/**
		 * 构造函数
		 */
		public function ICSView()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addStageEvent);
		}
		/**
		 * 提示错误信息 
		 * @param container	容器
		 * @param str				内容
		 * 
		 */
		public static function showError(container:DisplayObjectContainer,str:String):void {
			/*var window:Window = new Window(container, Math.random() * 200, Math.random() * 200);
			var label:Label = new Label(window, 10, 10, str);
			label.autoSize = true;
			window.title = "程序组提醒您：";
			window.width = 300;
			window.height = 200;
			window.hasCloseButton = true;
			window.addEventListener(Event.CLOSE, onWindowClose);
			
			function onWindowClose():void {
				window.removeEventListener(Event.CLOSE, onWindowClose);
				container.removeChild(window);
			}*/
		}
		/* public function */
	
		public function get inStage():Boolean
		{
			return this.stage!=null;
		}
		/** 子类实现
		 * 	初始化的时候择机执行一次，不主动在构造函数中触发
		 *  */
		protected function init():void
		{
			//throw new IllegalOperationError("Abstract method:must be overridden in a subclass");
		}

		/* INTERFACE IRecyclable */

		/** 重新初始化
		 * 	放置到舞台上时执行
		 *  */
		public function reInit():void
		{
			//throw new IllegalOperationError("Abstract method:must be overridden in a subclass");
		}

		/** 准备回收
		 *	移除出舞台执行
		 * */
		public function readyRecycle():void
		{
			if (parent) {
				parent.removeChild(this);
			}
				
			gotoAndStop(1);
		}
		/**
		 * 根据vo显示
		 * @param vo
		 */
		public function update(vo:IVo=null):void
		{
			//throw new IllegalOperationError("Abstract method:must be overridden in a subclass");
		}
		
		/** protected function  */
		/**
		 * 简单trace 
		 * @param traceObj
		 * 
		 */
		protected function simpleTrace(...args):void{
			DebugManagerSingle.instance.trace(args);
		}
		/**
		 * 切忌在ADDED_TO_STAGE事件中addChild一个侦听了ADDED_TO_STAGE事件的显示对象
		 * 详细情况见：http://blog.sina.com.cn/s/blog_55ff5d2d0100tofp.html（危险的ADDED_TO_STAGE事件）
		 * @param	e
		 */
		protected function addStageEvent(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addStageEvent);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeStageEvent);
		}
		/**
		 * 
		 * @param e
		 */
		protected function removeStageEvent(e:Event):void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addStageEvent);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeStageEvent);
			
			gotoAndStop(1);
		}
		/**
		 * 设置a对鼠标的响应状态
		 * @param a
		 * @param b
		 * 
		 */
		protected function setMouseEnabled(a:Sprite,b:Boolean):void{
			a.mouseEnabled = b;
			a.buttonMode=b;
			a.mouseChildren=b;
		}
		/**
		 * 绘制皮肤
		 */
		protected function drawSkin():void {
			//TODO:绘制新的皮肤
		}
		/* INTERFACE blog.zihua2007.interfaces.IDispose */
		/**
		 * 销毁，子类实现
		 * 存在这样一个问题，父对象在removeFromeStage事件触发的时候，将子对象从自身移除，
		 * 如果子对象的removeFromeStage事件存在stage的引用，当执行子对象的removeFromeStage方法时就会报错。
		 * 父对象不应该对子对象做操作，销毁的顺序应该由子对象开始逐步向根对象执行
		 */
		public function dispose():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addStageEvent);
			var len:int = numChildren;
			var dp:DisplayObject;
			for (var i:int = 0; i < len; i++) 
			{
				dp = getChildAt(i);
				if (dp.hasOwnProperty("dispose")&&(dp is Component||dp is ICSView)) {
					dp["dispose"]();
				}
			}
		}
		public function set inObjectPool(value:Boolean):void{
			_inObjectPool=value;
		}
		public function get inObjectPool():Boolean{
			return _inObjectPool;
		}
	}
	
}