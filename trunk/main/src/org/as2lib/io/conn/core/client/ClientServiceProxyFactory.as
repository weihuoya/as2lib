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
 
import org.as2lib.core.BasicInterface;
import org.as2lib.io.conn.core.client.ClientServiceProxy;

/**
 * ClientServiceProxyFactory acts as central provider of client service
 * proxies.
 *
 * @author Simon Wacker
 * @author Christoph Atteneder
 */
interface org.as2lib.io.conn.core.client.ClientServiceProxyFactory extends BasicInterface {
	
	/**
	 * @overload #getClientServiceProxyByUrl(String):ClientServiceProxy
	 * @overload #getClientServiceProxyByUrlAndType(String, Function)
	 */
	public function getClientServiceProxy();
	
	/**
	 * Returns a clien service proxy that is fully configured and ready
	 * for usage.
	 *
	 * @param url the full url to the service
	 * @return a configured client service proxy
	 */
	public function getClientServiceProxyByUrl(url:String):ClientServiceProxy;
	
	/**
	 * Returns a proxy that can be casted to the passed-in type (class or
     * interface).
	 *
	 * <p>The type is therefore normally the type of the 'remote' service
	 * you wanna call methods on.
	 *
	 * @param url the full url to the service
	 * @param type the type of the service
	 * @return a proxy that can be casted to the passed-in type
	 */
	public function getClientServiceProxyByUrlAndType(url:String, type:Function);
	
}