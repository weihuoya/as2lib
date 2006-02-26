import com.asual.enflash.EnFlashObject;
import com.asual.enflash.utils.Arrays;

/**
 * List class creates a simple structure similar to the Array object. It inherits
 * all the EnFlashObject goodies and provides additional methods for quick access
 * and manipulations. 
 */
class com.asual.enflash.data.List extends EnFlashObject {
	
	private var _items:Array;
	private var _name:String = "List";

	/**
	 * @param id (optional) Descriptive ID of this object.
	 */
	public function List(id:String){
		super(id);
		_items = new Array();
	}

	/**
	 * Provides the index number of an object's member.
	 * 
	 * @param item A member of this object
	 * @return Index number of the member
	 */
	public function getIndex(item:Object):Number {
		return Arrays.getIndex(_items, item);
	}

	/**
	 * Sets a new index number for an existing member.
	 * 
	 * @param index The new index of the member
	 * @param obj The member that is going to be re-indexed
	 */
	public function setIndex(index:Number, obj:Object):Void {
		Arrays.setIndex(_items, index, obj);
	}

	/**
	 * Provides access to an object's member based on an index number.
	 * 
	 * @param index Index number
	 * @return A member residing on the provided index
	 */
	public function getItem(index:Number) {
		return _items[index];
	}

	/**
	 * Provides access to an object's member based on a value of a property.
	 * 
	 * @param property Property name
	 * @param value Value of the property
	 * @return A member with such a property value
	 */
	public function getItemByProperty(property:String, value:Object) {
		return Arrays.getByProperty(_items, property, value);
	}

	/**
	 * Provides access to an object placed before the specified member.
	 * 
	 * @param item A member that belongs to this object
	 * @param loop (optional) Enables a loop feature
	 * @return The previous member
	 */	
	public function getPreviousItem(obj:Object, loop:Boolean) {
		
		if (loop == undefined) loop = false;
		var index = getIndex(obj);
		
		if (index == 0 && loop) {
			return _items[_items.length - 1];
		} else {
			return _items[index - 1];
		}
	}

	/**
	 * Provides access to an object placed after the specified member.
	 * 
	 * @param item A member that belongs to this object
	 * @param loop (optional) Enables a loop feature
	 * @return The next member object
	 */
	public function getNextItem(obj:Object, loop:Boolean) {

		if (loop == undefined) loop = false;
		var index = getIndex(obj);
		
		if ((index == _items.length - 1) && loop) {
			return _items[0];
		} else {
			return _items[index + 1];
		}
	}

	/**
	 * Adds a member to this object.
	 * 
	 * @param item An object that will be added
	 */
	public function addItem(item:Object):Void {
		_items.push(item);
	}

	/**
	 * Adds a member to this object at the specified index.
	 * 
	 * @param index Index number of the new member element
	 * @param item An object that will be added
	 */
	public function addItemAt(index:Number, item:Object):Void {
		Arrays.pushAt(_items, index, item);
	}

	/**
	 * Removes a member from this object.
	 * 
	 * @param item An object that will be removed
	 * @return The removed object
	 */
	public function removeItem(item:Object) {
		return Arrays.remove(_items, item);
	}

	/**
	 * Removes a member at the specified index.
	 * 
	 * @param index Index number of the member that will be removed
	 * @return The removed object
	 */
	public function removeItemAt(index:Number) {
		return Arrays.removeAt(_items, index);
	}

	/**
	 * Removes all the members of this object.
	 * 
	 * @return An array containing all the members removed
	 */
	public function removeAll():Array {
		return _items.splice(0);
	}

	/**
	 * Swaps two objects in the list.
	 * 
	 * @param obj1 The first object
	 * @param obj2 The second object
	 */
	public function swap(obj1:Object, obj2:Object):Void {
		Arrays.swap(_items, obj1, obj2);
	}

	/**
	 * The number of members in this object.
	 */	
	public function get length():Number {
		return _items.length;
	}

	/**
	 * The first member of this object.
	 */
	public function get firstItem():Object {
		return _items[0];
	}

	/**
	 * The last member of this object.
	 */	
	public function get lastItem():Object {
		return _items[_items.length - 1];
	}

	/**
	 * Provides access to the array used by this object.
	 * 
	 * @return Array object
	 */	
	public function get array():Array {
		return _items;
	}
	
	private function _getXML():XMLNode {
		
		var xml = super._getXML();
		if (length > 0) {
			var i:Number = -1;
			var iMax:Number = length;
			while(++i != iMax) {
				xml.firstChild.appendChild(getItem(i).getXML());
			}
		}
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		var node;
		var i:Number = -1;
		var iMax:Number = xml.childNodes.length;
		while(++i != iMax) {
			addItem(xml.childNodes[i].attributes.id);
		}
		super._setXML(xml);
	}

}