package com.xueersi.corelibs.uiCore
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	import com.xueersi.corelibs.event.TimelineEvent;

	/**
	 * @describe  	动态按钮
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2011-8-11 10:11
	 */
	public class AbcDynamicBtn extends AbcBtn
	{
		private var _label:String;

		public function AbcDynamicBtn(timeLineMc:MovieClip, label:String="button")
		{
			super(timeLineMc);
			_label=label;

			onGotoLabel();
		}

		/* public function */
		public function set label(value:String):void
		{
			_label=value;
			onGotoLabel();
		}

		public function get label():String
		{
			return _label;
		}

		/* override function */
		override protected function addStageEvent(e:Event):void
		{
			super.addStageEvent(e);
			addEventListener(TimelineEvent.LABEL_REACHED, onGotoLabel);
		}

		override protected function removeStageEvent(e:Event):void
		{
			super.removeStageEvent(e);
			removeEventListener(TimelineEvent.LABEL_REACHED, onGotoLabel);
		}

		override public function readyRecycle():void
		{
			super.readyRecycle();
			_label="";
			txt.text="";
		}

		/* private function */
		private function get txt():TextField
		{
			return timeLineMc["txt"];
		}

		private function onGotoLabel(e:TimelineEvent=null):void
		{
			if (txt.text != _label)
				txt.text=_label;
		}
	}

}
