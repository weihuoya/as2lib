import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.data.holder.HashMap;

/**
 * CacheInfo is the interface for classes residing in the Cache.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.CacheInfo {
	/**
	 * Returns the name of the entity this CacheInfo represents.
	 *
	 * @return the name of the entity
	 */
	public function getName(Void):String;
	
	/**
	 * Returns the full name of the entity this CacheInfo represents. The full
	 * name includes the name as well as the path.
	 *
	 * @return the full name of the entity
	 */
	public function getFullName(Void):String;
	
	/**
	 * Returns the parent of the entity represented by a PackageInfo. The parent
	 * is the package the entity resieds in.
	 *
	 * @return the parent
	 */
	public function getParent(Void):PackageInfo;
	
	/**
	 * Returns a HashMap containing the children of the entity.
	 *
	 * @return the children of the entity
	 */
	public function getChildren(Void):HashMap;
}