import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Map;
import org.as2lib.env.reflect.CacheInfo;
import org.as2lib.env.reflect.NoSuchChildException;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.iterator.Iterator;

/**
 * PackageInfo represents a real package in the Flash environment. This class is
 * used to store specific information about the package it represents.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 * @see org.as2lib.env.reflect.CacheInfo
 */
class org.as2lib.env.reflect.PackageInfo extends BasicClass implements CacheInfo {
	/** The name of the package. */
	private var name:String;
	
	/** The full name of the package. This means the package name as well as the path. */
	private var fullName:String;
	
	/** The actual package this PackageInfo represents. */
	private var package;
	
	/** The parent of the package. This is the packge the package resides in. */
	private var parent:PackageInfo;
	
	/** The children of the package. That means all classes and packages contained in the package. */
	private var children:Map;
	
	/**
	 * Constructs a new PackageInfo.
	 *
	 * @param name the name of the package
	 * @param package the actual package the PackageInfo shall represent
	 * @param parent the PackageInfo representing the parent package
	 */
	public function PackageInfo(name:String, 
							  	package, 
							  	parent:PackageInfo) {
		this.name = name;
		this.package = package;
		this.parent = parent;
	}
	
	/**
	 * Returns the name of the package. The name does not include the path.
	 *
	 * @return the name of the package
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the full name of the package. The full name is composed of the
	 * name and the path.
	 *
	 * @return the full name of the package
	 */
	public function getFullName(Void):String {
		if (ObjectUtil.isEmpty(fullName)) {
			if (getParent().isRoot()) {
				return (fullName = getName());
			}
			fullName = getParent().getFullName() + "." + getName();
		}
		return fullName;
	}
	
	/**
	 * Returns the actual package this PackageInfo represents.
	 *
	 * @return the actual package
	 */
	public function getPackage(Void) {
		return package;
	}
	
	/**
	 * Returns the parent of the package represented by a PackageInfo. The parent
	 * is the package the package resides in.
	 *
	 * @return the PackageInfo representing the parent of the package
	 */
	public function getParent(Void):PackageInfo {
		return parent;
	}
	
	/**
	 * Returns a Map containing CacheInfos representing the children of the
	 * package. That means all classes and packages contained in the package.
	 *
	 * @return a Map containing the children
	 */
	public function getChildren(Void):Map {
		if (children == undefined) {
			children = ReflectUtil.getChildren(this);
		}
		return children;
	}
	
	/**
	 * Returns the CacheInfo corresponding to the name of the child.
	 *
	 * @param childName the name of the child
	 * @return the CacheInfo corresponding to the child's name
	 * @throws org.as2lib.env.reflect.NoSuchChildException if there is no child with the passed name
	 */
	public function getChild(childName:String):CacheInfo {
		var iterator:Iterator = getChildren().iterator();
		var child:CacheInfo;
		while (iterator.hasNext()) {
			child = CacheInfo(iterator.next());
			if (child.getName() == childName) {
				return child;
			}
		}
		throw new NoSuchChildException("The child with the name [" + childName + "] you tried to obtain does not exist.",
									   this,
									   arguments);
	}
	
	/**
	 * Returns false because a PackageInfo can never be the root. The root is
	 * represented by a RootInfo.
	 *
	 * @return false
	 */
	public function isRoot(Void):Boolean {
		return false;
	}
}