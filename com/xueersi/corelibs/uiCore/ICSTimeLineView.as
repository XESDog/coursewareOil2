package com.xueersi.corelibs.uiCore
{
	import com.xueersi.corelibs.event.TimelineEvent;
	
	import flash.display.FrameLabel;
	import flash.events.Event;

	public class ICSTimeLineView extends ICSView
	{
		/** 是否播放状态 */
		private var _isPlay:Boolean;
		/** 经过的帧标签 */
		private var _previousLabel:String;
		public function ICSTimeLineView()
		{
			super();
			isPlay = true;
		}
		public function get isPlay():Boolean
		{
			return _isPlay;
		}
		
		public function set isPlay(value:Boolean):void
		{
			if (value == _isPlay) return;
			_isPlay=value;
			if (value)
			{
				addEventListener(Event.ENTER_FRAME, watch);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, watch);
			}
		}
		/** override function  */
		override public function play():void
		{
			super.play();
			isPlay=true;
		}
		
		override public function stop():void
		{
			super.stop();
			isPlay=false;
		}
		override protected function removeStageEvent(e:Event):void{
			super.removeStageEvent(e);
		}
		/**
		 * gotoAndStop指定label
		 * 到达目的label后抛出事件TimelineEvent.GOTO_LABEL_REACHED
		 * @param	label
		 * @param	data	发送GOTO_LABEL_REACHED事件，将该数据带出
		 * @param	fun		到达指定帧，执行的方法
		 * @param	...arg	fun的参数
		 */
		override public function gotoAndStop(frame:Object,scene:String=null):void
		{
			if(frame as String){
				if (hasFrameLabel(frame.toString()))
				{
					addEventListener(Event.ENTER_FRAME, onGotoAndStop);
					super.gotoAndStop(frame);
					isPlay=false;
				}else {
					throw new Error("[ICSView] 没有这个帧标签。");
				}
			}else if (frame as int) {
				addEventListener(Event.ENTER_FRAME, onGotoAndStop);
				super.gotoAndStop(frame);
				isPlay=false;
			}else {
				throw new Error("[ICSView] 没有这样的帧类型。");
			}
			function onGotoAndStop(e:Event):void
			{
				if (currentFrame == totalFrames) {
					dispatchEvent(new TimelineEvent(TimelineEvent.END_REACHED, currentFrame, currentFrameLabel));
					removeEventListener(Event.ENTER_FRAME, onGotoAndStop);
				}
				if (currentFrameLabel)
				{
					dispatchEvent(new TimelineEvent(TimelineEvent.LABEL_REACHED, currentFrame, currentFrameLabel));
					removeEventListener(Event.ENTER_FRAME, onGotoAndStop);
				}
			}
		}
		override public function gotoAndPlay(frame:Object,scene:String=null):void
		{
			if(frame as String){
				if (hasFrameLabel(frame.toString()))
				{
					isPlay = true;
					super.gotoAndPlay(frame);
				}else {
					throw new Error("[ICSView] 没有这个帧标签。");
				}
			}else if (frame as int) {
				isPlay = true;
				super.gotoAndPlay(frame);
			}else {
				throw new Error("[ICSView] 没有这样的帧类型。");
			}
		}
		/**  play,gotoAndPlay启用侦听，stop,gotoAndStop停止侦听*/
		private function watch(e:Event):void
		{
			if (currentFrameLabel)
			{
				dispatchEvent(new TimelineEvent(TimelineEvent.LABEL_REACHED, currentFrame, currentFrameLabel));
			}
			if (currentFrame == totalFrames)
			{
				dispatchEvent(new TimelineEvent(TimelineEvent.END_REACHED, currentFrame, currentFrameLabel));
			}
		}
		/**
		 * 是否存在该帧标签
		 * @param	frameLabel
		 * @return
		 */
		private function hasFrameLabel(frameLabel:String):Boolean {
			var len:int = currentLabels.length;
			for each (var item:FrameLabel in currentLabels) 
			{
				if (item.name == frameLabel) {
					return true;
				}
			}
			return false;
		}
	}
}