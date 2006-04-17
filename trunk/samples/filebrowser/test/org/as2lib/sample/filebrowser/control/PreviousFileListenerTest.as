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

import org.as2lib.sample.filebrowser.control.PreviousFileListener;
import org.as2lib.sample.filebrowser.control.Scene;
import org.as2lib.sample.filebrowser.view.NoSuchFileException;
import org.as2lib.test.mock.MockControl;
import org.as2lib.test.unit.TestCase;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.control.PreviousFileListenerTest extends TestCase {
	
	public function PreviousFileListenerTest(Void) {
	}
	
	public function testOnReleaseWithNoPreviousFile(Void):Void {
		var sceneControl:MockControl = new MockControl(Scene);
		var scene:Scene = sceneControl.getMock();
		scene.hasFiles();
		sceneControl.setReturnValue(true);
		scene.showPreviousFile();
		sceneControl.setThrowable(new NoSuchFileException("Should be catched by the previous file listener.", this, arguments));
		scene.showLastFile();
		sceneControl.replay();
		
		var listener:PreviousFileListener = new PreviousFileListener();
		listener.setScene(scene);
		listener.onRelease(null);
		
		sceneControl.verify();
	}
	
}