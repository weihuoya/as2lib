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
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.env.reflect.CompositeMemberInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.NoSuchChildException;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.holder.Iterator;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * PackageInfo represents a real package in the Flash environment. This class is
 * used to store specific information about the package it represents.
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
	 * @see org.as2lib.env.reflect.MemberInfo#getName()
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * @see org.as2lib.env.reflect.CompositeMemberInfo#getFullName()
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
	 * @see org.as2lib.env.reflect.MemberInfo#getParent()
	 */
	public function getParent(Void):PackageInfo {
		return parent;
	}
	
	/**
	 * Returns an Array containing CompositeMemberInfos representing the children of the
	 * package. That means all classes and packages contained in the package.
	 *
	 * @return an Array containing the children
	 */
	public function getChildren(Void):Array {
		if (!children) {
			children = ReflectConfig.getChildrenAlgorithm().execute(this);
		}
		return children;
	}
	
	/**
	 * Returns an Array containing ClassInfos representing the classes contained
	 * in this package.
	 *
	 * @return an Array containing the classes
	 */
	public function getChildClasses(Void):Array {
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
	 * @return an Array containing the packages
	 */
	public function getChildPackages(Void):Array {
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
	 * Overload
	 * #getChildByName()
	 * #getChildByChild()
	 */
	public function getChild(child):CompositeMemberInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getChildByName);
		overload.addHandler([Object], getChildByChild);
		return CompositeMemberInfo(overload.forward(arguments));
	}
	
	/**
	 * Returns the CompositeMemberInfo corresponding to the name of the child.
	 *
	 * @param childName the name of the child
	 * @return the CompositeMemberInfo corresponding to the child's name
	 * @throws org.as2lib.env.reflect.NoSuchChildException if there is no child with the passed name
	 */
	public function getChildByName(childName:String):CompositeMemberInfo {
		var child:CompositeMemberInfo = getChildren().get(childName);
		if (ObjectUtil.isAvailable(child)) {
			return child;
		}
		throw new NoSuchChildException("The child with the name [" + childName + "] you tried to obtain does not exist.",
									   this,
									   arguments);
	}
	
	/**
	 * Returns the CompositeMemberInfo corresponding to the child.
	 *
	 * @param child the concrete child you want the CompositeMemberInfo for
	 * @return the CompositeMemberInfo corresponding to the child
	 * @throws org.as2lib.env.reflect.NoSuchChildException if the child does not exist in this package
	 * @throws org.as2lib.env.except.IllegalArgumentException if the child is neither of type function nor object
	 */
	public function getChildByChild(concreteChild):CompositeMemberInfo {
		if (ObjectUtil.isTypeOf(concreteChild, "function")) {
			return getChildClassByClass(concreteChild);
		}
		if (ObjectUtil.isTypeOf(concreteChild, "object")) {
			return getChildPackageByPackage(concreteChild);
		}
		throw new IllegalArgumentException("The passed child [" + concreteChild + "] must be either of type function or object.",
										   this,
										   arguments);
	}
	
	/**
	 * Overlaod
	 * #getChildClassByName()
	 * #getChildClassByClass()
	 */
	public function getChildClass(clazz):ClassInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getChildClassByName);
		overload.addHandler([Function], getChildClassByClass);
		return ClassInfo(overload.forward(arguments));
	}
	
	/**
	 * Returns a ClassInfo corresponding to the name of the class.
	 *
	 * @param class the name of the class
	 * @return a ClassInfo corresponding to the passed name
	 * @throws org.as2lib.env.reflect.NoSuchChildException if the class does not exist in this package
	 */
	public function getChildClassByName(clazz:String):ClassInfo {
		var result:ClassInfo = ClassInfo(getChildClasses().get(clazz));
		if (ObjectUtil.isAvailable(result)) {
			return result;
		}
		throw new NoSuchChildException("The class with the name [" + clazz + "] you tried to obtain does not exist.",
									   this,
									   arguments);
	}
	
	/**
	 * Returns a ClassInfo corresponding to the passed concrete class.
	 *
	 * @param class the concrete class a corresponding ClassInfo shall be returned
	 * @return the ClassInfo corresponding to the passed class
	 * @throws org.as2lib.env.reflect.NoSuchChildException if the class does not exist in this package
	 */
	public function getChildClassByClass(clazz:Function):ClassInfo {
		var result:ClassInfo;
		var iterator:Iterator = getChildClasses().iterator();
		while (iterator.hasNext()) {
			result = ClassInfo(iterator.next());
			if (result.getType() == clazz) {
				return result;
			}
		}
		throw new NoSuchChildException("The class [" + clazz + "] you tried to obtain does not exist in this package.",
									   this,
									   arguments);
	}
	
	/**
	 * Overlaod
	 * #getChildPackageByName()
	 * #getChildPackageByPackage()
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
	 * @param package the name of the package
	 * @return a PackageInfo corresponding to the passed name
	 * @throws org.as2lib.env.reflect.NoSuchChildException if the package does not exist in this package
	 */
	public function getChildPackageByName(package:String):PackageInfo {
		var result:PackageInfo = PackageInfo(getChildPackages().get(package));
		if (ObjectUtil.isAvailable(result)) {
			return result;
		}
		throw new NoSuchChildException("The package with the name [" + package + "] you tried to obtain does not exist.",
									   this,
									   arguments);
	}
	
	/**
	 * Returns a PackageInfo corresponding to the passed concrete package.
	 *
	 * @param package the concrete package a corresponding PackageInfo shall be returned
	 * @return the PackageInfo corresponding to the passed package
	 * @throws org.as2lib.env.reflect.NoSuchChildException if the package does not exist in this package
	 */
	public function getChildPackageByPackage(package:Function):PackageInfo {
		var result:PackageInfo;
		var iterator:Iterator = getChildPackages().iterator();
		while (iterator.hasNext()) {
			result = PackageInfo(iterator.next());
			if (result.getPackage() == package) {
				return result;
			}
		}
		throw new NoSuchChildException("The package [" + package + "] you tried to obtain does not exist in this package.",
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
	
	/** 
	 * Returns true if the applied package is a parent package of this package.
	 * 
	 * @param package Package that could be a parent package.
	 * @return true if the applied package is a parent package of this package.
	 */
	public function isParentPackage(package:PackageInfo):Boolean {
		var parent:PackageInfo = getParent();
		if (parent === package) {
			return true;
		} else if(parent.isRoot()) {
			return false;
		} else {
			return parent.isParentPackage(package);
		}
	}
}