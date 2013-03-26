package com.xueersi.corelibs.manager 
{
	import com.xueersi.corelibs.cores.vo.MEDIA_IMAGE_VO;
	import com.xueersi.corelibs.event.ICSMediaEvent;
	
	import flash.net.registerClassAlias;

	/**
	 * 
	 * 单例模式类
	 * @describe		...
	 * @author			Mr.zheng
	 * @time 			2012/7/25 9:57
	 */
	public class RegisterClassManagerSingle
	{
		private static var _instance:RegisterClassManagerSingle = null;
		public function RegisterClassManagerSingle(single:Single){
			
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		/**
		 * 单例引用
		 */
		public static function get instance():RegisterClassManagerSingle
		{
			if(_instance == null)
			{
				_instance = new RegisterClassManagerSingle(new Single());
			}
			return _instance;
		}
		
		//start-----------------------------------------------------------------------------
		/* public function */
		public function init():void {
			registerClassAlias("com.xueersi.corelibs.event.ICSMediaEvent", ICSMediaEvent);
			registerClassAlias("com.xueersi.corelibs.cores.vo.MEDIA_IMAGE_VO", MEDIA_IMAGE_VO);
		}
		/* private function */
	}
}
class Single{}