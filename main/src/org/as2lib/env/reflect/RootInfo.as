import org.as2lib.env.reflect.CacheInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;

/**
 * RootInfo represents the root of the class path. The root in the Flash environment
 * is _global. There can only exist one RootInfo instance.
 *
 * @author Simon Wacker
 * @see org.as2lib.env.reflect.PackageInfo
 * @see org.as2lib.env.reflect.CacheInfo
 */
class org.as2lib.env.reflect.RootInfo extends PackageInfo implements CacheInfo {
	/**
	 * Constructs a RootInfo.
	 */
	public function RootInfo(Void) {
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