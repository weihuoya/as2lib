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

import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;

/**
 * ConstructorInfo represents the constrcutor of a class.
 *
 * <p>The name of a constructor is always 'new', see #NAME.
 *
 * <p>Constructors are also not static.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ConstructorInfo extends MethodInfo {
	
	/** The name of all constructors. */
	public static var NAME:String = "new";
	
	/**
	 * Constructs a new ConstructorInfo instance.
	 *
	 * @param constructor the actual constructor
	 * @param declaringClass the class that declares the constructor
	 */
	public function ConstructorInfo(constructor:Function, declaringClass:ClassInfo) {
		super (NAME, constructor, declaringClass, false);
	}
	
}