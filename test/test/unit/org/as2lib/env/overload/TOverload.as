import org.as2lib.test.unit.Test;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.overload.OverloadHandler;
import org.as2lib.env.overload.SimpleOverloadHandler;
import org.as2lib.env.overload.UnknownOverloadHandlerException;
import org.as2lib.env.overload.SameTypeSignatureException;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.util.ObjectUtil;

/**
 * @author Simon Wacker
 */
class test.org.as2lib.env.overload.TOverload extends Test {
	public function TOverload(Void) {
	}
	
	public function testAddHandler(Void):Void {
		var o:Overload = new Overload(this);
		var oh:OverloadHandler = new SimpleOverloadHandler([], new Function());
		o.addHandler(oh);
		assertNotThrows(o, "removeHandler", [oh]);
	}
	
	public function testAddHandlerByValue(Void):Void {
		var o:Overload = new Overload(this);
		var oh:OverloadHandler = o.addHandlerByValue([], new Function());
		assertIsNotEmpty("The received OverloadHandler [" + oh + "] is empty.", oh);
		assertTrue("The received instance [" + oh + "] is not of type OverloadHandler.", ObjectUtil.isInstanceOf(oh, OverloadHandler));
		assertNotThrows(o, "removeHandler", [oh]);
	}
	
	public function testRemoveHandler(Void):Void {
		var o:Overload = new Overload(this);
		var oh:OverloadHandler = o.addHandlerByValue([], new Function());
		assertNotThrows(o, "removeHandler", [oh]);
		assertThrows(IllegalArgumentException, o, "removeHandler", [new SimpleOverloadHandler([], new Function())]);
	}
	
	public function testForward(Void):Void {
		var o:Overload = new Overload(this);
		o.addHandlerByValue([String, Object], firstMethod);
		o.addHandlerByValue([Object, String], secondMethod);
		var number:Number = Number(o.forward(["string", new Object()]));
		assertTrue("The returned number [" + number + "] does not have the correct value [0].", (number == 0));
		assertThrows(SameTypeSignatureException, o, "forward", [new String("firstString"), new String("secondString")]);
		assertThrows(UnknownOverloadHandlerException, o, "forward", [0, 0]);
	}
	
	private function firstMethod(string:String, object:Object):Number {
		assertTrue("The passed in parameter string [" + string + "] does not have the correct value [string].", (string == "string"));
		assertTrue("The passed in parameter object [" + object + "] is not of type Object.", ObjectUtil.isInstanceOf(object, Object));
		return 0;
	}
	
	private function secondMethod(Void):Void {
		addError("The wrong method is being executed.");
	}
}