/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.reflect.CompositeMemberInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.reflect.algorithm.ChildAlgorithm;

/**
 * PackageInfo represents a real package in the Flash environment. This class is
 * used to get specific information about the package it represents.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.PackageInfo extends BasicClass implements CompositeMemberInfo {
	
	/** The name of the package. */
	private var name:String;
	
	/** The full name of the package. This means the package name as well as the path. */
	private var fullName:String;
	
	/** The actual package this PackageInfo represents. */
	private var package;
	
	/** The parent of the package. This is the packge the package resides in. */
	private var parent:PackageInfo;
	
	/** The children of the package. That means all classes and packages contained in the package. */
	private var children:Array;
	
	/** Stores the child algorithm. */
	private var childAlgorithm:ChildAlgorithm;
	
	/**
	 * Constructs a new PackageInfo instance.
	 *
	 * <p>All arguments are allowed to be null, but keep in mind that if one is
	 * not all methods function.
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
	 * Sets the algorithm used to find children.
	 *
	 * <p>If you pass an algorithm of value null or undefined,
	 * #getChildAlgorithm() will return the default one.
	 *
	 * <p>This algorithm is used by the #getChildren() method.
	 *
	 * @param childAlgorithm the new child algorithm to find children
	 *
	 * @see #getChildAlgorithm()
	 */
	public function setChildAlgorithm(childAlgorithm:ChildAlgorithm):Void {
		this.childAlgorithm = childAlgorithm;
	}
	
	/**
	 * Returns the child algorithm used to find children.
	 *
	 * <p>Either the algorithm set via #setChildAlgorithm() will be
	 * returned or the default child algorithm returned by the
	 * ReflectConfig#getChildAlgorithm() method.
	 *
	 * <p>If you set an algorithm of value null or undefined the default
	 * one will be used.
	 *
	 * @return the currently used child algorithm
	 *
	 * @see #setChildAlgorithm(ChildAlgorithm)
	 */
	public function getChildAlgorithm(Void):ChildAlgorithm {
		if (!childAlgorithm) childAlgorithm = ReflectConfig.getChildAlgorithm();
		return childAlgorithm;
	}
	
	/**
	 * @see org.as2lib.env.reflect.MemberInfo#getName()
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the full name of the represented package. That means the name
	 * of the package plus its package path.
	 *
	 * <p>The path will not be included if #getParent() returns null, 
	 * undefined.
	 *
	 * <p>If the #getParent() method returns a package whose #isRoot() method
	 * returns true it is not listed in the resulting string.
	 *
	 * @see org.as2lib.env.reflect.CompositeMemberInfo#getFullName()
	 */
	public function getFullName(Void):String {
		if (fullName === undefined) {
			if (getParent().isRoot() || !getParent()) {
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
	 * @see org.as2lib.env.reflect.MemberInfo#getParent()
	 */
	public function getParent(Void):PackageInfo {
		return parent;
	}
	
	/**
	 * Returns an Array containing CompositeMemberInfos representing the children of the
	 * package. That means all classes and packages contained in the package.
	 *
	 * <p>Null will be returned if #getPackage() returns null or undefined.
	 *
	 * @return an Array containing the children
	 */
	public function getChildren(Void):Array {
		if (getPackage() == null) return null;
		if (children === undefined) {
			children = getChildAlgorithm().execute(this);
		}
		return children;
	}
	
	/**
	 * Returns an Array containing ClassInfo instances representing the classes
	 * contained in this package.
	 *
	 * <p>Null will be returned if the #getChildren() method returns null.
	 *
	 * @return an Array containing the classes
	 */
	public function getChildClasses(Void):Array {
		if (!getChildren()) return null;
		var result:Array = new Array();
		var l:Number = getChildren().length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			var child:CompositeMemberInfo = getChildren()[i];
			if (child instanceof ClassInfo) {
				result[result.length] = child;
			}
		}
		return result;
	}
	
	/**
	 * Returns an Array containing PackageInfos representing the packages contained
	 * in this package.
	 *
	 * <p>Null will be returned if the #getChildren() method returns null.
	 *
	 * @return an Array containing the packages
	 */
	public function getChildPackages(Void):Array {
		if (!getChildren()) return null;
		var result:Array = new Array();
		var l:Number = getChildren().length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			var child:CompositeMemberInfo = getChildren()[i];
			if (child instanceof PackageInfo) {
				result[result.length] = child;
			}
		}
		return result;
	}
	
	/**
	 * @overload #getChildByName(String)
	 * @overload #getChildByChild(*)
	 */
	public function getChild(child):CompositeMemberInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getChildByName);
		overload.addHandler([Object], getChildByChild);
		return overload.forward(arguments);
	}
	
	/**
	 * Returns the CompositeMemberInfo corresponding to the name of the child.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The #getChildren() method returns null or undefined.</li>
	 *   <li>The passed-in name is null or undefined.</li>
	 *   <li>There is no child with the passed-in name.</li>
	 * </ul>
	 *
	 * @param childName the name of the child
	 * @return the CompositeMemberInfo corresponding to the child's name
	 */
	public function getChildByName(childName:String):CompositeMemberInfo {
		if (childName == null) return null;
		var children:Array = getChildren();
		if (!children) return null;
		for (var i:Number = 0; i < children.length; i++) {
			var child:CompositeMemberInfo = children[i];
			if (child.getName() == childName) {
				return child;
			}
		}
		return null;
	}
	
	/**
	 * Returns the CompositeMemberInfo corresponding to the child.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The #getChildren() method returns null or undefined.</li>
	 *   <li>The passed-in argument is null or undefined.</li>
	 *   <li>The child could not be found.</li>
	 * </ul>
	 *
	 * @param child the concrete child you want the CompositeMemberInfo for
	 * @return the CompositeMemberInfo corresponding to the child
	 */
	public function getChildByChild(concreteChild):CompositeMemberInfo {
		if (concreteChild == null) return null;
		if (!getChildren()) return null;
		if (typeof(concreteChild) == "function") {
			return getChildClassByClass(concreteChild);
		} else {
			return getChildPackageByPackage(concreteChild);
		}
	}
	
	/**
	 * @overload #getChildClassByName(String)
	 * @overload #getChildClassByClass(Function)
	 */
	public function getChildClass(clazz):ClassInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getChildClassByName);
		overload.addHandler([Function], getChildClassByClass);
		return overload.forward(arguments);
	}
	
	/**
	 * Returns a ClassInfo corresponding to the name of the class.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in class name is null or undefined.</li>
	 *   <li>The #getChildClasses() method returns null.</li>
	 *   <li>There is no class with the passed-in name.</li>
	 * </ul>
	 *
	 * @param className the name of the class
	 * @return a ClassInfo corresponding to the passed name
	 */
	public function getChildClassByName(className:String):ClassInfo {
		if (className == null) return null;
		var classes:Array = getChildClasses();
		if (!classes) return null;
		for (var i:Number = 0; i < classes.length; i++) {
			var clazz:ClassInfo = classes[i];
			if (clazz.getName() == className) {
				return clazz;
			}
		}
		return null;
	}
	
	/**
	 * Returns a ClassInfo corresponding to the passed concrete class.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in argument is null or undefined.</li>
	 *   <li>The #getChildClasses() method returns null.</li>
	 *   <li>There is no class matching the passed-in concrete class in this package.</li>
	 * </ul>
	 *
	 * @param concreteClass the concrete class a corresponding ClassInfo shall be returned
	 * @return the ClassInfo corresponding to the passed class
	 */
	public function getChildClassByClass(concreteClass:Function):ClassInfo {
		if (!concreteClass) return null;
		var classes:Array = getChildClasses();
		if (!classes) return null;
		for (var i:Number = 0; i < classes.length; i++) {
			var clazz:ClassInfo = classes[i];
			if (clazz.getType() == concreteClass) {
				return clazz;
			}
		}
		return null;
	}
	
	/**
	 * @overload #getChildPackageByName(String)
	 * @overload #getChildPackageByPackage(*)
	 */
	public function getChildPackage(package):PackageInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getChildPackageByName);
		overload.addHandler([Object], getChildPackageByPackage);
		return PackageInfo(overload.forward(arguments));
	}
	
	/**
	 * Returns a PackageInfo corresponding to the name of the package.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in package name is null or undefined.</li>
	 *   <li>The #getChildPackages() method returns null.</li>
	 *   <li>There is no package with the given name.</li>
	 * </ul>
	 *
	 * @param packageName the name of the package
	 * @return a PackageInfo corresponding to the passed name
	 */
	public function getChildPackageByName(packageName:String):PackageInfo {
		if (packageName == null) return null;
		var packages:Array = getChildPackages();
		if (!packages) return null;
		for (var i:Number = 0; i < packages.length; i++) {
			var package:PackageInfo = packages[i];
			if (package.getName() == packageName) {
				return package;
			}
		}
		return null;
	}
	
	/**
	 * Returns a PackageInfo corresponding to the passed concrete package.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in concrete package is null or undefined.</li>
	 *   <li>The #getChildPackages() method returns null.</li>
	 *   <li>A package matching the passed-in concrete package could not be found.</li>
	 * </ul>
	 *
	 * @param concretePackage the concrete package a corresponding PackageInfo shall be returned
	 * @return the PackageInfo corresponding to the passed package
	 */
	public function getChildPackageByPackage(concretePackage):PackageInfo {
		if (concretePackage == null) return null;
		var packages:Array = getChildPackages();
		if (!packages) return null;
		for (var i:Number = 0; i < packages.length; i++) {
			var package:PackageInfo = packages[i];
			if (package.getPackage() == concretePackage) {
				return package;
			}
		}
		return null;
	}
	
	/**
	 * Returns false because a PackageInfo can never be the root. The root is
	 * represented by the RootInfo instance.
	 *
	 * @return false
	 */
	public function isRoot(Void):Boolean {
		return false;
	}
	
	/** 
	 * Returns true if this package is the parent package of the passed-in one.
	 * 
	 * <p>False will be returned if:
	 * <ul>
	 *   <li>The passed-in package is not a parent package of this package.</li>
	 *   <li>The passed-in package is null or undefined.</li>
	 *   <li>The passed-in package equals this package.</li>
	 *   <li>The passed-in package's isRoot() method returns true.</li>
	 * </ul>
	 * 
	 * @param package package this package could be a parent of
	 * @return true if this package is the parent of the passed-in package
	 */
	public function isParentPackage(package:PackageInfo):Boolean {
		if (!package) return false;
		if (package.isRoot()) return false;
		if (package == this) return false;
		var parent:PackageInfo = package.getParent();
		if (!parent) return false;
		if (parent == this) return true;
		return isParentPackage(parent);
	}
	
}