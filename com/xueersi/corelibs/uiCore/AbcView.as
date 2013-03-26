package com.xueersi.corelibs.uiCore
{
	import com.xueersi.corelibs.interfaces.IRecyclable;
	import com.xueersi.corelibs.interfaces.IVo;
	import com.xueersi.corelibs.manager.DebugManagerSingle;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @describe  	显示对象基类
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2011-7-31 11:59
	 */
	public class AbcView extends Sprite implements IRecyclable
	{
		private var _inObjectPool:Boolean;

		/**
		 * 构造函数
		 */
		public function AbcView()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addStageEvent);
		}

		/* public function */
		/**
		 * 
		 * @return 
		 */
		public function get inStage():Boolean
		{
			return this.stage!=null;
		}

		/**
		 * 根据vo显示
		 * @param vo
		 */
		public function update(vo:IVo=null):void
		{

		}
		/**
		 * 简单trace 
		 * @param traceObj
		 * 
		 */
		protected function simpleTrace(...args):void{
			DebugManagerSingle.instance.trace(args);
		}
		/* override function */
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
		}
		/**
		 * 设置a对鼠标的响应状态
		 * @param a
		 * @param b
		 * 
		 */
		protected function setMouseEnabled(a:Sprite,b:Boolean):void{
			a.mouseEnabled=b;
			a.mouseChildren=b;
		}
		/**
		 *　移除所有显示对象 
		 * 
		 */
		protected function removeAllChildren():void{
			//removeChildren(0,numChildren);
		}
		/** 子类实现
		 * 	初始化的时候择机执行一次，不主动在构造函数中触发
		 *  */
		public function init():void
		{
			//throw new IllegalOperationError("Abstract method:must be overridden in a subclass");
		}

		/* INTERFACE blog.zihua2007.interfaces.IRecyclable */

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
			if (parent)
				parent.removeChild(this);
		}

		/* INTERFACE blog.zihua2007.interfaces.IDispose */
		/**
		 *	销毁
		 */
		public function dispose():void
		{
			if (parent)
				parent.removeChild(this);
			removeAllChildren();
			this.removeEventListener(Event.ADDED_TO_STAGE, addStageEvent);
		}
		public function set inObjectPool(value:Boolean):void{
			_inObjectPool=value;
		}
		public function get inObjectPool():Boolean{
			return _inObjectPool;
		}
	/* private function */

	}

}
