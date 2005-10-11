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

import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.io.file.ResourceLoader;
import org.as2lib.io.file.LoadStartListener;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.LoadProgressListener;
import org.as2lib.io.file.LoadErrorListener;
import org.as2lib.data.holder.Map;

/**
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.io.file.ResourceLoaderProcess extends AbstractProcess
	implements LoadStartListener,
		LoadCompleteListener,
		LoadProgressListener,
		LoadErrorListener {
			
	private var resourceLoader:ResourceLoader;
	private var isFinished:Boolean;
	private var uri:String;
	private var method:String;
	private var parameter:Map;
			
	public function ResourceLoaderProcess(resourceLoader:ResourceLoader) {
		this.resourceLoader = resourceLoader;
		resourceLoader.addListener(this);
	}
	
	public function setUri(uri:String, method:String, parameter:Map):Void {
		this.uri = uri;
		this.method = method;
		this.parameter = parameter;
	}
	
	public function getResourceLoader(Void):ResourceLoader {
		return resourceLoader;
	}
	
	public function run() {
		isFinished = true;
		var uri:String = (arguments[0] instanceof String) ? arguments[0] : this.uri;
		var method:String = (arguments[1] instanceof String) ? arguments[1] : this.method;
		var parameter:Map = (arguments[2] instanceof Map) ? arguments[2] : this.parameter;
		resourceLoader.load(uri, method, parameter);
		working = !hasFinished();
	}

	public function onLoadStart(resourceLoader:ResourceLoader):Void {
		sendStartEvent();
	}

	public function onLoadComplete(resourceLoader:ResourceLoader):Void {
		finish();
	}

	public function onLoadProgress(resourceLoader:ResourceLoader):Void {
		sendUpdateEvent();
	}

	public function onLoadError(resourceLoader:ResourceLoader, errorCode:String, error):Boolean {
		interrupt(error);
		return true;
	}
}