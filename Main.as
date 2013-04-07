package 
{
	import com.xesDog.coursewareOil2.managers.Manager_Version;
	import com.xesDog.coursewareOil2.managers.Manager_Xml;
	import com.xesDog.coursewareOil2.managers.ResizeManager;
	import com.xesDog.coursewareOil2.uis.MenuList;
	import com.xesDog.coursewareOil2.uis.VideoContainer;
	import de.polygonal.ds.TreeNode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
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
		/**
		 * 按钮的up状态临时存储
		 */
		private var _btnUpStates:Dictionary;
		/**
		 * 当前按钮
		 */
		private var _currMainBtn:SimpleButton;
		
		private var _headBarMc:MovieClip;
		private var _logMc:MovieClip;
		private var _bottomBarMc:MovieClip;
		private var _versionMc:MovieClip;
		private var _fullScreenMc:MovieClip;
		private var _bgMc:MovieClip;
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			Manager_Version.instance.setVersion(this);	//版本信息
			Manager_Xml.instance.init();
			Manager_Xml.instance.loadMenuXml();			//菜单信息
			Manager_Xml.instance.xmlLoaded.addOnce(onMenuXmlLoaded);
			
			_btnUpStates = new Dictionary();
			
			_headBarMc = this["headBarMc"];
			_logMc = this["logMc"];
			_bottomBarMc = this["bottomBarMc"];
			_versionMc = this["versionMc"];
			_fullScreenMc = this["fullScreenMc"];
			_bgMc = this["bgMc"];
			
			hideAllMenuList();
			this["videoMc"].visible = false;
			
			ResizeManager.instance.init(this.stage);
			setMCLayout();
			
			this.addEventListener(MouseEvent.CLICK, onStageClick);
			
			_fullScreenMc.addEventListener(MouseEvent.CLICK, onFullClick);
			
		}
		
		private function onFullClick(e:MouseEvent):void 
		{
			if (stage.displayState.indexOf(StageDisplayState.FULL_SCREEN) == -1) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}else {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}

		/**
		 * 菜单读取完成
		 */
		private function onMenuXmlLoaded():void 
		{
			trace(Manager_Xml.instance.menuNode);
			addMainBtnsEvent();
		}
		/**
		 * 设置布局相关
		 */
		private function setMCLayout():void {
			_logMc.percentX = .5;
			ResizeManager.instance.addResizeObj(_logMc);
			
			_headBarMc.onResize = function() {
				_headBarMc.width = stage.stageWidth;
			}
			ResizeManager.instance.addResizeObj(_headBarMc);
			
			_bottomBarMc.percentY = 1;
			_bottomBarMc.onResize = function() {
				_bottomBarMc.width = stage.stageWidth;
			}
			ResizeManager.instance.addResizeObj(_bottomBarMc);
			
			_versionMc.percentY = 1;
			ResizeManager.instance.addResizeObj(_versionMc);
			
			_fullScreenMc.percentX = 1;
			_fullScreenMc.percentY = 1;
			ResizeManager.instance.addResizeObj(_fullScreenMc);
			
			_bgMc.onResize = function() {
				_bgMc.width = stage.stageWidth;
				_bgMc.height = stage.stageHeight;
			}
			ResizeManager.instance.addResizeObj(_bgMc);
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
				_currMainBtn.upState = _btnUpStates[_currMainBtn];
				_currMainBtn = null;
			}
		}
		/**
		 * 隐藏所有menuList
		 */
		private function hideAllMenuList():void {
			var menuList:MenuList;
			for (var i:int = 1; i <=_menuNum; i++) 
			{
				menuList = this["menuList_" + i] as MenuList;
				menuList.visible = false;
				menuList.btnClickSignal.add(onLeafBtnClick);
			}
		}
		/**
		 * 叶节点点击之后
		 * @param	node
		 */
		private function onLeafBtnClick(node:TreeNode):void 
		{
			this["videoMc"].visible = true;
			VideoContainer(this["videoMc"]).setVideoBy(node);
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
			var btn:SimpleButton = e.currentTarget as SimpleButton;
			if (_currMainBtn) {
				_currMainBtn.upState = _btnUpStates[_currMainBtn];
			}
			_currMainBtn = btn;
			_btnUpStates[btn] = btn.upState;
			btn.upState = btn.overState;
			
			
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

		//UI======================================================


	}
	
}