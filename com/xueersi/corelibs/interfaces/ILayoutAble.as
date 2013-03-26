package com.xueersi.corelibs.interfaces
{
	import com.xueersi.corelibs.cores.vo.LayoutVo;

	/**
	 * @ 描述			参与整体布局
	 * @ 作者			郑子华
	 * @ 版本			version 1.0
	 * @ 创建日期		2011-4-14下午02:59:43
	 */
	public interface ILayoutAble
	{
		function get layoutObj():LayoutVo;
		function set layoutObj(value:LayoutVo):void;
	}
}
