import org.as2lib.basic.out.Level;
import org.as2lib.basic.out.level.*;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.Out {
	/** All output will be made. */
	public static var ALL:Level = new All();
	/** All output that is at a lower output level will be made. */
	public static var DEBUG:Level = new Debug();
	/** All output that is at a lower output level will be made. */
	public static var INFO:Level = new Info();
	/** All output that is at a lower output level will be made. */
	public static var WARNING:Level = new Warning();
	/** All output that is at a lower output level will be made. */
	public static var ERROR:Level = new Error();
	/** All output that is at a lower output level will be made. */
	public static var FATAL:Level = new Fatal();
	/** No output will be made. */
	public static var NONE:Level = new None();
	
	/**
	 * The actual level of the Out instance.
	 */
	private var level:Level;
	
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
	public function setLevel(newLevel:Level):Void {
		level = newLevel;
	}
}