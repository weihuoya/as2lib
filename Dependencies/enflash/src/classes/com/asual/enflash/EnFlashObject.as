import com.asual.enflash.utils.Arrays;

/**
 * EnFlashObject is the base class of the EnFlash Framework. It provides object identification, 
 * hierarchical referencing, event handling and XML serialization/deserialization.
 */
class com.asual.enflash.EnFlashObject {

	private static var _enflash:Object;

	private var _ref:Number;
	private var _parent:Number;
	private var _listeners:Object;
	private var _id:String;
	private var _name:String = "EnFlashObject";

    /**
     * Event that notifies when this object is initialized.
     */
	public var oninit:Function;

    /**
     * Event that notifies when this object is removed.
     */
	public var onremove:Function;

	/**
	 * @param id (optional) Descriptive ID of this object.
	 */		
	public function EnFlashObject(id:String) {

		_listeners = new Object();

		if (_enflash == undefined) {
			_enflash = this;
		}

		_ref = _enflash.register(this);
		_id = (id != undefined) ? id : toString() + _ref;
	}

	/**
	 * Basic method that returns the type of this object.
	 * 
	 * @return The type of this object
	 */
	public function toString():String {
		return _name;
	}

	/**
	 * Initializes this object and makes it part of the EnFlash hierarchy.
	 * 
	 * @param parent Parent's reference
	 */
	public function init(parent:Number):Void {
		_init(parent);
	}

	/**
	 * The ID of this object
	 */
	public function get id():String {
		return _id;
	}
	
	/**
	 * The parent of this object
	 */
	public function get parent():Object {
		return _enflash.getByRef(_parent);
	}

	/**
	 * The reference number of this object that is used in the EnFlash hierarchy.
	 */	
	public function get ref():Number {
		return _ref;
	}	

	/**
	 * Generates an XML structure that contains all the information available for this object.
	 * 
	 * @return XML representation of this object
	 */
	public function getXML():XMLNode {
		return _getXML();
	}

	/**
	 * Loads an XML structure that contains public properties, event listeners and inline objects.
	 * 
	 * @param xml XML represantation of this object
	 */	
	public function setXML(xml:XMLNode):Void {
		_setXML(xml);
	}

	/**
	 * Adds event specific listeners to this object.<br />
	 * Example: <code>addEventListener("init", myObject, myObject.methodName, {neededObject: someObject});</code>
	 * 
 	 * @param type Event type
 	 * @param object The object that will listen for the event
 	 * @param method The method that will be invoked when the event is dispached
 	 * @param args (optional) Additional object with custom properties that will be received by the listener
	 */
	public function addEventListener(type:String, object:Object, method:Function, args:Object):Void {

		if (_listeners[type] == undefined){
			_listeners[type] = new Array();
		}

		_listeners[type].push({o: object, m: method, a:args});
	}

	/**
	 * Removes event specific listeners from this object.<br />
	 * Example: <code>removeEventListener("init", myObject);</code>
	 * 
 	 * @param type Event type
 	 * @param object The object that will be removed from the listeners collection
 	 * @param method (optional)	Method reference that specifies exactly which couple of object/method 
 	 * has to be removed. This can be used when an object listens for specific event with multiple methods
	 */
	public function removeEventListener(type:String, object:Object, method:Function):Void {

		if (_listeners[type] != undefined) {

			var i:Number = _listeners[type].length;

			if (method != undefined) {
				while(i--) {
					if (_listeners[type][i].o == object && _listeners[type][i].m == method) {
						_listeners[type][i] = null;
					}
				}
			} else {
				while(i--) {
					if (_listeners[type][i].o == object) {
						_listeners[type][i] = null;
					}
				}
			}

			if (_listeners[type].length == 0) {
				delete _listeners[type];
			}
		}
	}
	
