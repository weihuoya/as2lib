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
import org.as2lib.core.BasicInterface;

/**
 * 
 * @author Christoph Atteneder
 */

class org.as2lib.data.io.conn.ConnectorRequest extends BasicClass implements BasicInterface {
	private var host:String;
	private var path:String;
	private var method:String;
	private var args:Array;
	
	public function ConnectorRequest(host:String, path:String, method:String) {
		if(host != "" || host != null) this.host = host;
		if(path != "" || path != null) this.path = path;
		if(method != "" || method != null){
			this.method = method;
			this.args = new Array();
			for(var i=3; i<arguments.length; i++) {
				args.push(arguments[i]);
			}
		}
	}
	
	public function setHost(host:String):Void {
		this.host = host;
	}
	
	public function getHost(Void):String {
		return host;
	}
	
	public function setPath(path:String):Void {
		this.path = path;
	}
	
	public function getPath(Void):String {
		return path;
	}
	
	public function setMethod(method:String):Void {
		this.method = method;
	}
	
	public function getMethod(Void):String {
		return method;
	}
	
	public function setParams():Void {
		args = arguments;
	}
	
	public function getParams():Array {
		return args;
	}
}