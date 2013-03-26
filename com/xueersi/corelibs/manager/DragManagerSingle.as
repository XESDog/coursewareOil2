package  com.xueersi.corelibs.manager
{
	import com.xueersi.corelibs.interfaces.IDragManager;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import gs.TweenMax;
	/**
	 * 
	 * 单例模式类
	 * @describe		拖拽管理
	 * @author			Mr.zheng
	 * @time 			2012/5/28 15:43
	 */
	public class DragManagerSingle implements IDragManager
	{
		private static var _instance:DragManagerSingle = null;
		public function DragManagerSingle(single:Single){
			
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():DragManagerSingle
		{
			if(_instance == null)
			{
				_instance = new DragManagerSingle(new Single());
			}
			return _instance;
		}
		
		public function get hitObject():DisplayObject 
		{
			return _hitObject;
		}
		
		public function get isDebug():Boolean 
		{
			return _isDebug;
		}
		
		public function set isDebug(value:Boolean):void 
		{
			_isDebug = value;
		}
		
		public function get dragObj():DisplayObject 
		{
			return _dragObj;
		}
		
		//start-----------------------------------------------------------------------------
		/**
		 * 侦听鼠标事件
		 */
		private var _contextView:DisplayObjectContainer;
		/**
		 * 拖拽对象
		 */
		private var _dragObj:DisplayObject;
		/**
		 * 鼠标点
		 */
		private var _mouseP:Point;
		/**
		 * 停止拖拽类型
		 */
		private var _stopType:int = 0;
		/**
		 * 需要检测碰撞的集合
		 */
		private var _hits:Array;
		/**
		 * 调试
		 */
		private var _isDebug:Boolean=false;
		/**
		 * 触碰到的对象，一定是_hits里面的对象
		 */
		private var _hitObject:DisplayObject;
		/**
		 * 碰撞区域元件
		 */
		private const HIT_AREA:String = "hitArea_mc";
		/**
		 * 事件发送
		 */
		public  var eventDispatcher:EventDispatcher = new EventDispatcher();
		/**
		 * 不做任何操作，默认
		 */
		public static const STOP_DRAG_NORMAL:int = 0;
		/**
		 * 删除显示对象
		 */
		public static const STOP_DRAG_REMOVE:int = 1;
		
		/**
		 * 停止拖拽
		 */
		public static const STOP_DRAG:String = "stop_drag";
		
		/* public function */
		public function init(contextView:DisplayObjectContainer):void {
			_contextView = contextView;
		}
		public function uninit():void {
			_contextView = null;
			_dragObj = null;
			_hitObject = null;
			_hits = null;
			_mouseP = null;
		}
		/* INTERFACE com.xueersi.corelibs.interfaces.IDragManager */
		
		public function startDrag(obj:*,dragContainer:DisplayObjectContainer,mouseP:Point,hits:Array,stopType:int=0):void 
		{
			_contextView.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_contextView.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			if (hits)_hits = hits;
			
			_mouseP = mouseP;
			_stopType = stopType;
			if (obj is DisplayObject) {
				_dragObj = obj;
			}
			if (obj is Class) {
				var objInstance:*= new obj();
				if (objInstance is DisplayObject) {
					_dragObj = objInstance;
					dragContainer.addChild(_dragObj);
				}else {
					throw new Error("传入参数不是显示对象Class。");
				}
			}
		}
		/* private function */
		/**
		 *	
		 * @param	type	0：停止拖拽
		 * 					1：remove显示对象
		 */
		private function stopDrag():void 
		{
			if (_stopType == STOP_DRAG_REMOVE) {
				_dragObj.parent.removeChild(_dragObj);
			}
			_contextView = null;
			_dragObj = null;
			_mouseP = null;
			_stopType = 0;
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			_contextView.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_contextView.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			//如果有检测对象判断和那个对象触碰
			if (_hits.length > 0) {
				_hitObject = getHitObject();
			}
			
			eventDispatcher.dispatchEvent(new Event(STOP_DRAG));
			stopDrag();
			
			
			if (_isDebug && hitObject) {
				TweenMax.to(hitObject, .5, { glowFilter: { color:0xff0000, alpha:1, blurX:20, blurY:20 }, onComplete:function(dp:DisplayObject):void {
						dp.filters = [];
				},onCompleteParams:[hitObject]});
			}
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			var x:Number = _contextView.mouseX - _mouseP.x;
			var y:Number = _contextView.mouseY - _mouseP.y;
			_dragObj.x += x;
			_dragObj.y += y;
			_mouseP.x = _contextView.mouseX;
			_mouseP.y = _contextView.mouseY;
		}
		private function getHitObject():DisplayObject {
			var bounds:Rectangle;
			var hitArea:DisplayObject;
			var dragRec:Rectangle = getDisplayObjectBounds(_dragObj);
			var resultRec:Rectangle;
			//所有触碰到的对象rectangle集合
			var resultDic:Dictionary = new Dictionary;
			for each (var item:DisplayObject in _hits) 
			{
				bounds = getDisplayObjectBounds(item);
				resultRec = dragRec.intersection(bounds);
				if(!resultRec.isEmpty())resultDic[item] = resultRec;
			}
			
			var maxRec:Rectangle;
			var resultObj:DisplayObject;
			for (var name:* in resultDic) 
			{
				resultRec = resultDic[name];
				if (maxRec) {
					if (resultRec.width * resultRec.height > maxRec.width * maxRec.height) {
						maxRec = resultRec;
						resultObj = name;
					}
				}else {
					maxRec = resultRec;
					resultObj = name;
				}
			}
			return maxRec?resultObj:null;
		}
		/**
		 * 获取bounds
		 * @param	dp
		 * @return
		 */
		private function getDisplayObjectBounds(dp:DisplayObject):Rectangle {
			var bounds:Rectangle;
			if (dp is DisplayObjectContainer ) {
				var hitArea:DisplayObject = DisplayObjectContainer(dp).getChildByName(HIT_AREA) as DisplayObject;
				if (hitArea) {
					bounds = hitArea.getBounds(_contextView);
				}else {
					bounds = dp.getBounds(_contextView);
				}
			}else{
				bounds = dp.getBounds(_contextView);
			}
			return bounds;
		}
	}
}
class Single{}