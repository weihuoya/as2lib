﻿import org.as2lib.basic.BasicClass;
import org.as2lib.data.holder.HashMap;
import org.as2lib.basic.reflect.ClassInfo;
import org.as2lib.basic.reflect.PackageInfo;
import org.as2lib.basic.reflect.RootInfo;

class org.as2lib.basic.reflect.Cache extends BasicClass {
	private var classes:HashMap;
	private var packages:HashMap;
	private var root:RootInfo;
	
	public function Cache(Void) {
		classes = new HashMap();
		packages = new HashMap();
		root = new RootInfo("root", _global);
	}
	
	public function getClass(object:Object):ClassInfo {
		return ClassInfo(classes.get(object.__proto__));
	}
	
	public function addClass(info:ClassInfo):ClassInfo {
		classes.put(info.getClass().prototype, info);
		return info;
	}
	
	public function getPackage(object:Object):PackageInfo {
		return PackageInfo(packages.get(object));
	}
	
	public function addPackage(info:PackageInfo):PackageInfo {
		packages.put(info.getPackage(), info);
		return info;
	}
	
	public function getRoot(Void):RootInfo {
		return root;
	}
}