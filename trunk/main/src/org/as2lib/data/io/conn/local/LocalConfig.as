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
import org.as2lib.data.io.conn.core.server.ServerRegistry;
import org.as2lib.data.io.conn.core.server.ServerFactory;
import org.as2lib.data.io.conn.local.server.LocalServerFactory;
import org.as2lib.data.io.conn.local.server.LocalServerRegistry;

/**
 * LocalConfig is the fundamental configuration class for all classes in
 * the org.as2lib.local package.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.data.io.conn.local.LocalConfig extends BasicClass {
	
	/** The used ServerRegistry */
	private static var serverRegistry:ServerRegistry;
	
	/** The used ServerFactory */
	private static var serverFactory:ServerFactory;
	
	/**
	 * Private constructor.
	 */
	private function LocalConfig(Void) {
	}
	
	/**
	 * Returns the ServerRegistry instance currently used. 
	 * If no ServerRegistry instance has been set manually
	 * a LocalServerRegistry instance will be used.
	 *
	 * @return the ServerRegistry instance used.
	 */
	public static function getServerRegistry(Void):ServerRegistry {
		if (!serverRegistry) serverRegistry = new LocalServerRegistry();
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
		if (!serverFactory) serverFactory = new LocalServerFactory();
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