package com.xueersi.corelibs.uiCore
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.describeType;

	/**
	 * @describe  	绑定素材的视图
	 * @author  	zihua.zheng
	 * @time		2011-8-10 17:04
	 */
	public class AbcBindView extends AbcView
	{
		/** 按钮前缀 */
		protected const PREFIX_BTN:String="btn";
		/** 动画前缀 */
		protected const PREFIX_ANM:String="anm";
		/** 动态按钮前缀 */
		protected const PREFIX_DYB:String="dyb";
		/** 文本前缀 */
		protected const PREFIX_TXT:String="txt";
		/** 头像前缀（后缀为_CPS） */
		protected const PREFIX_PIC:String="pic";
		/** 进度条前缀（后缀为_CPS） */
		protected const PREFIX_PGB:String="pgb";

		public function AbcBindView()
		{
		}

		/* public function */
		/**
		 * 绑定视图
		 * btn_ 按钮
		 * anm_ 动画
		 * dyb_	动态按钮
		 * @param child
		 */
		public function bindView(child:MovieClip):void
		{
			var child_names:Array=getPropertyName(this, /(_LEA)$/); //基础元素leaf
			var depth:int;
			var childname:String;
			var prefix:String;
			for (var i:int=0; i < child_names.length; i++)
			{
				childname=child_names[i];
				prefix=childname.split("_")[0];
				switch (prefix)
				{
					case PREFIX_BTN:
						//创建按钮对象,将按钮对象按照素材的深度放置到素材中
						depth=child.getChildIndex(child[childname]);
						this[childname]=new AbcBtn(child[childname]);
						child.addChildAt(this[childname], depth);
						break;
					case PREFIX_ANM:
						depth=child.getChildIndex(child[childname]);
						this[childname]=new TimeLineView(child[childname]);
						child.addChildAt(this[childname], depth);
						break;
					case PREFIX_DYB:
						depth=child.getChildIndex(child[childname]);
						this[childname]=new AbcDynamicBtn(child[childname]);
						child.addChildAt(this[childname], depth);
						break;
					case PREFIX_TXT:
						depth=child.getChildIndex(child[childname]);
						this[childname]=new AbcTextField(child[childname]);
						child.addChildAt(this[childname], depth);
						break;
					default:
						if (child[childname] is MovieClip)
						{
							child[childname].stop();
						}
						this[childname]=child[childname];
				}
			}
			//将素材中的对象放置到AbcView
			while (child.numChildren > 0)
			{
				var instance:DisplayObject=child.removeChildAt(0);
				this.addChild(instance);
			}
			//递归
			replaceClassAsAbcView(child);
		}

		/** protected function */
		/**
		 * 查找对象public属性集合
		 * @param child
		 * @param condition
		 * @return
		 */
		protected function getPropertyName(child:Sprite, condition:RegExp=null):Array
		{
			var arr_property:Array=[];
			var reg_test:RegExp=condition;

			var xml_target:XML=describeType(child);
			var xmlList_variable:XMLList=xml_target.variable;
			for each (var xml_variable:XML in xmlList_variable)
			{
				var str_pro:String=String(xml_variable.@name);
				if (reg_test != null)
				{
					if (reg_test.test(str_pro))
					{
						arr_property.push(str_pro);
					}
				}
				else
				{
					arr_property.push(str_pro);
				}
			}
			return arr_property;
		}

		/* override function */

		/* private function */
		/**
		 * 替换 AbcView 对象
		 * @param child
		 *
		 */
		private function replaceClassAsAbcView(child:MovieClip):void
		{
			var class_names:Array=getPropertyName(this, /(_CPS)$/); //复合对象composite
			var depth:int;
			var prefix:String;
			for (var i:int=0; i < class_names.length; i++)
			{
				var childname:String=class_names[i];
				prefix=childname.split("_")[0];
				switch (prefix)
				{
					/*case PREFIX_PIC:
						this[childname] = new AbcPic();
						this[childname].bindView(child[childname]);
						AbcPic(this[childname]).init();
						break;*/
					case PREFIX_PGB:
						this[childname] = new AbcProgressBar();
						this[childname].bindView(child[childname]);
						AbcProgressBar(this[childname]).init();
						break;
					default:
						this[childname].bindView(child[childname]);
				}
				//notice,在bindView方法中，该对象已经被addChild到this中，因此取depth
				//用this.getChildIndex();
				depth=this.getChildIndex(child[childname]);
				this.addChildAt(this[childname], depth);
				this[childname].x=child[childname].x;
				this[childname].y=child[childname].y;
			}
		}
	}

}
