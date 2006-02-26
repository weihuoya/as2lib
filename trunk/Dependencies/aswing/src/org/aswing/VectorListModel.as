/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.AbstractListModel;
import org.aswing.ListModel;
import org.aswing.util.IVector;

/**
 * @author iiley
 */
class org.aswing.VectorListModel extends AbstractListModel implements ListModel, IVector{
	
	private var array:Array;
	
	/**
	 * VectorListMode(array:Array) the array to be the data in vector<br>
	 * VectorListMode() create a new array to be the data in vector<br>
	 */
	public function VectorListModel(array:Array){
		if(array == undefined){
			this.array = new Array();
		}else{
			this.array = array;
		}
	}
	
	public function get(i:Number):Object{
		return array[i];
	}
	
	/**
	 * implemented ListMode
	 */
	public function getElementAt(i:Number):Object{
		return get(i);
	}
	
	public function append(obj:Object, index:Number):Void{
		if(index == undefined){
			index = array.length;
			array.push(obj);
		}else{
			array.splice(index, 0, obj);
		}
		fireIntervalAdded(this, index, index);
	}
	
	public function replaceAt(index:Number, obj:Object):Object{
		var oldObj:Object = array[index];
		array[index] = obj;
		fireContentsChanged(this, index, index);
		return oldObj;
	}	
	
	public function appendAll(arr:Array, index:Number):Void{
		if(index == undefined){
			index = array.length;
		}
		if(index == 0){
			array = array.concat(arr);
		}else{
			var right:Array = array.splice(index);
			array = array.concat(arr);
			array = array.concat(right);
		}
		fireContentsChanged(this, index, index+arr.length-1);
	}
	
	/**
	 * notice the listeners the specified obj's value changed.
	 */
	public function valueChanged(obj:Object):Void{
		valueChangedAt(indexOf(obj));
	}
	
	/**
	 * notice the listeners the specified obj's value changed.
	 */
	public function valueChangedAt(index:Number):Void{
		if(index>=0 && index<array.length){
			fireContentsChanged(this, index, index);
		}
	}
	
	/**
	 * notice the listeners the specified range values changed.
	 * [from, to](include "from" and "to").
	 */
	public function valueChangedRange(from:Number, to:Number):Void{
		fireContentsChanged(this, from, to);
	}
	
	public function removeAt(index:Number):Object{
		if(index<0 || index>= size()){
			return null;
		}
		var obj:Object = array[index];
		array.splice(index, 1);
		fireIntervalRemoved(this, index, index);
		return obj;
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
	 * and toIndex(both inclusive). Shifts any succeeding elements to the left (reduces their index). 
	 * This call shortens the ArrayList by (toIndex - fromIndex) elements. (If toIndex==fromIndex, 
	 * this operation has no effect.) 
	 * @return the elements were removed from the vector
	 */
	public function removeRange(fromIndex:Number, toIndex:Number):Array{
		if(array.length > 0){
			toIndex = Math.min(toIndex, array.length-1);
			var removed:Array = array.splice(fromIndex, toIndex-fromIndex+1);
			fireIntervalRemoved(this, fromIndex, toIndex);
			return removed;
		}else{
			return new Array();
		}
	}
	
	public function indexOf(obj:Object):Number{
		for(var i:Number = 0; i<array.length; i++){
			if(array[i] == obj){
				return i;
			}
		}
		return -1;
	}
	
	public function contains(obj:Object):Boolean{
		return indexOf(obj) >=0;
	}
	
	public function first():Object{
		return array[0];
	}
	
	public function last():Object{
		return array[array.length - 1];
	}
	
	public function size():Number{
		return array.length;
	}
	

	public function isEmpty():Boolean{
		return array.length <= 0;
	}	
	
	/**
	 * Implemented ListMode
	 */
	public function getSize():Number{
		return size();
	}
	
	public function clear():Void{
		var ei:Number = size() - 1;
		if(ei >= 0){
			array.splice(0);
			fireIntervalRemoved(this, 0, ei);
		}
	}
	
	public function toArray():Array{
		var arr:Array = new Array();
		for(var i:Number = 0; i<array.length; i++){
			arr.push(array[i]);
		}
		return arr;
	}
		
	public function sort(compare:Object, options:Number):Array{
		var returned:Array = array.sort(compare, options);
		fireContentsChanged(this, 0, array.length-1);
		return returned;
	}
	
	public function sortOn(key:Object, options:Number):Array{
		var returned:Array = array.sortOn(key, options);
		fireContentsChanged(this, 0, array.length-1);
		return returned;
	}
	
	public function toString():String{
		return "Vector : " + array.toString();
	}
	
}
