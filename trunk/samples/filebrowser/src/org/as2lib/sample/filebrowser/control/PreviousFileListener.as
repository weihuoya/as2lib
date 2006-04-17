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
import org.as2lib.sample.filebrowser.control.Scene;
import org.as2lib.sample.filebrowser.view.navigation.Button;
import org.as2lib.sample.filebrowser.view.navigation.ReleaseListener;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.control.PreviousFileListener extends BasicClass implements ReleaseListener {
	
	private var scene:Scene;
	
	public function PreviousFileListener(Void) {
	}
	
	public function setScene(scene:Scene):Void {
		this.scene = scene;
	}
	
	public function onRelease(button:Button):Void {
		if (scene.hasFiles()) {
			try {
				scene.showPreviousFile();
			} catch (exception:org.as2lib.sample.filebrowser.view.NoSuchFileException) {
				scene.showLastFile();
			}
		}
	}
	
}