/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.io.conn.ConnectionFactory;
import org.as2lib.data.io.conn.local.LocalConnFactory;
import org.as2lib.data.io.conn.local.ServerRegistry;
import org.as2lib.data.io.conn.local.LocalServerRegistry;
import org.as2lib.data.io.conn.local.ServerFactory;
import org.as2lib.data.io.conn.local.LocalServerFactory;

/**
 * LocalConfig is the fundamental configuration class for all classes in the org.as2lib.local
 * package.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */

class org.as2lib.data.io.conn.local.LocalConfig extends BasicClass {
	private static var connectionFactory:ConnectionFactory;
	private static var serverRegistry:ServerRegistry;
	private static var serverFactory:ServerFactory;
	
	/**
	 * Constructor isn´t necessary to be called, because only 
	 * static methods are availiable.
	 */
	private function LocalConfig(Void) {
	}
	
	/**
	 * Returns the ConnectionFactory instance currently used. 
	 * If no ConnectionFactory instance has been set manually
	 * a LocalConnFactory instance will be used.
	 *
	 * @return the ConnectionFactory instance used.
	 */
	public static function getConnectionFactory(Void):ConnectionFactory {
		if (ObjectUtil.isEmpty(connectionFactory)) {
			connectionFactory = new LocalConnFactory();
		}
		return connectionFactory;
	}
	
	/**
	 * Sets a new ConnectionFactory instance.
	 *
	 * @param factory the new ConnectionFactory instance
	 */
	public static function setConnectionFactory(factory:ConnectionFactory):Void {
		connectionFactory = factory;
	}
	
	/**
	 * Returns the ServerRegistry instance currently used. 
	 * If no ServerRegistry instance has been set manually
	 * a LocalServerRegistry instance will be used.
	 *
	 * @return the ServerRegistry instance used.
	 */
	public static function getServerRegistry(Void):ServerRegistry {
		if (ObjectUtil.isEmpty(serverRegistry)) {
			serverRegistry = new LocalServerRegistry();
		}
		return serverRegistry;
	}
	
	/**
	 * Sets a new ServerRegistry instance.
	 *
	 * @param registry the new ServerRegistry instance
	 */
	public static function setServerRegistry(registry:ServerRegistry):Void {
		serverRegistry = registry;
	}
	
	/**
	 * Returns the ServerFactory instance currently used. 
	 * If no ServerFactory instance has been set manually
	 * a LocalServerFactory instance will be used.
	 *
	 * @return the ServerFactory instance used.
	 */
	public static function getServerFactory(Void):ServerFactory {
		if (ObjectUtil.isEmpty(serverFactory)) {
			serverFactory = new LocalServerFactory();
		}
		return serverFactory;
	}
	
	/**
	 * Sets a new ServerFactory instance.
	 *
	 * @param factory the new ServerFactory instance
	 */
	public static function setServerFactory(factory:ServerFactory):Void {
		serverFactory = factory;
	}
}