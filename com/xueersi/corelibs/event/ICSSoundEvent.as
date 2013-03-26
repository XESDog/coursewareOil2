package com.xueersi.corelibs.event 
{
	import com.xueersi.corelibs.interfaces.IVo;
	
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Mr.zheng
	 */
	public class ICSSoundEvent extends Event 
	{
		public var data:IVo;
		public static const SOUND_PLAY:String = "sound_play";
		public static const SOUND_PAUSE:String = "sound_pause";
		public static const SOUND_STOP:String = "sound_stop";
		public static const SOUND_STOP_ALL:String = "sound_stopAll";
		public function ICSSoundEvent(type:String, data:IVo=null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			this.data = data;
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new ICSSoundEvent(type,data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ICSSoundEvent", "type","data", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}