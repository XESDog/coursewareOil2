package com.xueersi.corelibs.event 
{
	import com.xueersi.corelibs.interfaces.IVo;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Mr.zheng
	 */
	public class ICSToolEvent extends Event 
	{

		public static const CALCULATOR:String = "calculator";
		public static const STOPWATCH:String = "stopwatch";
		public static const GRAPH_TOOL:String = "graph_tool";
		/**
		 * 九宫格
		 */
		public static const SPEED_DIAL:String = "speed_dial";
		
		public function ICSToolEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 

			super(type, bubbles, cancelable);			
		} 
		
		public override function clone():Event 
		{ 
			return new ICSToolEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ICSToolEvent", "type","bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}