package com.xueersi.corelibs.cores 
{
	import com.bit101.components.Accordion;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.Window;
	import flash.geom.Rectangle;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * @describe  	...
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012/6/18 15:26 
	 */
	public class AccordionMain extends BaseMain
	{
		public var titleMc:MovieClip;
		public var contentArr:Array = [];
		
		private var _accordion:Accordion;
		private var _panel:ScrollPane;
		/**
		 * accordion组件title的基本高度 
		 */
		private const ITEM_HEIGHT:int=20;
		public function AccordionMain() 
		{
			_accordion = new Accordion(this, 0, 0);
		}
		/* public function */
		override protected function init():void {
			
			var len:int = contentArr.length;
			var dp:MovieClip;
			var window:Window;
			
			if (titleMc) {
				if(titleMc.width>0||titleMc.height>0){
					var titleBound:Rectangle = titleMc.getBounds(this);
					_accordion.y = titleBound.y + titleBound.height;
				}else {
					_accordion.y = titleMc.y;
				}
			}
			
			if (len < 2) {
				throw new Error("contentArr长度小于2，不需要使用AccordionMain");
			}
			for (var i:int = 0; i < len; i++) 
			{
				if (i < 2) {
					window=_accordion.getWindowAt(i);
					window.title = contentArr[i].title;
				}else{
					_accordion.addWindow(contentArr[i].title);
				}
				dp = contentArr[i].display;
				dp.mouseEnabled = false;
				if (dp) {
					//如果显示对象很小，不需要scrollPanel，反之需要
					if(dp.width>ROOT_WIDTH||dp.height>ROOT_HEIGHT - ITEM_HEIGHT* len-_accordion.y){
						_panel = new ScrollPane();
						_panel.setSize(ROOT_WIDTH, ROOT_HEIGHT - ITEM_HEIGHT * len-_accordion.y);
						_accordion.getWindowAt(i).addChild(_panel);
						_panel.addChild(dp);
						_panel.autoHideScrollBar = true;
						_panel.content.mouseEnabled = false;
					}else {
						_accordion.getWindowAt(i).addChild(dp);
					}
					dp.x = 0;
					dp.y = 0;
				}
				//Notice:组件必须在设置完成之后，再设置宽高，不然，宽高对应不上。
				_accordion.setSize(ROOT_WIDTH, ROOT_HEIGHT-_accordion.y);
			}
		}
		/* override function */
		
		/* private function */
	}
	
} 