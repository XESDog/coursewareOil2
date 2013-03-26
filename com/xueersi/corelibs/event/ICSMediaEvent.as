package com.xueersi.corelibs.event 
{
	import com.xueersi.corelibs.interfaces.IVo;
	
	import flash.events.Event;
	
	/**
	 * 该事件类    将被三类组件分别  调度 
	 * 这三类组件  分别专用于处理  图片  视频  影片剪辑  ，与 本类的 公共静态变量   MEDIA_IMAGE MEDIA_VIDEO  MEDIA_MOVIECLIP 对应
	 * 当事件被调度时  事件的iov类型参数 data 携带 该组件的iov类型数据，以供在处理该事件的函数中被引用
	 * @author Mr.zheng
	 */
	public class ICSMediaEvent extends Event 
	{
		public var data:IVo;
		public static const MEDIA_IMAGE:String = "media_image";			//图片
		public static const MEDIA_VIDEO:String = "media_video";			//视频
		public static const MEDIA_MOVIECLIP:String = "media_movieClip";	//影片剪辑
		public function ICSMediaEvent(type:String,data:IVo=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.data = data;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ICSMediaEvent(type, data,bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MediaEvent", "type", "data","bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}