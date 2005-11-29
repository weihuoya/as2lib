import ChangeEvent;
import Message;
import loggers.*;
/**
 * 
 * Static class for logging messages.
 * Change _loggerName for logging mode (e. g. SocketLogger.LOGGER_NAME)!
 * 
 * Usage with MMC (Flash IDE)
 *  - Classpath:
 *  - ActionScript:
 *    Log.addMessage("Message", Log.LEVEL);
 *    
 * Usage with MTASC (Eclipse and ASDT)
 *  - MTASC:
 *    mtasc -swf "deploy.swf" -cp "asdt.logger.lib.flash_classes" -trace "Log.addMessage" 
 *  - ActionScript:
 *    TRACE("Message", Log.LEVEL);
 * 
 * @see sample.fla
 * @author Sascha Wolter (www.saschawolter.de)
 * @version	0.8
 * 
 */
class Log extends Array
{
	/**
	* Error Levels
	*/
	public static var NONE : Number = 0;
	public static var INFO : Number = 4;
	public static var WARNING : Number = 2;
	public static var ERROR : Number = 1;
	public static var VERBOSE : Number = 7;
	public static var LEVEL_LIST:Array = ["NONE", "ERROR", "WARNING", "ERROR/WARNING", "INFO", "ERROR/INFO", "WARNING/INFO", "VERBOSE"];
	/**
	 * Singleton Pattern
	 */
	private static var _singleton:Log = null;	
	/**
	 * Static methods
	 */
	public static function getInstance ():Log
	{
		if (!_singleton)
		{
			_singleton = new Log();
		}
		return _singleton;
	}
	public static function addMessage ():Void
	{
		var instance:Log;		
		if (arguments.length == 4)
		{
			arguments.splice(1, 0, Log.VERBOSE);
		}
		instance = getInstance();
		instance.addMessageToBuffer.apply(instance, arguments);		
	}	
	/**
	 * The _buffer is used to store messages until the logger is connected
	 */
	private var _bufferSize : Number = 20;
	/**
	 * Logger
	 */
	private var _loggerName:String = SocketLogger.LOGGER_NAME;
	private var _logger:ILogger = null;
	//
	private function Log ()
	{
		// Singelton
		_logger = LoggerFactory.createLogger(_loggerName);
	}
	private function onValueChanged () : Void
	{
		var event :ChangeEvent;
		event = new ChangeEvent ();
		event.source = this;
		// send events to the listener
		_logger.valueChanged(event);
	};	
	private function addMessageToBuffer(msg:String, level:Number, className:String, fileName:String, line:Number ):Void
	{
		var message:Message;
		message = Message.create (msg, level, className, fileName, line);
		push(message);
	}
	//
	private function push(message:Message)
	{
		super.push(message);
		if (length > _bufferSize)
		{
			shift ();
		}
		onValueChanged();		
	}
	public function setBufferSize (value:Number):Void
	{
		_bufferSize = value;
	}
}