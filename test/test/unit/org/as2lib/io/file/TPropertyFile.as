import org.as2lib.test.unit.TestCase;
import org.as2lib.io.file.PropertyFile;
import org.as2lib.io.file.SimpleFile;
import org.as2lib.io.file.FileListener;

class test.unit.org.as2lib.io.file.TPropertyFile extends TestCase implements FileListener {
	private var file:PropertyFile;
	public function setUp(Void):Void {
		file = new PropertyFile();
	}
	public function testFile(Void):Void {
		System.useCodepage = false;
		file.load("org/as2lib/io/file/propertyFile.txt");
		file.addListener(this);
		pause();
	}
	public function onLoad(Void):Void {
		trace(file.getEntry("count.lines", ["hi"]));
		resume();
	}
	public function tearDown(Void):Void {
		delete file;
	}
}