import org.as2lib.test.unit.TestCase;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.EmptyDataHolderException;
import org.as2lib.data.iterator.Iterator;

class test.unit.org.as2lib.data.holder.AbstractTStack extends TestCase {
	
	private var obj1:Object;
	private var obj2:Object;
	
	public function AbstractTStack(Void) {
		obj1 = {};
		obj2 = {};
	}
	
	private function fillStack(stack:Stack):Void {
		stack.push(obj1);
		stack.push(obj2);
	}
	
	public function testPush(Void):Void {
		var stack:Stack = this["getStack"]();
		fillStack(stack);
		assertEquals(stack.pop(), obj2);
		assertFalse(stack.isEmpty());
		assertEquals(stack.pop(), obj1);
		assertTrue(stack.isEmpty());
	}
	
	public function testPop(Void):Void {
		var stack:Stack = this["getStack"]();
		assertThrows(EmptyDataHolderException, stack, "pop", []);
		fillStack(stack);
		assertEquals(stack.pop(), obj2);
		assertFalse(stack.isEmpty());
		assertEquals(stack.pop(), obj1);
		assertTrue(stack.isEmpty());
	}
	
	public function testPeek(Void):Void {
		var stack:Stack = this["getStack"]();
		assertThrows(EmptyDataHolderException, stack, "peek", []);
		fillStack(stack);
		assertEquals(stack.peek(), obj2);
		assertEquals(stack.pop(), obj2);
		assertFalse(stack.isEmpty());
		assertEquals(stack.peek(), obj1);
		assertFalse(stack.isEmpty());
		assertEquals(stack.pop(), obj1);
		assertTrue(stack.isEmpty());
	}
	
	public function testIterator(Void):Void {
		var stack:Stack = this["getStack"]();
		var iterator:Iterator = stack.iterator();
		assertFalse(iterator.hasNext());
		fillStack(stack);
		assertFalse(iterator.hasNext());
		iterator = stack.iterator();
		assertTrue(iterator.hasNext());
		assertEquals(obj2, iterator.next());
		assertEquals(obj1, iterator.next());
	}
	
	public function testIsEmpty(Void):Void {
		var stack:Stack = this["getStack"]();
		var obj:Object = {};
		assertTrue(stack.isEmpty());
		stack.push(obj);
		assertFalse(stack.isEmpty());
		stack.push(obj);
		assertFalse(stack.isEmpty());
		stack.pop();
		stack.pop();
		assertTrue(stack.isEmpty());
		try {
			stack.pop();
		} catch(e:org.as2lib.data.holder.EmptyDataHolderException) {
		}
		assertTrue(stack.isEmpty());
	}
	
}