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
import org.as2lib.sample.filebrowser.view.file.FileView;
import org.as2lib.sample.filebrowser.view.file.FileViewMap;
import org.as2lib.test.mock.MockControl;
import org.as2lib.test.unit.TestCase;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.view.file.FileViewMapTest extends TestCase {
	
	private var fileViewMap:FileViewMap;
	
	public function FileViewMapTest(Void) {
	}
	
	public function setUp(Void):Void {
		fileViewMap = new FileViewMap();
	}
	
	public function testPutFileViewWithIllegalFileExtension(Void):Void {
		var fileViewControl:MockControl = new MockControl(FileView);
		var fileView:FileView = fileViewControl.getMock();
		fileViewControl.replay();
		
		try {
			fileViewMap.putFileView(null, fileView);
			fail("IllegalArgumentException was expected to be thrown for a 'null' file extension");
		} catch (exception:org.as2lib.env.except.IllegalArgumentException) {
		}
		try {
			fileViewMap.putFileView("", fileView);
			fail("IllegalArgumentException was expected to be thrown for a blank string file extension");
		} catch (exception:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		fileViewControl.verify();
	}
	
	public function testPutFileViewWithNullFileView(Void):Void {
		var fileViewControl:MockControl = new MockControl(FileView);
		var fileView:FileView = fileViewControl.getMock();
		fileViewControl.replay();
		
		fileViewMap.putFileView("jpg", fileView);
		fileViewMap.putFileView("jpg", null);
		assertEmpty("file view for file extension 'jpg' should be removed", fileViewMap.findFileView("jpg"));
		
		fileViewControl.verify();
	}
	
	public function testPutFileViewMultipleTimesWithDifferentFileExtensions(Void):Void {
		var fileViewControl:MockControl = new MockControl(FileView);
		var fileView:FileView = fileViewControl.getMock();
		fileViewControl.replay();
		
		var fileView2Control:MockControl = new MockControl(FileView);
		var fileView2:FileView = fileView2Control.getMock();
		fileView2Control.replay();
		
		var fileView3Control:MockControl = new MockControl(FileView);
		var fileView3:FileView = fileView3Control.getMock();
		fileView3Control.replay();
		
		fileViewMap.putFileView("jpg", fileView);
		fileViewMap.putFileView("png", fileView2);
		fileViewMap.putFileView("flv", fileView3);
		assertSame("wrong file view for file extension 'jpg'", fileViewMap.findFileView("jpg"), fileView);
		assertSame("wrong file view for file extension 'png'", fileViewMap.findFileView("png"), fileView2);
		assertSame("wrong file view for file extension 'flv'", fileViewMap.findFileView("flv"), fileView3);
		
		fileViewControl.verify();
		fileView2Control.verify();
		fileView3Control.verify();
	}
	
	public function testFindFileViewWithDefaultFileView(Void):Void {
		var fileViewControl:MockControl = new MockControl(FileView);
		var fileView:FileView = fileViewControl.getMock();
		fileViewControl.replay();
		
		var defaultFileViewControl:MockControl = new MockControl(FileView);
		var defaultFileView:FileView = defaultFileViewControl.getMock();
		defaultFileViewControl.replay();
		
		fileViewMap.setDefaultFileView(defaultFileView);
		fileViewMap.putFileView("jpg", fileView);
		assertSame("wrong file view for file extension 'jpg'", fileViewMap.findFileView("jpg"), fileView);
		assertSame("file view for unknown file extension should be the default file view", fileViewMap.findFileView("png"), defaultFileView);
		
		fileViewControl.verify();
		defaultFileViewControl.verify();
	}
	
	public function testFindFileViewWithUnknownFileExtension(Void):Void {
		var fileViewControl:MockControl = new MockControl(FileView);
		var fileView:FileView = fileViewControl.getMock();
		fileViewControl.replay();
		
		fileViewMap.putFileView("jpg", fileView);
		assertEmpty("file view for file extension 'png' should not exist", fileViewMap.findFileView("png"));
		
		fileViewControl.verify();
	}
	
	public function testShowWithLegalFile(Void):Void {
		var fileControl:MockControl = new MockControl(File);
		var file:File = fileControl.getMock();
		file.getExtension();
		fileControl.setReturnValue("png");
		fileControl.replay();
		
		var fileViewControl:MockControl = new MockControl(FileView);
		var fileView:FileView = fileViewControl.getMock();
		fileView.hide();
		fileViewControl.replay();
		
		var fileView2Control:MockControl = new MockControl(FileView);
		var fileView2:FileView = fileView2Control.getMock();
		fileView2.hide();
		fileView2.show(file);
		fileView2Control.replay();
		
		var fileView3Control:MockControl = new MockControl(FileView);
		var fileView3:FileView = fileView3Control.getMock();
		fileView3.hide();
		//fileView3.show(file)
		fileView3Control.replay();
		
		fileViewMap.putFileView("jpg", fileView);
		fileViewMap.putFileView("png", fileView2);
		fileViewMap.putFileView("flv", fileView3);
		fileViewMap.show(file);
		
		fileControl.verify();
		fileViewControl.verify();
		fileView2Control.verify();
		fileView3Control.verify();
	}
	
}