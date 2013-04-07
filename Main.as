package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Mr.zheng
	 */
	dynamic public class Main extends MovieClip 
	{
		
		/**
		 * 菜单数
		 */
		private var _menuNum:uint = 14;
		/**
		 * 当前显示的menuList
		 */
		private var _currMenuList:DisplayObject;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			hideAllMenuList();
			addMainBtnsEvent();
			
			this.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		/**
		 * 舞台的任意地方点击
		 * @param	e
		 */
		private function onStageClick(e:MouseEvent):void 
		{
			trace("stage click");
			if (_currMenuList) {
				_currMenuList.visible = false;
				_currMenuList = null;
			}
		}
		/**
		 * 隐藏所有menuList
		 */
		private function hideAllMenuList():void {
			var menuList:DisplayObject;
			for (var i:int = 1; i <=_menuNum; i++) 
			{
				menuList = this["menuList_" + i] as DisplayObject;
				menuList.visible = false;
			}
		}
		/**
		 * 添加Main btns事件
		 */
		private function addMainBtnsEvent():void {
			var btn:DisplayObject;
			for (var i:int = 1; i <= _menuNum; i++) 
			{
				btn = this["btn_" + i] as DisplayObject;
				btn.addEventListener(MouseEvent.ROLL_OVER, onMainBtnRollOver);
				btn.addEventListener(MouseEvent.CLICK, onMainBtnClick);
			}
		}
		
		private function onMainBtnRollOver(e:MouseEvent):void 
		{
			var name:String = e.currentTarget.name;
			var id:String = name.split("_")[1];
			if (_currMenuList)_currMenuList.visible = false;
			_currMenuList = this["menuList_" + id] as DisplayObject;
			_currMenuList.visible = true;
		}
		/**
		 * Main btns 点击
		 * @param	e
		 */
		private function onMainBtnClick(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
		}
		
	}
	
}