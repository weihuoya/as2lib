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
import org.as2lib.data.io.conn.ConnectionFactory;
import org.as2lib.data.io.conn.Connection;
import org.as2lib.data.io.conn.local.LocalConn;
import org.as2lib.data.io.conn.local.LocalConfig;

/**
 * LocalConnFactory creates new Connection.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */

class org.as2lib.data.io.conn.local.LocalConnFactory extends BasicClass implements ConnectionFactory {
	public function LocalConnFactory(Void) {
	}
	
	/**
	 * @see org.as2lib.data.io.conn.ConnectionFactory
	*/
	public function getConnection(host:String):Connection {
		var result:Connection = new LocalConn(host);
		result.open();
		return result;
	}
}