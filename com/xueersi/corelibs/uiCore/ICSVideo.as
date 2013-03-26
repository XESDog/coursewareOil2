package com.xueersi.corelibs.uiCore 
{
	import com.xueersi.corelibs.cores.vo.MEDIA_VIDEO_VO;
	import com.xueersi.corelibs.event.ICSMediaEvent;
	import com.xueersi.corelibs.interfaces.IVo;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @describe  	本类作为某个视频缩略图(显示对象)的基类使用，作用：点击视频缩略图 ，弹出视频播放器面板。
	 * @author  	Ms.zhao
	 * @website 	http://
	 * @time		2012/7/20
	 */
	public class ICSVideo extends ICSView
	{
		private var mediaVo:MEDIA_VIDEO_VO;
		private var _url:String;
		private var _videoWidth:Number;
		private var _videoHeight:Number;
		private var _needPlayer:Boolean;
		private var _container:DisplayObjectContainer;
		
		public function ICSVideo() 
		{
		}
		/* public function */
		


		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		public function set container(value:DisplayObjectContainer):void
		{
			_container = value;
		}

		public function get needPlayer():Boolean
		{
			return _needPlayer;
		}

		public function set needPlayer(value:Boolean):void
		{
			_needPlayer = value;
		}

		public function get videoHeight():Number
		{
			return _videoHeight;
		}

		public function set videoHeight(value:Number):void
		{
			_videoHeight = value;
			if(mediaVo)
			{
				mediaVo.height = _videoHeight;
			}
			
		}

		public function get videoWidth():Number
		{
			return _videoWidth;
		}

		public function set videoWidth(value:Number):void
		{
			_videoWidth = value;
			if(mediaVo)
			{
				mediaVo.width = _videoWidth;
			}
			
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
			if(mediaVo)
			{
				mediaVo.url = _url;
			}
			
		}
		/* override function */
		override protected function addStageEvent(e:Event):void 
		{
			super.addStageEvent(e);
			this.addEventListener(MouseEvent.CLICK, onClick,false ,0 ,true);
		}
		
		override protected function removeStageEvent(e:Event):void 
		{
			super.removeStageEvent(e);
		}
		/*
		 * 在所有以此类为基类的mc中，需调用该初始化函数
		*/
		override protected function init():void
		{
			if(mediaVo==null)
			{
				mediaVo = new MEDIA_VIDEO_VO();
			}
			
			if(_url==null)
			{
				trace("缺少视频路径");
			}
			else
			{
				mediaVo.url = _url;
			}
			if(!_videoWidth)
			{
				trace("缺少视频宽度，自动设置600");
				_videoWidth = 600;
			}
			mediaVo.width = _videoWidth
			if(!_videoHeight)
			{
				trace("缺少视频高度，自动设置450");
				_videoHeight = 450;
			}
			mediaVo.height = _videoHeight;
			mediaVo.needPlayer = _needPlayer;
			if(!_container)
			{
				trace("缺少视频容器 ,容器是可缺省的")
			}
			mediaVo.container = _container;
		}
		/* private function */
		private function onClick(e:MouseEvent):void 
		{
			//TODO:向框架发送事件
			loaderInfo.sharedEvents.dispatchEvent(new ICSMediaEvent(ICSMediaEvent.MEDIA_VIDEO,mediaVo));
		}
	}
	
}