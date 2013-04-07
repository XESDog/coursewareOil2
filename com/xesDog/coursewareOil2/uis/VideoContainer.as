package com.xesDog.coursewareOil2.uis 
{
	
	import de.polygonal.ds.TreeNode;
	import fl.video.FLVPlayback;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	
	/**
	 * @describe  	...
	 * @author  	Mr.zheng
	 * @website 	@彪客
	 * @time		2013/3/27 14:23
	 */
	dynamic public class VideoContainer extends MovieClip
	{
		private var _video:FLVPlayback;
		private var _isFull:Boolean = false;
		public function VideoContainer() 
		{
			this["videoRuleMc"].visible = false;
			_video = new FLVPlayback();
			//addChild(_video);
			_video.x = this["videoRuleMc"].x;
			_video.y = this["videoRuleMc"].y;
			_video.width = this["videoRuleMc"].width;
			_video.height = this["videoRuleMc"].height;
			//_video.skin = "MinimaFlatCustomColorPlayBackSeekCounterVolMuteFull.swf";
			_video.skinBackgroundColor = 0x333333;
			_video.autoPlay = true;
			_video.skinAutoHide = false;
			_video.fullScreenTakeOver = false;
			
			_video.playPauseButton = this["playPauseBtn"];
			_video.muteButton = this["soundBtn"];
			_video.fullScreenButton = this["fullBtn"];
			_video.seekBar = this["seekBar"];
			_video.bufferingBar = this["bufferBar"];
			_video.backButton = this["backBtn"];
			_video.forwardButton = this["forwardBtn"];
			
			_video.fullScreenButton.addEventListener(MouseEvent.CLICK, onFullClick);
		}
		
		/* public function */
		public function setVideoBy(node:TreeNode):void {
			setVideoName(node);
			_video.source = node.val.videoUrl;
			
			addChild(_video);
		}
		/* override function */
		
		/* private function */
		private function setVideoName(node:TreeNode):void {
			this["videoNameMc"].txt.text = node.val.name;
		}
		private function onFullClick(e:MouseEvent):void 
		{
			isFull = !_isFull;
		}
		
		public function set isFull(value:Boolean):void 
		{
			if (value!=_isFull) {
				_isFull = value;
				if (value) {
					this.stage.addChild(_video);
					_video.x = _video.y = 0;
					_video.width = stage.stageWidth;
					_video.height = stage.stageHeight;
				}else {
					this.addChild(_video);
					_video.x = this["videoRuleMc"].x;
					_video.y = this["videoRuleMc"].y;
					_video.width=this["videoRuleMc"].width;
					_video.height = this["videoRuleMc"].height;
				}
			}
			
		}
	}
	
}