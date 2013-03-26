package com.xueersi.corelibs.uiCore 
{
	import com.xueersi.corelibs.manager.DebugManagerSingle;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @describe  	进度条
	 * @author  	zihua.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2011-10-15 20:17
	 */
	public class AbcProgressBar extends AbcBindView
	{
		public var progress_LEA:MovieClip;
		
		/** 是否显示调试信息 */
		protected var DEBUG:Boolean = true;
		
		private var _sonNum:Number=0;
		private var _parentNum:Number=0;
		
		public function AbcProgressBar() 
		{
		}
		/* public function */
		/**
		 * 设置进度
		 * @param	sonNum		分子
		 * @param	parentNum	分母
		 */
		public function setProgress(sonNum:Number, parentNum:Number):void {
			if (sonNum < 0 || parentNum < 0) {
//				abcTrace(new TraceVo("sonNum或parentNum值不能小于0", TraceVo.TRACE_CH, "AbcProgressBar"));
				throw new Error("sonNum或parentNum值不能小于0");
			}
			_sonNum = sonNum;
			_parentNum = parentNum;
			//取小数点后两位
			var rate:Number = new Number((sonNum / parentNum).toFixed(2));
			rate = rate > 1?rate = 1:rate;
			progress_LEA.scaleX = rate;
		}
		/* override function */
		override public function init():void 
		{
			super.init();
			setMouseEnabled(progress_LEA, false);
		}
		override protected function addStageEvent(e:Event):void 
		{
			super.addStageEvent(e);
			if (DEBUG) this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
		}
		override protected function removeStageEvent(e:Event):void 
		{
			super.removeStageEvent(e);
			if (DEBUG) this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
		}
		override public function readyRecycle():void 
		{
			super.readyRecycle();
			progress_LEA.scaleX = 1;
			_sonNum = 0;
			_parentNum = 0;
		}
		override public function dispose():void 
		{
			super.dispose();
			progress_LEA = null;
		}
		/* private function */
		private function onRollOver(e:MouseEvent):void 
		{
//			abcTrace(new TraceVo("sonNum:"+_sonNum+" parentNum:"+_parentNum, TraceVo.TRACE_CH, "AbcProgressBar"));
			DebugManagerSingle.instance.trace("[AbcProgressBar:onRollOver] sonNum:"+_sonNum+" parentNum:"+_parentNum);
		}
	}
	
}