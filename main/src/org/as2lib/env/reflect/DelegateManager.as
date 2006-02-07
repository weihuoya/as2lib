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
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.reflect.Delegate;

/**
 * {@code DelegateManager} provides proxy methods for {@link Delegate#createByMethod}
 * and {@link Delegate#createByName} that cache created delegates.
 * 
 * Each {@code Delegate#create} call returns a new instance of the delegate for the 
 * passed-in method and scope. It causes inconvenience using delegates as event listeners
 * with the MX-like event dispatching model. It requires to create special class members
 * to store references to the created delegates to remove event listeners later.
 * 
 * Delegate methods obtained through {@code DelegateManager} class are cached. So
 * every {@code DelegateManager#create} call for the same scope and method will return
 * the same delegate.
 * 
 * <p>Example:
 * <code>
 *   import mx.controls.Button;
 *   import org.as2lib.env.reflect.DelegateManager;
 *   
 *   class com.domain.MyClass {
 *   	private var myButton:Button; 
 *   
 *   	public function MyClass(Void) {
 *	 		myButton = Button(_root.attachMovie("Button", "myButton", 0));
 *	 		myButton.addEventListener("click", DelegateManager.create(this, onButtonClick));
 *	 	}
 *	   
 *   	private function onButtonClick():Void {
 *   		trace("Click!");
 *   		myButton.removeEventListener("click", DelegateManager.create(this, onButtonClick));
 *   	}
 *   }
 *  
 * </code>
 * 
 * @author Igor Sadovskiy
 * @version 1.0
 * @see org.as2lib.env.reflect.Delegate
 */
class org.as2lib.env.reflect.DelegateManager extends BasicClass {
	
	/** Scope cache for delegate created by method. */
	private static var methodCache:Map;
	
	/** Scopes cache for delegates created by name. */
	private static var nameCache:Map;
	
	/**
	 * @overload #createByMethod
	 * @overload #createByName
	 */
	public static function create():Function {
		var o:Overload = new Overload(eval("th" + "is"));
		o.addHandler([Object, Function], createByMethod);
		o.addHandler([Object, String], createByName);
		return o.forward(arguments);
	}
	
	/**
	 * Looks if a delegate method for the given {@code scope} and {@code method} has
	 * already been created by the {@code createByMethod} method and returns it if found.
	 * Otherwise a new delegate is created and put into the cache so that it can be
	 * reused in the future.
	 * 
	 * @param scope the scope to invoke the given {@code method} on
	 * @param method the method to invoke on the given {@code scope}
	 * @return the method that delegates invocations to the given {@code method} on the
	 * given {@code scope}
	 * @see Delegate#createByMethod
	 */
	public static function createByMethod(scope, method:Function):Function {
		// checks if cache is initialized
		if (methodCache == null) methodCache = new HashMap();
		return getDelegateFromCache(methodCache, scope, method);
	}
	
	/**
	 * Looks if a delegate method for the given {@code scope} and {@code methodName} has
	 * already been created by the {@code #createByName} method and returns it if found.
	 * Otherwise a new delegate is created and put into the cache so that it can be reused
	 * in the future. 
	 * 
	 * @param scope the scope to invoke the method on
	 * @param methodName the name of the method to invoke
	 * @return a delegate that invokes the method with the given {@code methodName} on
	 * the given {@code scope}
	 * @see Delegate#createByName
	 */
	public static function createByName(scope, methodName:String):Function {
		// checks if cache is initialized
		if (nameCache == null) nameCache = new HashMap();
		return getDelegateFromCache(nameCache, scope, methodName);
	}

	/**
	 * Searches in the specified cache for a delegate and creates a new one if not
	 * found.
	 * 
	 * @param cache the cache to search in
	 * @param scope the scope of the delegate to search for
	 * @param method the method, either a concrete method or a method name, of the
	 * delegate to search for
	 * @return the found or created delegate
	 */
	private static function getDelegateFromCache(cache:Map, scope, method):Function {
		var result:Function;		
		var delegates:Map;
		// checks for scope in cache
		if (cache.get(scope) != null) {
			delegates = cache.get(scope); 
			// checks for cached delegate
			if (delegates.get(method) != null) {
				result = delegates.get(method); 	
			}
			else {
				result = Delegate.create(scope, method);
				delegates.put(method, result);
			}
		}
		else {
			// create delegate
			result = Delegate.create(scope, method);
			// create delegate's cache
			delegates = new HashMap();
			delegates.put(method, result);
			cache.put(scope, delegates);
		}
		return result;
	}
	
	/**
	 * Constructs a new {@code DelegateManager} instance.
	 */
	private function DelegateManager(Void) {
	}
	
}