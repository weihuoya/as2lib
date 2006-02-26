import org.actionstep.*;
import org.actionstep.menu.NSMenuView;

class org.actionstep.test.ASTestMenu2 {

  private static var m_app:NSApplication;
  private static var m_target:Object;

	public static function test():Void {
		//
		// Create window and app.
		//
		// Note the way we are creating the window. We MUST use lib/video.swf
		// as the content swf, so that we can access the Video object provided
		// within the swf.
		//
		m_target = new Object();
		m_target.showStatusAlertTimesDialog = function() {
		  trace("Got showStatusAlertTimesDialog");
		};
		m_app = NSApplication.sharedApplication();
		addMenuItemsToMenu(menuItems());

		//
		// Test boundaries, and draw a rect to see it in action
		//
		NSMenuView.setBounds(new NSSize(550, 400));
		var pt:NSPoint = NSMenu.rootMenu().window().frame().origin;
		var size:NSSize = NSMenuView.bounds();
		ASDraw.drawRect(_root, pt.x, pt.y, size.width, size.height, 0xFF0000, 100, .25);

		m_app.run();
	}

  private static function addMenuItemsToMenu(items:Array, menu:NSMenu) {
    if (menu == undefined) {
      menu = (new NSMenu()).initWithTitle("ROOT");
  		m_app.setMainMenu(menu);
    }
    var mi:NSMenuItem;
    for (var i:Number = 0;i<items.length;i++) {
      mi = menu.addItemWithTitleActionKeyEquivalent(items[i].name, items[i].action);
      if (items[i].enabled != undefined) {
        mi.setEnabled(items[i].enabled);
      }
      if (items[i].checked) {
        mi.setState(NSCell.NSOnState);
      }
      if (items[i].target) {
        mi.setTarget(items[i].target);
      }
      if (items[i].items) {
        var submenu:NSMenu = (new NSMenu()).initWithTitle(items[i].name);
        addMenuItemsToMenu(items[i].items, submenu);
        menu.setSubmenuForItem(submenu, mi);
      }
    }
  }

  private static function menuItems():Array {
    return [
      {name:"Map Background", items:[
        {name:"Country Outlines", checked:true},
        {name:"Day/Night Shading"},
        {name:"Color Coded Countries & Names"}
        ]
      },
      {name:"Flight Aids", items:[
        {name:"All Airfields"},
        {name:"Navaids"},
        {name:"Waypoints"},
        {name:"Action Points"},
        {name:"PIREPS"},
        {name:"AIREPS"}
        ]
      },
      {name:"File", items:[
        {name:"Open"},
        {name:"Close"}
        ]
      },
      {name:"User Preferences", items:[
        {name:"Set Status Alert Times", target:m_target, action:"showStatusAlertTimesDialog"},
        {name:"Set Special Notifications", target:m_target, action:"showSpecialNotificationsDialog"}
        ]
      },
      {name:"Planning Docs", items:[
        {name:"ATO", target:m_target, action:"showATODialog"},
        {name:"TACC CHIT", enabled:false},
        {name:"DCO Setup File", enabled:false},
        {name:"Receiver Electronic Mission Folder"},
        {name:"Tanker Electronic Mission Folder"},
        {name:"Flight Plans", items:[
          {name:"Receivers", items:[
            {name:"Flight Plan"},
            {name:"Winded L-48h"},
            {name:"Winded L-24h"},
            {name:"Winded L-10h"},
            {name:"Winded L-4h"}
            ]
          },
          {name:"Tanker Petro 81 ", items:[
            {name:"Flight Plan"},
            {name:"Winded L-48h"},
            {name:"Winded L-24h"},
            {name:"Winded L-10h"},
            {name:"Winded L-4h"}
            ]
          },
          {name:"Tanker Petro 82 ", items:[
            {name:"Flight Plan"},
            {name:"Winded L-48h"},
            {name:"Winded L-24h"},
            {name:"Winded L-10h"},
            {name:"Winded L-4h"}
            ]
          }
          ]
        },
        {name:"Tanker Flight Plan"},
        {name:"Tanker Winded Flight Plan"}
        ]
      },
      {name:"Print", items:[
        {name:"Print Map"},
        {name:"Print Map with Grid Lines"},
        {name:"Print Map with CMEF"}
        ]
      },
      {name:"Tools", items:[
        {name:"GDSS"},
        {name:"ADIS"},
        {name:"CAMPS"},
        {name:"FalconView"},
        {name:"GAMAT"}
        ]
      },
      {name:"Help", items:[
        {name:"About CATS"}
        ]
      }
    ];
  }
}