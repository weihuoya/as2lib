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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageMemberInfo;
import org.as2lib.env.reflect.PackageMemberFilter;
import org.as2lib.env.reflect.algorithm.PackageAlgorithm;
import org.as2lib.env.reflect.algorithm.PackageMemberAlgorithm;

/**
 * PackageInfo represents a real package in the Flash environment. This
 * class is used to get specific information about the package it represents.
 *
 * <p>You can use the static search methods {@link #forName} and 
 * {@link #forPackage} to get package infos for specific packages.
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
	
	/** The algorithm to find packages. */
	private static var packageAlgorithm:PackageAlgorithm;
	
	/** The algorithm to find members of packages, that are classes and packages. */
	private static var packageMemberAlgorithm:PackageMemberAlgorithm;
	
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
	
	/**
	 * Returns the package info corresponding to the passed-in name.
	 *
	 * <p>The package name is composed of the preceding path and the
	 * actual package name, that means it must be fully qualified. For
	 * example 'org.as2lib.core'.
	 *
	 * <p>This method first checks whether the package is already
	 * contained in the cache.
	 *
	 * @param packageName the full name of the package
	 * @return the package info corresponding to the passed-in name
	 * @throws IllegalArgumentException if the passed-in name is null, undefined or an empty string or
	 *                                  if the object corresponding to the passed-in name is not of type object
	 * @throws PackageNotFoundException if a package with the passed-in name could not be found
	 */
	public static function forName(packageName:String):PackageInfo {
		return getPackageAlgorithm().executeByName(packageName);
	}
	
	/**
	 * Returns the package info corresponding to the passed-in package.
	 *
	 * <p>This method first checks whether the package is already
	 * contained in the cache.
	 *
	 * @param package the package you wanna get the package info for
	 * @return the package info corresponding to the passed-in package
	 * @throws IllegalArgumentException if the passed-in package is null or undefined
	 */
	public static function forPackage(package):PackageInfo {
		if (package == null) throw new IllegalArgumentException("The passed-in package '" + package + "' is not allowed to be null or undefined.", eval("th" + "is"), arguments);
		var packageInfo:PackageInfo = ReflectConfig.getCache().getPackage(package);
		if (packageInfo) return packageInfo;
		return ReflectConfig.getCache().addPackage(new PackageInfo(package));
	}
	
	/**
	 * Sets the algorithm used to find packages.
	 *
	 * <p>If you pass an algorithm of value null or undefined,
	 * {@link #getPackageAlgorithm} will return the default one.
	 *
	 * @param newPackageAlgorithm the new algorithm to find packages
	 * @see #getPackageAlgorithm
	 */
	public static function setPackageAlgorithm(newPackageAlgorithm:PackageAlgorithm):Void {
		packageAlgorithm = newPackageAlgorithm;
	}
	
	/**
	 * Returns the algorithm used to find packages.
	 *
	 * <p>Either the algorithm set via {@link #setPackageAlgorithm} will be
	 * returned or the default one which is an instance of class
	 * {@link PackageAlgorithm}.
	 *
	 * @return the set or the default package algorithm
	 * @see #setPackageAlgorithm
	 */
	public static function getPackageAlgorithm(Void):PackageAlgorithm {
		if (!packageAlgorithm) packageAlgorithm = new PackageAlgorithm();
		return packageAlgorithm;
	}
	
	/**
	 * Sets the algorithm used to find members of packages.
	 *
	 * <p>Members of packages are classes, interfaces and packages.
	 *
	 * <p>If you pass an algorithm of value null or undefined,
	 * {@link #getPackageMemberAlgorithm} will return the default one.
	 *
	 * @param newPackageMemberAlgorithm the new algorithm to find members of packages
	 * @see #getPackageMemberAlgorithm
	 */
	public static function setPackageMemberAlgorithm(newPackageMemberAlgorithm:PackageMemberAlgorithm):Void {
		packageMemberAlgorithm = newPackageMemberAlgorithm;
	}
	
	/**
	 * Returns the member algorithm used to find members of packages.
	 *
	 * <p>Either the algorithm set via {@link #setPackageMemberAlgorithm} will be
	 * returned or the default one which is an instance of class
	 * {@link PackageMemberAlgorithm}.
	 *
	 * @return the set or the default member algorithm
	 * @see #setPackageMemberAlgorithm
	 */
	public static function getPackageMemberAlgorithm(Void):PackageMemberAlgorithm {
		if (!packageMemberAlgorithm) packageMemberAlgorithm = new PackageMemberAlgorithm();
		return packageMemberAlgorithm;
	}
	
	/**
	 * Constructs a new PackageInfo instance.
	 *
	 * <p>Note that you do not have to pass-in the concrete package. But
	 * if you do not pass it in some methods cannot do their job correctly.
	 * 
	 * <p>If you do not pass-in the name or the parent they get resolved
	 * lazily when requested using the passed-in package.
	 *
	 * @param package the actual package the PackageInfo shall represent
	 * @param name (optional) the name of the package
	 * @param parent (optional) the PackageInfo representing the parent package
	 */
	public function PackageInfo(package,
								name:String,  
							  	parent:PackageInfo) {
		this.package = package;
		this.name = name;
		this.parent = parent;
	}
	
	/**
	 * Returns the name of the represented package.
	 *
	 * <p>This does not include the package's path/namespace. If this package
	 * info represented for example the org.as2lib.core package the returned
	 * name would be 'core'.
	 *
	 * @return the name of the package
	 * @see #getFullName
	 */
	public function getName(Void):String {
		if (name === undefined) initNameAndParent();
		return name;
	}
	
	/**
	 * Returns the full name of the represented package. That means the name
	 * of the package plus its package path/namespace.
	 *
	 * <p>The path does not get included if:
	 * <ul>
	 *   <li>The {@link #getParent} method returns null or undefined.</li>
	 *   <li>The {@link #getParent} method returns the root package, that means its {@link #isRoot} method returns true.</li>
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
		if (parent === undefined) initNameAndParent();
		return parent;
	}
	
	/**
	 * Initializes the name and the parent of the represented package.
	 *
	 * <p>This is done using the result of an execution of the package algorithm
	 * returned by the static {@link #getPackageAlgorithm} method.
	 */
	private function initNameAndParent(Void):Void {
		var info = getPackageAlgorithm().execute(getPackage());
		if (name === undefined) name = info.name == null ? null : info.name;
		if (parent === undefined) parent = info.parent == null ? null : info.parent;
	}
	
	/**
	 * @overload #getMembersByFlag
	 * @overload #getMembersByFilter
	 */
	public function getMembers():Array {
		var o:Overload = new Overload(this);
		o.addHandler([], getMembersByFlag);
		o.addHandler([Boolean], getMembersByFlag);
		o.addHandler([PackageMemberFilter], getMembersByFilter);
		return o.forward(arguments);
	}
	
	/**
	 * Returns an array containing PackageMemberInfo instances representing
	 * the members of the package and maybe the ones of the sub-packages.
	 *
	 * <p>The members of a package are all types and packages contained in
	 * the represented package.
	 *
	 * <p>If the passed-in argument filterSubPackages is null or undefined
	 * it gets interpreted as true, that means sub-packages' package members
	 * will be filtered/excluded from the result.
	 *
	 * <p>Null will be returned if
	 * <ul>
	 *   <li>The {@link #getPackage} method returns null or undefined.</li>
	 *   <li>The {@link #getPackageMemberAlgorithm}.execute method returns null or undefined.</li>
	 * </ul>
	 *
	 * @param filterSubPackages (optional) determines whether the sub-packages'
	 * members shall be filtered/excluded from (true) or included (false) in the result
	 * @return an array containing the members of the represented package
	 */
	public function getMembersByFlag(filterSubPackages:Boolean):Array {
		if (getPackage() == null) return null;
		if (filterSubPackages == null) filterSubPackages = true;
		if (members === undefined) {
			members = getPackageMemberAlgorithm().execute(this);
		}
		var result:Array = members.concat();
		if (!filterSubPackages) {
			var subPackages:Array = members["packages"];
			for (var i:Number = 0; i < subPackages.length; i++) {
				result = result.concat(PackageInfo(subPackages[i]).getMembersByFlag(filterSubPackages));
			}
		}
		return result;
	}
	
	/**
	 * Returns an array containing PackageMemberInfo instances representing
	 * the members of the package and sub-packages that do not get filtered/
	 * excluded.
	 *
	 * <p>The members of a package are all types and packages contained in
	 * the represented package.
	 *
	 * <p>The {@link PackageMemberFilter#filter} method
	 * gets invoked for every package member to determine whether it shall
	 * be contained in the result.
	 *
	 * <p>If the passed-in packageMemberFilter is null or undefined the
	 * result of the invocation of {@link #getMembersByFlag} with
	 * argument 'true' gets returned.
	 *
	 * <p>Null will be returned if
	 * <ul>
	 *   <li>The {@link #getPackage} method returns null or undefined.</li>
	 *   <li>The #getPackageMemberAlgorithm().execute method returns null or undefined.</li>
	 * </ul>
	 *
	 * @param packageMemberFilter the filter that filters unwanted package members out
	 * @return an array containing the remaining members of the represented package
	 */
	 public function getMembersByFilter(packageMemberFilter:PackageMemberFilter):Array {
		if (getPackage() == null) return null;
		if (!packageMemberFilter) return getMembersByFlag(true);
		var result:Array = getMembersByFlag(packageMemberFilter.filterSubPackages());
		for (var i:Number = 0; i < result.length; i++) {
			if (packageMemberFilter.filter(PackageMemberInfo(result[i]))) {
				result.splice(i, 1);
				i--;
			}
		}
		return result;
	}
	
	/**
	 * @overload #getMemberClassesByFlag
	 * @overload #getMemberClassesByFilter
	 */
	public function getMemberClasses():Array {
		var o:Overload = new Overload(this);
		o.addHandler([], getMemberClassesByFlag);
		o.addHandler([Boolean], getMemberClassesByFlag);
		o.addHandler([PackageMemberFilter], getMemberClassesByFilter);
		return o.forward(arguments);
	}
	
	/**
	 * Returns an array containing ClassInfo instances representing the
	 * member classes of the package and maybe the ones of the sub-packages.
	 *
	 * <p>If the passed-in argument filterSubPackages is null or undefined
	 * it gets interpreted as true, that means sub-packages' classes will
	 * be filtered/excluded from the result.
	 *
	 * <p>Null will be returned if
	 * <ul>
	 *   <li>The {@link #getPackage} method returns null or undefined.</li>
	 *   <li>The #getPackageMemberAlgorithm().execute method returns null or undefined.</li>
	 * </ul>
	 *
	 * @param filterSubPackages (optional) determines whether the sub-packages member
	 * classes shall be filtered/excluded from (true) or included (false) in the result
	 * @return an array containing the member classes of the represented package
	 */
	public function getMemberClassesByFlag(filterSubPackages:Boolean):Array {
		if (getPackage() == null) return null;
		if (filterSubPackages == null) filterSubPackages = true;
		if (members === undefined) {
			members = getPackageMemberAlgorithm().execute(this);
		}
		var result:Array = members["classes"].concat();
		if (!filterSubPackages) {
			var subPackages:Array = members["packages"];
			for (var i:Number = 0; i < subPackages.length; i++) {
				result = result.concat(PackageInfo(subPackages[i]).getMemberClassesByFlag(filterSubPackages));
			}
		}
		return result;
	}
	
	/**
	 * Returns an array containing ClassInfo instances representing the
	 * class members of the package and sub-packages that do not get
	 * filtered/excluded.
	 *
	 * <p>The {@link PackageMemberFilter#filter} method
	 * gets invoked for every member class to determine whether it shall
	 * be contained in the result.
	 *
	 * <p>If the passed-in clasFilter is null or undefined the result of the
	 * invocation of {@link #getMemberClassesByFlag} with argument
	 * 'true' gets returned.
	 *
	 * <p>Null will be returned if
	 * <ul>
	 *   <li>The {@link #getPackage} method returns null or undefined.</li>
	 *   <li>The #getPackageMemberAlgorithm().execute method returns null or undefined.</li>
	 * </ul>
	 *
	 * @param classFilter the filter that filters unwanted member classes out
	 * @return an array containing the remaining member classes of the represented package
	 */
	 public function getMemberClassesByFilter(classFilter:PackageMemberFilter):Array {
		if (getPackage() == null) return null;
		if (!classFilter) return getMemberClassesByFlag(true);
		var result:Array = getMemberClassesByFlag(classFilter.filterSubPackages());
		for (var i:Number = 0; i < result.length; i++) {
			if (classFilter.filter(ClassInfo(result[i]))) {
				result.splice(i, 1);
				i--;
			}
		}
		return result;
	}
	
	/**
	 * @overload #getMemberPackagesByFlag
	 * @overload #getMemberPackagesByFilter
	 */
	public function getMemberPackages():Array {
		var o:Overload = new Overload(this);
		o.addHandler([], getMemberPackagesByFlag);
		o.addHandler([Boolean], getMemberPackagesByFlag);
		o.addHandler([PackageMemberFilter], getMemberPackagesByFilter);
		return o.forward(arguments);
	}
	
	/**
	 * Returns an array containing {@link PackageInfo} instances representing the
	 * member packages of the package and maybe the ones of the sub-packages.
	 *
	 * <p>If the passed-in argument filterSubPackages is null or undefined
	 * it gets interpreted as true, that means sub-packages' packages will
	 * be filtered/excluded from the result.
	 *
	 * <p>Null will be returned if
	 * <ul>
	 *   <li>The {@link #getPackage} method returns null or undefined.</li>
	 *   <li>The #getPackageMemberAlgorithm().execute method returns null or undefined.</li>
	 * </ul>
	 *
	 * @param filterSubPackages (optional) determines whether the sub-packages member
	 * packages shall be filtered/excluded from (true) or included (false) in the result
	 * @return an array containing the member packages of the represented package
	 */
	public function getMemberPackagesByFlag(filterSubPackages:Boolean):Array {
		if (getPackage() == null) return null;
		if (filterSubPackages == null) filterSubPackages = true;
		if (members === undefined) {
			members = getPackageMemberAlgorithm().execute(this);
		}
		var result:Array = members["packages"].concat();
		if (!filterSubPackages) {
			var subPackages:Array = members["packages"];
			for (var i:Number = 0; i < subPackages.length; i++) {
				result = result.concat(PackageInfo(subPackages[i]).getMemberPackagesByFlag(filterSubPackages));
			}
		}
		return result;
	}
	
	/**
	 * Returns an array containing {@link PackageInfo} instances representing the
	 * package members of the package and sub-packages that do not get
	 * filtered/excluded.
	 *
	 * <p>The {@link PackageMemberFilter#filter} method
	 * gets invoked for every member package to determine whether it shall
	 * be contained in the result.
	 *
	 * <p>If the passed-in packageFilter is null or undefined the result of the
	 * invocation of {@link #getMemberPackagesByFlag} with argument
	 * 'true' gets returned.
	 *
	 * <p>Null will be returned if
	 * <ul>
	 *   <li>The {@link #getPackage} method returns null or undefined.</li>
	 *   <li>The #getPackageMemberAlgorithm().execute method returns null or undefined.</li>
	 * </ul>
	 *
	 * @param packageFilter the filter that filters unwanted member packages out
	 * @return an array containing the remaining member packages of the represented package
	 */
	 public function getMemberPackagesByFilter(packageFilter:PackageMemberFilter):Array {
		if (getPackage() == null) return null;
		if (!packageFilter) return getMemberPackagesByFlag(true);
		var result:Array = getMemberPackagesByFlag(packageFilter.filterSubPackages());
		for (var i:Number = 0; i < result.length; i++) {
			if (packageFilter.filter(PackageInfo(result[i]))) {
				result.splice(i, 1);
				i--;
			}
		}
		return result;
	}
	
	/**
	 * @overload #getMemberByName
	 * @overload #getMemberByMember
	 */
	public function getMember():PackageMemberInfo {
		var o:Overload = new Overload(this);
		o.addHandler([String], getMemberByName);
		o.addHandler([Object], getMemberByMember);
		return o.forward(arguments);
	}
	
	/**
	 * Returns the package member info corresponding to the name of the member.
	 *
	 * <p>If the package member with the passed-in name cannot be found directly
	 * in the represented package its sub-packages get searched through.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The {@link #getMembers} method returns null or undefined.</li>
	 *   <li>The passed-in name is null or undefined.</li>
	 *   <li>There is no member with the passed-in name.</li>
	 * </ul>
	 *
	 * @param memberName the name of the member
	 * @return the member corresponding to the member's name
	 */
	public function getMemberByName(memberName:String):PackageMemberInfo {
		if (memberName == null) return null;
		if (getMembersByFlag(true)) {
			if (members[memberName]) return members[memberName];
			var subPackages:Array = members["packages"];
			for (var i:Number = 0; i < subPackages.length; i++) {
				var member:PackageMemberInfo = PackageInfo(subPackages[i]).getMemberByName(memberName);
				if (member) return member;
			}
		}
		return null;
	}
	
	/**
	 * Returns the package member info corresponding to the passed-in concrete
	 * member.
	 *
	 * <p>If the package member corresponding to the passed-in concrete member
	 * cannot be found directly in the represented package its sub-packages
	 * get searched through.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The {@link #getMembers} method returns null or undefined.</li>
	 *   <li>The passed-in argument is null or undefined.</li>
	 *   <li>The member could not be found.</li>
	 * </ul>
	 *
	 * @param concreteMember the concrete member you want the PackageMemberInfo instance for
	 * @return the PackageMemberInfo instance corresponding to the member
	 */
	public function getMemberByMember(concreteMember):PackageMemberInfo {
		if (concreteMember == null) return null;
		if (typeof(concreteMember) == "function") {
			return getMemberClassByClass(concreteMember);
		} else {
			return getMemberPackageByPackage(concreteMember);
		}
	}
	
	/**
	 * @overload #getMemberClassByName
	 * @overload #getMemberClassByClass
	 */
	public function getMemberClass(clazz):ClassInfo {
		var o:Overload = new Overload(this);
		o.addHandler([String], getMemberClassByName);
		o.addHandler([Function], getMemberClassByClass);
		return o.forward(arguments);
	}
	
	/**
	 * Returns the class info corresponding to the passed-in class name.
	 *
	 * <p>If the member class with the passed-in name cannot be found directly
	 * in the represented package its sub-packages get searched through.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in class name is null or undefined.</li>
	 *   <li>There is no class with the passed-in name.</li>
	 * </ul>
	 *
	 * @param className the name of the class
	 * @return the class info corresponding to the passed-in name
	 */
	public function getMemberClassByName(className:String):ClassInfo {
		if (className == null) return null;
		if (getMemberClassesByFlag(true)) {
			if (members["classes"][className]) return members["classes"][className];
		}
		var subPackages:Array = getMemberPackagesByFlag(true);
		if (subPackages) {
			for (var i:Number = 0; i < subPackages.length; i++) {
				var clazz:ClassInfo = PackageInfo(subPackages[i]).getMemberClassByName(className);
				if (clazz) return clazz;
			}
		}
		return null;
	}
	
	/**
	 * Returns the class ifno corresponding to the passed-in concrete class.
	 *
	 * <p>If the member class corresponding to the passed-in concrete class
	 * cannot be found directly in the represented package its sub-packages
	 * get searched through.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in argument is null or undefined.</li>
	 *   <li>There is no class matching the passed-in concrete class in this package.</li>
	 * </ul>
	 *
	 * @param concreteClass the concrete class a corresponding class info shall be returned
	 * @return the class info corresponding to the passed-in concrete class
	 */
	public function getMemberClassByClass(concreteClass:Function):ClassInfo {
		if (!concreteClass) return null;
		var classes:Array = getMemberClassesByFlag(true);
		if (classes) {
			for (var i:Number = 0; i < classes.length; i++) {
				var clazz:ClassInfo = classes[i];
				if (clazz.getType() == concreteClass) {
					return clazz;
				}
			}
		}
		var subPackages:Array = getMemberPackagesByFlag(true);
		if (subPackages) {
			for (var i:Number = 0; i < subPackages.length; i++) {
				var clazz:ClassInfo = PackageInfo(subPackages[i]).getMemberClassByClass(concreteClass);
				if (clazz) return clazz;
			}
		}
		return null;
	}
	
	/**
	 * @overload #getMemberPackageByName
	 * @overload #getMemberPackageByPackage
	 */
	public function getMemberPackage(package):PackageInfo {
		var o:Overload = new Overload(this);
		o.addHandler([String], getMemberPackageByName);
		o.addHandler([Object], getMemberPackageByPackage);
		return o.forward(arguments);
	}
	
	/**
	 * Returns the package info corresponding to the passed-in package name.
	 *
	 * <p>If the member package with the passed-in name cannot be found directly
	 * in the represented package its sub-packages get searched through.
	 * 
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in package name is null or undefined.</li>
	 *   <li>The {@link #getMemberPackages} method returns null.</li>
	 *   <li>There is no package with the given name.</li>
	 * </ul>
	 *
	 * @param packageName the name of the package
	 * @return the package info corresponding to the passed-in name
	 */
	public function getMemberPackageByName(packageName:String):PackageInfo {
		if (packageName == null) return null;
		if (getMemberPackagesByFlag(true)) {
			if (members["packages"][packageName]) return members["packages"][packageName];
			var subPackages:Array = members["packages"];
			for (var i:Number = 0; i < subPackages.length; i++) {
				var package:PackageInfo = PackageInfo(subPackages[i]).getMemberPackageByName(packageName);
				if (package) return package;
			}
		}
		return null;
	}
	
	/**
	 * Returns a PackageInfo corresponding to the passed concrete package.
	 *
	 * <p>If the member package corresponding to the passed-in concrete package
	 * cannot be found directly in the represented package its sub-packages
	 * get searched through.
	 * 
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in concrete package is null or undefined.</li>
	 *   <li>The {@link #getMemberPackages} method returns null.</li>
	 *   <li>A package matching the passed-in concrete package could not be found.</li>
	 * </ul>
	 *
	 * @param concretePackage the concrete package the corresponding package info shall be returned
	 * @return the package info corresponding to the passed-in concrete package
	 */
	public function getMemberPackageByPackage(concretePackage):PackageInfo {
		if (concretePackage == null) return null;
		var packages:Array = getMemberPackagesByFlag(true);
		if (packages) {
			for (var i:Number = 0; i < packages.length; i++) {
				var package:PackageInfo = packages[i];
				if (package.getPackage() == concretePackage) {
					return package;
				}
			}
			for (var i:Number = 0; i < packages.length; i++) {
				var package:PackageInfo = PackageInfo(packages[i]).getMemberPackageByPackage(concretePackage);
				if (package) return package;
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
	 *   <li>The passed-in package's isRoot method returns true.</li>
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