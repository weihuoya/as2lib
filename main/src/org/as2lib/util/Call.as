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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.Executable;
import org.as2lib.util.AccessPermission;

/**
 * Call is used to enable another object to make a function call in another
 * scope without having to know where. This enables you to pass a Call to another
 * object and let the object execute the call.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.util.Call extends BasicClass implements Executable {
	
	/** The object to execute the Function one. */
	private var object;
	
	/** The Function to be executed. */
	private var func:Function;
	
	/**
	 * Constructs a new Call instance.
	 *
	 * @param object the object the Function shall be executed on
	 * @param func the Function that shall be executed
	 * @throws IllegalArgumentException if neigther the object or the function is not available.
	 */
	public function Call(object, func:Function) {
		if(object == null) {
			throw new IllegalArgumentException("Required parameter 'object' is not available", this, arguments);
		}
		if(func == null) {
			throw new IllegalArgumentException("Required parameter 'func' is not available", this, arguments);
		}
		this.object = object;
		this.func = func;
	}
	
	/**
	 * Executes the passed method on the passed object with the given
	 * arguments and returns the result of the execution.
	 *
	 * @param args the arguments that shall be passed
	 * @return the result of the method execution
	 */
	public function execute(args:Array) {
		return func.apply(object, args);
	}
	
	/**
	 * Extended Stringifier for this class.
	 * 
	 * @return Call as string.
	 */
	public function toString(Void):String {
		// TODO: Refactor the code and outsource it.
		var result:String="";
		result += "[type " + ReflectUtil.getTypeNameForInstance(this) + " -> ";
		AccessPermission.set(object, null, AccessPermission.ALLOW_ALL);
		if (ObjectUtil.isEmpty(object)) {
			result += object.toString() + "." + ObjectUtil.getChildName(object, func);
		} else {
			var className:String = ReflectUtil.getTypeName(object);
			if (className) {
				result += className;
				result += "." + ReflectUtil.getMethodName(func, object);
			} else {
				result += object.toString() + "." + ObjectUtil.getChildName(object, func);
			}
		}
		result += "() ]";
		return result;
	}
	
	/**
	 * Iterates through the passed Object using the for..in loop and executes
	 * the Call by passing the object, the found child and its name.
	 * 
	 * Example:
	 * <CODE>
	 *   class MyClass {
	 * 
         *      private var a:String;
         *      private var b:String;
         *      private var c:String;
	 * 
	 *      public function MyClass() {
	 *          a = "1";
	 *          b = "2";
	 *          c = "2";
	 *      }
	 *      
	 *      public function traceObject(value, name:String, inObject):Void {
	 *          trace(name+": "+value);
	 *      }
	 * 
	 *      public function listAll() {
         *          new Call(this, traceObject).forEach(this);
	 *      }
	 *   }
	 * </CODE>
	 *
	 * Note: Only childs visible by a for-in loop will be displayed!
	 *  
	 * @param object the object to iterate over
	 * @param call the Call to be executed for each found object
	 */
	public function forEach(object):Void {
		var i:String;
		for (i in object) {
			execute([object[i], i, object]);
		}
	}
	
}