	/**
	 * Dispatches event to all available listeners.<br />
	 * Example: <code>dispatchEvent("init", object1, object2.someProperty,...objectN);</code>
	 * 
	 * @param type Event type
	 * @param params (optional) Additional event specific parameters
	 */
	public function dispatchEvent(type:String, params:Object):Void {

		arguments.shift();
		var event = _createEvent(this, type, arguments);

		if(this["on" + type] != undefined) {
			this["on" + type](event);	
		}

		if (_listeners[type] != undefined) {
			var item;
			var i:Number = -1;
			var iMax:Number = _listeners[type].length;
			while(++i != iMax){
				item = _listeners[type][i];
				if (item != null) {
					_dispatchOneEvent(event, type, item);
				}
			}
		}
	}

	/**
	 * Dispatches event to a single listener.<br />
	 * Example: 
	 * <code>dispatchEventOnce(listenerObject, "init", object1, object2.someProperty,...objectN);</code>
	 * 
	 * @param object Known listener object
	 * @param type Event type
	 * @param params (optional) Additional event event specific parameters
	 */
	public function dispatchEventOnce(object:Object, type:String, params:Object):Void {

		arguments.shift();
		arguments.shift();

		var event = _createEvent(this, type, arguments);

		if (_listeners[type] != undefined) {
			var item;
			var i:Number = -1;
			var iMax:Number = _listeners[type].length;
			while(++i != iMax){
				item = _listeners[type][i];
				if (item != null && item.o == object) {
					_dispatchOneEvent(event, type, item);
					break;
				}
			}
		}
	}
	
	/**
	 * Provides a list of event specific listeners.
 	 * 
 	 * @param type Event type
 	 * @return Array of objects with 3 properties: object, method and arguments
	 */
	public function getListeners(type:String):Array {

		var listeners = new Array();

		if (_listeners[type] != undefined) {
			var item;
			var i:Number = -1;
			var iMax:Number = _listeners[type].length;
			while(++i != iMax) {
				item = _listeners[type][i];
				if (item != null) {
					listeners.push({object: item.o, method: item.m, arguments: item.a});
				}
			}
		}
		return listeners;
	}

	/**
	 * Provides a list of event specific listeners.
 	 * 
 	 * @param type Event type
 	 * @return Array of objects with 3 properties: object, method and arguments
	 */
	public function getListeningObjects(type:String):Array {

		var listeners = new Array();

		if (_listeners[type] != undefined) {
			var item;
			var i:Number = -1;
			var iMax:Number = _listeners[type].length;

			while(++i != iMax) {
				item = _listeners[type][i];
				if (item != null && !Arrays.contains(listeners, item.o)) {
					listeners.push(item.o);
				}
			}
		}
		return listeners;
	}

	/**
	 * Creates a delegate for an event that will be handled in the specified scope. This method is 
	 * useful when working with Flash's build-in objects.
	 * 
	 * @param object The object that provides a scope for the event execution
 	 * @param method Method reference that will handle the event
 	 * @param args (optional) Object containing custom properties that will be passed together with the event
 	 * @return Delegate function
	 */
	public function createDelegate(object:Object, method:Function, args:Object):Function {

		var self = this;
		return function() {
			return self._dispatchDelegate(this, object, method, args, arguments.callee, arguments);
		}
	}

	/**
	 * Removes a previously created delegate.
	 * 
 	 * @param object Object that has a method with an assigned Delegate
 	 * @param method The method that is binded to a Delegate that has to be removed
	 */
	public function removeDelegate(object:Object, method:Function):Void {
		
		var name;
		for(var p in object){
			if (object[p] == method) {
				name = p;
				break;
			}
		}
		delete object[name];
	}

	/**
	 * Displays program messages in a top-level Label instance.<br />
	 * Example: <code>log("myObject", myObject,...myObject.someProperty);</code>
	 *  
  	 * @param msg One or multiple objects and values to be displayed.
	 */
	public function log(msg:Object):Void {
		_enflash.log(arguments);
	}

	/**
	 * Removes this object from the application.
	 */
	public function remove():Void {
		_remove();
	}

	private function _init(parent:Number):Void {
		_parent = parent;
		dispatchEvent("init");
	}
	
