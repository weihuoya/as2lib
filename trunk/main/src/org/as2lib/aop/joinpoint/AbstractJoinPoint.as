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
import org.as2lib.aop.matcher.Matcher;

/**
 * AbstractJoinPoint offers default implementations of methods needed
 * by join points. It also declares the constants which values represent
 * a specific join point type.
 *
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.AbstractJoinPoint extends BasicClass {
	
	/** Number value that indicates that it the used join point a method join point. */
	public static var TYPE_METHOD:Number = 0;
	
	/** Number value that indicates that it the used join point a property join point. */
	public static var TYPE_PROPERTY:Number = 1;
	
	/** Number value that indicates that it the used join point a set-property join point. */
	public static var TYPE_SET_PROPERTY:Number = 2;
	
	/** Number value that indicates that it the used join point a get-property join point. */
	public static var TYPE_GET_PROPERTY:Number = 3;
	
	/**
	 * Abstract constructor that prevents initialization.
	 */
	private function AbstractJoinPoint(Void) {
	}
	
	/**
	 * @see org.as2lib.aop.JoinPoint#matches(String):Boolean
	 */
	public function matches(pattern:String):Boolean {
		return Matcher.match((this["getInfo"]().getDeclaringType().getFullName() + "." + this["getInfo"]().getName()), pattern);
	}
}