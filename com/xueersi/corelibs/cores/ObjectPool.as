package com.xueersi.corelibs.cores
{
	import com.xueersi.corelibs.interfaces.IRecyclable;
	
	import de.polygonal.ds.pooling.LinkedObjectPool;

	/**
	 * @ 描述			对象池
	 * @ 作者			郑子华
	 * @ 版本			version 1.0
	 * @ 创建日期		2011-4-13上午11:54:50
	 */
	public class ObjectPool extends LinkedObjectPool
	{
		/**
		 * 构造函数
		 * @param type
		 */
		public function ObjectPool(type:Class)
		{
			super(1,true);
			allocate(type);
		}

		/**
		 * 回收
		 * @param o
		 */
		public function recoverObj(o:IRecyclable):void
		{
			o.readyRecycle();
			o.inObjectPool=true;
			put(o);
		}

		/**
		 * 获取
		 * @return 
		 */
		public function getObject():IRecyclable
		{
			var o:IRecyclable=get() as IRecyclable;
			o.inObjectPool=false;
			o.reInit();
			return o;
		}
	}
}
