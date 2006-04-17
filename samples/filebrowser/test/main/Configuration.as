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

import org.as2lib.app.conf.AbstractConfiguration;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestSuiteFactory;
import org.as2lib.tool.test.unit.MainListener;

/**
 * @author Simon Wacker
 */
class main.Configuration extends AbstractConfiguration {
	
	public function Configuration(Void) {
	}
	
	public function init(movieClip:MovieClip):Void {
		var factory:TestSuiteFactory = new TestSuiteFactory();
		var runner:TestRunner = factory.collectAllTestCases().getTestRunner();
		runner.addListener(new MainListener(movieClip));
		runner.start();
	}
	
	public function setReferences(Void):Void {
		use(org.as2lib.sample.filebrowser.model.FileTest);
		use(org.as2lib.sample.filebrowser.view.file.FileViewMapTest);
		use(org.as2lib.sample.filebrowser.control.PreviousFileListenerTest);
	}

}