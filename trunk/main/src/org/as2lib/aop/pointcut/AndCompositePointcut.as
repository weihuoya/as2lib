﻿/*
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

import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.stack.SimpleStack;
import org.as2lib.data.holder.Iterator;
import org.as2lib.aop.pointcut.CompositePointcut;
import org.as2lib.aop.pointcut.AbstractCompositePointcut;
import org.as2lib.aop.pointcut.PointcutConfig;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.AndCompositePointcut extends AbstractCompositePointcut implements CompositePointcut {
	
	/**
	 * Constructs a new AndCompositePointcut.
	 *
	 * @param pointcutString the string representing the and-composite pointcut
	 */
	public function AndCompositePointcut(pointcutString:String) {
		var pointcuts:Array = pointcutString.split(" && ");
		for (var i:Number = 0; i < pointcuts.length; i++) {
			addPointcut(PointcutConfig.getPointcutFactory().getPointcut(pointcuts[i]));
		}
	}
	
	/**
	 * @see org.as2lib.aop.Pointcut#captures(JoinPoint):Boolean
	 */
	public function captures(joinPoint:JoinPoint):Boolean {
		var iterator:Iterator = pointcutStack.iterator();
		while (iterator.hasNext()) {
			var pointcut:Pointcut = Pointcut(iterator.next());
			if (!pointcut.captures(joinPoint)) {
				return false;
			}
		}
		return true;
	}
	
}