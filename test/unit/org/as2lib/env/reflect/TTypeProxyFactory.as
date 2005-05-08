import org.as2lib.test.unit.TestCase;
import org.as2lib.env.reflect.TypeProxyFactory;
import org.as2lib.env.reflect.ProxyFactory;
import org.as2lib.env.reflect.InvocationHandler;
import org.as2lib.core.BasicInterface;
import org.as2lib.env.bean.PropertyValue;

class org.as2lib.env.reflect.TTypeProxyFactory extends TestCase {

	private function getBlankInvocationHandler(Void):InvocationHandler {
		var result = new Object();
		result.__proto__ = InvocationHandler["prototype"];
		return result;
	}
	
	public function testCreateProxyWithTypeOfValueNullAndUndefined(Void):Void {
		var factory:ProxyFactory = new TypeProxyFactory();
		assertNull(factory.createProxy(null));
		assertNull(factory.createProxy(undefined));
	}
	
	public function testTypeCast(Void):Void {
		var factory:ProxyFactory = new TypeProxyFactory();
		assertNotNull(BasicInterface(factory.createProxy(BasicInterface, getBlankInvocationHandler())));
	}
	
	public function testInvocationPropagationWithInterface(Void):Void {
		var factory:ProxyFactory = new TypeProxyFactory();
		var proxy1:BasicInterface;
		var handler:InvocationHandler = getBlankInvocationHandler();
		var owner:TTypeProxyFactory = this;
		handler.invoke = function(proxy, method:String, args:FunctionArguments) {
			owner["assertSame"](proxy1, proxy);
			owner["assertSame"]("toString", method);
			owner["assertSame"]("arg1", args[0]);
			owner["assertSame"]("arg2", args[1]);
		}
		proxy1 = BasicInterface(factory.createProxy(BasicInterface, handler));
		proxy1.toString("arg1", "arg2");
	}
	
	public function testInvocationPropagationWithClass(Void):Void {
		var factory:ProxyFactory = new TypeProxyFactory();
		var proxy1:PropertyValue;
		var handler:InvocationHandler = getBlankInvocationHandler();
		var owner:TTypeProxyFactory = this;
		handler["count"] = 0;
		handler.invoke = function(proxy, method:String, args:FunctionArguments) {
			owner["assertSame"](proxy1, proxy);
			if (this["count"] == 0) {
				owner["assertSame"]("toString", method);
				owner["assertSame"]("arg1", args[0]);
				owner["assertSame"]("arg2", args[1]);
			}
			if (this["count"] == 1) {
				owner["assertSame"]("getName", method);
				owner["assertSame"](args.length, 0);
			}
			this["count"]++;
		}
		proxy1 = PropertyValue(factory.createProxy(PropertyValue, handler));
		proxy1.toString("arg1", "arg2");
		proxy1.getName();
		assertSame(handler["count"], 2);
	}
	
}