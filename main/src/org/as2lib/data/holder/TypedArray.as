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

import org.as2lib.util.ObjectUtil;
import org.as2lib.core.BasicInterface;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ClassInfo;

/**
 * Acts like a normal Array but assures that only objects from one and the same
 * type are added to the Array.
 * 
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.data.holder.TypedArray extends Array implements BasicInterface {
	/** The type of values that can be added. */
	private var type:Function;
	
	/**
	 * Constructs a new TypedArray instance.
	 *
	 * @param type the type of the values this TypedArray contains
	 * @param array the Array that shall be wrapped
	 */
	public function TypedArray(type:Function) {
		this.type = type;
	}
	
	/**
	 * @see Array#concat()
	 */
	public function concat():TypedArray {
		var result:TypedArray = new TypedArray(this.type);
		for (var i:Number = 0; i < length; i++) {
			result.push(this[i]);
		}
		// Performance Speed up - so the getter for the length isn't always used (useful with big arrays)
		var l:Number = arguments.length;
		for (var i:Number = 0; i < l; i++) {
			var content = arguments[i];
			if (ObjectUtil.isInstanceOf(content, Array)) {
				// Performance Speed up - so the getter for the length isn't always used (useful with big arrays)
				var l2:Number = content.length;
				for (var k:Number = 0; k < l2; k++) {
					result.push(content[k]);
				}
			} else {
				result.push(content);
			}
		}
		return result;
	}
	
	/**
	 * @see Array#push()
	 */
	public function push(value):Number {
		validate(value);
		return super.push(value);
	}
	
	/**
	 * @see Array#unshift()
	 */
	public function unshift(value):Number {
		validate(value);
		return super.unshift(value);
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#getClass()
	 */
	public function getClass(Void):ClassInfo {
		return ReflectUtil.getClassInfo(this);
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return super.toString();
	}

	/**
	 * Validates the passed object based on its type.
	 *
	 * @param object the object which type shall be validated
	 * @throws org.as2lib.env.except.IllegalArgumentException if the type of the object is not valid
	 */
	private function validate(object):Void {
		if (!ObjectUtil.typesMatch(object, type)) {
			throw new IllegalArgumentException("Type mismatch between [" + object + "] and [" + type + "].",
											   this,
											   arguments);
		}
	}
}