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

import org.as2lib.core.BasicInterface;
import org.as2lib.env.reflect.ClassInfo;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.ClassMemberInfo extends BasicInterface {
	/**
	 * Returns the name of the class member.
	 *
	 * @return the class member's name
	 */
	public function getName(Void):String;
	
	/**
	 * Returns the declaring class of the class member.
	 *
	 * @return the class member's declaring class
	 */
	public function getDeclaringClass(Void):ClassInfo;
	
	/**
	 * Returns whether the class member is static or not.
	 *
	 * @return true when the property is static else false
	 */
	public function isStatic(Void):Boolean;
}