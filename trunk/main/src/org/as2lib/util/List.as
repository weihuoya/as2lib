import org.as2lib.basic.EventableElement
import org.as2lib.basic.ListElement
import org.as2lib.basic.exceptions.*

/**
 * Basic List Class for a better Working with Lists within a Project.
 * This Class provides Standard Functionality for stepping trought a List
 * Adding of Entrys, getting of Entrys and more.
 *
 * @autor Martin Heidegger based by Functions from Andre Fiedler [aka SunBox]
 * @date 17.11.2003
 */
/*
* List
*
*	Attributes:
*	  entry 	- 
*	  length	- the length of the list
*
*	Functions:
*	  (obj) getLastElement()					- returns the last element in the list
*	  (obj) getFirstData()						- returns the first not empty elements data in the list
*	  (obj) getLastData()						- returns the last elements data in the list
*	        insertDataBefore(<data>, <index>)	- inserts a new ListElement at the specified index with the given data
*	        insertFirstData(<data>)				- inserts a new first element with the given data
*	        insertLastData(<data>)				- inserts a new last element with the given data
*	  (obj) deleteElement(<element>)			- deletes the given element and returned its data
*	  (obj) deleteFirstData(<data>)				- deletes the first element and returned its data
*	  (obj) deleteLastData(<data>)				- deletes the last element and returned its data
*	  (obj) getElementAt(<index>)				- returns the element at the specified index
*	  (obj) getDataAt(<index>)					- returns the elements data at the specified index
*	        insertDataAt(<data>, <index>)		- inserts a new element with the given data at the specified index
*	  (obj) deleteDataAt(<index>)				- deletes the element at the specified index and returned its data
*	  (obj) setDataAt(<data>, <index>)			- sets the data of the element at the specified index and returned its old data
*	        deleteAllData(<index>)				- deletes all data and sets the list to the state after creating
*
*   Eventhandler:
*     no Eventhandlers at present
*
*/

class org.as2lib.util.List extends EventableElement{
	// The first unused element in the List. It marks the beginning of the list.
	public var entry:Object;
	// Internal Var for the Length.
	private var _length:Number;
	
	function List () {
		this._length = 0;
		
		this.entry = new ListElement(null, null, null);
		this.entry._next = this.entry;
		this.entry._prev = this.entry;
	}
	
	/**
	 * Length of the List.
	 * 
	 * @return	length as Number.
	 *
	 * @see #getElementAt
	 */
	function get length():Number {
		return this._length;
	}
	
	/**
	 * Returns true if the list is empty, otherwise it returns false.
	 */
	public function isEmpty():Boolean {
		return this._length == 0;
	}
	
	/**
	 * Returns the first not empty Element in the List.
	 * 
	 * @return	The first Element
	 *
	 * @throws ObjectNotFoundException 	If there's no first Element available.
	 */
	public function getFirstElement():Object {
		if( this.isEmpty() ) {
			throw new ObjectNotFoundException("The List is Empty. There is no first Element.", "org.as2lib.util.List", "getFirstElement", null);
		} else {
			return(this.entry._next);
		}
	}
	
	/**
	 * Returns the last not empty Element in the List.
	 *
	 * @return	The last Element.
	 *
	 * @throws ObjectNotFoundException 	If there's no last Element available.
	 */
	public function getLastElement():Object {
		if ( this.isEmpty() ) {
			throw new ObjectNotFoundException("he List is Empty. There is no last Element.", "org.as2lib.util.List", "getLastElement", null);
		} else {
			return(this.entry._prev);
		}
	}
	
	/**
	 * Returns the content from the first not empty Element in the List.
	 *
	 * @return	The Content from the first Element.
	 *
	 * @throws ObjectNotFoundException 	If there's no first Element available.
	 */
	public function getFirstData():Object {
		if ( this.isEmpty() ) {
			throw new ObjectNotFoundException("The List is Empty. There is no first Element.", "org.as2lib.util.List", "getFirstData", null);
		} else {
			return(this.entry._next._data);
		}
	}
	
	/**
	 * Returns the content from the last not empty Element in the List.
	 *
	 * @return	The Content from the last Element.
	 *
	 * @throws ObjectNotFoundException 	If there's no last Element available.
	 */
	public function getLastData():Object {
		if ( this.isEmpty() ) {
			throw new ObjectNotFoundException("The List is Empty. There is no last Element.", "org.as2lib.util.List", "getFirstData", null);
		} else {
			return(this.entry._prev._data);
		}
	}
	
	/**
	 * Inserts a new ListElement at the specified index with the given data.
	 *
	 * @param d		Content of the new Object.
	 * @param e		Existing Listelement where it should be added
	 */
	public function insertDataBefore(d:Object, e:ListElement):Object {
		if(e instanceof ListElement){
			var listElement = new ListElement(d, e._prev, e);
			listElement._prev._next = listElement;
			listElement._next._prev = listElement;
			this._length++;
		} else {
			return (null);
		}
	}
	
	public function insertFirstData(d:Object):Object {
		return (this.insertDataBefore(d, this.entry._next));
	}
	
	public function insertLastData(d:Object):Object {
		return (this.insertDataBefore(d, this.entry));
	}
	
	public function deleteElement(e:Object):Boolean {
		if(e instanceof ListElement && e !=this.entry) {
			e._prev._next = e._next;
			e._next._prev = e._prev;
			return (true);
		} else {
			return (false);
		}
	}
	
	public function deleteFirstData():Object {
		var firstData = this.entry._next._data;
		this.deleteElement(this.entry._next);
		return (firstData);		
	}
	
	public function deleteLastData():Object {
		var lastData = this.entry._prev._data;
		deleteElement(this.entry._prev);
		return (lastData);		
	}
	
	public function getElementAt(index:Number):Object {
		if(index < 0 || index >= this._length) {
			return(null);
		} else {
			var listElement = this.entry;
			if(index < this._length/2) {
				for(var i=0; i<=index; i++) listElement = listElement._next;
			} else {
				for(var i=this._length; i>index; i--) listElement = listElement._prev;
			}
			return (listElement);
		}
	}
	
	public function getDataAt (index:Number):Object {
		return (this.getElementAt(index)._data);
	}
	
	public function insertDataAt (d:Object, index:Number):Boolean {
		if(typeof d == "object" && (index < 0 && index > this._length) ) {
			var listElement;
			
			// TODO -- Really not "this._length-1" -- ???
			if(index == this._length) listElement = this.entry;
			else listElement = this.getElementAt(index);
			
			this.insertDataBefore(d, listElement);	
			
			return (true);
		} else {
			return (false);
		}
	}
	
	public function deleteDataAt (index:Number):Object {
		if(index < 0 && index > this._length-1) {
			var listElement = this.getElementAt(index);
			this.deleteElement(listElement);
			return (listElement._data);
		} else {
			return(null);
		}		
	}
	
	public function setDataAt (d:Object, index:Number):Object {
		if(typeof d == "object" && ( 0 < index && index < this._length) ) {
			var listElement = this.getElementAt(index);
			var oldData = listElement._data;
			listElement._data = d;
			return (oldData);
		} else {
			return (null);
		}
	}
	
	public function deleteAllData ():Void {
		this.entry._next = this.entry;
		this.entry._prev = this.entry;
		this._length = 0;
	}
}