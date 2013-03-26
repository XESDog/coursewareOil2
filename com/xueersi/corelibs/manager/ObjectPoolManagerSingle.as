package com.xueersi.corelibs.manager
{
	import com.xueersi.corelibs.cores.ObjectPool;
	import com.xueersi.corelibs.interfaces.IRecyclable;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	

	/**
	 * @ 描述			对象池管理
	 * 					单例模式
	 * @ 作者			郑子华
	 * @ 版本			version 1.0
	 * @ 创建日期		2011-4-13上午11:51:32
	 */
	public class ObjectPoolManagerSingle
	{
		private static var _instance:ObjectPoolManagerSingle = null;
		public function ObjectPoolManagerSingle(single:Single) 
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		/**
		 * 单例引用
		 */
		public static function get instance():ObjectPoolManagerSingle
		{
			if(_instance == null)
			{
				_instance = new ObjectPoolManagerSingle(new Single());
			}
			return _instance;
		}
		
		public function get objectPoolArr():Array 
		{
			return _objectPoolArr;
		}
		/**
		 * objectPool对象集合
		 * _objectPoolArr[Class]=ObjectPool.Dictionary[IRecyclabe,IRecyclabe,IRecyclabe...]
		 */ 
		private var _objectPoolArr:Array = [];
		/**
		 * 获取对象
		 * @param type
		 * 
		 */
		public function getObjByClass(type:Class):IRecyclable {
			var typeName:String=getQualifiedClassName(type);
			if(_objectPoolArr[typeName]==null){
				_objectPoolArr[typeName]=new ObjectPool(type);
			}
			var objectPool:ObjectPool=_objectPoolArr[typeName] as ObjectPool;
			return objectPool.getObject();
		}
		/**
		 * 回收对象
		 * @param	o
		 * @param	typeName
		 */
		public function recoveObj(o:IRecyclable):void {
			var objectPool:ObjectPool;
			var typeName:String = getQualifiedClassName(o);
			var className:Class = getDefinitionByName(typeName) as Class;
			if ( _objectPoolArr[typeName] == null) {
				objectPool =new ObjectPool(className);
				_objectPoolArr[typeName]=objectPool;
			}else {
				objectPool = _objectPoolArr[typeName] as ObjectPool;
			}
			objectPool.recoverObj(o);
		}
	}
}
class Single{}