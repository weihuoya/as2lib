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
import org.as2lib.data.io.conn.core.client.ClientServiceProxy;

/**
 * Interface for standardized ServiceFactories.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
interface org.as2lib.data.io.conn.core.client.ClientServiceProxyFactory extends BasicInterface {
	
	/**
	 * @overload #getServiceProxyByUrl()
	 * @overload #getServiceProxyByUrlAndInterface()
	 */
	public function getServiceProxy();
	
	/**
	 * Returns a ClientServiceProxy instance that is fully configured and ready
	 * for usage.
	 * 
	 * @param url the full url to the service
	 * @return an instance of type ClientServiceProxy
	 */
	public function getServiceProxyByUrl(url:String):ClientServiceProxy;
	
	/**
	 * Returns a proxy that can be casted to the given interface.
	 *
	 * @param url the full url to the service
	 * @param interfaze the interface of the service
	 * @return a proxy that can be casted to the given interface
	 */
	public function getServiceProxyByUrlAndInterface(url:String, interfaze:Function);
	
}