import org.as2lib.core.BasicClass;
import org.as2lib.env.event.distributor.EventDistributorControlFactory;
import org.as2lib.env.event.distributor.EventDistributorControl;
import org.as2lib.env.event.distributor.SimpleConsumableEventDistributorControl;

class org.as2lib.env.event.distributor.SimpleConsumableEventDistributorControlFactory extends BasicClass implements EventDistributorControlFactory {
	public function createEventDistributorControl(type:Function):EventDistributorControl {
		return new SimpleConsumableEventDistributorControl(type);
	}
}