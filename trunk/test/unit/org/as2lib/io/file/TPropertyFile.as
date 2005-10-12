
import org.as2lib.io.file.PropertiesFile;
import org.as2lib.io.file.TSimpleTextFile;
import org.as2lib.data.holder.Properties;
import org.as2lib.data.type.Byte;
import org.as2lib.io.file.TextFileFactory;
import org.as2lib.io.file.PropertiesFileFactory;

class org.as2lib.io.file.TPropertyFile extends TSimpleTextFile {
	
	public function getTextFileFactory(Void):TextFileFactory {
		return new PropertiesFileFactory();
	}
	
	public function testProperties(Void):Void {
		var file:PropertiesFile = new PropertiesFile("# Commenting\n"
			+" # Commenting again.\n"
			+"# comment.valid.entry=Entry\n"
			+"# Next line is a empty line\n"
			+"\n"
			+"using.normal=Answer\n"
			+"using.tabs	Answer\n"
			+"using.dots:Answer\n"
			+"using.normal.with.spaces = Answer.   \n"
			+"using.one.argument=Answer {0} is 2\n"
			+"using.more.arguments=Answer {0} is {1}\n"
			+"using.special.characters=Ich komme aus Österreich.\n"
			+"using.escaping.1=This is a '{0} escaped entry.\n"
			+"using.escaping.2=This is a ''escaped'' entry.\n"
			+"using.escaping.3=This is a ''' invalid entry.\n"
			+"using.escaping.4=This is a \\\\ really escaped entry.\n"
			+"using.escaping.5=This is a \\n really escaped entry.\n"
			+"using.double.names=This may not be available.\n"
			+"using.double.names=This should be available.\n"
			+"using.multiple.lines=This is content and as long no other content arrives this will stay the content. \\\n"
			+"  If you don''t believe me than its your fault. Your Problem and not mine!  \n"
			+"using.multiple.lines.with.same=This is content and as long no other contet arrives this will stay the content.\\n\\\n"
			+"You may handle '= with a different purpose but it will sound unrealistic if you planned to use it continuosly.", new Byte(10), "http://www.where.com");
		var props:Properties = file.getProperties();
		assertEquals(props.getProperty("not.existant"), "not.existant");
		assertEquals(props.getProperty("not.existant", "default"), "default");
		assertEquals(props.getProperty("using.normal"), "Answer");
		assertEquals(props.getProperty("using.tabs"), "Answer");
		assertEquals(props.getProperty("using.dots"), "Answer");
		assertEquals(props.getProperty("using.normal.with.spaces"), "Answer.");
		assertEquals(props.getProperty("using.one.argument"), "Answer {0} is 2");
		assertEquals(props.getProperty("using.special.characters"), "Ich komme aus Österreich.");
		assertEquals(props.getProperty("using.escaping.1"), "This is a '{0} escaped entry.");
		assertEquals(props.getProperty("using.escaping.2"), "This is a ''escaped'' entry.");
		assertEquals(props.getProperty("using.escaping.3"), "This is a ''' invalid entry.");
		assertEquals(props.getProperty("using.escaping.4"), "This is a \\ really escaped entry.");
		assertEquals(props.getProperty("using.escaping.5"), "This is a \n really escaped entry.");
		assertEquals(props.getProperty("using.double.names"), "This should be available.");
		assertEquals(props.getProperty("using.multiple.lines"), "This is content and as long no other content arrives this will stay the content. If you don''t believe me than its your fault. Your Problem and not mine!");
	}
}