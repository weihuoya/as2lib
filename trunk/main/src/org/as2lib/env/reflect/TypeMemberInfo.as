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

import org.as2lib.env.reflect.TypeInfo;
import org.as2lib.env.reflect.MemberInfo;

/**
 * TypeMemberInfo represents a type member.
 *
 * <p>Type members are methods, implicit get/set methods (refered to as
 * properties by the reflection api) and variables (not supported).
 *
 * <p>Class or instance variables are not supported because they can
 * only be evaluated if the got initialized previously. Therefore results
 * could vary dramatically.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.TypeMemberInfo extends MemberInfo {
	
	/**
	 * Returns the declaring type of the type member.
	 *
	 * @return the type member's declaring type
	 */
	public function getDeclaringType(Void):TypeInfo;
	
	/**
	 * Returns whether the type member is static or not.
	 *
	 * <p>Static type members are members per type. Speaking of classes static
	 * type members are class variables or class methods.
	 *
	 * <p>Non-Static type members are members per instance. For example
	 * instance variables or instance methods.
	 *
	 * @return true when the type member is static else false
	 */
	public function isStatic(Void):Boolean;
	
}