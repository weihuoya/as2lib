import loggers.*;
/**
 * 
 * @see Log.as
 * @author Sascha Wolter (www.saschawolter.de)
 * @version	0.8
 */
class loggers.LoggerFactory
{
	public static function createLogger (loggerName:String):ILogger
	{
		var value:ILogger;
		switch (loggerName)
		{
			case FlashoutLogger.LOGGER_NAME:
			 value = FlashoutLogger.getInstance();
			 break;
			case OldSocketLogger.LOGGER_NAME:
			 value = OldSocketLogger.getInstance();
			 break;			 
			case SocketLogger.LOGGER_NAME:
			 value = SocketLogger.getInstance();
			 break;
			case TraceLogger.LOGGER_NAME:
			 value = TraceLogger.getInstance();
			 break;			
			default:
			 value = SocketLogger.getInstance();
			 break;			
		}
		return value;
	}
	private function LoggerFactory ()
	{
		// Static class
	}	
}