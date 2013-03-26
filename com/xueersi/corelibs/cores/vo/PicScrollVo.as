package com.xueersi.corelibs.cores.vo
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/*
	 * 图片滚动组件的 数据类型	
	*/
	public class PicScrollVo
	{
		public var picClassArr:Array;
		public var leftBtn:DisplayObjectContainer;
		public var rightBtn:DisplayObjectContainer;
		public var backGround:DisplayObjectContainer;
		public var gap:Number;
		public var replace:Boolean = true;
		public var currentIndex:int = 0;
		//位置数组    内置代表滚动界面上摆放图片的位置和大小的mc 
		public var positionArr:Array;

		public function PicScrollVo()
		{
			
		}
		
		
		
	}
}