package com.xueersi.corelibs.uiCore
{
	import com.xueersi.corelibs.cores.vo.PicScrollVo;
	import com.xueersi.corelibs.event.ShowBigPicEvent;
	import com.xueersi.corelibs.utils.Align;
	import com.xueersi.corelibs.utils.TransBetweenArrayVector;
	import com.xueersi.corelibs.utils.ZoomAccount;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class PreviewScroll extends PicScrollSwitch
	{
		public function PreviewScroll()
		{
			
			super();
		}

		protected override function clickPicHandler(e:MouseEvent):void
		{
			//( " 调度事件: " + picClassArray);
			var clickS:Sprite = e.target as Sprite;
			var bigmap:Bitmap = clickS.getChildAt(0) as Bitmap;
			var bitmapdata:BitmapData = bigmap.bitmapData;
			//获取类的排序所以 
			var _className:String = getQualifiedClassName(bitmapdata);
			var _class:Class = getDefinitionByName(_className) as Class;

			var index:int = picClassArray.indexOf(_class);
			//复制数组
			var arr:Array = picClassArray.concat();
			loaderInfo.sharedEvents.dispatchEvent( new ShowBigPicEvent(ShowBigPicEvent.START_TO_SHOW , index , arr ));
		}
		
	}
}