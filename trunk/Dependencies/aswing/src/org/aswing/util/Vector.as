/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.util.IVector;

/**
 * Vector
 * @author firdosh
 */
class org.aswing.util.Vector implements IVector{
	
	private var _elements:Array;
	public static var CASEINSENSITIVE:Number=1;
	public static var DESCENDING :Number=2;
	public static var UNIQUESORT :Number=4;
	public static var RETURNINDEXEDARRAY :Number=8;	
	public static var NUMERIC  :Number=16;	
	
	public function Vector(){
		_elements=new Array();	
	}
	
	/**
	 * Call the operation by pass each element once.
	 * <p>
	 * for example:
	 * <pre>
	 * //hide all component in vector components
	 * components.each( 
	 *     function(c:Component){
	 *         c.setVisible(false);
	 *     });
	 * <pre>
	 * @param operation the operation function for each element
	 */
	public function each(operation:Function):Void{
		for(var i:Number=0; i<_elements.length; i++){
			operation(_elements[i]);
		}
	}
	
	/**
	 * Call the operation by pass each element once without the specified element.
	 * <p>
	 * for example:
	 * <pre>
	 * //hide all component in vector components without firstOne component
	 * var firstOne:Component = the first one;
	 * components.eachWithout( 
	 * 	   firstOne,
	 *     function(c:Component){
	 *         c.setVisible(false);
	 *     });
	 * <pre>
	 * @param obj the which will not be operated.
	 * @param operation the operation function for each element
	 */
	public function eachWithout(obj:Object, operation:Function):Void{
		for(var i:Number=0; i<_elements.length; i++){
			if(_elements[i] != obj){
				operation(_elements[i]);
			}
		}
	}	
	
	public function get(i:Number):Object{
		return _elements[i];
	}
	
	public function elementAt(i:Number):Object{
		return get(i);
	}
	
	public function append(obj:Object, index:Number):Void{
		if(index == undefined){			
			_elements.push(obj);
		}else{
			_elements.splice(index, 0, obj);
		}
	}
	public function appendAll(arr:Array, index:Number):Void{
		if(index == undefined || index == 0){			
			_elements = _elements.concat(arr);
		}else{
			var right:Array = _elements.splice(index);
			_elements = _elements.concat(arr);
			_elements = _elements.concat(right);
		}
	}
	
	public function replaceAt(index:Number, obj:Object):Object{
		if(index<0 || index>= size()){
			return null;
		}
		else{		
			var oldObj:Object = _elements[index];
			_elements[index] = obj;		
			return oldObj;
		}
	}
	
	public function removeAt(index:Number):Object{
		if(index<0 || index>= size()){
			return null;
		}
		else{		
			var obj:Object = _elements[index];
			_elements.splice(index, 1);		
			return obj;
		}
	}
	public function remove(obj:Object):Object{
		var i:Number = indexOf(obj);
			if(i>=0){
				return removeAt(i);
			}else{
				return null;
			}
	}
	
	/**
	 * Removes from this List all of the elements whose index is between fromIndex, 
	 * inclusive and toIndex, exclusive. Shifts any succeeding elements to the left (reduces their index). 
	 * This call shortens the ArrayList by (toIndex - fromIndex) elements. (If toIndex==fromIndex, 
	 * this operation has no effect.) 
	 * @return the elements were removed from the vector
	 */
	public function removeRange(fromIndex:Number, toIndex:Number):Array{
		return _elements.splice(fromIndex, toIndex-fromIndex+1);
	}
	public function indexOf(obj:Object):Number{
		for(var i:Number = 0; i<_elements.length; i++){
			if(_elements[i] == obj){
				return i;
			}
		}
		return -1;
	}
	public function contains(obj:Object):Boolean{
		return indexOf(obj) >=0;
	}
	public function first():Object{
		return _elements[0];
	}
	public function last():Object{
		return _elements[_elements.length-1];
	}
	
	
	public function size():Number{
		return _elements.length;
	}
	public function setElementAt(index:Number,element:Object):Void{
		replaceAt(index,element);
	}
	public function getSize():Number{
		return size();
	}
	public function clear():Void{
		_elements.splice(0);
		_elements=new Array();
		
	}
	public function sort(compare:Object, options:Number):Array{
		return _elements.sort(compare, options);
	}
	public function sortOn(key:Object, options:Number):Array{
		return _elements.sortOn(key, options);
	}
	public function toString(Void):String{
		return "Vector : " + _elements.toString();
	}
	
	public function clone(Void):Vector{
		var cloned:Vector=new Vector();
		for (var i:Number=0; i<_elements.length; i++){
			cloned.append(_elements[i]);
		}		
		return cloned;
	}
	
	public function isEmpty():Boolean{
		if(_elements.length>0)
			return false;
		else
			return true;
	}
	
	public function toArray():Array{
		var arr:Array = new Array();
		for(var i:Number = 0; i<_elements.length; i++){
			arr.push(_elements[i]);
		}
		return arr;
	}
	
	
	
		
}
