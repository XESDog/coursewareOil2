package com.xueersi.corelibs.uiCore 
{
	import com.xueersi.corelibs.cores.vo.MEDIA_IMAGE_VO;
	import com.xueersi.corelibs.event.ICSMediaEvent;
	import com.xueersi.corelibs.manager.DebugManagerSingle;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @describe  	ICS中的图片
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012/7/12 10:25
	 */
	public class ICSPic extends ICSView
	{
		/**
		 * 需要在面板中显示的图片
		 */
		public var picClass:Class;
		/** 弹板名称 */
		public var picTitle:String="";
		public function ICSPic() 
		{
			
		}
		/* public function */
		
		/* override function */
		override protected function addStageEvent(e:Event):void 
		{
			setMouseEnabled(this,true);
			addEventListener(MouseEvent.CLICK, onClick);
			super.addStageEvent(e);
		}
		
		override protected function removeStageEvent(e:Event):void 
		{
			super.removeStageEvent(e);
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		/* private function */
		private function onClick(e:MouseEvent):void 
		{
			//TODO:向框架发送事件
			if (!picClass) {
				ICSView.showError(MovieClip(root), "[ICSPic]中没有定义picClass属性");
				return;
			}
			var obj:Object = new picClass() as Object;
			var mediaVo:MEDIA_IMAGE_VO;
			if (obj) {
				if(obj is DisplayObject){
					//显示对象
				}else if(obj is BitmapData) {
					obj = new Bitmap(obj as BitmapData);
				}else {
					ICSView.showError(MovieClip(root),"[picClass]不是可用类型");
				}
				mediaVo= new MEDIA_IMAGE_VO();
				mediaVo.dp = obj as DisplayObject;
				mediaVo.title = picTitle;
				
				var icsMediaEvent:ICSMediaEvent=new ICSMediaEvent(ICSMediaEvent.MEDIA_IMAGE, mediaVo);
				loaderInfo.sharedEvents.dispatchEvent(icsMediaEvent);
			}
		}
		/**
		 * 取出BitmapData
		 * @return
		 */
		/*private function getDisplayObject():DisplayObject 
		{
			return numChildren > 0?getChildAt(0):null;
		}*/
		
	}
	
}