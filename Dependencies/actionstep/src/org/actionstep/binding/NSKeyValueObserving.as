/* See LICENSE for copyright and terms of use */

import org.actionstep.ASUtils;
import org.actionstep.binding.NSKeyValueCoding;
import org.actionstep.NSException;
import org.actionstep.NSObject;
import org.actionstep.NSDictionary;
import org.actionstep.constants.NSKeyValueChange;
import org.actionstep.ASDebugger;

/**
 * <p>This class is used to register observations on objects.</p>
 * 
 * <p>All classes registering as observers must implement the
 * {@link org.actionstep.binding.ASKeyValueObserver} interface.</p>
 * 
 * @see org.actionstep.binding.ASKeyValueObserver#observeValueForKeyPathOfObjectChangeContext()
 * @see #addObserverWithObjectForKeyPathOptionsContext()
 * @see #removeObserverWithObjectForKeyPath()
 * 
 * @author Scott Hyndman
 */
class org.actionstep.binding.NSKeyValueObserving extends NSObject {

	//******************************************************
	//*                    Constants
	//******************************************************

	/**
	 * Indicates that the change dictionary should provide the new attribute
	 * value, if applicable.
	 */
	public static var NSKeyValueObservingOptionNew:Number = 0x01;

	/**
	 * Indicates that the change dictionary should provide the old attribute
	 * value, if applicable.
	 */
	public static var NSKeyValueObservingOptionOld:Number = 0x02;

	//******************************************************
	//*                   Construction
	//******************************************************

	/**
	 * This is a static class.
	 */
	private function NSKeyValueObserving() {
	}

	//******************************************************
	//*            Registering for observation
	//******************************************************

	/**
	 * <p>Registers <code>anObserver</code> to receive key value observer
	 * notifications for the specified <code>keyPath</code> relative to
	 * <code>anObject</code>.</p>
	 *
	 * <p>An exception is raised if <code>anObserver</code> is <code>null</code> or
	 * does not implement
	 * observeValueForKeyPathOfObjectChangeContext(String,Object,NSDictionary,Object)
	 * or <code>keyPath</code> is <code>null</code>.</p>
	 */
	public static function addObserverWithObjectForKeyPathOptionsContext(
			anObserver:Object, anObject:Object, keyPath:String, options:Number,
			context:Object):Void {

		//
		// Null checks
		//
		if (keyPath == null || anObserver == null) {
			var e:NSException = NSException.exceptionWithNameReasonUserInfo(
				NSException.NSInvalidArgument,
				"keyPath and anObserver must be non-null.",
				null);
			trace(e);
			throw e;
		}

		//
		// Check for implementation
		//
		if (!ASUtils.respondsToSelector(anObserver,
				"observeValueForKeyPathOfObjectChangeContext")) {
			var e:NSException = NSException.exceptionWithNameReasonUserInfo(
				NSException.NSInvalidArgument,
				"anObserver must implement observeValueForKeyPathOfObjectChangeContext.",
				null);
			trace(e);
			throw e;
		}

		//
		// Get the object, getter and setter.
		//
		var parts:Array = keyPath.split(".");
		var last:String = parts[parts.length - 1];
		parts = parts.slice(0, -1);
		var actingObjKeyPath:String = parts.join(".");
		
		var actingObj:Object = NSKeyValueCoding.valueWithObjectForKeyPath(
			anObject, actingObjKeyPath);
		var objAndSetter:Object = NSKeyValueCoding.setterAndObjectWithObjectForKeyPath(
			actingObj, last);

		//
		// Create the observer object
		//
		var observeObj:Object = {
			observer: anObserver,
			object: anObject,
			keyPath: keyPath,
			context: context,
			options: options
		};

		var self:Object = NSKeyValueObserving;
		var createChangeDict:Function = createChangeDictionaryWithObjectForKeyPath;

		if (typeof(objAndSetter.setter) == "function") {
			if (objAndSetter.setter.__isWrapped) {
				objAndSetter.setter.__kvObservers.push(observeObj);
			} else {						
				//
				// Wrap the function
				//
				var setter:Function = objAndSetter.setter;
				objAndSetter.object[objAndSetter.setterName] = function(
						value:Object):Void {
							
					var obj:Object = arguments.callee.__object;
					
					//
					// Get old value
					//
					var getr:Function = arguments.callee.__getter;
					
					var oldVal:Object;
					switch (getr.type) {
						case 1:
							oldVal = getr.value.call(obj);
							break;
							
						case 2:
							oldVal = obj[getr.value];
							break;
					}
					
					//
					// Set value
					//
					var setr:Function = arguments.callee.__setter;
					setr.call(obj, value);
					
					//
					// Get new value
					//
					switch (getr.type) {
						case 1:
							value = getr.value.call(obj);
							break;
							
						case 2:
							value = obj[getr.value];
							break;
					}

					//
					// If value hasn't changed, don't notify
					//
					if (oldVal == value) {
						return;
					}
					
					//
					// Notify observers
					//
					var observers:Array = arguments.callee.__kvObservers;
					var len:Number = observers.length;

					for (var i:Number = 0; i < len; i++) {
						var ob:Object = observers[i];
						var change:NSDictionary = NSDictionary(
							createChangeDict.call(self, anObject, keyPath, oldVal, value, ob.options));
						ob.observer.observeValueForKeyPathOfObjectChangeContext(
							ob.keyPath, ob.object, change, ob.context);
					}
				};

				//
				// Get the "getter" function
				//
				var getter:Object = NSKeyValueCoding.getterWithObjectForKey(actingObj,
					last);
				
				//
				// Decorate the setter
				//
				objAndSetter.object[objAndSetter.setterName].__isWrapped = true;
				objAndSetter.object[objAndSetter.setterName].__object = actingObj;
				objAndSetter.object[objAndSetter.setterName].__setter = setter;
				objAndSetter.object[objAndSetter.setterName].__getter = getter;
				objAndSetter.object[objAndSetter.setterName].__kvObservers
					= new Array(observeObj);
			}
		} else {
			var objToWatch:Object = objAndSetter.object;

			if (objToWatch["__hasWrapped_" + objAndSetter.setter] != null) {
				//
				// Add the observer
				//
				objToWatch["__kvObservers_" + objAndSetter.setter].push(observeObj);
			} else {
				//
				// Build the observer array
				//
				var observers:Array
					= objToWatch["__kvObservers_" + objAndSetter.setter]
					= new Array(observeObj);
				_global.ASSetPropFlags(objToWatch,
					["__kvObservers_" + objAndSetter.setter], 1);

				//
				// Create a watch function
				//
				var watchFunction:Function = function(prop:String, 
						oldVal:Object, newVal:Object):Object {					
					//
					// Notify observers
					//
					var len:Number = observers.length;

					for (var i:Number = 0; i < len; i++) {
						var ob:Object = observers[i];
						var change:NSDictionary = NSDictionary(
							createChangeDict.call(self, anObject, keyPath, oldVal, newVal, ob.options));
						ob.observer.observeValueForKeyPathOfObjectChangeContext(
							ob.keyPath, ob.object, change, ob.context);
					}

					return newVal;
				};
					
				//
				// Decorate the object
				//
				objToWatch.watch(objAndSetter.setter, watchFunction, null);
				objToWatch["__hasWrapped_" + objAndSetter.setter] = true;
				_global.ASSetPropFlags(objToWatch,
					["__hasWrapped_" + objAndSetter.setter], 1);
			}
		}
	}

