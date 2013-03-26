package com.xueersi.corelibs.uiCore
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 按钮对象
	 * @author aishi
	 * @author Mr.zheng 整理 2011-8-10 18:42
	 * 影片剪辑仿按钮控制器
	 */
	dynamic public class AbcBtn extends TimeLineView
	{
		/** 按钮的状态 */
		static protected const State_Up:String="up";
		static protected const State_Over:String="over";
		static protected const State_Down:String="down";
		static protected const State_Disable:String="disabled";
		static protected const State_Selected:String="selected";

		public function AbcBtn(timeLineMc:MovieClip):void
		{
			super(timeLineMc);
			timeLineMc.mouseEnabled=false;
			timeLineMc.mouseChildren=false;
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
		public function set enabled(value:Boolean):void
		{
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
		 * 是否启用
		 */
		public function get enabled():Boolean
		{
			return timeLineMc.currentLabel != State_Disable;
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
			return timeLineMc.currentLabel == State_Selected;
		}

		/** procted function */
		protected function rollOverHandler(evt:MouseEvent):void
		{
			updateState(State_Over);
		}

		protected function rollOutHandler(evt:MouseEvent):void
		{
			updateState(State_Up);
		}

		protected function mouseDownHandler(evt:MouseEvent):void
		{
			updateState(State_Down);
		}

		protected function mouseUpHandler(evt:MouseEvent):void
		{
			updateState(State_Over);
		}

		/** private function */
		/**
		 * 更新状态
		 * @param	state
		 */
		private function updateState(state:String):void
		{
			mouseEventEnabled=true;
			timeLineMc.gotoAndStop(state);
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
					mouseEventEnabled=false;
					break;
				case State_Selected:
					removeListeners();
					mouseEventEnabled=false;
					break;
			}
		}

		private function configListeners():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		private function removeListeners():void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		private function set mouseEventEnabled(enabled:Boolean):void
		{
			this.mouseEnabled=enabled;
			this.buttonMode=enabled;
			this.mouseChildren=enabled;
		}
	}
}
