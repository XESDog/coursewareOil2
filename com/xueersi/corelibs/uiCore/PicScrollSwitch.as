package com.xueersi.corelibs.uiCore
{
	/*
	 * 图片滚动切换
	*/
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
	import flash.utils.getQualifiedClassName;
	
	import gs.TweenLite;
	
	public class PicScrollSwitch extends ICSView
	{
		protected var maskShape:Shape;
		private var _leftBtn:DisplayObjectContainer;
		private var _rightBtn:DisplayObjectContainer;
		private var _backGround:DisplayObjectContainer;
		//皮肤
		private var _leftBtnSkin:Asset_Album_toLeft;
		private var _rightBtnSkin:Asset_Album_toRight;
		private var _backGroundSkin:Asset_Album_bg;
		//装入image的容器
		protected var picSprite:Sprite;
		//该组件的复杂数据类型，包含几乎所有公共参数
		protected var vo:PicScrollVo;
		//图片类数组
		protected var picClassArray:Array;
		//占位符数组   从界面读取并存储  rectangle 到数组  用来记录显示图片的位置和大小
		protected var positionVector:Vector.<Rectangle>;
		//当前显示图片在图片类数组中的起始索引
		protected var currentStartIndex:int;
		//显示的图片数量
		protected var displayNum:int;
		//间隙   一个包括   "物体自身尺寸+绝对间隙 "  的平均值 
		protected var gap:Number;

		public var onTweenLite:Boolean;
		
		protected var replace:Boolean;
		
		public function PicScrollSwitch()
		{
			picSprite = new Sprite();
			this.addChild(picSprite);
		}
		
		public  function initAlbum($vo:PicScrollVo):void
		{
			if($vo==null)
			{
				//弹出错误板子
				ICSView.showError(this ,"vo赋值错误  传入vo为空");
			}
			else
			{
				vo = $vo;
				currentStartIndex = vo.currentIndex;
				
				//获取占位mc数组
				var placeholderArr:Array = vo.positionArr;
				//占位mc数组验证     获得displayNum
				placeHolderArr_verification(placeholderArr);
				maskShape = drawMask();
				picSprite.mask = maskShape;
				//间隙   displayNum 必须在占位mc验证之后使用
				if(vo.gap)
				{
					gap = vo.gap;
				}
				else
				{
					gap = maskShape.width/displayNum;
				}
				
				//获取图片的类数组
				picClassArray = vo.picClassArr;
				//图片类数组验证
				picCalssArr_verification();
				leftButton_verification();
				rightButton_verification();
				backGround_verification();
				picSprite.addEventListener(MouseEvent.CLICK , clickPicHandler , false ,0 ,true );
				this.addEventListener(Event.REMOVED_FROM_STAGE , removeFromStage , false ,0 ,true );
			}

		}
		
		protected function removeFromStage(event:Event):void
		{
			//("清空")
			picSprite.removeEventListener(MouseEvent.CLICK , clickPicHandler );
			this.removeEventListener(Event.REMOVED_FROM_STAGE , removeFromStage );
			_leftBtn.removeEventListener(MouseEvent.CLICK ,clickLeft );
			_rightBtn.removeEventListener(MouseEvent.CLICK ,clickRight );
			//清空数组
			var len:int = picClassArray.length;
			picClassArray.splice(0,len);
			len = positionVector.length;
			positionVector.splice(0,len);
			
			//清空图片容器
			removeAllChildrenOf(picSprite);
			
			maskShape.graphics.clear();
			vo = null;
		}

		protected function clickPicHandler(e:MouseEvent):void
		{
			//被继承
			
		}
		/*
		 * 占位mc验证
		*/
		protected function placeHolderArr_verification(placeholderArr:Array):void
		{
			//( "placeholderArr:"+ placeholderArr )
			if(placeholderArr!=null)
			{
				if(placeholderArr.length!=0)
				{
					//获得占位用的mc的矩形vector
					positionVector = createPlaceHolder(placeholderArr);
					displayNum = placeholderArr.length;
				}
				else
				{
					ICSView.showError(this ,"占位mc数组为空");
				}
			}
			else
			{
				ICSView.showError(this ,"占位mc数组未定义");
			}
		}
		/*
		 * 图片类数组验证   并生成图片实例    装入数组
		*/
		protected function picCalssArr_verification():void
		{
			if(picClassArray!=null)
			{
				if(picClassArray.length!=0)
				{
					//这里将传入的图片类 实例化为图片  并装入数组  生成最初的显示缩略图
					initPic(picClassArray , currentStartIndex );
					
				}
				else
				{
					ICSView.showError(this ,"图片类数组为空");
				}
			}
			else
			{
				ICSView.showError(this ,"图片类数组未定义");
			}
		}
		/*
		 * 左键验证
		*/
		protected function leftButton_verification():void
		{
			_leftBtn = vo.leftBtn;
			if(_leftBtn==null)
			{
				ICSView.showError(this ,"左键没有定义")
			}
			else
			{
				//添加侦听注意： 请在换肤后添加，否则   侦听对象错误。
				_leftBtnSkin = new Asset_Album_toLeft();
				if(_leftBtnSkin && vo.replace)
				{
					//替换皮肤
					replaceSkin( _leftBtn as DisplayObjectContainer, _leftBtnSkin );
					_leftBtn = _leftBtnSkin;
				}
				_leftBtn.addEventListener(MouseEvent.CLICK ,clickLeft ,false ,0 ,true );
			}
		}
		/*
		* 右键验证
		*/
		protected function rightButton_verification():void
		{
			_rightBtn = vo.rightBtn;
			if(_rightBtn==null)
			{
				ICSView.showError(this ,"右键没有定义")
			}
			else
			{
				_rightBtnSkin = new Asset_Album_toRight();
				if(_leftBtnSkin && vo.replace)
				{
					//替换皮肤
					replaceSkin(_rightBtn as DisplayObjectContainer , _rightBtnSkin );
					_rightBtn = _rightBtnSkin;
				}
				_rightBtn.addEventListener(MouseEvent.CLICK ,clickRight ,false ,0 ,true );
			}
			
		}
		protected function backGround_verification():void
		{
			_backGround = vo.backGround;
			if(_backGround==null)
			{
				ICSView.showError(this ,"底图没有定义");
			}
			else
			{
				_backGroundSkin = new Asset_Album_bg();
				//替换皮肤
				replaceSkin(_backGround as DisplayObjectContainer , _backGroundSkin );
			}
			
		}
		/*
		 * 替换皮肤  移除并清除原皮肤内部    替换为新皮肤元件
		*/
		protected function replaceSkin(obj:DisplayObjectContainer , skin:DisplayObjectContainer ):void
		{
			var rect:Rectangle = obj.getRect(this);
			
			this.addChild(skin);
			skin.x = rect.x;
			skin.y = rect.y;
			skin.width = rect.width;
			skin.height = rect.height;
			//交互深度
			this.swapChildren( obj , skin);
			//移除被替换物体
			this.removeChild(obj);
			//情况物体内部
			removeAllChildrenOf(obj);
		}
		/*
		* 响应右键点击
		*/
		protected function clickRight(event:MouseEvent):void
		{
			//("点击向右键")
			if(onTweenLite)
			{
				//killAllTweenLite();
				return;
			}
			
			var newlyAddedIndex:Number= currentStartIndex + displayNum;
			
			newlyAddedIndex = imageCountRule(newlyAddedIndex);
			
			//在右侧添加一个补位容器，内部是下一张图片
			addPicAtRight(newlyAddedIndex,displayNum);
			//在代表位置的数组中的前方插入  左侧补位的矩形
			addPositonAtLeft( displayNum);
			//图片群移动  向左
			movingToTarget(movingToLeftComplete);
			currentStartIndex = newlyAddedIndex;
		}
		/*
		* 响应左键点击
		*/
		protected function clickLeft(event:MouseEvent):void
		{
			//("点击左键，图片群产生相对位移，向右移动    ")
			if(onTweenLite)
			{
				return;
			}
			var newlyAddedIndex:Number= currentStartIndex - displayNum;
			newlyAddedIndex = imageCountRule(newlyAddedIndex);
			addPicAtLeft(newlyAddedIndex,displayNum);
			addPositonAtRight( displayNum);
			//图片群移动
			movingToTarget(movingToRightComplete);
			currentStartIndex = newlyAddedIndex;
		}
		//---------------------------杀死所有tween动作-------------------------------------------------
		public function killAllTweenLite():void
		{

			onTweenLite = false;
		
			//_picSprite 内部执行  
			var len:int = picSprite.numChildren;
			for(var i:int=0;i<len;i++)
			{
				var sprite:Sprite = picSprite.getChildAt(i) as Sprite;
				TweenLite.killTweensOf(sprite,true);
			}
		}
		protected function movingToTarget( completeFunction:Function ):void
		{
			onTweenLite = true;
			var len:int = picSprite.numChildren;
			for ( var i:int=0;i<len;i++ )
			{
				var sprite:Sprite = picSprite.getChildAt(i)  as Sprite;
				
				var tempRect:Rectangle = positionVector[i];
				
				if(i==len-1)
				{
					TweenLite.to( sprite ,1 ,{x:tempRect.x ,y:tempRect.y ,width:tempRect.width ,height:tempRect.height ,onComplete:completeFunction});
				}
				else
				{
					TweenLite.to( sprite ,1 ,{x:tempRect.x ,y:tempRect.y ,width:tempRect.width ,height:tempRect.height});
				}
			}
		}
		//---------------------------右键点击相关---------------------------------------------
		
		/*
		* 该方法被向右键点击，图片相对位移向左时调用
		* 图片右补位
		*/
		protected function addPicAtRight(imageStartIndex:int,len:int=1):void
		{
			//遮罩的覆盖矩形
			var positionLen:int = positionVector.length;
			//获取代表最右侧图片的大小和位置的矩形
			var rect2:Rectangle = positionVector[positionLen-1];
			var classLen:int = picClassArray.length;
			var endIndex:int = imageStartIndex+len;
			var _maskRect:Rectangle = maskShape.getRect( picSprite );

			//如果i超出范围 则按照rightNum来取图片类
			var rightNum:int;
			for(var i:int=imageStartIndex;i<endIndex;i++)
			{
				rightNum = imageCountRule(i);
				//从左侧算起  第几个索引处的矩形
				var tempRect:Rectangle = positionVector[i-imageStartIndex];
				
				var otherRect:Rectangle = new Rectangle( tempRect.x + _maskRect.width + gap ,rect2.y ,rect2.width ,rect2.height);
				
				var nx:Number = Align.center( otherRect.x ,otherRect.width,rect2.width);
				var ny:Number = Align.center( otherRect.y ,otherRect.height ,rect2.height);
				
				var rect3:Rectangle = new Rectangle( nx ,ny ,rect2.width ,rect2.height);
				var sprite:Sprite = createPicContainer(rect3);
				createPicture( picClassArray , rightNum  , sprite );
			}
		}
		/*
		* 该方法在向右键点击，图片相对位移向左时被调用
		* 表示位置的rect 左补位  图片容器向左运动时的目标
		*/
		protected function addPositonAtLeft( len:int=1 ):void
		{
			//遮罩的覆盖矩形
			var rect1:Rectangle = maskShape.getRect( picSprite );
			//获取代表最左侧图片的大小和位置的矩形
			var rect2:Rectangle = positionVector[0];
			var tempVec: Vector.<Rectangle> = new Vector.<Rectangle>;
			for(var i:int=0;i<len;i++)
			{
				var nx:Number = positionVector[i].x;
				//新添加的位置    等于是全部向左移动了  遮罩的宽度   即图片群的宽度；
				var rect:Rectangle = new Rectangle(nx - rect1.width-gap ,rect2.y , rect2.width ,rect2.height);
				tempVec.push( rect );
				//rectDictionary[rect] = true;
			}
			
			positionVector = tempVec.concat(positionVector);
			
		}
		
		/*
		* 该方法被向右键点击，图片相对位移向左时调用
		*/
		protected function addPlaceHolderAtLeft():void
		{
			//遮罩的覆盖矩形
			var rect1:Rectangle = maskShape.getRect( picSprite );
			var rect2:Rectangle = positionVector[0];
			var rect3:Rectangle = new Rectangle( rect1.left-rect2.width ,rect2.y ,rect2.width ,rect2.height);
			positionVector.unshift(rect3);
		}
		/*
		 * 移动结束   要把 补位图片和占位rect清空
		*/
		protected function movingToLeftComplete():void
		{
			subtractFillPosAtLeft();
			subtractInvisiblePicAtLeft();
			onTweenLite = false;
		}
		/*
		 * 减去左侧补位的rect
		*/
		protected function subtractFillPosAtLeft():void
		{
			positionVector.splice( 0 ,displayNum );
		}
		/*
		*   减去左侧不可见的图片  在点击向右按钮   向左运动之后 
		*   减去显示深度索引中  靠前的几个。
		*/
		protected function subtractInvisiblePicAtLeft():void
		{
			for ( var i:int=displayNum-1;i>=0;i-- )
			{
				picSprite.removeChildAt(i);
			}
		}
		//------------------------点击向左键-------------------------------------------------------------------------------
		/*
		* 该方法被向左键点击，图片相对位移向右时调用
		* 图片左补位
		*/
		protected function addPicAtLeft(imageStartIndex:int,len:int=1):void
		{
			var positionLen:int = positionVector.length;
			//获取代表最左侧图片的大小和位置的矩形
			var mostLeftRect:Rectangle = positionVector[0];
			var classLen:int = picClassArray.length;
			var endIndex:int = imageStartIndex+len;
			var _maskRect:Rectangle = maskShape.getRect( picSprite );
			//如果i超出范围 则按照rightNum来取图片类
			var rightNum:int;
			for(var i:int=imageStartIndex;i<endIndex;i++)
			{
				rightNum = imageCountRule(i);
				//从左侧算起  依次索引处的矩形
				var tempRect:Rectangle = positionVector[i-imageStartIndex];
				//将该矩形平移到左侧   _maskRect.width+_gap 的距离   即是新的占位符;
				var otherRect:Rectangle = new Rectangle( tempRect.x - _maskRect.width - gap ,mostLeftRect.y ,mostLeftRect.width ,mostLeftRect.height);
				//与占位符的中间点对齐 
				var nx:Number = Align.center( otherRect.x ,otherRect.width,mostLeftRect.width);
				var ny:Number = Align.center( otherRect.y ,otherRect.height ,mostLeftRect.height);
				
				var rect3:Rectangle = new Rectangle( nx ,ny ,mostLeftRect.width ,mostLeftRect.height);
				var sprite:Sprite = createPicContainer(rect3);
				//交换深度  它的深度排序 与他的最终运动位置有关
				swapPicSpriteDepth(i-imageStartIndex);
				createPicture( picClassArray , rightNum  , sprite );
			}
		}
		
		protected function swapPicSpriteDepth(n:int):void
		{
			var endIndex:Number = picSprite.numChildren-1;
			picSprite.swapChildrenAt( n ,endIndex );
		}
		/*
		* 该方法在向左键点击，图片相对位移向右时被调用
		* 表示位置的rect 右补位  图片容器向右运动时的目标
		* len 代表 补位的数目
		*/
		protected function addPositonAtRight( len:int=1 ):void
		{
			//遮罩的覆盖矩形
			var rect1:Rectangle = maskShape.getRect( picSprite );
			//获取代表最右侧图片的大小和位置的矩形
			var rect2:Rectangle = positionVector[positionVector.length-1];
			var tempVec: Vector.<Rectangle> = new Vector.<Rectangle>;
			for(var i:int=0;i<len;i++)
			{
				var nx:Number = positionVector[i].x;
				//新添加的位置   =全部向右移动了  遮罩+_gap的宽度   
				var rect:Rectangle = new Rectangle(nx + rect1.width+gap ,rect2.y , rect2.width ,rect2.height);
				tempVec.push( rect );
			}
			
			positionVector = positionVector .concat(tempVec);
		}
		/*
		 * 点击左键   相对位移向右 运动  结束
		*/
		protected function movingToRightComplete():void
		{
			onTweenLite = false;
			subtractFillPosAtRight();
			subtractInvisiblePicAtRight();
		}
		/*
		*   减去右侧不可见的图片  在点击向左按钮   向右运动完成之后 
		*   减去显示深度索引中  靠后的几个。
		*/
		protected function subtractInvisiblePicAtRight():void
		{
			var len:int = picSprite.numChildren;
			var endIndex:int = len-1;
			for ( var i:int=endIndex;i>endIndex-displayNum;i-- )
			{
				picSprite.removeChildAt(i);
			}
		}
		/*
		 * 减去  右侧的占位符  在数组中索引靠后的几位
		*/
		protected function subtractFillPosAtRight():void
		{
			var n:int = -1 * displayNum;
			positionVector.splice( n ,displayNum );			
		}
		/*
		 * 图片计数规则
		*/
		protected function imageCountRule(n:int):int
		{
			var len:int = picClassArray.length;
			var endIndex:int = len-1;
			if(n>endIndex)
			{
				n = n-len;
			}
			if(n<0)
			{
				n = len+n;
			}
			return n;
		}
		/*
		* 该方法需要    positionVector.<Rectangle> 被赋值后
		*/
		protected function drawMask():Shape
		{
			var shape:Shape = new Shape();
			this.addChild(shape);

			var len:int = positionVector.length;
			var arr:Array = getmaskSize(len);
			var left_top:Point = arr[0];
			var right_botom:Point = arr[1];
			var tempw:Number = right_botom.x - left_top.x;
			var temph:Number = right_botom.y - left_top.y;
			shape.x = left_top.x;
			shape.y = left_top.y;	
			shape.graphics.beginFill( 0,1 );
			shape.graphics.drawRect( 0 ,0 ,tempw ,temph );
			shape.graphics.endFill();
			return shape;
		}
		/*
		 * 该方法需要    positionVector.<Rectangle> 被赋值后
		*/
		protected function getmaskSize(len:int):Array
		{
			var i:int;
			var tempRect:Rectangle = positionVector[0]
			var nxMin:Number = tempRect.x;
			var nxMax:Number = tempRect.right;
			var nyMin:Number = tempRect.y;
			var nyMax:Number = tempRect.bottom;
			for(i=0;i<len;i++)
			{
				tempRect =  positionVector[i]
				if( nxMin > tempRect.left )
				{
					nxMin = tempRect.left;
				}
				if(nxMax< tempRect.right)
				{
					nxMax= tempRect.right;
				}
				if(nyMin>tempRect.top)
				{
					nyMin = tempRect.top;
				}
				if(nyMax < tempRect.bottom)
				{
					nyMax = tempRect.bottom;
				}
			}
			var arr:Array=[new Point(nxMin,nyMin) , new Point(nxMax,nyMax) ];
			return  arr;
		}
		/*
		 * 初始化 显示的缩略图  
		*/
		protected function initPic(arr:Array , startIndex:int):void
		{
			var sprite:Sprite;
			for(var i:int=startIndex;i<startIndex+displayNum;i++)
			{
				sprite = picSprite.getChildAt(i-startIndex) as Sprite;
				createPicture(arr ,i ,sprite  );
			}
			
		}
		protected function createPicture(arr:Array ,currentIndex:int , sprite:Sprite  ):void
		{
			var _class:Class = arr[currentIndex] as Class;
			var bitmapdata:BitmapData = new _class as BitmapData;
			var bitmap:Bitmap = new Bitmap(bitmapdata ,"auto",true );
			
			putImageIntoSprite(sprite , bitmap);
		}
		/*
		 * 该方法中装入图片  并使其自适应
		*/
		protected function putImageIntoSprite(sprite:Sprite , bitmap:Bitmap):void
		{
			var containerRect:Rectangle = sprite.getRect(picSprite);
			sprite.addChild(bitmap);
			
			//图片缩放自适应
			ZoomAccount.adaptive( containerRect ,bitmap as DisplayObject ,0 );
		}
		protected function createPlaceHolder(arr:Array):Vector.<Rectangle>
		{
			var tempVec:Vector.<Rectangle> = new Vector.<Rectangle>;
			var len:int = arr.length;
			if(len>6)
			{
				ICSView.showError(this ,"占位mc数目超出范围6")
			}
			for(var i:int=0;i<len;i++)
			{
				var mc:MovieClip = arr[i] as MovieClip;
				if(mc)
				{
					//占位符矩形
					var rect:Rectangle = mc.getRect(picSprite);
					tempVec.push(rect);
					//删除原有的占位mc
					this.removeChild(mc);
				}
				//根据  占位mc创建图片容器sprite
				createPicContainer(rect);
			}
			return tempVec;
		}
		/*
		 * 向 picSprite内部添加图片的容器 sprite  大小与占位符相当
		*/
		protected function createPicContainer(rect:Rectangle):Sprite
		{
			var sprite:Sprite = new Sprite();
			picSprite.addChild(sprite);
			sprite.x = rect.x;
			sprite.y = rect.y;
			//内部绘制透明色块
			sprite.graphics.beginFill(0 ,0);
			sprite.graphics.drawRect( 0,0,rect.width ,rect.height);
			sprite.graphics.endFill();
			return sprite;
		}
		protected function getRectCenter(rect:Rectangle):Point
		{
			var nx:Number = rect.left + rect.width/2;
			var ny:Number = rect.top + rect.height/2;
			return new Point(nx ,ny);
		}
		protected function removeAllChildrenOf(obj:DisplayObjectContainer):void
		{
			while(obj.numChildren!=0)
			{
				obj.removeChildAt(0);
			}
		}
	}
}