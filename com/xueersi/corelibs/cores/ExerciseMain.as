package com.xueersi.corelibs.cores 
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.xueersi.corelibs.cores.vo.ICSDesignDisplayVo;
	import com.xueersi.corelibs.cores.vo.MEDIA_IMAGE_VO;
	import com.xueersi.corelibs.event.ICSMediaEvent;
	import com.xueersi.corelibs.uiCore.ICSScrollPane;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GradientGlowFilter;
	
	/**
	 * @describe  	习题文档类
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012/7/18 11:15
	 */
	public class ExerciseMain extends BaseMain
	{
		public var contentObj:ICSDesignDisplayVo = new ICSDesignDisplayVo();
		/**
		 * 面板背景皮肤
		 */
		public var panelSkinClass:Class;
		/**
		 * 按钮
		 * [0]按钮名
		 * [1]点击按钮后显示的对象
		 */
		public var btnArr:Array = [];
		
		
		private var _scrollPanel:ICSScrollPane;
		

		/* public function */
		
		/* override function */
		override protected function init():void 
		{
			_scrollPanel = new ICSScrollPane();
			addChild(_scrollPanel);
			_scrollPanel.setSize(ROOT_WIDTH, ROOT_HEIGHT);
			if (contentObj.display == null) {
				throw new Error("请设置contentObj.display属性：将需要显示的MovieClip对象赋值给该属性");
			}else{
				_scrollPanel.addChild(contentObj.display);
				contentObj.display.x = contentObj.display.y = 0;
				_scrollPanel.content.mouseEnabled = false;
				contentObj.display.mouseEnabled = false;
			}
			if (panelSkinClass) {
				_scrollPanel.skinClass = panelSkinClass;
			}
			showBtn();
		}
		/* private function */
		/**
		 * 显示“分析”、“铺垫”。。。
		 */
		private function showBtn():void {
			var len:int = btnArr.length;
			var btn:PushButton;
			var line:Shape = new Shape();
			for (var i:int = 0; i < len; i++) 
			{
				btn = new PushButton(this, 0, 0, btnArr[i][0]);
				btn.width = 45;
				btn.height = 20;
				btn.x = ROOT_WIDTH - (btn.width+10) * (len - i)-30;
				btn.y = ROOT_HEIGHT - 50;
				btn.name = "btn_" + i;
				
				
				var label:Label = new Label();
				label.textField.textColor = 0xffffff;
				
				var gradientGlow:GradientGlowFilter=new GradientGlowFilter(0, 45, [0x1f4d79, 0x1f4d79], [0, 1], [0, 255], 1.5, 1.5, 100, 3, "outer");
				label.textField.filters = [gradientGlow];
				
				btn.setLabelStyle(label);
				
				btn.addEventListener(MouseEvent.CLICK, onBtnClick);
				
				if (i < len - 1) {
					addChild(line);
					line.graphics.lineStyle(1, 0x1f4d79);
					line.graphics.lineTo(0, 24);
					line.x = ROOT_WIDTH - (btn.width + 20) * (len - i-1)-25;
					line.y=ROOT_HEIGHT - 52;
				}
			}
		}
		private function onBtnClick(e:MouseEvent):void 
		{
			var i:int = String(e.target.name).split("_")[1];
			var mediaVo:MEDIA_IMAGE_VO;
			mediaVo= new MEDIA_IMAGE_VO();
			mediaVo.dp = btnArr[i][1] as DisplayObject;
			
			var icsMediaEvent:ICSMediaEvent=new ICSMediaEvent(ICSMediaEvent.MEDIA_IMAGE, mediaVo);
			dispatchIcsEvent(icsMediaEvent);
		}
	}
	
}