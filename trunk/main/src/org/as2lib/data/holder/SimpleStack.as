import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.HolderConfig;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.EmptyDataHolderException;

class org.as2lib.data.holder.SimpleStack extends BasicClass implements Stack {
	private var target:Array;
	
	public function SimpleStack(Void) {
		target = new Array();
	}
	
	public function push(value):Void {
		target.push(value);
	}
	
	public function pop(Void) {
		if (target.length == 0) {
			throw new EmptyDataHolderException("You tried to pop an element from an empty Stack.",
										  this,
										  arguments);
		}
		return target.pop();
	}
	
	public function peek(Void) {
		if (target.length == 0) {
			throw new EmptyDataHolderException("You tried to peek an element from an empty Stack.",
										  this,
										  arguments);
		}
		return target[target.length - 1];
	}
	
	public function iterator(Void):Iterator {
		return (new ArrayIterator(target));
	}
	
	public function isEmpty(Void):Boolean {
		return (target.length == 0);
	}
	
	public function toString(Void):String {
		return HolderConfig.getStackStringifier().execute(this);
	}
}