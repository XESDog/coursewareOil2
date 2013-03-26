package com.xueersi.corelibs.event 
{
	import com.xueersi.corelibs.interfaces.IVo;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Mr.zheng
	 */
	public class ICSMouseEvent extends Event 
	{
		public static const MOUSE_START_DRAG:String = "mouse_start_drag";//开始拖拽
		public static const MOUSE_STOP_DRAG:String = "mouse_stop_drag";	//停止拖拽
		/**
		 * 鼠标位置，等
		 */
		public var data:IVo;
		public function ICSMouseEvent(type:String,data:IVo,bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.data = data;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ICSMouseEvent(type,data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ICSMouseEvent", "type","data","bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}