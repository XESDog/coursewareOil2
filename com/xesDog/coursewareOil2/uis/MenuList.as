package com.xesDog.coursewareOil2.uis 
{
	
	import com.xesDog.coursewareOil2.managers.Manager_Xml;
	import de.polygonal.ds.TreeNode;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	
	/**
	 * @describe  	...
	 * @author  	Mr.zheng
	 * @website 	@彪客
	 * @time		2013/3/27 10:56
	 */
	public class MenuList extends Sprite
	{
		/**
		 * 按钮个数
		 */
		private var _btnNum:uint;
		/**
		 * 菜单列表编号
		 */
		private var _menuListID:uint;
		
		private var _btnClickSignal:Signal;
		
		public function MenuList() 
		{
			_btnNum = setBtnEvent();
			_menuListID = name.split("_")[1];
			
			_btnClickSignal = new Signal(TreeNode);
		}
		/* public function */
		public function setBtnEvent():uint {
			var len:uint = this.numChildren;
			var dp:DisplayObject;
			var num:uint = 0;
			for (var i:int = 0; i < len; i++) 
			{
				dp = getChildAt(i) as DisplayObject;
				if (dp is SimpleButton) {
					dp.addEventListener(MouseEvent.CLICK, onClick);
					num++;
				}
			}
			return num;
		}
		
		public function get btnNum():uint 
		{
			return _btnNum;
		}
		
		public function get btnClickSignal():Signal 
		{
			return _btnClickSignal;
		}
		/* override function */
		
		/* private function */
		private function onClick(e:MouseEvent):void 
		{
			var name:String = e.currentTarget.name;
			var id:uint = name.split("_")[1];
			var node:TreeNode;
			node = Manager_Xml.instance.getNodeBy(_menuListID, id);
			
			_btnClickSignal.dispatch(node);
			
			trace("click:" + _menuListID, id);
			trace(node);
		}
	}
	
}