import org.as2lib.basic.BasicClass;
import org.as2lib.basic.Throwable;
import org.as2lib.basic.string.Stringifier;
import org.as2lib.basic.string.ObjectStringifier;
import org.as2lib.basic.string.ThrowableStringifier;

class org.as2lib.util.StringifyUtil extends BasicClass {
	private static var objectStringifier:Stringifier = new ObjectStringifier();
	private static var throwableStringifier:Stringifier = new ThrowableStringifier();
	
	public static function stringifyObject(object:Object):String {
		return objectStringifier.execute(object);
	}
	
	public static function stringifyThrowable(throwable:Throwable):String {
		return throwableStringifier.execute(Object(throwable));
	}
	
	public static function setObjectStringifier(stringifier:Stringifier):Void {
		objectStringifier = stringifier;
	}
	
	public static function setThrowableStringifier(stringifier:Stringifier):Void {
		throwableStringifier = stringifier;
	}
}