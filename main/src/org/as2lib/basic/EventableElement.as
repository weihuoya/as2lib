import org.as2lib.util.StringUtil
import org.as2lib.exceptions.*

/**
 * Basic Class for Eventhandling.
 * This Class should get extended by any Class that has to handle anything
 * This Class should work DOM3 Compatible with one little Difference: you have
 * to register an Eventtype <b>before</b> you add a listener.
 *
 * @author	Martin Heidegger
 * @date 	13.11.2003
 */

class org.as2lib.basic.EventableElement {
	// registered Listeners
	private var __listener:Array;
	// registered Listenertype (as String for faster searching)
	private var __listenerTypes:String = "";
	
	/**
	 * Adds an Handler to an Event from this Object.
	 *
	 * @see	#removeEventListener
	 * @see #addEventType
	 * @see #removeEventType
	 * 
	 * @param type		Type of event that should get handled by the handler
	 * @param handler	Object that should be registered
	 *
	 * @throws WrongArgumentException		If the type of <handler> was wrong (didn't contains Handler-Method or was no Method)
	 * @throws ObjectNotDefinedException	If the Handler wasn't defined
	 */
	public function addEventListener(type:String, handler):Void{
		if(typeof this.__listener[type] == "object") {
			if(handler != undefined && (typeof handler[type] == "function" || typeof handler == "function")) {
				this.__listener[type].push(handler);
			} else {
				throw new WrongArgumentException("You dont use a correct Handler.", "de.flashforum.basic.EventableElement", "addEventListener", arguments);				
			}
		} else {
			throw new ObjectNotDefinedException("The Event ["+type+"] is not registered", "de.flashforum.basic.EventableElement", "addEventListner", arguments);
		}
	}
	
	/**
	 * Removes an existing Handler
	 * 
	 * @see	#addEventListener
	 * @see #addEventType
	 * @see #removeEventType
	 * 
	 * @param type		Type of the Handler that should be removed
	 * @param handler	Handler Object which type should be removed
	 * 
	 * @throws ObjectNotFoundException	If the Listener that should be removed doesn't exists
	 */
	public function removeEventListener(type:String, handler:Object):Void {
		// It could be that the Listener was added more than one time!
		var found = false;
		for(var i in this.__listener[type]){
			if(this.__listener[type][i] === handler) {
				found = true;
				delete(this.__listener[type][i]);
			}
		}
		if(!found)
			throw new ObjectNotFoundException("The Listener you want to remove was never defined", "de.flashforum.basic.EventableElement", "removeEventListener", arguments);
	}
	
	/**
	 * Add's a new Type into the List of the Available Types
	 *
	 * @see removeEventType
	 * 
	 * @param type	New Type that should be introduced (may not contain ',')
	 *
	 * @throws ObjectAllreadyDefinedException	To make sure that type is only defined one time
	 * @throws WrongArgumentExceptions			If the Type is too short to be Added or it contains ','
	 */
	public function addEventType(type:String):Void {
		if(!StringUtil.contains(type, ",") && type.length > 0) {
			if(this.__listenerTypes.indexOf(type) >= 0) {
				throw new ObjectAllreadyDefinedException("The Type ["+type+"] is allready Defined", "de.flashforum.basic.EventableElement", "addEventType", arguments);
			} else {
				if(!this.__listener)
					this.__listener = new Array();
				this.__listenerTypes += type+",";
				this.__listener[type] = new Array();
			}
		} else {
			throw new WrongArgumentException("The new Listener-Type["+type+"] must not contain ',' and must be longer than 0", "de.flashforum.basic.EventableElement", "addEventType", arguments);
		}
	}
	
	/**
	 * Removes an Eventtype out of the Typelist
	 * 
	 * @see addEventType
	 *
	 * @param type	registered Type that should be removed
	 * 
	 * @throws ObjectNotFoundException	If the Type you want to remove never existed
	 */
	// todo: check if it contains ','
	public function removeEventType(type:String) {
		var listenerIndex = this.__listenerTypes.indexOf(type);
		if(listenerIndex >= 0) {
			delete(this.__listener[type]);
			StringUtil.replace(this.__listenerTypes, type+",", "");
		} else {
			throw new ObjectNotFoundException("The Listener you requested to remove ["+type+"] was not defined.", "de.flashforum.basic.EventableElement", "removeListenerType", arguments);
		}
	}
	
	/**
	 * Dispatches an Event to all Listeners
	 *
	 * @param eventObject	Object that contains the Attribute "type" as EventType. the "target" Attributes can be an Object that should be used
	 * 
	 * @throws WrongArgumentException	if Attribute "target" is defined but no Object
	 * @throws WrongArgumentException	if the type isn't defined
	 * @throws WrongArgumentException	if the eventObject isn't defined
	 */
	 
	//todo: is it better to use a Class instead of "object" ?
	//todo: what's up with this "target" ???
	public function dispatchEvent(eventObject:Object):Void {
		if(eventObject) {
			if(typeof eventObject.type != "String") {
				var type = eventObject.type;
				if(!eventObject.target){
					eventObject.target = this;
				} else if(typeof eventObject.target != "object"){
					throw new WrongArgumentException("eventObject[0].target is not an Object", "de.flashforum.basic.EventableElement", "dispatchEvent", arguments);
				}
				
				this[type+"Handler"](eventObject);
				this.executeListeners(type, eventObject);
			} else {
				throw new WrongArgumentException("eventObject[0].type is not defined. Could not execute Event", "de.flashforum.basic.EventableElement", "dispatchEvent", arguments);
			}
		} else {
			throw new WrongArgumentException("eventObject[0] isn't defined", "de.flashforum.basic.EventableElement", "dispatchEvent", arguments);
		}
	}
	
	/**
	 * Function to call the existing Listeners to an Event.
	 *
	 * @param type			Event that should be called
	 * @param eventObject	EventObject that should be passed to the Listeners
	 */
	private function executeListeners(type:String, eventObject:Object):Void {
		for(var i in this.__listener[type]){
			var listener = this.__listener[type][i];
			if(typeof listener == "function") {
				listener.apply(null, [eventObject]);
			} else {
				if(typeof listener.handleEvent == "function") {
					listener.handleEvent(eventObject);
				} else {
					listener[eventObject.type](eventObject);
				}
			}
		}
	}
}