import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.aop.proxy.MethodProxyFactory;
import org.as2lib.aop.proxy.SimpleMethodProxyFactory;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.proxy.ProxyConfig extends BasicClass {
	private static var methodProxyFactory:MethodProxyFactory;
	
	private function ProxyConfig(Void) {
	}
	
	public static function setMethodProxyFactory(factory:MethodProxyFactory):Void {
		methodProxyFactory = factory;
	}
	
	public static function getMethodProxyFactory(Void):MethodProxyFactory {
		if (ObjectUtil.isEmpty(methodProxyFactory)) {
			methodProxyFactory = new SimpleMethodProxyFactory();
		}
		return methodProxyFactory;
	}
}