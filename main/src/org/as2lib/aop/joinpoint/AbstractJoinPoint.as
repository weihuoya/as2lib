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
import org.as2lib.aop.Matcher;
import org.as2lib.aop.AopConfig;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * AbstractJoinPoint offers default implementations of methods needed
 * by join points. It also declares the constants which values represent
 * a specific join point type.
 *
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.AbstractJoinPoint extends BasicClass {
	
	/**
	 * The invoker method used to invoke the original method of a join point. This
	 * invoker is invoked on different scopes, never on this scope.
	 * 
	 * <p>This invoker removes itself, before executing the method, from the object it
	 * was assigned to. It expects itself to have the name {@code "__as2lib__invoker"}.
	 * 
	 * @param object the object that holds this invoker method
	 * @param method the method to invoke on the {@code super} object
	 * @param args the arguments to use for the invocation
	 * @return the result of the invocation of {@code method} with {@code args} on the
	 * {@code super} scope
	 */
	private static var INVOKER:Function = function(object, method:Function, args:Array) {
		// removes reference to this function
		object.__as2lib__invoker = null;
		// deletes the variable '__as2lib__invoker'
		delete object.__as2lib__invoker;
		// 'super' is not accessible from this scope, at least that's the compiler error
		return method.apply(eval("su" + "per"), args);
	};
	
	/** Number value that indicates that it the used join point a method join point. */
	public static var TYPE_METHOD:Number = 0;
	
	/** Number value that indicates that it the used join point a property join point. */
	public static var TYPE_PROPERTY:Number = 1;
	
	/** Number value that indicates that it the used join point a set-property join point. */
	public static var TYPE_SET_PROPERTY:Number = 2;
	
	/** Number value that indicates that it the used join point a get-property join point. */
	public static var TYPE_GET_PROPERTY:Number = 3;
	
	private var matcher:Matcher;
	
	private var thiz;
	
	/**
	 * Abstract constructor that prevents initialization.
	 */
	private function AbstractJoinPoint(thiz) {
		if (!thiz) throw new IllegalArgumentException("Argument 'thiz' must not be 'null' nor 'undefined'.", this, arguments);
		this.thiz = thiz;
	}
	
	/**
	 * @see org.as2lib.aop.JoinPoint#getThis(Void)
	 */
	public function getThis(Void) {
		return this.thiz;
	}
	
	public function setMatcher(matcher:Matcher):Void {
		this.matcher = matcher;
	}
	
	public function getMatcher(Void):Matcher {
		if (!matcher) matcher = AopConfig.getMatcher();
		return matcher;
	}
	
	public function proceedMethod(method:MethodInfo, args:Array) {
		var p:Object = method.getDeclaringType().getType().prototype;
		var t:Object = this.thiz;
		var m:Function = method.getMethod();
		if (t.__proto__ == p) {
			return m.apply(t, args);
		}
		while (t.__proto__ != p) {
			t = t.__proto__;
		}
		t.__as2lib__invoker = INVOKER;
		return this.thiz.__as2lib__invoker(t, m, args);
	}
	
	/**
	 * @see org.as2lib.aop.JoinPoint#matches(String):Boolean
	 */
	public function matches(pattern:String):Boolean {
		return getMatcher().match((this["getInfo"]().getDeclaringType().getFullName() + "." + this["getInfo"]().getName()), pattern);
	}
	
}