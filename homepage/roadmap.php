<?
  require('class.inc.php');
  $homepageInfo = new HomepageInfo;
  $homepageInfo->title = "Roadmap";
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
          <h2>Roadmap</h2>
          <div class="hr"></div>
          <div class="text">
            A long list of features until release 1.0 of as2lib already exists. This release provides a solid fundament for creating Rich Internet Applications with as2.
            <br />
            <h4>0.1 Basic as2 extensions (see <a href="features.php" title="Features of the as2lib">Featurelist</a>)</h4>
            <h4>0.2 Extended Programming Support</h4>
            <ul>
              <li>Enhanced File Access, includes Streamresponse, etc.</li>
              <li>Standardized Connection Handling (for Remoting, LocalConnection, WebServices, XMLSocket,....)</li>
              <li>Integrated Support for AOP</li>
              <li>Regular Expressions</li>
            </ul>
            <h4>0.3 Simple Application Support</h4>
            <ul>
              <li>Application Loading via Config Files</li>
              <li>Language File Support for Applications</li>
              <li>Session Handling for Userrelated Properties (Settings for Flash, Serverside, etc.)</li>
              <li>Environment related program switches (one programm many environments: In Browser, In Central, as Standalone Application)</li>
            </ul>
            <h4>0.4 Web Support</h4>
            <ul>
              <li>JavaScript access definition (easier access to JavaScript Methods by Flash)</li>
              <li>History management (System for easing handling of the History Problem)</li>
              <li>Extended Accessability support (Way to define WebAccessInitiative (WAI) compatible Flash-Pages )</li>
            </ul>
            <h4>0.5 GUI Definitions</h4>
            <ul>
              <li>A Graphical Component Definition.</li>
              <li>Predefined GUI Components.</li>
            </ul>
            <br />
            We plan to release one alpha, one beta and a final for every 0.* release. The timespan between each release should be about 12 weeks.
          </div>
        </div>
      </div>
<? include('footer.inc.php') ?>