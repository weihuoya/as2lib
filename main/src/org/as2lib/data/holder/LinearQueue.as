import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.data.holder.Queue;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.EmptyDataHolderException;
import org.as2lib.data.holder.HolderConfig;

class org.as2lib.data.holder.LinearQueue extends BasicClass implements Queue {
	private var data:Array;
	
	public function LinearQueue(Void) {
		data = new Array();
	}
	
	public function enqueue(value):Void {
		data.push(value);
	}
	
	public function dequeue(Void) {
		if (data.length == 0) {
			throw new EmptyDataHolderException("You tried to dequeue an element from an empty Queue.",
										  this,
										  arguments);
		}
		return data.shift();
	}
	
	public function peek(Void) {
		if (data.length == 0) {
			throw new EmptyDataHolderException("You tried to peek an element from an empty Queue.",
										  this,
										  arguments);
		}
		return data[0];
	}
	
	public function isEmpty(Void):Boolean {
		return (data.length == 0);
	}
	
	public function iterator(Void):Iterator {
		return (new ArrayIterator(data));
	}
	
	public function toString(Void):String {
		return HolderConfig.getQueueStringifier().execute(this);
	}
}