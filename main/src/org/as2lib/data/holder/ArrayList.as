import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.List;
import org.as2lib.env.overload.Overload;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;

/**
 * @author Simon Wacker
 */
class org.as2lib.data.holder.ArrayList extends BasicClass implements List {
	private var data:Array;
	
	public function ArrayList(Void) {
		data = new Array();
	}
	
	public function insert(value):Void {
		insertLast(value);
	}
	
	public function insertFirst(value):Void {
		data.unshift(value);
	}
	
	public function insertLast(value):Void {
		data.push(value);
	}
	
	public function insertAll(list:List):Void {
		var iterator:Iterator = list.iterator();
		while (iterator.hasNext()) {
			insertLast(iterator.next());
		}
	}
	
	public function remove() {
		var o:Overload = new Overload(this);
		o.addHandler([Object], removeByValue);
		o.addHandler([Number], removeByIndex);
		o.forward(arguments);
	}
	
	public function removeByValue(value):Void {
		data.splice(indexOf(value), 1);
	}
	
	public function removeByIndex(index:Number) {
		var result = data[index];
		data.splice(index, 1);
		return result;
	}
	
	public function removeFirst(Void) {
		return data.shift();
	}
	
	public function removeLast(Void) {
		return data.pop();
	}
	
	public function removeAll(list:List):Void {
		var iterator:Iterator = list.iterator();
		while (iterator.hasNext()) {
			removeByValue(iterator.next());
		}
	}
	
	public function set(index:Number, value) {
		var result = data[index];
		data[index] = value;
		return result;
	}
	
	public function setAll(index:Number, list:List):Void {
		var iterator:Iterator = list.iterator();
		while (iterator.hasNext()) {
			set(index++, iterator.next());
		}
	}
	
	public function get(index:Number) {
		return data[index];
	}
	
	public function contains(value):Boolean {
		return (indexOf(value) > -1);
	}
	
	public function containsAll(list:List):Boolean {
		var iterator:Iterator = list.iterator();
		while (iterator.hasNext()) {
			if (!contains(iterator.next())) {
				return false;
			}
		}
		return true;
	}
	
	public function retainAll(list:List):Void {
		for (var i:Number = 0; i < data.length; i++) {
			if (!list.contains(data[i])) {
				removeByIndex(i);
			}
		}
	}
	
	public function clear(Void):Void {
		data = new Array();
	}
	
	public function size(Void):Number {
		return data.length;
	}
	
	public function isEmpty(Void):Boolean {
		return (data.length < 1);
	}
	
	public function iterator(Void):Iterator {
		return (new ArrayIterator(data));
	}
	
	public function indexOf(value):Number {
		var l = data.length;
		while (data[--l] != value && l>-1);
		return l;
	}
}