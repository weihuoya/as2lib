﻿import org.as2lib.basic.reflect.PackageInfo;
import org.as2lib.data.Hashtable;

interface org.as2lib.basic.reflect.ReflectInfo {
	public function getName(Void):String;
	public function getFullName(Void):String;
	public function getParent(Void):PackageInfo;
	public function getChildren(Void):Hashtable;
}