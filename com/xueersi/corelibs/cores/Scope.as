package com.xueersi.corelibs.cores 
{
	
	/**
	 * @describe  	范围值
	 * @author  	zihua.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012-2-9 19:04
	 */
	public class Scope
	{
		private var _min:Number;		//最小值
		private var _max:Number;		//最大值
		private var _value:Number;	//当前值
		
		public function Scope(min:Number,max:Number) 
		{
			if (min > max) {
				throw new Error("min大于max");
			}
			
			this._min = min;
			this._max = max;
			value=min;
		}
		
		public function get min():Number 
		{
			return _min;
		}
		
		public function get max():Number 
		{
			return _max;
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			if (value > _max) {
				_value = _max;
				return;
			}
			if (value < _min) {
				_value = min;
				return;
			}
			_value = value;
		}
		/* public function */
		
		/* override function */
		
		/* private function */
	}
	
}