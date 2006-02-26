/*
 Copyright aswing.org, see the LICENCE.txt.
*/
import org.aswing.awml.AwmlLoader;
import org.aswing.awml.AwmlParser;
import org.aswing.JFrame;

/**
 * AWML test class.
 *
 * @author Igor Sadovskiy
 */
class test.AwmlTest  {

	private var frame:JFrame;
	private var loader:AwmlLoader;
        
    public function AwmlTest() {
        loader = new AwmlLoader();
        loader.addActionListener(onAwmlLoaded, this);
        loader.load("../res/test.xml");
    }
    
    public static function main():Void{
    	//LogManager.setLogger(new SosLogger());
        //UIManager.setLookAndFeel(new WinXpLookAndFeel());
        Stage.scaleMode = "noScale";
        Stage.align = "T";
        try{
            trace("try AwmlTest");
            var p:AwmlTest = new AwmlTest();
        }catch(e){
            trace("error : " + e);
        }
    }

	private function onAwmlLoaded(target:AwmlLoader, awml:String):Void {
		frame = AwmlParser.parse(awml);
		frame.show();
		trace("done AwmlTest");
	} 
}
