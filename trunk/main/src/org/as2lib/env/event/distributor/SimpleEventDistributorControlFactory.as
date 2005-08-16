import org.as2lib.core.BasicClass;
import org.as2lib.env.event.distributor.EventDistributorControlFactory;
import org.as2lib.env.event.distributor.EventDistributorControl;
import org.as2lib.env.event.distributor.SimpleEventDistributorControl;

class org.as2lib.env.event.distributor.SimpleEventDistributorControlFactory extends BasicClass implements EventDistributorControlFactory {
	
	public function createEventDistributorControl(type:Function):EventDistributorControl {
		return new SimpleEventDistributorControl(type);
	}
}