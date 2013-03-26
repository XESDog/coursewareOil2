package  com.xueersi.corelibs.manager
{
	import com.xueersi.corelibs.cores.PanelBase;
	import com.xueersi.corelibs.event.EaseEvent;
	import com.xueersi.corelibs.interfaces.IPopManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	/**
	 * 
	 * 单例模式类
	 * @describe		管理面板  面板管理程序 专用于管理弹出的面板
	 * @author			zihua.zheng
	 * @time 			2012-3-27 11:14
	 */
	public class PopupManagerSingle implements IPopManager
	{
		private static var _instance:PopupManagerSingle = null;
		public function PopupManagerSingle(single:Single)
		{
			
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		private var _defaultRec:Rectangle;
		/**
		 * 默认取场景的大小为区域
		 */
		public function get defaultRec():Rectangle
		{
			return _defaultRec;
		}

		/**
		 * @private
		 */
		public function set defaultRec(value:Rectangle):void
		{
			_defaultRec = value;
		}

		/**
		 * 单例引用
		 */
		public static function get instance():PopupManagerSingle
		{
			if(_instance == null)
			{
				_instance = new PopupManagerSingle(new Single());
			}
			return _instance;
		}
		private var _container:DisplayObjectContainer;

		//start-----------------------------------------------------------------------------
		/* 
		 * public function
		*/
		public function init(container:DisplayObjectContainer):void
		{
			_container = container;
		}
		
		/* INTERFACE com.sonModule.popupManager.interfaces.IPopManager */
		/**
		 * 
		 * @param	panelClass
		 * @param	data	{contain:	父容器,
		 * 					containRec:	容器区域(Rectangle),
		 * 					panelVo:	面板数据,
		 * 					easeInClass:弹出效果,
		 * 					easeOutClass:弹回效果...}
		 */
		public function popupPanel(panelType:*, data:*):PanelBase 
		{
			var panel:PanelBase;
			if(panelType is Class){
				panel=new panelType();
			}else if(panelType is PanelBase){
				panel=panelType;
				if(panel.inStage){
					DebugManagerSingle.instance.trace("panelType 指定对象已经在舞台。");
					return null;
				}
			}else if(panel==null){
				DebugManagerSingle.instance.trace("panelType 指定对象为null。");
				return null;
			}else{
				throw new Error("panelType参数类型不符合规定。");
			}
			panel.setEase(data.easeInClass,data.easeOutClass);
			//更新显示，注意这里的先后问题，data是初始数据，因此先显示。添加到舞台后执行addStageEvent可能会有其他数据更新
			panel.update(data.panelVo);
			//添加到舞台
			data.contain.addChild(panel);
			//如果没有设置containRec属性，使用默认
			
			if (data.containRec) {
				if(data.containRec.isEmpty()){
					panel.x = panel.y = 0;
				}else {
					panel.x = data.containRec.width >> 1;
					panel.y = data.containRec.height >> 1;
				}
			}else {
				if(_defaultRec==null)
				{
					_defaultRec = new Rectangle(0,0,_container.stage.stageWidth,_container.stage.stageHeight);
				}
				
				panel.x = _defaultRec.width >> 1;
				panel.y = _defaultRec.height >> 1;
			}
			//执行缓动
			panel.popup();
			return panel;
		}
		public function popdownPanel(panel:PanelBase):void 
		{
			if(panel==null){
				DebugManagerSingle.instance.trace("panelType 指定对象为null。");
				return;
			}
			if(!panel.inStage){
				DebugManagerSingle.instance.trace("panelType 指定对象不在舞台上。");
				return;
			}
			panel.addEventListener(EaseEvent.EASE_COMPLETED, onEaseOutCompleted);
			//执行缓动，停止对鼠标事件的感应
			panel.mouseEnabled=false;
			panel.mouseChildren=false;
			panel.popdown();
		}
		/* private function */
		private function onEaseOutCompleted(e:EaseEvent):void 
		{
			var panel:PanelBase = e.currentTarget as PanelBase;
			panel.removeEventListener(EaseEvent.EASE_COMPLETED, onEaseOutCompleted);
			//移出舞台
			if(panel.parent)panel.parent.removeChild(panel);
			//初始化显示
			//收归对象池管理
//			ObjectPoolManagerSingle.instance.recoveObj(panel as IRecyclable);
		}
	}
}
class Single{}