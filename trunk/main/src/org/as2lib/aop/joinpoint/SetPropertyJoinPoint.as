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

import org.as2lib.aop.joinpoint.PropertyJoinPoint;
import org.as2lib.env.reflect.PropertyInfo;

/**
 * {@code SetPropertyJoinPoint} is a join point matching set access to a property. It
 * represents the setter method of a property.
 * 
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.SetPropertyJoinPoint extends PropertyJoinPoint {
	
	/**
	 * Constructs a new {@code SetPropertyJoinPoint) instance.
	 * 
	 * @param info the property info of the represented property
	 * @param thiz the logical this of the interception
	 * @throws IllegalArgumentException of argument {@code thiz} is {@code null} or
	 * {@code undefined}
	 * @throws IllegalArgumentException if argument {@code info} is {@code null} or
	 * {@code undefined}
	 * @see <a href="http://www.simonwacker.com/blog/archives/000068.php">Passing Context</a>
	 */
	public function SetPropertyJoinPoint(info:PropertyInfo, thiz) {
		super(info, thiz);
	}
	
	/**
	 * Proceeds this join point by executing the setter of the represented property
	 * with the given arguments and returning the result of the execution.
	 * 
	 * @param args the arguments to use for the execution
	 * @return the result of the execution
	 */
	public function proceed(args:Array) {
		return proceedMethod(this.info.getSetter());
	}
	
	/**
	 * Returns the type of this property.
	 * 
	 * @return {@link AbstractJoinPoint#SET_PROPERTY}
	 */
	public function getType(Void):Number {
		return SET_PROPERTY;
	}
	
}