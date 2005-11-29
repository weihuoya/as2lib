﻿import Log;
/**
 * Class for Messages send by Flash to a SocketServer for logging messages
 * (helpfull in conjunction with a XML SocketServer)
 *
 * @see Log.as
 * @author Sascha Wolter (www.saschawolter.de)
 * @version	0.8
 */
class Message
{
		/**
		 * Properties
		 */	
		private var _message:String = null;
		private var _className:String = null;
		private var _fileName:String = null;
		private var _line:Number = null;
		private var _level:Number = null;
		private var _timestamp:Date = null;
		/** 
		 * Static Methods
		 */
		public static function create (msg:String, level:Number, className:String, fileName:String, line:Number ):Message
		{
			var message:Message;
			message = new Message();
			if (msg)
			{
				message.setMessage(msg);
			}
			if (level)
			{
				message.setLevel(level);
			}
			if (className)
			{
				message.setClassName(className);
			}
			if (fileName)
			{
				message.setFileName(fileName);
			}
			if (line)
			{
				message.setLine(line);
			}
			return message;
		}
		/**
		 * Methods
		 */
		public function Message ()
		{
			/**
			 * Set Defaults
			 */
			setFileName(_root._url);
			setLevel(Log.INFO);
			setTimestamp(new Date ());
		}
		public function setMessage(value:String):Void
		{
			_message = value;
		}
		public function getMessage():String
		{
			return _message;
		}
		public function setClassName(value:String):Void
		{
			_className = value;
		}
		public function getClassName():String
		{
			return _className;
		}
		public function setFileName(value:String):Void 
		{
			_fileName = value;
		}
		public function getFileName():String 
		{
			return _fileName;
		}
		public function setLine(value:Number):Void
		{
			_line = value;
		}
		public function getLine():Number
		{
			return _line;
		}
		public function setLevel(value:Number):Void 
		{
			_level = value;
		}
		public function getLevel():Number 
		{
			return _level;
		}
		public function getLevelName():String
		{
			return Log.LEVEL_LIST[getLevel()];	
		}
		private function setTimestamp(value:Date):Void 
		{
			_timestamp = value;
		}
		public function getTimestamp():Date 
		{
			return _timestamp;
		}
		public function toString ():String
		{
			var value:String = "";
			if (getLevel())
			{
				value += "[" + getLevelName() + "] ";
			}
			if (getTimestamp())
			{
				value += "- " + getTimestamp() + " ";
			}
			value += ": ";
			if (getMessage())
			{
				value += getMessage() + " ";
			}
			if (getLine())
			{
				value += "at Line " + String(getLine()) + " ";
			}
			if (getClassName())
			{
				value += "in class " + getClassName() + " ";
			}
			if (getFileName())
			{
				value += "(file: " + getFileName() + ")";
			}
			return value;	
		}
}