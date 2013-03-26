package com.xueersi.corelibs.uiCore 
{
	import com.xueersi.corelibs.event.ICSToolEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * @describe  	...
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012/8/15 10:51
	 */
	public class ICSInputTxt extends ICSView
	{
		private var _txt:TextField;
		public function ICSInputTxt() 
		{
			if (!this["txt"]) {
				ICSView.showError(this,"请在元件中放置一个动态文本，并取名'txt'");
			}else {
				_txt = this["txt"];
			}
			
		}
		/* public function */
		
		/* override function */
		override protected function addStageEvent(e:Event):void 
		{
			super.addStageEvent(e);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		override protected function removeStageEvent(e:Event):void 
		{
			super.removeStageEvent(e);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		/* private function */
		private function onMouseDown(e:MouseEvent):void 
		{
			loaderInfo.sharedEvents.dispatchEvent(new ICSToolEvent(ICSToolEvent.SPEED_DIAL));
			
			//侦听九宫格的事件
			for (var i:int = 0; i < 10; i++) 
			{
				loaderInfo.sharedEvents.addEventListener("num_"+i,onInputNum);
			}
			loaderInfo.sharedEvents.addEventListener("num_cancel", onCancel);
			loaderInfo.sharedEvents.addEventListener("speedDial_close", onSpeedDialClose);
		}
		
		private function onSpeedDialClose(e:Event):void 
		{
			for (var i:int = 0; i < 10; i++) 
			{
				loaderInfo.sharedEvents.removeEventListener("num_"+i,onInputNum);
			}
			loaderInfo.sharedEvents.removeEventListener("num_cancel", onCancel);
			loaderInfo.sharedEvents.removeEventListener("speedDial_close", onSpeedDialClose);
		}
		
		private function onCancel(e:Event):void 
		{
			_txt.text=_txt.text.slice(0,_txt.length-1);
		}
		
		private function onInputNum(e:Event):void 
		{
			var str:String = e.type.split("_")[1].toString();
			_txt.appendText(str);
		}
	}
	
}