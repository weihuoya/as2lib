import org.as2lib.basic.out.OutLevel;
import org.as2lib.basic.out.level.*;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.Out {
	/** All output will be made. */
	public static var ALL:OutLevel = new All();
	/** All output that is at a lower output level will be made. */
	public static var DEBUG:OutLevel = new Debug();
	/** All output that is at a lower output level will be made. */
	public static var INFO:OutLevel = new Info();
	/** All output that is at a lower output level will be made. */
	public static var WARNING:OutLevel = new Warning();
	/** All output that is at a lower output level will be made. */
	public static var ERROR:OutLevel = new Error();
	/** All output that is at a lower output level will be made. */
	public static var FATAL:OutLevel = new Fatal();
	/** No output will be made. */
	public static var NONE:OutLevel = new None();
	
	/**
	 * The actual level of the Out instance.
	 */
	private var level:OutLevel;
	
	/**
	 * Constructs a new Out instance and sets the default out level, ALL.
	 */
	public function Out(Void) {
		level = All;
	}
	
	/**
	 * Sets a new level.
	 * @param newLevel
	 */
	public function setLevel(newLevel:OutLevel):Void {
		level = newLevel;
	}
}