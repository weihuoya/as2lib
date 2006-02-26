import org.actionstep.ASDebugger;
import org.actionstep.rails.ASRailsDriver;

class org.actionstep.rails.ASRailsMain {

  private static var driver:ASRailsDriver;

  public static function main() {
    Stage.align="LT";
    Stage.scaleMode="noScale";
    ASDebugger.setLevel(ASDebugger.INFO);
    try
    {
      driver = new ASRailsDriver();
      driver.connect();
    }
    catch (e:Error)
    {
      trace(e.message);
    }
  }

}
