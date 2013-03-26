package com.xueersi.corelibs.event
{
	import com.xueersi.corelibs.cores.vo.PicScrollVo;
	
	import flash.events.Event;
	/*
	 * 该事件 将触发课件播放器的ShowBigPic组件 
	*/
	public class ShowBigPicEvent extends Event
	{
		public var picArr:Array;
		public var currentIndex:int;
		public static const START_TO_SHOW:String = "start_to_show";
		
		public function ShowBigPicEvent(type:String ,currentIndex:int ,picArr:Array , bubbles:Boolean=false , cancelable:Boolean=false )
		{
			this.picArr = picArr;
			this.currentIndex = currentIndex;
			super( type ,bubbles ,cancelable);
		}
		public override function clone():Event
		{
			return new ShowBigPicEvent(type , currentIndex , picArr , bubbles , cancelable );
		}
	}
}