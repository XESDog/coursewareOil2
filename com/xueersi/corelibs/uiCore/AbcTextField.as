package com.xueersi.corelibs.uiCore {
	import com.xueersi.corelibs.manager.DebugManagerSingle;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * @describe  	UI设计的时候，在素材中拖画出来的
	 * 				textField无法绑定字体
	 * 				也无法解决文字超过范围不显示的问题。
	 * 				因此，专门用这样一个类来处理游戏中的文字
	 * 				
	 * 				具体实现：将素材中的文本用txt_作为前缀，绑定的时候，将素材addChild到该对象
	 * 						 该对象作为素材中文本的替身完成显示工作
	 * @author 		zihua.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2011-9-16
	 */
	public class AbcTextField extends AbcView {
		/** 是否显示调试信息 */
		protected var DEBUG:Boolean = false;
		/** 补充字符 */
		private var _addChar:String;
		/** 文本中文字的显示范围 */
		private var _rec:Shape;
		/** 截取之后的文字 */
		private var _remainText:String = "";
		private var _text:String;
		
		/** 素材中textField对象的引用 */
		private var _txt:TextField;
		/**
		 * 构造函数 
		 * @param txt		文本框
		 * @param addChar	替换符
		 * @param text		文本
		 */
		public function AbcTextField(txt:TextField,addChar:String="...",text:String=""):void {
			_txt = txt;
			_addChar = addChar;
			addChild(txt);
			this.x=txt.x;
			this.y = txt.y;
			txt.x=0;
			txt.y = 0;
			
			_rec = new Shape();
			if (DEBUG) drawTxtRec();
			
			if (text != "") {
				this.text = text;
			}else{
				this.text=_txt.text;
			}
			addChild(_rec);
		}
		/**
		 * 
		 * @return 
		 */
		public function get text():String { return _text; }
		/**
		 * 
		 * @param value
		 */
		public function set text(value:String):void 
		{
			if (_text == value) return;
			_text = value;
			//value在_txt中超过显示范围，超过的部分用“...”代替
			_txt.text = value;
			_remainText = value;
			replaceTextPass();
			if(DEBUG)drawTextRec();
		}
		/** override function */
		override protected  function addStageEvent(e:Event):void 
		{
			super.addStageEvent(e);
			if (DEBUG) {
				this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			}
			
		}
		override protected  function removeStageEvent(e:Event):void 
		{
			super.removeStageEvent(e);
			if (DEBUG) {
				this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			}
		}
		/**
		 * 画出文本范围
		 */
		private function drawTextRec():void {
			_rec.graphics.beginFill(0xffffff, .2);
			_rec.graphics.drawRect(_txt.x, _txt.y, _txt.textWidth, _txt.textHeight);
			_rec.graphics.endFill();
		}
		/**
		 * 画出textField范围
		 */
		private function drawTxtRec():void {
			_rec.graphics.beginFill(0xffffff, .2);
			_rec.graphics.drawRect(_txt.x, _txt.y, _txt.width, _txt.height);
			_rec.graphics.endFill();
		}
		/**
		 * 获取文本宽中最后一个文字的索引值
		 * @param	p	当前文本显示区域右下脚
		 * @return
		 */
		private function getLastChatIndex(p:Point):int {
			//英文字符只占size/2
			var size:int = int(_txt.defaultTextFormat.size)*.5;
			var index:int = -1;
			var loopCount:int = 0;
			//循环5次，找到为止
			while (index==-1&&loopCount<5) {
				index = _txt.getCharIndexAtPoint(p.x - size * loopCount-size, p.y-size);
				loopCount++;
			}
			return index;
		}
		/** private function */
		/**
		 * 文字是否超过文本框的范围
		 * @return	超过，则返回当前文本显示区域右下角坐标，否则返回null
		 */
		private function get isTextPass():Point {
			var p:Point;
			if (_txt.textWidth > _txt.width || _txt.textHeight > _txt.height) {
				p = new Point(Math.min(_txt.textWidth,_txt.width),Math.min(_txt.textHeight,_txt.height));
			}
			return p;
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			DebugManagerSingle.instance.trace("[AbcTextField:onRollOver] "+_text);
		}
		/**
		 * 删掉多余的部分
		 */
		private function replaceTextPass():void {
			var p:Point = isTextPass;
			var index:int;
			if (p) {
				index = getLastChatIndex(p);
				if (index > 1) {//index!=-1&&index>1
					_remainText = _remainText.slice(0, index+1);
					_txt.replaceText(index, _txt.length, _addChar);
					stepByStepTry();
				}
			}
		}
		/**
		 * 逐步的尝试，每次删掉最后的一个字符，直到能放下为止
		 */
		private function stepByStepTry():void {
			var p:Point = isTextPass;
			if (p) {
				_remainText = _remainText.slice(0,_remainText.length - 1);//删掉最后一个字符
				_txt.replaceText(_remainText.length, _txt.length, _addChar);
				stepByStepTry();
			}
		}
	}
}
