import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.data.holder.Queue;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.EmptyDataHolderException;
import org.as2lib.data.holder.HolderConfig;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.except.IllegalArgumentException;

class org.as2lib.data.holder.TypedQueue extends BasicClass implements Queue {
	private var queue:Queue;
	private var type:Function;
	
	public function TypedQueue(queue:Queue, type:Function) {
		this.queue = queue;
		this.type = type;
	}
	
	public function enqueue(value):Void {
		validate(value);
		queue.enqueue(value);
	}
	
	public function dequeue(Void) {
		return queue.dequeue();
	}
	
	public function peek(Void) {
		return queue.peek();
	}
	
	public function isEmpty(Void):Boolean {
		return queue.isEmpty();
	}
	
	public function iterator(Void):Iterator {
		return queue.iterator();
	}
	
	public function toString(Void):String {
		return queue.toString();
	}
	
	private function validate(object):Void {
		if (!ObjectUtil.typesMatch(object, type)) {
			throw new IllegalArgumentException("Type mismatch between [" + object + "] and [" + type + "].");
		}
	}
}