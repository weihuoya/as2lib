import org.as2lib.data.iterator.Iterator;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Stack;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.except.IllegalArgumentException;

class org.as2lib.data.holder.TypedStack extends BasicClass implements Stack {
	private var stack:Stack;
	private var type:Function;
	
	public function TypedStack(stack:Stack, type:Function) {
		this.stack = stack;
		this.type = type;
	}
	
	public function push(value):Void {
		validate(value);
		stack.push(value);
	}
	
	public function pop(Void) {
		return stack.pop();
	}
	
	public function peek(Void) {
		return stack.peek();
	}
	
	public function iterator(Void):Iterator {
		return stack.iterator();
	}
	
	public function isEmpty(Void):Boolean {
		return stack.isEmpty();
	}
	
	public function toString(Void):String {
		return stack.toString();
	}
	
	private function validate(object):Void {
		if (!ObjectUtil.typesMatch(object, type)) {
			throw new IllegalArgumentException("Type mismatch between [" + object + "] and [" + type + "].");
		}
	}
}