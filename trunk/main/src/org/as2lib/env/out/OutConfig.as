import org.as2lib.Config;
import org.as2lib.core.BasicClass;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.out.string.WriteStringifier;
import org.as2lib.env.out.string.ErrorStringifier;
import org.as2lib.env.event.EventBroadcasterFactory;

/**
 * OutConfig is the main config class for the out package.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.out.OutConfig extends BasicClass {
	/** This Stringifier is used to stringify an OutWriteInfo. */
	private static var writeStringifier:Stringifier;
	
	/** Stringifier used to stringify an OutErrorInfo. */
	private static var errorStringifier:Stringifier;
	
	/** Internal EventbroadcasterFactory Holder */
	private static var eventBroadcasterFactory:EventBroadcasterFactory;
	
	/**
	 * Private constructor.
	 */
	private function OutConfig(Void) {
	}
	
	/**
	 * Sets the Stringifier used to stringify an OutWriteInfo.
	 * 
	 * @param stringifier the new Stringifier used to stringify an OutWriteInfo
	 */
	public static function setWriteStringifier(newStringifier:Stringifier):Void {
		writeStringifier = newStringifier;
	}
	
	/**
	 * Returns the Stringifier used to stringify an OutWriteInfo.
	 * Initializes the Stringifier if it wasn't initialized before.
	 *
	 * @return The ErrorStringifier instance of the Config.
	 */
	public static function getWriteStringifier(Void):Stringifier {
		if(!writeStringifier) writeStringifier = new WriteStringifier();
		return writeStringifier;
	}
	
	/**
	 * Sets the Stringifier used to stringify an OutErrorInfo.
	 * 
	 * @param stringifier the new Stringifier used to stringify an OutErrorInfo
	 */
	public static function setErrorStringifier(newStringifier:Stringifier):Void {
		errorStringifier = newStringifier;
	}
	
	/**
	 * Returns the Stringifier used to stringify an OutErrorInfo.
	 * Initializes the Stringifier if it wasn't initialized before.
	 *
	 * @return The ErrorStringifier instance of the Config.
	 */
	public static function getErrorStringifier(Void):Stringifier {
		if(!errorStringifier) errorStringifier = new ErrorStringifier();
		return errorStringifier;
	}
	
	/**
	 * Returns the EventBroadcasterFactory config.
	 * If the EventBroadcasterFactory was not set it takes it from the basic Config.
	 * 
	 * @see Config
	 * @return the EventBroadcasterFactory instance of the config.
	 */
	public static function getEventBroadcasterFactory(Void):EventBroadcasterFactory {
		if(!eventBroadcasterFactory) return Config.getEventBroadcasterFactory();
		return eventBroadcasterFactory;
	}
	
	/**
	 * Sets the EventBroadcastorFactory configuration.
	 * 
	 * @param eventBroadcasterFactory Factory for creating EventBroadcasters.
	 */
	public static function setEventBroadcasterFactory(to:EventBroadcasterFactory):Void {
		eventBroadcasterFactory = to;
	}
}