	private function _dispatchDelegate(target, object, method, args, func, funcargs):Function {
		
		var name;
		for(var p in target){
			if (target[p] == func) {
				name = p;
				break;
			}
		}
		var event = _createEvent(target, name, funcargs);

		for (var p in args) {
			event[p] = args[p];
		}

		return method.apply(object, [event]); 
	}
	
	private function _dispatchOneEvent(event:Object, type:String, item:Object):Void {

		if (item.a != undefined) {
			for (var p in item.a) {
				event[p] = item.a[p];
			}
		}
		
		item.m.apply(item.o, [event]);

		if (item.o["on" + type] != undefined){
			item.o["on" + type](event);
		}
	}
		
	private function _getRecursiveEvent(o, m) {

		var proto = o;
		_global.ASSetPropFlags(proto.__constructor__.prototype, null, 0, true);
		if (o.__constructor__.prototype != undefined) {
			while (proto != undefined) {
				_global.ASSetPropFlags(proto.__constructor__.prototype, null, 0, true);	
				for (var p in proto.__constructor__.prototype) {
					if (proto.__constructor__.prototype[p] == m){
						return p;
					}
				}
				proto = proto.__proto__;
				_global.ASSetPropFlags(proto.__constructor__.prototype, null, 1);
			}
		}
		_global.ASSetPropFlags(proto.__constructor__.prototype, null, 1);

	}

	private function _getEvent(type:String, index:Number):String {
	
		if (index == undefined) index = 0;
		
		var o = getListeners(type)[index].object;
		var m = getListeners(type)[index].method;

		m = _getRecursiveEvent(o, m);

		return o.id + "." + m;
	}

	private function _setEvent(type:String, event:String, obj):Void {

		if (obj == undefined) {
			obj = this;
		}
		
		var arr = event.split(".");
		var method = arr.pop();
		var object = _enflash.getById(arr.pop());

		obj.addEventListener(type, object, object[method]);
	}

	private function _createEvent(target:Object, type:String, args:Array):Object {

		var event = {target: target, type: type};
		
		if (args.length > 0) {

			switch(target.toString()){
				case "ComboBox":
					event.selectedItem = args[0];
					break;
				case "ListBox":
					event.selectedItem = args[0];
					break;
				case "Menu":
					event.menuItem = args[0];
					break;
				case "Tween":
					event.object = args[0];
					event.property = args[1];
					event.value = args[2];
					break;
			}

			switch(type){
				case "blur":
					event.newFocus = args[0];
					break;
				case "focus":
					event.oldFocus = args[0];
					event.tab = args[1];
					break;
				case "format":
					event.shortcut = args[0];
					break;
				case "onSetFocus":
					event.oldFocus = args[0];
					event.newFocus = args[1];
					break;
				case "onMouseWheel":
					event.delta = args[0];
					break;
				case "onData":
					event.source = args[0];
					break;
				case "onLoad":
					event.success = args[0];
					break;
				case "onLoadInit":
					event.movieclip = args[0];
					break;
				case "onLoadError":
					event.movieclip = args[0];
					event.error = args[1];
					break;
			}
		}
		return event;
	}

	private function _getXML():XMLNode {
	
		var xml = new XML();
		var node = xml.createElement(toString());

		if (_id != toString() + _ref) {
			node.attributes.id = _id;
		}
		if (getListeners("init").length > 0) {
			node.attributes.oninit = _getEvent("init");
		}

		xml.appendChild(node);
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (xml.attributes.oninit != undefined) {
			_setEvent("init", xml.attributes.oninit);
		}
	}
	
	private function _remove():Void {

		_enflash.unregister(this);
		dispatchEvent("remove");

		this.remove = null;
		this.parent = null;
		
		for (var p in this){
			if (p != "__constructor__" && p != "__proto__") {
				if (typeof(this[p].remove) == "function"){
					this[p].remove();
				}
				delete this[p];
				this[p] = null;
			}			
		}
	}		
}