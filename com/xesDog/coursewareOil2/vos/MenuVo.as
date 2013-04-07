package com.xesDog.coursewareOil2.vos 
{
	
	/**
	 * @describe  	...
	 * @author  	Mr.zheng
	 * @website 	@彪客
	 * @time		2013/3/27 10:11
	 */
	public class MenuVo
	{
		/**
		 * 描述名称
		 */
		public var name:String = "";
		/**
		 * 视频的地址
		 */
		public var videoUrl:String = "";
		/* public function */
		public function toString():String {
			return name + " " + videoUrl;
		}
		/* override function */
		
		/* private function */
	}
	
}