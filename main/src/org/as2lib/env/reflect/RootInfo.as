import org.as2lib.env.reflect.CacheInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;

/**
 * RootInfo represents the root of the class path. The root in the Flash environment
 * is _global. There can only exist one RootInfo instance. Thus it is implemented
 * as a Singleton.
 *
 * @author Simon Wacker
 * @see org.as2lib.env.reflect.PackageInfo
 * @see org.as2lib.env.reflect.CacheInfo
 */
class org.as2lib.env.reflect.RootInfo extends PackageInfo implements CacheInfo {
	/** The onliest instance of the RootInfo class. */
	private static var instance:RootInfo = new RootInfo();
	
	/**
	 * Returns the onliest instance of the RootInfo class.
	 *
	 * @return an instance of the RootInfo class
	 */
	public static function getInstance(Void):RootInfo {
		return instance;
	}
	
	/**
	 * Constructs a RootInfo.
	 */
	private function RootInfo(Void) {
		super("root", _global, undefined);
	}
	
	/**
	 * Returns the full name of the root. This returns the same as the #getName()
	 * operation.
	 *
	 * @return the full name of the root
	 */
	public function getFullName(Void):String {
		return getName();
	}
	
	/**
	 * Returns true.
	 *
	 * @return true
	 */
	public function isRoot(Void):Boolean {
		return true;
	}
}