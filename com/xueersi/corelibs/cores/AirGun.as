package com.xueersi.corelibs.cores 
{
	
	/**
	 * @describe  	空气枪，后入的顶掉前面的
	 * @author  	zihua.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012-3-9 14:26
	 */
	public class AirGun
	{
		private var _maxSize:int=2;
		private var _a:Array;
		/**
		 * 如果设置上限为2，当数组中已经有两个对象了，再添加的对象会顶到最先进入的对象
		 */
		public function AirGun() 
		{
			_a = [];
		}
		/* public function */
		/**
		 * 入列，如果数组已经满了，移除下标为0的项
		 * @param	item
		 */
		public function enququ(item:*):void {
			if (_a.length >= _maxSize) {
				_a.shift();
			}
			_a.push(item);
		}
		public function get currItem():*{
			return _a.length<_maxSize?_a[0]:_a[1];
		}
		public function get preItem():*{
			return _a[0];
		}
		/* override function */
		
		/* private function */
	}
	
}