	/**
	 * Removes <code>anObserver</code> from all key value observer notifications
	 * associated with the specified <code>keyPath</code> relative to
	 * <code>anObject</code>.
	 */
	public static function removeObserverWithObjectForKeyPath(anObserver:Object,
			anObject:Object, keyPath:String):Void {
		//
		// Get object and setter.
		//
		var objAndSetter:Object = NSKeyValueCoding.setterAndObjectWithObjectForKeyPath(
			anObject, keyPath);

		if (typeof(objAndSetter.setter) == "function") {
			//
			// No observers to remove
			//
			if (objAndSetter.object[objAndSetter.setterName].__isWrapped == null) {
				return;
			}

			//
			// Remove the observer
			//
			var observers:Array = objAndSetter.object[objAndSetter.setterName].__kvObservers;
			var len:Number = observers.length;

			for (var i:Number = 0; i < len; i++) {
				if (observers[i].observer == anObserver) {
					observers.splice(i, 1);
					i--;
					len--;
				}
			}

			if (observers.length != 0) { // No more work to do.
				return;
			}

			//
			// Remove all observation stuff if we have no more observers
			//
			objAndSetter.object[objAndSetter.setterName].__isWrapped = false;
			objAndSetter.object[objAndSetter.setterName].__object = null;
			objAndSetter.object[objAndSetter.setterName] = objAndSetter.setter.__setter;

			objAndSetter.setter.__setter = null;
			delete objAndSetter.setter.__setter;
			objAndSetter.setter.__getter = null;
			delete objAndSetter.setter.__getter;
			objAndSetter.setter.__kvObservers = null;
			delete objAndSetter.setter.__kvObservers;

		} else {
			var objToWatch:Object = objAndSetter.object;

			//
			// No observers to remove
			//
			if (objToWatch["__hasWrapped_" + objAndSetter.setter] == null) {
				return;
			}

			//
			// Remove observer
			//
			var observers:Array
					= objToWatch["__kvObservers_" + objAndSetter.setter];
			var len:Number = observers.length;

			for (var i:Number = 0; i < len; i++) {
				if (observers[i].observer == anObserver) {
					observers.splice(i, 1);
					i--;
					len--;
				}
			}

			if (observers.length != 0) { // No more work to do.
				return;
			}

			//
			// Remove all observation stuff if we have no more observers
			//
			objToWatch["__hasWrapped_" + objAndSetter.setter] = null;
			delete objToWatch["__hasWrapped_" + objAndSetter.setter];
			objToWatch["__kvObservers_" + objAndSetter.setter] = null;
			delete objToWatch["__kvObservers_" + objAndSetter.setter];
			objToWatch.unwatch(objAndSetter.setter);
		}
	}

	/**
	 * AS-Specific helper function.
	 */
	private static function createChangeDictionaryWithObjectForKeyPath(
			anObject:Object, keyPath:String, oldVal:Object, value:Object, 
			options:Number):NSDictionary {
				
		var dict:NSDictionary = NSDictionary.dictionary();

		dict.setObjectForKey(NSKeyValueChange.NSSetting, "NSKeyValueChangeKindKey");

		//! do more stuff
		switch (dict.objectForKey("NSKeyValueChangeKindKey")) {
			case NSKeyValueChange.NSSetting:
				//
				// Conditionally include values based on options
				//
				if (options & NSKeyValueObservingOptionNew 
						== NSKeyValueObservingOptionNew) {
					dict.setObjectForKey(value, "NSKeyValueChangeNewKey");
				}
				if (options & NSKeyValueObservingOptionOld
						== NSKeyValueObservingOptionOld) {
					dict.setObjectForKey(oldVal, "NSKeyValueChangeOldKey");
				}
			break;

		default:
			trace(ASDebugger.warning(
				"unknown value: "+dict.objectForKey("NSKeyValueChangeKindKey")));
		}

		return dict;
	}
}