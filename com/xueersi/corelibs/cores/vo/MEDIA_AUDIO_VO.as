package com.xueersi.corelibs.cores.vo
{
	import com.xueersi.corelibs.interfaces.IVo;
	
	import flash.media.Sound;
	
	public class MEDIA_AUDIO_VO implements IVo
	{
		private var _data:Object;
		public var sound:Class;
		public var vol:Number;
		public var startTime:Number;
		public var endTime:Number;
		public var repeat:Boolean;
		public var soundID:int;
		public function MEDIA_AUDIO_VO()
		{
			
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}