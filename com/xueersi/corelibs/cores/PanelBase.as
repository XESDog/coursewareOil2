package com.xueersi.corelibs.cores 
{
	import com.xueersi.corelibs.event.EaseEvent;
	import com.xueersi.corelibs.interfaces.IEase;
	import com.xueersi.corelibs.interfaces.IPanel;
	import com.xueersi.corelibs.uiCore.ICSView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * @describe  	面板基类
	 * @author  	zihua.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012-3-28 16:27
	 */
	public class PanelBase extends ICSView implements IPanel
	{
		/**
		 * 弹出缓动
		 */
		protected var _easeIn:IEase;
		/**
		 * 弹入缓动
		 */
		protected var _easeOut:IEase;
		
		private var _mouseP:Point;
		private var _canMove:Boolean=false;
		
		public function PanelBase():void{
			//设置缓动默认值，默认值效果是不缓动
			
		}
		/**
		 * 是否可拖动 ，默认为false
		 */
		public function set canMove(value:Boolean):void
		{
			_canMove = value;
			if(value){
				this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			}else{
				this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			}
		}

		override protected function addStageEvent(e:Event):void{
			super.addStageEvent(e);
			if(_canMove)this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		override protected function removeStageEvent(e:Event):void{
			super.removeStageEvent(e);
			if(_canMove)this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseLeave);
			
			_mouseP=new Point(mouseX,mouseY);
		}
		
		protected function onMouseLeave(event:Event):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.removeEventListener(MouseEvent.ROLL_OUT,onMouseLeave);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.removeEventListener(MouseEvent.ROLL_OUT,onMouseLeave);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			this.x+=mouseX-_mouseP.x;
			this.y+=mouseY-_mouseP.y;
		}
		/* INTERFACE com.sonModule.popupManager.interfaces.IPanel */
		
		public function popup():void 
		{
			_easeIn.executeEase(this);
		}
		
		public function popdown():void 
		{
			_easeOut.addEventListener(EaseEvent.EASE_COMPLETED, onEaseCompleted);
			_easeOut.executeEase(this);
		}
		
		public function setEase(easeInClass:Class, easeOutClass:Class):void
		{
			_easeIn = new easeInClass();
			_easeOut = new easeOutClass();
		}
		
		protected function onEaseCompleted(e:EaseEvent):void 
		{
			_easeOut.removeEventListener(EaseEvent.EASE_COMPLETED, onEaseCompleted);
			dispatchEvent(e.clone());
		}
		/* public function */
		
		/* override function */
		
		/* private function */
	}
	
}