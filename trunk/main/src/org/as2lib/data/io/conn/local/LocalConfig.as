import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.io.conn.ConnectionFactory;
import org.as2lib.data.io.conn.local.LocalConnFactory;
import org.as2lib.data.io.conn.local.ServerRegistry;
import org.as2lib.data.io.conn.local.LocalServerRegistry;
import org.as2lib.data.io.conn.local.ServerFactory;
import org.as2lib.data.io.conn.local.LocalServerFactory;

class org.as2lib.data.io.conn.local.LocalConfig extends BasicClass {
	private static var connectionFactory:ConnectionFactory;
	private static var serverRegistry:ServerRegistry;
	private static var serverFactory:ServerFactory;
	
	private function LocalConfig(Void) {
	}
	
	public static function getConnectionFactory(Void):ConnectionFactory {
		if (ObjectUtil.isEmpty(connectionFactory)) {
			connectionFactory = new LocalConnFactory();
		}
		return connectionFactory;
	}
	
	public static function setConnectionFactory(factory:ConnectionFactory):Void {
		connectionFactory = factory;
	}
	
	public static function getServerRegistry(Void):ServerRegistry {
		if (ObjectUtil.isEmpty(serverRegistry)) {
			serverRegistry = new LocalServerRegistry();
		}
		return serverRegistry;
	}
	
	public static function setServerRegistry(registry:ServerRegistry):Void {
		serverRegistry = registry;
	}
	
	public static function getServerFactory(Void):ServerFactory {
		if (ObjectUtil.isEmpty(serverFactory)) {
			serverFactory = new LocalServerFactory();
		}
		return serverFactory;
	}
	
	public static function setServerFactory(factory:ServerFactory):Void {
		serverFactory = factory;
	}
}