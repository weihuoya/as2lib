import org.as2lib.test.unit.TestCase;
import org.as2lib.data.holder.SimpleStack;
import org.as2lib.data.holder.EmptyDataHolderException;
import org.as2lib.data.iterator.Iterator;

class test.unit.org.as2lib.data.holder.TSimpleStack extends TestCase {
	public function TSimpleStack(Void) {
	}
	
	public function testPush(Void):Void {
		var stack:SimpleStack = new SimpleStack();
		var obj1:Object = {};
		var obj2:Object = {};
		stack.push(obj1);
		stack.push(obj2);
		assertEquals(stack.pop(), obj2);
		assertFalse(stack.isEmpty());
		assertEquals(stack.pop(), obj1);
		assertTrue(stack.isEmpty());
	}
	
	public function testPop(Void):Void {
		var stack:SimpleStack = new SimpleStack();
		var obj1:Object = {};
		var obj2:Object = {};
		assertThrows(EmptyDataHolderException, stack, "pop", []);
		stack.push(obj1);
		stack.push(obj2);
		assertEquals(stack.pop(), obj2);
		assertFalse(stack.isEmpty());
		assertEquals(stack.pop(), obj1);
		assertTrue(stack.isEmpty());
	}
	
	public function testPeek(Void):Void {
		var stack:SimpleStack = new SimpleStack();
		var obj1:Object = {};
		var obj2:Object = {};
		assertThrows(EmptyDataHolderException, stack, "peek", []);
		stack.push(obj1);
		stack.push(obj2);
		assertEquals(stack.peek(), obj2);
		assertEquals(stack.pop(), obj2);
		assertFalse(stack.isEmpty());
		assertEquals(stack.peek(), obj1);
		assertFalse(stack.isEmpty());
		assertEquals(stack.pop(), obj1);
		assertTrue(stack.isEmpty());
	}
	
	public function testIterator(Void):Void {
		var stack:SimpleStack = new SimpleStack();
		var iterator:Iterator = stack.iterator();
		assertFalse(iterator.hasNext());
		stack.push("value1");
		stack.push("value2");
		assertFalse(iterator.hasNext());
		iterator = stack.iterator();
		assertTrue(iterator.hasNext());
		assertEquals("value2", iterator.next());
		assertEquals("value1", iterator.next());
	}
	
	public function testIsEmpty(Void):Void {
		var stack:SimpleStack = new SimpleStack();
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
		} catch(e:org.as2lib.data.holder.EmptyDataHolderException) {}
		assertTrue(stack.isEmpty());
	}
}