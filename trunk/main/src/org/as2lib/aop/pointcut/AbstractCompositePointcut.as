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
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.stack.SimpleStack;
import org.as2lib.aop.Pointcut;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.AbstractCompositePointcut extends BasicClass {
	
	/** Stores all added pointcuts. */
	private var pointcutStack:Stack;
	
	/**
	 * Private constructor that constructs a new AbstractCompositePointcut.
	 */
	private function AbstractCompositePointcut(Void) {
		pointcutStack = new SimpleStack();
	}
	
	/**
	 * Adds a new pointcut to the list of pointcuts.
	 *
	 * <p>Does not add the pointcut if it is null or undefined.
	 *
	 * @param pointcut the pointcut to be added
	 */
	public function addPointcut(pointcut:Pointcut):Void {
		if (pointcut) pointcutStack.push(pointcut);
	}
	
}