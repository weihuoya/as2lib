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

import org.as2lib.sample.filebrowser.model.File;
import org.as2lib.sample.filebrowser.view.file.ErrorListener;
import org.as2lib.sample.filebrowser.view.View;

/**
 * @author Simon Wacker
 */
interface org.as2lib.sample.filebrowser.view.file.FileView extends View {
	
	public function show(file:File):Void;
	public function hide(Void):Void;
	public function addErrorListener(errorListener:ErrorListener):Void;
	
}