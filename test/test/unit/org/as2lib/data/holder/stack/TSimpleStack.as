import org.as2lib.test.unit.TestCase;
import org.as2lib.data.holder.stack.SimpleStack;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.EmptyDataHolderException;
import org.as2lib.data.holder.Iterator;
import test.unit.org.as2lib.data.holder.AbstractTStack;

class test.unit.org.as2lib.data.holder.TSimpleStack extends AbstractTStack {
	public function TSimpleStack(Void) {
	}
	
	public function getStack(Void):Stack {
		return new SimpleStack();
	}
	
}