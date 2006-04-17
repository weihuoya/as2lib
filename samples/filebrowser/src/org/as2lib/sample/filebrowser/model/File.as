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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.sample.filebrowser.model.MalformedFilePathException;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.model.File extends BasicClass {
	
	private var path:String;
	private var extension:String;
	
	public function File(path:String) {
		if (path == null) {
			throw new IllegalArgumentException("Argument 'path' [" + path + "] must not be 'null' nor 'undefined'", this, arguments);
		}
		if (isPathMalformed(path)) {
			throw new MalformedFilePathException("File path '" + path + "' is malformed.", this, arguments);
		}
		this.path = path;
		this.extension = evaluateExtension();
	}
	
	private function isPathMalformed(path:String):Boolean {
		if (path == "") return true;
		if (path.indexOf(".") < 1) return true;
		if (path.indexOf(".") == path.length - 1) return true;
		return false;
	}
	
	private function evaluateExtension(Void):String {
		//return path.substring(path.indexOf("."));
		return path.substring(path.indexOf(".") + 1);
	}
	
	public function getPath(Void):String {
		return path;
	}
	
	public function getExtension(Void):String {
		return extension;
	}
	
}