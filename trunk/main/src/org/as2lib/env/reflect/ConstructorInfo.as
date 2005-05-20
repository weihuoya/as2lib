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
 * {@code ConstructorInfo} represents the constrcutor of a class.
 *
 * <p>The name of a constructor is always {@code "new"}. This name can be obtained
 * through the constant {@link #NAME}.
 * 
 * <p>Constructors are also not static.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ConstructorInfo extends MethodInfo {
	
	/** The name of constructors. */
	public static var NAME:String = "new";
	
	/**
	 * Constructs a new {@code ConstructorInfo} instance.
	 *
	 * @param constructor the concrete constructor
	 * @param declaringClass the class that declares the {@code constructor}
	 */
	public function ConstructorInfo(constructor:Function, declaringClass:ClassInfo) {
		//super (NAME, constructor, declaringClass, false);
		// there seems to be a recursion problem somewhere (I could not track it down)
		this.__proto__.__proto__ = MethodInfo.prototype;
		this.name = NAME;
		this.method = constructor;
		this.declaringType = declaringClass;
		this.staticFlag = false;
	}
	
}