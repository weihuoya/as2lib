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

import org.as2lib.aop.joinpoint.PropertyJoinPoint;
import org.as2lib.env.reflect.PropertyInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.SetPropertyJoinPoint extends PropertyJoinPoint {
	
	/**
	 * @see org.as2lib.aop.joinpoint.PropertyJoinPoint#new(PropertyInfo, Object)
	 */
	public function SetPropertyJoinPoint(info:PropertyInfo, thiz) {
		super(info, thiz);
	}
	
	/**
	 * @see org.as2lib.aop.JoinPoint#proceed(Array)
	 */
	public function proceed(args:Array) {
		return proceedMethod(this.info.getSetter());
	}
	
	/**
	 * @see org.as2lib.aop.JoinPoint#getType(Void):Number
	 */
	public function getType(Void):Number {
		return SET_PROPERTY;
	}
	
}