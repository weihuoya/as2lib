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
import org.as2lib.util.Stringifier;
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * StackTraceElementStringifier stringifies StackTraceElement instances.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.env.except.StackTraceElementStringifier extends BasicClass implements Stringifier {
	
	/** Show the real arguments. */
	private var showArgumentsValues:Boolean;
	
	/**
	 * Constructs a new StackTraceElementStringifier instance.
	 *
	 * <p>By default the types of the arguments are shown and not their
	 * value.
	 *
	 * @param showArgumentsValues determines whether to show a string representation
	 * of the arguments' values, that is the string that gets returned by their
	 * toString methods, (true) or only the types of the arguments (false).
	 */
	public function StackTraceElementStringifier(showArgumentsValues:Boolean) {
		this.showArgumentsValues = showArgumentsValues;
	}
	
	/**
	 * Returns the string representation of the passed-in StackTraceElement
	 * instance.
	 *
	 * <p>The string representation is composed as follows:
	 * <pre>static theFullQualifiedNameOfTheThrower.theMethodName(theFirstArgument, ..)</pre>
	 *
	 * <p>Depending on the settings arguments are either represented by their
	 * types of by the result of their toString methods.
	 *
	 * <p>A real string representation could look like this:
	 * <pre>org.as2lib.data.holder.MyDataHolder.setMaximumLength(Number)</pre>
	 * or this:
	 * <pre>org.as2lib.data.holder.MyDataHolder.setMaximumLength(-2)</pre>
	 *
	 * <p>If an element is null, undefined or its string representation could
	 * not been obtained the string '[unknown]' gets used.
	 *
	 * <p>If the method of the stack trace element is the constructor of the
	 * thrower the string 'new' gets used.
	 *
	 * @param target the StackTraceElement instance to stringify
	 * @return the string representation of the passed-in StackTraceElement
	 */
	public function execute(target):String {
		var element:StackTraceElement = target;
		var result:String = "";
		var thrower = element.getThrower();
		var method:Function = element.getMethod();
		
		var throwerName:String = ReflectUtil.getTypeName(thrower);
		if (throwerName == null) {
			throwerName = "[unknown]";
		}
		
		var methodName:String;
		if ((method == thrower || method == thrower.__constructor__) && thrower && method) {
			// source string 'new' out, to a constant
			methodName = "new";
		} else {
			methodName = ReflectUtil.getMethodName(method, thrower);
			if (methodName == null) {
				methodName = "[unknown]";
			}
		}
		result += ReflectUtil.isMethodStatic(methodName, thrower) ? "static " : "";
		
		result += throwerName;
		result += "." + methodName;
		result += "(";
		if (showArgumentsValues) {
			result += element.getArguments().toString() ? element.getArguments().toString() : "[unknown]";
		} else {
			var args:Array = element.getArguments();
			for (var i:Number = 0; i < args.length; i++) {
				var argType:String = ReflectUtil.getTypeName(args[i]);
				if (argType == null) argType = "[unknown]";
				result += argType;
				if (i < args.length-1) result += ", ";
			}
		}
		result += ")";
	
		return result;
	}
	
}