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
import org.as2lib.env.except.UnsupportedOperationException;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.TypeMemberInfo;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.PropertyJoinPoint extends AbstractJoinPoint implements JoinPoint {
	
	/** Stores the PropertyInfo instance that represents the represented property. */
	private var info:PropertyInfo;
	
	/** Stores the object returned by the #getThis() method. */
	private var thiz;
	
	/**
	 * Constructs a new PropertyJoinPoint.
	 *
	 * @param info the PropertyInfo instance that represents the represented property
	 * @param thiz a reference to the object the property is defined in
	 */
	public function PropertyJoinPoint(info:PropertyInfo, thiz) {
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
	 * @see org.as2lib.aop.JoinPoint#getInfo(Array)
	 */
	public function proceed(args:Array) {
		throw new UnsupportedOperationException("The execute operation is not supported by PropertyJoinPoint instances [" + this + "].", this, arguments);
	}
	
	/**
	 * @see org.as2lib.aop.JoinPoint#clone(Void):JoinPoint
	 */
	public function clone(Void):JoinPoint {
		var getter:Function;
		var setter:Function;
		if (info.isStatic()) {
			getter = info.getDeclaringType().getType()[info.getGetter().getName()];
			setter = info.getDeclaringType().getType()[info.getSetter().getName()];
		} else {
			getter = info.getDeclaringType().getType().prototype[info.getGetter().getName()];
			setter = info.getDeclaringType().getType().prototype[info.getSetter().getName()];
		}
		var newInfo:PropertyInfo = new PropertyInfo(info.getName(),
													info.getDeclaringType(),
													info.isStatic(),
													setter,
													getter);
		return (new PropertyJoinPoint(newInfo, getThis()));
	}
	
	/**
	 * @see org.as2lib.aop.JoinPoint#getType(Void):Number
	 */
	public function getType(Void):Number {
		return TYPE_PROPERTY;
	}
	
}