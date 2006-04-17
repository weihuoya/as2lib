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
import org.as2lib.test.unit.TestCase;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.model.FileTest extends TestCase {
	
	public function FileTest(Void) {
	}
	
	public function testNewWithIllegalPath(Void):Void {
		try {
			var file:File = new File(null);
			fail("IllegalArgumentException was expected for path of value 'null'");
		} catch (exception:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithMalformedPath(Void):Void {
		try {
			var file:File = new File("");
			fail("MalformedFilePathException was expected for blank file path");
		} catch (exception:org.as2lib.sample.filebrowser.model.MalformedFilePathException) {
		}
		try {
			var file:File = new File("my/malformed/file_path");
			fail("MalformedFilePathException was expected for malformed file path 'my/malformed/file_path'");
		} catch (exception:org.as2lib.sample.filebrowser.model.MalformedFilePathException) {
		}
		try {
			var file:File = new File(".jpg");
			fail("MalformedFilePathException was expected for malformed file path '.jpg'");
		} catch (exception:org.as2lib.sample.filebrowser.model.MalformedFilePathException) {
		}
		try {
			var file:File = new File("file_path.");
			fail("MalformedFilePathException was expected for malformed file path 'file_path.'");
		} catch (exception:org.as2lib.sample.filebrowser.model.MalformedFilePathException) {
		}
	}
	
	public function testGetExtension(Void):Void {
		var file:File = new File("images/juggling.jpg");
		assertSame("extension should be 'jpg'", file.getExtension(), "jpg");
	}
	
	public function testGetPath(Void):Void {
		var file:File = new File("images/juggling.jpg");
		assertSame("path should be 'images/juggling.jpg'", file.getPath(), "images/juggling.jpg");
	}
	
}