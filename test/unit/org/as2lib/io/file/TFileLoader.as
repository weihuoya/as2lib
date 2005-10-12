import org.as2lib.test.unit.TestCase;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.File;
import org.as2lib.io.file.ResourceNotLoadedException;
import org.as2lib.test.mock.MockControl;
import org.as2lib.data.type.Byte;
import org.as2lib.io.file.FileFactory;
import org.as2lib.app.exec.Executable;
import org.as2lib.app.exec.Call;
import org.as2lib.io.file.ResourceLoader;
import org.as2lib.app.exec.Process;

class org.as2lib.io.file.TFileLoader extends TestCase implements ResourceListener, ProcessListener {
	
	private static var ROOT = "org/as2lib/io/file/";
	private static var TEST_CONTENT = ROOT+"testContent.txt";
	private static var INVALID_FILE = ROOT+"notExistant.txt";
	
	private var progressExpected:Boolean  = false;
	private var fileNotFoundExpected:Call;
	private var fileNotFoundOccured:Boolean = false;
	private var loadCallBack:Executable;
	private var fileControl:MockControl;
	private var file:File;
	private var fileLoader:FileLoader;
	private var fileFactoryControl:MockControl;
	private var fileFactory:FileFactory;
	
	public function onFileProgress(l:FileLoader):Void {
		if (!progressExpected) {
			fail("Unexpected .onProgress error occured");
		} else {
			assertSame("Passed FileLoader in onProgress should match FileLoader that starts",
				l, fileLoader);
		}
	}
	public function onResourceProgress(l:ResourceLoader):Void {
		if (!progressExpected) {
			fail("Unexpected .onProgress error occured");
		} else {
			assertSame("Passed FileLoader in onProgress should match FileLoader that starts",
				l, fileLoader);
		}
	}
	
	public function onFileNotFound(uri:String):Void {
		if (!fileNotFoundExpected) {
			fail("Unexpected .onFileNotFound error for file '"+uri+"' occured");
		} else {
			fileNotFoundExpected.execute(uri);
		}
	}
	
	public function onResourceNotFound(uri:String):Void {
		if (!fileNotFoundExpected) {
			fail("Unexpected .onFileNotFound error for file '"+uri+"' occured");
		} else {
			fileNotFoundExpected.execute(uri);
		}
	}
	
	public function onFileLoad(file:File):Void {
		if (fileNotFoundExpected != null) {
			fail(".onLoad occured but .onFileNotFound was expected");
		} else {
			if (!loadCallBack) {
				fail("Unexpected .onLoadEvent occured for file '"+file.getLocation()+"'");
			} else {
				loadCallBack.execute(file);
			}
		}
	}
	
	public function onResourceLoad(fileLoader:ResourceLoader):Void {
		if (fileNotFoundExpected != null) {
			fail(".onLoad occured but .onFileNotFound was expected");
		} else {
			if (!loadCallBack) {
				fail("Unexpected .onLoadEvent occured for file '"+fileLoader.getUri()+"'");
			} else {
				loadCallBack.execute(file);
			}
		}
	}
	
	/**
	 * Validates if a invalid file throws a exception.
	 */
	public function testInValidFileSource() {
		fileFactoryControl = new MockControl(FileFactory);
		fileFactory = fileFactoryControl.getMock();
		fileFactoryControl.setArgumentsMatcher();
		fileFactoryControl.setReturnValueByValue(file);
		fileFactoryControl.replay();
		
		var fileLoader = new FileLoader(fileFactory);
		fileLoader.setUri(INVALID_FILE);
		
		fileNotFoundExpected = new Call(this, invalidNotFound);
		fileLoader.addListener(this);
		startProcess(fileLoader);
	}
	
	private function invalidNotFound(uri) {
		fileFactoryControl.verify();
		assertEquals("The URI that has not been found should match the uri that"
			+" should be loaded", uri, INVALID_FILE);
	}
	
	/**
	 * Validates if a valid file can be loaded proper.
	 */
	public function testValidFileSource() {
		fileControl = new MockControl(File);
		file = fileControl.getMock();
		fileControl.replay();
		
		fileFactoryControl = new MockControl(FileFactory);
		fileFactory = fileFactoryControl.getMock();
		fileFactory.createFile("testContent", new Byte(11), TEST_CONTENT);
		fileFactoryControl.setArgumentsMatcher();
		fileFactoryControl.setReturnValueByValue(file);
		fileFactoryControl.replay();
		
		fileLoader = new FileLoader(fileFactory);
		assertThrows("File should not be available before loading",
			ResourceNotLoadedException, fileLoader, fileLoader.getFile, []);
		fileLoader.setUri(TEST_CONTENT);
		fileLoader.addListener(this);
		loadCallBack = new Call(this, onValidLoadTest);
		
		progressExpected = true;
		startProcess(fileLoader);
	}
	
	private function onValidLoadTest(file:File) {
		assertEquals("The file should be 100% loaded", fileLoader.getPercentage(), 100);
		assertFalse("The file should not be started anymore", fileLoader.hasStarted());
		assertTrue("The file should be finished", fileLoader.hasFinished());
		assertSame("The resulted file should match the generated file", file, this.file);
		fileControl.verify();
		fileFactoryControl.verify();
	}
}