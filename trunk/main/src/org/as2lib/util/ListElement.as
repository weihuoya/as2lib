/** doubly concatenated ring list by André Fiedler [aka SunboX] Aug 2003 **/
/*
* ListElement
*
*	Attributes:
*	  data - the elements data
*	  prev - the preview element
*	  next - the next element
*
*	Functions:
*     (boo) hasNext()	- returns true if there is a next element, otherwise it returns false
*
*   Eventhandler:
*     no Eventhandlers at present
*
*/

class de.flashforum.basic.ListElement {
	private var _data:Object;
	private var _prev:Object;
	private var _next:Object;
	
	function ListElement (d, p, n){
		this._data = d;
		this._prev = p;
		this._next = n;
	}
	
	public function get data ():Object {
		return this._data;
	}
	
	public function get prev ():Object {
		return this._prev;
	}
	
	public function get next ():Object {
		return this._next;
	}
	
	public function hasNext ():Object {
		if(this._next.data != null){
			return(true);
		}
		return (false);
	}
}