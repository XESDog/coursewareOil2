package com.xueersi.corelibs.uiCore 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @describe  	按钮对象
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012/7/12 9:50
	 */
	dynamic public class ICSBtn extends ICSView
	{
		/** 按钮的状态 */
		static protected const State_Up:int=1;
		static protected const State_Over:int=2;
		static protected const State_Down:int=3;
		static protected const State_Disable:int=4;
		static protected const State_Selected:int = 5;
		/** 添加事件 */
		protected var isAddEvent:Boolean = false;
		
		public function ICSBtn():void {
			gotoAndStop(1);
		}
		/** override function */
		override protected function addStageEvent(e:Event):void
		{
			super.addStageEvent(e);
			configListeners();
		}

		override protected function removeStageEvent(e:Event):void
		{
			super.removeStageEvent(e);
			removeListeners();
			enabled=true;
		}

		/** public function */
		/**
		 * 是否启用
		 */
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			if (value)
			{
				updateState(State_Up);
			}
			else
			{
				updateState(State_Disable);
			}
		}
		/**
		 * 选中状态
		 */
		public function set selected(value:Boolean):void
		{
			if (value)
			{
				updateState(State_Selected);
			}
			else
			{
				updateState(State_Up);
			}
		}

		/**
		 * 选中状态
		 */
		public function get selected():Boolean
		{
			return currentFrame == State_Selected;
		}

		/** procted function */
		protected function rollOverHandler(e:MouseEvent):void
		{
			updateState(State_Over);
		}

		protected function rollOutHandler(e:MouseEvent):void
		{
			updateState(State_Up);
		}

		protected function mouseDownHandler(e:MouseEvent):void
		{
			updateState(State_Down);
		}

		protected function mouseUpHandler(e:MouseEvent):void
		{
			updateState(State_Over);
		}

		/**
		 * 更新状态
		 * @param	state
		 */
		protected function updateState(state:int):void
		{
			setMouseEnabled(this, true);
			gotoAndStop(state);
			switch (state)
			{
				case State_Up:
					configListeners();
					break;
				case State_Over:
					configListeners();
					break;
				case State_Down:
					configListeners();
					break;
				case State_Disable:
					removeListeners();
					setMouseEnabled(this,false);
					break;
				case State_Selected:
					removeListeners();
					setMouseEnabled(this,false);
					break;
			}
		}
		protected function removeListeners():void 
		{
			if (!isAddEvent) return;
			isAddEvent = false;
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		protected function configListeners():void 
		{
			if (isAddEvent) return;
			isAddEvent = true;
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
	}
	
}