package com.xueersi.corelibs.interfaces 
{
	import com.xueersi.corelibs.cores.PanelBase;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * @describe	面板管理
	 * @author 		zihua.zheng
	 * @time 		2012-3-27 11:18
	 */
	public interface IPopManager 
	{
		/**
		 * 初始化
		 */
		function init(contextView:DisplayObjectContainer):void;
		/**
		 * 弹出面板
		 * @param	panelClass	面板类
		 * @param	data		面板数据
		 */
		function popupPanel(panelType:*,data:*):PanelBase;
		/**
		 * 弹入面板
		 * @param	panel
		 */
		function popdownPanel(panel:PanelBase):void;
	}
	
}