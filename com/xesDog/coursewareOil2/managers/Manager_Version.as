package com.xesDog.coursewareOil2.managers 
{
	import flash.display.Sprite;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * 版本控制
	 * 单例模式类
	 * @author Mr.zheng
	 */
	public class Manager_Version
	{
		private static var _instance:Manager_Version = null;
		
		public const vMsg:String ="版本 oil2 Debugger v20130321.01"; 
		
		public function Manager_Version(single:Single) 
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!"); 
			}

		}
		/** 
		 * 单例引用
		 */
		public static function get instance():Manager_Version
		{
			if(_instance == null)
			{
				_instance = new Manager_Version(new Single());
			}
			return _instance;
		}
		/**
		 * 设置版本号
		 */
		public function setVersion(contextView:Sprite):void {
			var myContextMenu:ContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();
			var item:ContextMenuItem=new ContextMenuItem(vMsg,false,false);  
			myContextMenu.customItems.push(item);
			contextView.contextMenu = myContextMenu;
		}

	}
}
class Single{}