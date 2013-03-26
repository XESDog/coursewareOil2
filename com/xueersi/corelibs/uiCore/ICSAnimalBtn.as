package com.xueersi.corelibs.uiCore 
{
	import com.xueersi.corelibs.event.TimelineEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * @describe  	能播放动画的按钮，比如鼠标点击之后，按钮有段动画播放，然后再回到弹起状态
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012/8/7 10:00
	 */
	public class ICSAnimalBtn extends ICSBtn
	{
		protected var timeLineView:MovieClip;

		/* public function */
		
		/* override function */
		override protected function updateState(state:int):void 
		{
			super.updateState(state);
			switch (state)
			{
				case State_Down:
					removeListeners();
					timeLineView = hasMovieClip();
					if (!timeLineView)ICSView.showError(stage,"请在第三帧放上MovieClip.");
					timeLineView.addEventListener(Event.ENTER_FRAME, watch);
					break;
			}
		}
		/* private function */
		private function onEndReached():void 
		{
			configListeners();
			updateState(State_Up);
		}
		private function watch(e:Event):void
		{
			if (timeLineView.currentFrame == timeLineView.totalFrames)
			{
				timeLineView.removeEventListener(Event.ENTER_FRAME, watch);
				onEndReached();
			}
		}
		/** protected function  */
		/*protected function hasTimeLineView():ICSTimeLineView {
			var len:int = numChildren;
			for (var i:int = 0; i < len; i++) 
			{
				if (getChildAt(i) is ICSTimeLineView) {
					return getChildAt(i) as ICSTimeLineView;
				}
			}
			return null;
		}*/
		protected function hasMovieClip():MovieClip {
			var len:int = numChildren;
			for (var i:int = 0; i < len; i++) 
			{
				if (getChildAt(i) is MovieClip) {
					return getChildAt(i) as MovieClip;
				}
			}
			return null;
		}
	}
	
}