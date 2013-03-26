package com.xueersi.corelibs.cores 
{
	
	import com.xueersi.corelibs.cores.vo.MEDIA_AUDIO_VO;
	import com.xueersi.corelibs.event.ICSSoundEvent;
	import com.xueersi.corelibs.event.ICSToolEvent;
	import com.xueersi.corelibs.uiCore.ICSTimeLineView;
	import com.xueersi.corelibs.utils.FpsCounter;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @describe  	文档类基类
	 * @author  	Mr.zheng
	 * @website 	http://blog.sina.com.cn/zihua2007
	 * @time		2012/6/13 10:33
	 */
	[SWF(width="724",height="513",frameRate="24")]
	public class BaseMain extends ICSTimeLineView
	{
		/**
		 * 背景层 
		 */
		private var _bgShape:Shape;
		/**
		 * 遮罩层 
		 */
		private var _maskShape:Shape;
		/**
		 * 容器
		 */
		private var _container:Sprite;
		/**
		 * fps 
		 */		
		private var _fps:FpsCounter;
		/**
		 * 是否debug
		 */
		private var _isDebug:Boolean = false;
		/**
		 * 是否显示背景 
		 */
		private var _hasShowBgShape:Boolean=true;
		//root 长宽
		public static const ROOT_WIDTH:int = 724;
		public static const ROOT_HEIGHT:int = 513;
		/**
		 * 添加场景外的盖层
		 */
		private var soundID:int=-1;
		public function BaseMain() 
		{
			//RegisterClassManagerSingle.instance.init();
			_container = new Sprite();
			_container, mouseEnabled = false;
			super.addChild(_container);
			
			//将显示对象都放入到container中，-1是因为不能将最后的container考虑进去
			var len:int = numChildren-1;
			for (var i:int = 0; i < len; i++) 
			{
				_container.addChild(getChildAt(0));
			}
			
			createBgLayer();
			createCoverLayer();
		}
		/* protected function */

		/**
		 * 默认显示背景层，3d模型时不显示背景层 
		 */
		public function set hasBgShape(value:Boolean):void
		{
			_hasShowBgShape = value;
			_bgShape.visible=value;
		}

		/**
		 * 发送框架事件
		 * @param	e
		 */
		protected function dispatchIcsEvent(e:Event):void {
			loaderInfo.sharedEvents.dispatchEvent(e);
		}
		/* override function */
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			return _container.addChild(child);
		}
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			return _container.removeChild(child);
		}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			return _container.addChildAt(child, index);
		}
		override public function removeChildAt(index:int):DisplayObject 
		{
			return _container.removeChildAt(index);
		}
		/* private function */
		/**
		 * 创建遮盖在场景外面安全层
		 */
		private function createCoverLayer():void 
		{
			var bmd:BitmapData = new BitmapData(100, 100, false, 0x000000);
			var sw:Number = stage.stageWidth;
			var sh:Number = stage.stageHeight;
			_maskShape = new Shape();
			_maskShape.graphics.beginBitmapFill(bmd);
			_maskShape.graphics.drawRect( -1000, -1000, 2000+sw, 2000+sh);
			_maskShape.graphics.drawRect(0, 0, sw, sh);
			super.addChild(_maskShape);
		}
		/**
		 * 背景层 
		 * 
		 */
		private function createBgLayer():void{
			var bmd:BitmapData = new BitmapData(100, 100, false, 0x000000);
			_bgShape = new Shape();
			_bgShape.graphics.beginBitmapFill(bmd);
			_bgShape.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			super.addChildAt(_bgShape,0);
		}
		private function onEnterFrame(e:Event):void{
			_fps.update();
		}
		public function set isDebug(value:Boolean):void 
		{
			if (_isDebug != value) {
				if(value){
					_fps=new FpsCounter();
					super.addChild(_fps);
					_fps.mouseEnabled=false;
					_fps.mouseChildren=false;
					this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				}else {
					this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					super.removeChild(_fps);
					_fps = null;
				}
			}
			_isDebug = value;
		}
		/*
		 *显示计算器
		*/
		public function showCalculator():void
		{
			this.loaderInfo.sharedEvents .dispatchEvent(new ICSToolEvent( ICSToolEvent.CALCULATOR ,false ,false ) ) ;				
		}
		/**
		*显示秒表
		*/
		public function showStopwatch():void
		{
			this.loaderInfo.sharedEvents .dispatchEvent(new ICSToolEvent( ICSToolEvent.STOPWATCH , false ,false ) );				
		}
		/**
		*显示图形工具
		*/
		public function showGraphTool():void
		{
			this.loaderInfo.sharedEvents .dispatchEvent(new ICSToolEvent( ICSToolEvent.GRAPH_TOOL ,false ,false ) );				
		}
		/**
		 * 声音
		 */
		public function playAudio(sound:Class,vol:Number=1,startTime:Number=0,stopTime:Number=0,repeat:Boolean=false):int{
			var isVo:MEDIA_AUDIO_VO=new MEDIA_AUDIO_VO;
			isVo.sound=sound;
			isVo.vol=vol;
			isVo.startTime=startTime;
			isVo.endTime=stopTime;
			isVo.repeat=repeat;
			isVo.soundID=++soundID;
			this.loaderInfo.sharedEvents.dispatchEvent(new ICSSoundEvent(ICSSoundEvent.SOUND_PLAY,isVo));
			return soundID;
		}
		public function stopAudio(sound:Class,soundID:int=-1):void{
			var isVo:MEDIA_AUDIO_VO=new MEDIA_AUDIO_VO;
			isVo.sound=sound;
			isVo.soundID=soundID;
			this.loaderInfo.sharedEvents.dispatchEvent(new ICSSoundEvent(ICSSoundEvent.SOUND_STOP,isVo));
		}
		public function stopAllAudio():void{
			this.loaderInfo.sharedEvents.dispatchEvent(new ICSSoundEvent(ICSSoundEvent.SOUND_STOP_ALL));
		}
	}
}