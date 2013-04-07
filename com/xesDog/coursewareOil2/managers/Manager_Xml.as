package com.xesDog.coursewareOil2.managers 
{
	import com.xesDog.coursewareOil2.vos.MenuVo;
	import de.polygonal.ds.TreeNode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.osflash.signals.Signal;
	/**
	 * 
	 * 单例模式类
	 * @describe		...
	 * @author			Mr.zheng
	 * @time 			2013/3/27 10:13
	 */
	public class Manager_Xml
	{
		private static var _instance:Manager_Xml = null;
		public function Manager_Xml(single:Single){
			
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		/**
		 * 单例引用
		 */
		public static function get instance():Manager_Xml
		{
			if(_instance == null)
			{
				_instance = new Manager_Xml(new Single());
			}
			return _instance;
		}
		
		public function get xmlLoaded():Signal 
		{
			return _xmlLoaded;
		}
		
		public function get menuNode():TreeNode 
		{
			return _menuNode;
		}
		
		//start-----------------------------------------------------------------------------
		private var _xmlLoader:URLLoader;	//读取菜单
		private var _menuNode:TreeNode;		//菜单节点
		private var _xmlLoaded:Signal;				
		/* public function */
		public function init():void {
			_xmlLoaded = new Signal();
			_menuNode = new TreeNode();
		}
		
		public function loadMenuXml():void {
			_xmlLoader = new URLLoader(new URLRequest("assets/xmls/menu.xml"));
			_xmlLoader.addEventListener(Event.COMPLETE, onXmlLoaded);
		}
		/**
		 * 根据一组从根节点到叶节点的数值获取节点对象
		 * @param	...rest
		 */
		public function getNodeBy(...rest):TreeNode {
			var arr:Array = rest.concat();
			var len:uint = arr.length;
			var node:TreeNode=_menuNode;
			var num:uint;
			for (var i:int = 0; i < len; i++) 
			{
				num = arr[i];
				node = getChildNodeAt(num,node);
			}
			return node;
		}
		
		/* private function */
		private function onXmlLoaded(e:Event):void 
		{
			var menuXml:XML = new XML(_xmlLoader.data);
			//迭代生成树型结构
			var xl:XMLList = menuXml.elements();
			iterationMenuXml(_menuNode, xl);
			
			_xmlLoaded.dispatch();
		}
		/**
		 * 将xl中的对象迭代放入到parentNode中
		 * @param	parentNode
		 * @param	xl
		 */
		private function iterationMenuXml(parentNode:TreeNode,xl:XMLList):void {
			var len:uint = xl.length();
			var xml:XML;
			var menuVo:MenuVo;
			var node:TreeNode;
			for (var i:int = 0; i < len; i++) 
			{
				xml = xl[i] as XML;
				menuVo = new MenuVo();
				menuVo.name = xml.@name;
				menuVo.videoUrl = xml.@videoUrl;
				
				node = new TreeNode(menuVo, parentNode);
				
				iterationMenuXml(node, xml.elements());
			}
		}
		/**
		 * 获取node子对象中的第index个对象
		 * @param	index
		 * @param	node
		 * @return
		 */
		private function getChildNodeAt(index:uint,node:TreeNode):TreeNode {
			index = index - 1;
			node = node.getFirstChild();
			var num:uint = 0;
			while (num<index) 
			{
				node = node.next;
				num++;
			}
			return node;
		}
	}
}
class Single{}