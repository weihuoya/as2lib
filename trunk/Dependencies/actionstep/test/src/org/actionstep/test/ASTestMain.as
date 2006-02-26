/* See LICENSE for copyright and terms of use */
 
import org.actionstep.ASDebugger;
import org.actionstep.test.*;

/**
 * This is the main entry point for all test classes.
 */
class org.actionstep.test.ASTestMain { 

  public static function main() {
    Stage.align="LT";
    Stage.scaleMode="noScale";
    ASDebugger.setLevel(ASDebugger.INFO);
    try
    {    
//      ASTestControls.test(); // Change this line to run other tests
      ASTestProgressIndicator.test();
    }
    catch (e:Error)
    {
      trace(e.message);
    }
  }
}
  