<?
  require('class.inc.php');
  $homepageInfo = new HomepageInfo;
  $homepageInfo->title = "Features";
  $homepageInfo->page = "about";
  $homepageInfo->path = "";
  include('header.inc.php');
?>
      <div id="sidebar">
        <div id="sidebarContent">
          <div class="contentArea">
            <h2>Modules</h2>
            <div class="hr"></div>
            <ul class="links">
              <li><a href="index.php" title="The main project">as2lib</a></li>
              <li><a href="as2libConsole.php" title="as2ib console for the world">as2lib console</a></li>
            </ul>
          </div>
          <div class="contentArea">
            <h2>Informations</h2>
            <div class="hr"></div>
            <ul class="links">
              <li><a href="missionStatement.php" title="Targets at our mission.">Mission Statement</a></li>
              <li><a href="roadmap.php" title="Map to our road to success">Roadmap</a></li>
              <li><a href="license.php" title="You are allowed to...">License</a></li>
              <li><a href="team.php" title="Team members of the as2lib">Team</a></li>
              <li><a href="features.php" title="Features of the as2lib">Features</a></li>
              <li><a href="http://www.sourceforge.net/projects/as2lib" title="Projectpage hosted on Sourceforge">Sourceforge Project</a></li>
            </ul>
          </div>
          <div class="contentArea">
            <h2>Links</h2>
            <div class="hr"></div>
            <a href="http://www.sourceforge.net/projects/as2lib" class="externalIcons"><img src="http://sourceforge.net/sflogo.php?group_id=as2lib&amp;type=1" width="88" height="31" border="0" alt="SourceForge.net Logo"/></a>
          </div>
        </div>
      </div>
      <div id="content">
        <div class="contentArea">
          <h2>Features</h2>
          <div class="hr"></div>
          <div class="text">
            <h3>Actual Features of as2lib</h3>
            <ul>
              <li><b>Event Handling:</b> containing the specification and standard implementations.</li>
              <li><b>Reflections:</b> System to obtain information about a class, its methods, its package and so on.</li>
              <li><b>Overloading:</b> Implementation of a Overloading API for as2.</li>
              <li><b>Exceptions:</b> Exceptions that contain a lot more information, than Flash's inbuilt exceptions.</li>
              <li><b>Output Handling:</b> Standardized Outputhandling for multiple devices.</li>
              <li><b>Data Holders:</b> Additionally to standard dataholders for as2 (e.g.: HashMap, Queue, Stack, ....) exist TypeWrappers (for type checking) and Iterators.</li>
              <li><b>Utils:</b> Utils for working with Object, Array, String and Class.</li>
              <li><b>Unit Testing:</b> We offer an own Unittesting API similar to asUnit.</li>
              <li><b>Speed Testing:</b> API to run performance tests.</li>
            </ul>
          </div>
        </div>
      </div>
<? include('footer.inc.php') ?>