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

import org.as2lib.env.reflect.CompositeMemberInfo;
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
 * @see org.as2lib.env.reflect.CompositeMemberInfo
 */
class org.as2lib.env.reflect.RootInfo extends PackageInfo implements CompositeMemberInfo {
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