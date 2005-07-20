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

import org.as2lib.core.BasicClass;
import org.as2lib.aop.Matcher;
import org.as2lib.aop.AopConfig;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * {@code AbstractJoinPoint} provides implementations of methods commonly needed by
 * {@link JoinPoint} implementation classes. It also declares the constants that
 * represent specific join point types.
 *
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.AbstractJoinPoint extends BasicClass {
	
	/** Indicates a join point of type method. */
	public static var METHOD:Number = 0;
	
	/** Indicates a join point of type property. */
	public static var PROPERTY:Number = 1;
	
	/** Indicates a join point of type set-property. */
	public static var SET_PROPERTY:Number = 2;
	
	/** Indicates a join point of type get-property. */
	public static var GET_PROPERTY:Number = 3;
	
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
	
	/** The matcher used by this join point to evaluate the {@code captures} method. */
	private var matcher:Matcher;
	
	/** The logical this of the interception. */
	private var thiz;
	
	/**
	 * Constructs a new {@code AbstractJoinPoint) instance.
	 * 
	 * @param thiz the logical this of the interception
	 * @throws IllegalArgumentException of argument {@code thiz} is {@code null} or
	 * {@code undefined}
	 * @see #getThis
	 * @see <a href="http://www.simonwacker.com/blog/archives/000068.php">Passing Context</a>
	 */
	private function AbstractJoinPoint(thiz) {
		if (!thiz) throw new IllegalArgumentException("Argument 'thiz' must not be 'null' nor 'undefined'.", this, arguments);
		this.thiz = thiz;
	}
	
	/**
	 * Returns the logical this of the interception. This means if this join point is
	 * part of a call-pointcut the result will refer to the object where the call was
	 * made from. If this join point is part of an execution-, set- or get-pointcut the
	 * result will refer to the object that represented method or property resides in.
	 * 
	 * @return the logical this of this join point depending on the used pointcut
	 * @see <a href="http://www.simonwacker.com/blog/archives/000068.php">Passing Context</a>
	 */
	public function getThis(Void) {
		return this.thiz;
	}
	
	/**
	 * Sets the new matcher that is used by the {@link #captures} method to evaluate
	 * this join point against a given pattern.
	 * 
	 * @param matcher the new matcher to set
	 */
	public function setMatcher(matcher:Matcher):Void {
		this.matcher = matcher;
	}
	
	/**
	 * Returns the matcher that is used by the {@link #captures} method to evaluate
	 * this join point against a given pattern.
	 * 
	 * <p>If no matcher has been set manually the one returned by the
	 * {@link AopConfig#getMatcher} method will be used.
	 * 
	 * @return the pattern matcher
	 */
	public function getMatcher(Void):Matcher {
		if (!this.matcher) this.matcher = AopConfig.getMatcher();
		return this.matcher;
	}
	
	/**
	 * Proceeds the given {@code method} with the passed-in arguments {@code args}.
	 * 
	 * <p>Proceeding means that the method is executed on the logical this scope of
	 * this join point with the given arguments.
	 * 
	 * @param method the method to proceed
	 * @param args the arguments to use for the procession
	 * @return the result of the procession
	 */
	private function proceedMethod(method:MethodInfo, args:Array) {
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
	 * Checks if this join point matches the given {@code pattern}. Depending on the
	 * used matcher the pattern may contain wildcards like {@code "*"} and {@code ".."}.
	 * A pattern could for example be {@code "org..BasicClass.*"}.
	 * 
	 * @param pattern the pattern to match against this join point
	 * @return {@code true} if the given {@code pattern} matches this join point else
	 * {@code false}
	 * @see WildcardMatcher
	 * @see <a href="http://www.simonwacker.com/blog/archives/000053">Wildcards</a>
	 */
	public function matches(pattern:String):Boolean {
		return getMatcher().match((this["getInfo"]().getDeclaringType().getFullName() + "." + this["getInfo"]().getName()), pattern);
	}
	
}