package com.xueersi.corelibs.manager  
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.xueersi.corelibs.interfaces.IDebugManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 
	 * 单例模式类
	 * @describe		Debugger
	 * @author			Mr.zheng
	 * @time 				2011-9-18 14:00
	 */
	public class DebugManagerSingle implements IDebugManager
	{
		private static var _instance:DebugManagerSingle = null;
		public function DebugManagerSingle(single:Single){
			
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		/**
		 * 单例引用
		 */
		public static function get instance():DebugManagerSingle
		{
			if(_instance == null)
			{
				_instance = new DebugManagerSingle(new Single());
			}
			return _instance;
		}
		
		//start-----------------------------------------------------------------------------
		private var _contextView:DisplayObjectContainer;
//		private var _isInitCc:Boolean=false;//console初始化
		private var _isInitMonster:Boolean=false;
		/**
		 * 使用flash player 的trace 
		 */
		private var _useFpTrace:Boolean=false;
//		private var _isInitTheMiner:Boolean=false;
		
		/* INTERFACE org.abc.interfaces.IDebug */
		/**
		 * 一般将舞台，或者文档类作为参数传入 
		 * @param contextView
		 * 
		 */		
		public function init(contextView:DisplayObjectContainer):void 
		{
			_contextView = contextView;
			_useFpTrace=true;
		}
		/**
		 * 初始化Console
		 * 设置开启快捷键为"`" 
		 * 设置默认为不课件
		 * 。。。
		 */
		/*public function initCc():void {
			Cc.startOnStage(_contextView, "`"); // "`" - change for password. This will start hidden
			Cc.visible = false; // Show console, because having password hides console.
			
			Cc.config.commandLineAllowed = true; // enable advanced (but security risk) features.
			Cc.config.tracing = true; // Also trace on flash's normal trace
			Cc.config.remotingPassword = null; // Just so that remote don't ask for password
			Cc.remoting = true; // Start sending logs to remote (using LocalConnection)
			
			Cc.commandLine = true; // Show command line
			
			Cc.height = 220; // change height. You can set x y width height to position/size the main panel
			
			_isInitCc=true;
		}*/
		/**
		 * 初始化MonsterDebugger 
		 * 
		 */
		public function initMonsterDebugger():void{
			MonsterDebugger.initialize(_contextView);
			_isInitMonster=true;
		}
		public function set useFpTrace(value:Boolean):void{
			_useFpTrace=value;
		}
		/*_public function initTheMiner():void{
			contextView.addChild(new TheMiner());
			_isInitTheMiner=true;
		}*/
		public function trace(...args):void 
		{
//			if (_isInitCc) Cc.log.apply(null, args);
			if (_isInitMonster) MonsterDebugger.log(args);
			if(_useFpTrace)traceOld(args);
		}
		/**
		 * 观察obj 
		 * @param obj
		 * 
		 */
		public function inspect(obj:Object):void 
		{
//			if(_isInitCc)Cc.inspect(obj);
			if(_isInitMonster)MonsterDebugger.inspect(obj);
			if(_useFpTrace)traceOld("[MonsterDebugger:inspect]",obj);
		}
		/**
		 * 生成快照 
		 * @param label
		 * @param object
		 * 
		 */
		public function snapshot(label:String,object:DisplayObject):void{
			if(_isInitMonster)MonsterDebugger.snapshot(this,object,"MonsterDebugger",label);
			if(_useFpTrace)traceOld("[MonsterDebugger:snapshot] ",label+" ",object);
		}
		public function traceCh(channcel:*, ...args):void 
		{
//			if(_isInitCc)Cc.infoch(channcel,args);
		}
		/* public function */
		
		/* private function */
	
	}
}

class Single{}
var traceOld:Function=trace;