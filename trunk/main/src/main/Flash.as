import org.as2lib.env.log.logger.SimpleHierarchicalLogger;
//import org.as2lib.env.log.logger.TraceLogger;
import org.as2lib.env.log.logger.RootLogger;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.handler.TraceHandler;
import org.as2lib.env.log.repository.LoggerHierarchy;
import org.as2lib.env.log.LogManager;
import main.Config;

/**
 * Example class for a configuration in a MTASC / Flashout context.
 * Due to some classes within the as2lib have to be configured to work as expected.
 * Because Mtasc is to able to use the 
 * 
 * @author Martin Heidegger.
 */
class main.Flash {
	
	/**
	 * Runs different setups.
	 */
	static function main():Void {
		
		// Set up for logging
		setUpLogging();
		
		// Set up for Testcases
		Config.main();
	}
	
	/**
	 * 
	 */
	private static function setUpLogging(Void):Void {

		// Use a LoggerHierarchy as repository and take a TraceLogger by default
		var loggerHierarchy:LoggerHierarchy = new LoggerHierarchy(new RootLogger(AbstractLogLevel.ALL));
		  
		// Tell the Logger Repository to use the loggerHierarchy for default.
		LogManager.setLoggerRepository(loggerHierarchy); 
		  
		var traceLogger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger("org.as2lib");
		traceLogger.addHandler(new TraceHandler());
		  
		// Log to trace console in org.as2lib package
		loggerHierarchy.addLogger(traceLogger);
		  
		var exceptLogger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger("org.as2lib.env.except");
		exceptLogger.setLevel(AbstractLogLevel.NONE);
		  
		// Disables logging of exceptions.
		loggerHierarchy.addLogger(exceptLogger);
	}
}