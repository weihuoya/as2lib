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
import org.as2lib.env.overload.Overload;
import org.as2lib.env.except.UnsupportedOperationException;

/**
 * @author Simon Wacker
 */
class org.as2lib.io.conn.core.client.AbstractClientServiceProxyFactory extends BasicClass {
	
	/**
	 * Private constructor.
	 */
	private function AbstractClientServiceProxyFactory(Void) {
	}
	
	/**
	 * @see ClientServiceProxyFactory#getClientServiceProxy()
	 */
	public function getClientServiceProxy() {
		var o:Overload = new Overload(this);
		o.addHandler([String], this["getClientServiceProxyByUrl"]);
		o.addHandler([String, Function], getClientServiceProxyByUrlAndType);
		return o.forward(arguments);
	}
	
	/**
	 * @throws UnsupportedOperationException
	 * @see ClientServiceProxyFactory#getClientServiceProxyByUrlAndType()
	 */
	public function getClientServiceProxyByUrlAndType(url:String, type:Function) {
		throw new UnsupportedOperationException("This operation is not supported by this client service proxy factory.", this, arguments);
	}
	
}