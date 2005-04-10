import org.as2lib.core.BasicClass;
import org.as2lib.env.log.ConfigurableLogger;
import org.as2lib.env.log.logger.SimpleLogger;

class org.as2lib.tool.console.ConsoleConnection extends BasicClass {
	
	private static var logger:ConfigurableLogger;
	
	public function getLogger(Void):ConfigurableLogger {
		if (!logger) {
			logger = new SimpleLogger("ConsoleLogger");
		}
		return logger;
	}
	
}