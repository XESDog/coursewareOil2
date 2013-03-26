package com.xueersi.corelibs.uiCore
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.xueersi.corelibs.interfaces.IVo;
	import com.xueersi.corelibs.event.TimelineEvent;

	/**
	 * @describe  	时间轴view
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2011-8-10 18:43
	 */
	public class TimeLineView extends AbcView
	{
		private var _timeLineMc:MovieClip;
		/** 是否播放状态 */
		private var _isPlay:Boolean;
		/** 帧标签集合 */
		private var _currentLabels:Array;

		/** 是否显示调试信息 */
		protected var DEBUG:Boolean=false;

		public function TimeLineView(timeLineMc:MovieClip)
		{
			_timeLineMc=timeLineMc;
			super.addChild(timeLineMc);
			this.x=timeLineMc.x;
			this.y=timeLineMc.y;
			timeLineMc.x=0;
			timeLineMc.y=0;
			timeLineMc.gotoAndStop(1);

			/** 提取帧标签 */
			_currentLabels=[];
			var len:int=_timeLineMc.currentLabels.length;
			for (var i:int=0; i < len; i++)
			{
				_currentLabels.push(_timeLineMc.currentLabels[i].name);
			}
		}

		/* public function */
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
				_timeLineMc.addEventListener(Event.ENTER_FRAME, watch);
			}
			else
			{
				_timeLineMc.removeEventListener(Event.ENTER_FRAME, watch);
			}
		}

		public function play():void
		{
			_timeLineMc.play();
			isPlay=true;
		}

		public function stop():void
		{
			_timeLineMc.stop();
			isPlay=false;
		}

		/**
		 * gotoAndStop指定label
		 * 到达目的label后抛出事件TimelineEvent.GOTO_LABEL_REACHED
		 * @param	label
		 * @param	data	发送GOTO_LABEL_REACHED事件，将该数据带出
		 * @param	fun		到达指定帧，执行的方法
		 * @param	...arg	fun的参数
		 */
		public function gotoAndStop(label:String, data:IVo=null, fun:Function=null, ... args):void
		{
			if (_currentLabels.indexOf(label) != -1)
			{
				_timeLineMc.addEventListener(Event.ENTER_FRAME, onGotoAndStop);

				_timeLineMc.gotoAndStop(label);
				isPlay=false;
			}
			function onGotoAndStop(e:Event):void
			{
				if (currentFrame == _timeLineMc.totalFrames) {
					dispatchEvent(new TimelineEvent(TimelineEvent.END_REACHED, currentFrame, currentFrameLabel));
					removeEventListener(Event.ENTER_FRAME, onGotoAndStop);
				}
				if (currentFrameLabel == label)
				{
					if (fun == null)
					{
						fun=function():void
						{
							if (DEBUG)
								simpleTrace("[TimeLineView] 到达指定帧:" + label);
						}
						fun();
					}
					else
					{
						fun(args);
					}
					dispatchEvent(new TimelineEvent(TimelineEvent.LABEL_REACHED, currentFrame, currentFrameLabel, data));
					_timeLineMc.removeEventListener(Event.ENTER_FRAME, onGotoAndStop);
				}
			}
		}

		public function gotoAndPlay(label:String):void
		{
			if (_currentLabels.indexOf(label) != -1)
			{
				_timeLineMc.gotoAndPlay(label);
				isPlay=true;
			}
		}

		public function get timeLineMc():MovieClip
		{
			return _timeLineMc;
		}

		public function get currentFrame():int
		{
			return _timeLineMc.currentFrame;
		}

		public function get currentFrameLabel():String
		{
			return _timeLineMc.currentFrameLabel;
		}

		/* override function */
		override protected function addStageEvent(e:Event):void
		{
			super.addStageEvent(e);

		}

		override protected function removeStageEvent(e:Event):void
		{
			super.removeStageEvent(e);
			stop();
		}

		override public function dispose():void
		{
			super.dispose();
			_timeLineMc.gotoAndStop(1);
			_timeLineMc=null;
			_currentLabels=[];
		}

		override public function readyRecycle():void
		{
			super.readyRecycle();
			_timeLineMc.gotoAndStop(1);
		}

		override public function getChildByName(name:String):DisplayObject
		{
			return _timeLineMc.getChildByName(name);
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			return _timeLineMc.addChild(child);
		}

		/* private function */
		/**  play,gotoAndPlay启用侦听，stop,gotoAndStop停止侦听*/
		private function watch(e:Event):void
		{
			if (currentFrameLabel != null)
			{
				dispatchEvent(new TimelineEvent(TimelineEvent.LABEL_REACHED, currentFrame, currentFrameLabel));
			}
			if (currentFrame == _timeLineMc.totalFrames)
			{
				dispatchEvent(new TimelineEvent(TimelineEvent.END_REACHED, currentFrame, currentFrameLabel));
			}
		}
	}

}
