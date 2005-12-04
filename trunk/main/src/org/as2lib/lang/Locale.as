import org.as2lib.core.BasicInterface;

/**
 * @author Martin Heidegger
 */
interface org.as2lib.lang.Locale extends BasicInterface {
	public function getMessage(key:String, defaultValue:String, args:Array):String;	
	public function getLocaleCode(Void):String;
}