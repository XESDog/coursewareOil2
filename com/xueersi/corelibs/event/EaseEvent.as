package com.xueersi.corelibs.event
{
	import flash.events.Event;
	
	/**
	 * 缓动事件
	 * @author zihua.zheng
	 */
	public class EaseEvent extends Event 
	{
		/**
		 * 缓动执行完成
		 */
		public static const EASE_COMPLETED:String = "ease_completed";
		
		public function EaseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new EaseEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EaseEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}