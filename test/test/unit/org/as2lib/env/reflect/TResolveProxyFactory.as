import org.as2lib.test.unit.TestCase;
import org.as2lib.env.reflect.ResolveProxyFactory;
import org.as2lib.env.reflect.ProxyFactory;
import org.as2lib.env.reflect.InvocationHandler;
import org.as2lib.core.BasicInterface;

class test.unit.org.as2lib.env.reflect.TResolveProxyFactory extends TestCase {
	
	public function testTypeCast(Void):Void {
		var factory:ProxyFactory = new ResolveProxyFactory();
		assertNotNull(BasicInterface(factory.createProxy(BasicInterface, new InvocationHandler())));
	}
	
	public function testInvocationPropagation(Void):Void {
		var factory:ProxyFactory = new ResolveProxyFactory();
		var proxy1:BasicInterface;
		var handler:InvocationHandler = new InvocationHandler();
		var owner:TResolveProxyFactory = this;
		handler.invoke = function(proxy, method:String, args:FunctionArguments) {
			owner.assertSame(proxy1, proxy);
			owner.assertSame("getClass", method);
			owner.assertSame("arg1", args[0]);
			owner.assertSame("arg2", args[1]);
		}
		proxy1 = BasicInterface(factory.createProxy(BasicInterface, handler));
		proxy1.getClass("arg1", "arg2");
	}
	
}