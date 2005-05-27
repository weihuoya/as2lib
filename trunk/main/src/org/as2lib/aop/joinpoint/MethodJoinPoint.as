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

import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.aop.joinpoint.AbstractJoinPoint;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.TypeMemberInfo;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.MethodJoinPoint extends AbstractJoinPoint implements JoinPoint {
	
	/** Stores the MethodInfo instance that represents the represented method. */
	private var info:MethodInfo;
	
	/** Stores the object returned by the #getThis() method. */
	private var thiz;
	
	/**
	 * Constructs a new MethodJoinPoint.
	 *
	 * @param info the MethodInfo instance that represents the represented method
	 * @param thiz a reference to the object the method is defined in
	 */
	public function MethodJoinPoint(info:MethodInfo, thiz) {
		if (!info || !thiz) throw new IllegalArgumentException("Both arguments, info and thiz, are not allowed to be null or undefined.", this, arguments);
		this.info = info;
		this.thiz = thiz;
	}
	
	/**
	 * @see org.as2lib.aop.JoinPoint#getInfo(Void):TypeMemberInfo
	 */
	public function getInfo(Void):TypeMemberInfo {
		return info;
	}
	
	/**
	 * @see org.as2lib.aop.JoinPoint#getThis(Void)
	 */
	public function getThis(Void) {
		return thiz;
	}
	
	/**
	 * @see org.as2lib.aop.JoinPoint#proceed(Array)
	 */
	public function proceed(args:Array) {
		return MethodInfo(getInfo()).getMethod().apply(getThis(), args);
	}
	
	/**
	 * @see org.as2lib.aop.JoinPoint#clone(Void):JoinPoint
	 */
	public function clone(Void):JoinPoint {
		var method:Function;
		if (info.isStatic()) {
			method = info.getDeclaringType().getType()[info.getName()];
		} else {
			method = info.getDeclaringType().getType().prototype[info.getName()];
		}
		var newInfo:MethodInfo = new MethodInfo(info.getName(),
												info.getDeclaringType(),
												info.isStatic(),
												method);
		return (new MethodJoinPoint(newInfo, getThis()));
	}
	
	/**
	 * @see org.as2lib.aop.JoinPoint#getType(Void):Number
	 */
	public function getType(Void):Number {
		return TYPE_METHOD;
	}
	
}