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
import org.as2lib.env.reflect.PackageMemberInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.reflect.algorithm.PackageMemberAlgorithm;

/**
 * PackageInfo represents a real package in the Flash environment. This
 * class is used to get specific information about the package it represents.
 *
 * <p>You can use the static search methods #forName and #forPackage to
 * get package infos for specific packages.
 *
 * <p>If you for example have a package you wanna get information about
 * you first must retrieve the appropriate PackageInfo instance and you
 * can then use its methods to get the wanted information.
 * 
 * <code>var packageInfo:PackageInfo = PackageInfo.forPackage(org.as2lib.core);
 * trace("Package full name: " + packageInfo.getFullName());
 * trace("Parent package name: " + packageInfo.getParent().getName());
 * trace("Member classes: " + packageInfo.getMemberClasses());
 * trace("Member packages: " + packageInfo.getMemberPackages());</code>
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.PackageInfo extends BasicClass implements PackageMemberInfo {
	
	/** The name of the package. */
	private var name:String;
	
	/** The full name of the package. This means the package name as well as the path. */
	private var fullName:String;
	
	/** The actual package this PackageInfo represents. */
	private var package;
	
	/** The parent of the package. This is the packge the package resides in. */
	private var parent:PackageInfo;
	
	/** The members of the package. That means all classes, interfaces and packages contained in the package. */
	private var members:Array;
	
	/** Stores the member algorithm. */
	private var packageMemberAlgorithm:PackageMemberAlgorithm;
	
	/**
	 * Returns the package info corresponding to the passed-in name.
	 *
	 * <p>The package name is composed of the preceding path and the
	 * actual package name, that means it must be fully qualified.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in name is null, undefined or a blank string.</li>
	 *   <li>There is no package with the given name.</li>
	 * </ul>
	 *
	 * @param packageName the full name of the package
	 * @return the package info corresponding to the passed-in name
	 */
	public static function forName(packageName:String):PackageInfo {
		if (!packageName) return null;
		return ReflectConfig.getPackageAlgorithm().executeByName(packageName);
	}
	
	/**
	 * Returns the package info corresponding to the passed-in package.
	 *
	 * <p>This method first checks whether the package is already
	 * contained in the cache.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in package is null or undefined.</li>
	 *   <li>The package info corresponding to the package could not be generated.</li>
	 * </ul>
	 *
	 * @param package the package you wanna get the package info for
	 * @return the package info corresponding to the passed-in package
	 */
	public static function forPackage(package):PackageInfo {
		if (package == null) return null;
		var info:PackageInfo = ReflectConfig.getCache().getPackage(package);
		if (!info) {
			info = ReflectConfig.getPackageAlgorithm().execute(package);
		}
		return info;
	}
	
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
	 * Sets the algorithm used to find members.
	 *
	 * <p>If you pass an algorithm of value null or undefined,
	 * #getPackageMemberAlgorithm() will return the default one.
	 *
	 * <p>This algorithm is used by the #getMembers() method.
	 *
	 * @param packageMemberAlgorithm the new member algorithm to find members
	 *
	 * @see #getPackageMemberAlgorithm()
	 */
	public function setPackageMemberAlgorithm(packageMemberAlgorithm:PackageMemberAlgorithm):Void {
		this.packageMemberAlgorithm = packageMemberAlgorithm;
	}
	
	/**
	 * Returns the member algorithm used to find members of this package.
	 *
	 * <p>Either the algorithm set via #setPackageMemberAlgorithm() will be
	 * returned or the default member algorithm returned by the
	 * ReflectConfig#getPackageMemberAlgorithm() method.
	 *
	 * <p>If you set an algorithm of value null or undefined the default
	 * one will be used.
	 *
	 * @return the currently used member algorithm
	 *
	 * @see #setPackageMemberAlgorithm(PackageMemberAlgorithm)
	 */
	public function getPackageMemberAlgorithm(Void):PackageMemberAlgorithm {
		if (!packageMemberAlgorithm) packageMemberAlgorithm = ReflectConfig.getPackageMemberAlgorithm();
		return packageMemberAlgorithm;
	}
	
	/**
	 * Returns the name of the represented package.
	 *
	 * <p>This does not include the package's path/namespace. If this package
	 * info represented for example the org.as2lib.core package the returned
	 * name would be 'core'.
	 *
	 * @return the name of the package
	 * @see #getFullName(Void):String
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the full name of the represented package. That means the name
	 * of the package plus its package path/namespace.
	 *
	 * <p>The path does not get included if:
	 * <ul>
	 *   <li>The #getParent method returns null or undefined.</li>
	 *   <li>The #getParent method returns the root package, that means its #isRoot method returns true.</li>
	 * </ul>
	 *
	 * @return the full name of the package
	 */
	public function getFullName(Void):String {
		if (fullName === undefined) {
			if (getParent().isRoot() || isRoot()) {
				return (fullName = getName());
			}
			fullName = getParent().getFullName() + "." + getName();
		}
		return fullName;
	}
	
	/**
	 * Returns the actual package this PackageInfo instance represents.
	 *
	 * @return the actual represented package
	 */
	public function getPackage(Void) {
		return package;
	}
	
	/**
	 * Returns the parent of the represented package.
	 *
	 * <p>The parent is the package the represented package is contained
	 * in. The parent of the package org.as2lib.core is org.as2lib.
	 *
	 * @return the parent of the represented package
	 */
	public function getParent(Void):PackageInfo {
		return parent;
	}
	
	/**
	 * Returns an array containing PackageMemberInfo instances representing
	 * the members of the package. That means all classes and packages 
	 * contained in the package.
	 *
	 * <p>Null will be returned if
	 * <ul>
	 *   <li>The #getPackage method returns null or undefined.</li>
	 *   <li>The #getPackageMemberAlgorithm().execute method returns null or undefined.</li>
	 * </ul>
	 *
	 * @return an array containing the members
	 */
	public function getMembers(Void):Array {
		if (getPackage() == null) return null;
		if (members === undefined) {
			members = getPackageMemberAlgorithm().execute(this);
		}
		return members;
	}
	
	/**
	 * Returns an Array containing ClassInfo instances representing the classes
	 * contained in this package.
	 *
	 * <p>Null will be returned if the #getMembers() method returns null.
	 *
	 * @return an Array containing the classes
	 */
	public function getMemberClasses(Void):Array {
		if (!getMembers()) return null;
		var result:Array = new Array();
		var l:Number = getMembers().length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			var member:PackageMemberInfo = getMembers()[i];
			if (member instanceof ClassInfo) {
				result[result.length] = member;
			}
		}
		return result;
	}
	
	/**
	 * Returns an Array containing PackageInfos representing the packages contained
	 * in this package.
	 *
	 * <p>Null will be returned if the #getMembers() method returns null.
	 *
	 * @return an Array containing the packages
	 */
	public function getMemberPackages(Void):Array {
		if (!getMembers()) return null;
		var result:Array = new Array();
		var l:Number = getMembers().length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			var member:PackageMemberInfo = getMembers()[i];
			if (member instanceof PackageInfo) {
				result[result.length] = member;
			}
		}
		return result;
	}
	
	/**
	 * @overload #getMemberByName(String)
	 * @overload #getMemberByMember(*)
	 */
	public function getMember(member):PackageMemberInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getMemberByName);
		overload.addHandler([Object], getMemberByMember);
		return overload.forward(arguments);
	}
	
	/**
	 * Returns the PackageMemberInfo corresponding to the name of the member.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The #getMembers() method returns null or undefined.</li>
	 *   <li>The passed-in name is null or undefined.</li>
	 *   <li>There is no member with the passed-in name.</li>
	 * </ul>
	 *
	 * @param memberName the name of the member
	 * @return the PackageMemberInfo corresponding to the member's name
	 */
	public function getMemberByName(memberName:String):PackageMemberInfo {
		if (memberName == null) return null;
		var members:Array = getMembers();
		if (!members) return null;
		for (var i:Number = 0; i < members.length; i++) {
			var member:PackageMemberInfo = members[i];
			if (member.getName() == memberName) {
				return member;
			}
		}
		return null;
	}
	
	/**
	 * Returns the PackageMemberInfo corresponding to the member.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The #getMembers() method returns null or undefined.</li>
	 *   <li>The passed-in argument is null or undefined.</li>
	 *   <li>The member could not be found.</li>
	 * </ul>
	 *
	 * @param member the concrete member you want the PackageMemberInfo for
	 * @return the PackageMemberInfo corresponding to the member
	 */
	public function getMemberByMember(concreteMember):PackageMemberInfo {
		if (concreteMember == null) return null;
		if (!getMembers()) return null;
		if (typeof(concreteMember) == "function") {
			return getMemberClassByClass(concreteMember);
		} else {
			return getMemberPackageByPackage(concreteMember);
		}
	}
	
	/**
	 * @overload #getMemberClassByName(String)
	 * @overload #getMemberClassByClass(Function)
	 */
	public function getMemberClass(clazz):ClassInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getMemberClassByName);
		overload.addHandler([Function], getMemberClassByClass);
		return overload.forward(arguments);
	}
	
	/**
	 * Returns a ClassInfo corresponding to the name of the class.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in class name is null or undefined.</li>
	 *   <li>The #getMemberClasses() method returns null.</li>
	 *   <li>There is no class with the passed-in name.</li>
	 * </ul>
	 *
	 * @param className the name of the class
	 * @return a ClassInfo corresponding to the passed name
	 */
	public function getMemberClassByName(className:String):ClassInfo {
		if (className == null) return null;
		var classes:Array = getMemberClasses();
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
	 *   <li>The #getMemberClasses() method returns null.</li>
	 *   <li>There is no class matching the passed-in concrete class in this package.</li>
	 * </ul>
	 *
	 * @param concreteClass the concrete class a corresponding ClassInfo shall be returned
	 * @return the ClassInfo corresponding to the passed class
	 */
	public function getMemberClassByClass(concreteClass:Function):ClassInfo {
		if (!concreteClass) return null;
		var classes:Array = getMemberClasses();
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
	 * @overload #getMemberPackageByName(String)
	 * @overload #getMemberPackageByPackage(*)
	 */
	public function getMemberPackage(package):PackageInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getMemberPackageByName);
		overload.addHandler([Object], getMemberPackageByPackage);
		return overload.forward(arguments);
	}
	
	/**
	 * Returns a PackageInfo corresponding to the name of the package.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in package name is null or undefined.</li>
	 *   <li>The #getMemberPackages() method returns null.</li>
	 *   <li>There is no package with the given name.</li>
	 * </ul>
	 *
	 * @param packageName the name of the package
	 * @return a PackageInfo corresponding to the passed name
	 */
	public function getMemberPackageByName(packageName:String):PackageInfo {
		if (packageName == null) return null;
		var packages:Array = getMemberPackages();
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
	 *   <li>The #getMemberPackages() method returns null.</li>
	 *   <li>A package matching the passed-in concrete package could not be found.</li>
	 * </ul>
	 *
	 * @param concretePackage the concrete package a corresponding PackageInfo shall be returned
	 * @return the PackageInfo corresponding to the passed package
	 */
	public function getMemberPackageByPackage(concretePackage):PackageInfo {
		if (concretePackage == null) return null;
		var packages:Array = getMemberPackages();
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
	 * Returns whether this package info is represents a root package.
	 *
	 * <p>It is supposed to be a root package when its parent is null or
	 * undefined.
	 *
	 * @return true if this package info represents a root package else false
	 */
	public function isRoot(Void):Boolean {
		return !getParent();
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
		if (package == this) return false;
		while (package) {
			if (package.isRoot()) return false;
			package = package.getParent();
			if (package == this) return true;
		}
		return false;
	}
	
}