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

import org.as2lib.env.overload.OverloadHandler;
import org.as2lib.util.ObjectUtil;
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.SameTypeSignatureException;

/**
 * SimpleOverloadHandler is a default implementation of the OverloadHandler interface.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.overload.SimpleOverloadHandler extends BasicClass implements OverloadHandler {
	/** Contains the arguments types of the operation. */
	private var args:Array;
	
	/** The operation to be executed on the given target. */
	private var func:Function;
	
	/**
	 * Constructs a new SimpleOverloadHandler instance.
	 *
	 * @param args the arguments types of the operation
	 * @param func the actual operation to be executed on the target if the argumetns types match
	 */
	public function SimpleOverloadHandler(args:Array, func:Function) {
		this.args = args;
		this.func = func;
	}
	
	/**
	 * @see org.as2lib.env.overload.OverloadHandler#matches()
	 */
	public function matches(someArguments:Array):Boolean {
		var l:Number = someArguments.length;
		if (l != args.length) {
			return false;
		}
		for (var i:Number = 0; i < l; i++) {
			// Should ObjectUtil.typesMatch() return true for a check of null against any type?
			if (someArguments[i] !== null) {
				if (!ObjectUtil.typesMatch(someArguments[i], args[i])) {
					return false;
				}
			}
		}
		return true;
	}
	
	/**
	 * @see org.as2lib.env.overload.OverloadHandler#execute()
	 */
	public function execute(target, someArguments:Array) {
		return func.apply(target, someArguments);
	}
	
	/**
	 * @see org.as2lib.env.overload.OverloadHandler#isMoreExplicitThan()
	 */
	public function isMoreExplicitThan(handler:OverloadHandler):Boolean {
		var points:Number = 0;
		var args2:Array = handler.getArguments();
		for (var i:Number = args.length-1; i >= 0; i--) {
			if (args[i] != args2[i]) {
				if (ObjectUtil.isInstanceOf(args[i].prototype, args2[i])) {
					points-=-1;
				} else {
					points--;
				}
			}
		}
		if (points == 0) {
			throw new SameTypeSignatureException("The two OverloadHandler [" + this + "] and [" + handler + "] have the same type signature.",
										   this,
										   arguments);
		}
		return (points > 0);
	}
	
	/**
	 * @see org.as2lib.env.overload.OverloadHandler#getArguments()
	 */
	public function getArguments(Void):Array {
		return args;
	}
	
	/**
	 * Constructs a more detailed String output information for this class.
	 * 
	 * @returns Instance as string.
	 */
	public function toString(Void):String {
		// TODO: Extract to a Stringifier.
		var result:String = "[object SimpleOverloadHandler";
		var l:Number = args.length;
		if(l > 0) {
			result += " (";
		}
		for(var i:Number = 0; i < l; i++) {
			if(i != 0) {
				result += ", ";
			}
			result += args[i];
		}
		if(l > 0) {
			result += ") ";
		}
		return result + "]";
	}
}