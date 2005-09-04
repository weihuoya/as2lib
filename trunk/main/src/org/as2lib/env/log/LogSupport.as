import org.as2lib.core.BasicClass;
import org.as2lib.env.log.Logger;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.env.log.LogManager;

/**
 * @author HeideggerMartin
 */
class org.as2lib.env.log.LogSupport extends BasicClass {
	
	public static var LOG_IDENTIFIER:String = "__as2lib__logger__";
	private var logger:Logger;
	
	public static function getLogger(instance):Logger {
		var logger:Logger = instance.__proto__[LOG_IDENTIFIER];
		if (!logger) {
			logger = instance.__proto__[LOG_IDENTIFIER] = LogManager.getLogger(ReflectUtil.getTypeNameForInstance(instance));
		}
		return logger;
	}	
	
	function LogSupport() {
		logger = getLogger(this);
	}
}