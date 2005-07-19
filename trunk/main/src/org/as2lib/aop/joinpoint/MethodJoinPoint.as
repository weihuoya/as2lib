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
 * {@code MethodJoinPoint} represents a method as join point.
 * 
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.MethodJoinPoint extends AbstractJoinPoint implements JoinPoint {
	
	/** The info of the represented method. */
	private var info:MethodInfo;
	
	/**
	 * Constructs a new {@code MethodJoinPoint} instance.
	 *
	 * @param info the info of the represented method
	 * @param thiz thiz the logical this of the interception
	 * @throws IllegalArgumentException of argument {@code thiz} is {@code null} or
	 * {@code undefined}
	 * @throws IllegalArgumentException if argument {@code info} is {@code null} or
	 * {@code undefined}
	 * @see <a href="http://www.simonwacker.com/blog/archives/000068.php">Passing Context</a>
	 */
	public function MethodJoinPoint(info:MethodInfo, thiz) {
		super(thiz);
		if (!info) throw new IllegalArgumentException("Argument 'info' must not be 'null' nor 'undefined'.", this, arguments);
		this.info = info;
	}
	
	/**
	 * Returns the info of the represented method. This is a {@link MethodInfo}
	 * instance.
	 * 
	 * @return the info of the represented method
	 */
	public function getInfo(Void):TypeMemberInfo {
		return info;
	}
	
	/**
	 * Proceeds this join point by executing the represented method passing the given
	 * arguments and returning the result of the execution.
	 * 
	 * @param args the arguments to use for the execution
	 * @return the result of the execution
	 */
	public function proceed(args:Array) {
		return proceedMethod(this.info, args);
	}
	
	/**
	 * Clones this join point.
	 * 
	 * <p>Note that the returned join point is not a full-clone of this join point. The
	 * concrete method of of the returned join point's info is updated to the latest
	 * state. This may thus differ if it has been overwritten before.
	 * 
	 * @return a clone of this join point
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
	 * Returns the type of this join point.
	 * 
	 * @return {@link AbstractJoinPoint#METHOD}
	 */
	public function getType(Void):Number {
		return METHOD;
	}
	
}