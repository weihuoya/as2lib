<?
  require('class.inc.php');
  $homepageInfo = new HomepageInfo;
  $homepageInfo->title = "About";
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
          <h2>About the as2lib</h2>
          <div class="hr"></div>
          <div class="text">
            <h3>About the as2lib</h3>
            The as2lib is an opensource framework targeted to Macromedia Flash MX 2004+ developers. It offers support for basic idioms like event-handling, exception-handling, output-handling and reflections as well as different kinds of data holders and iterators. Also contained is a comprehensive set of IO classes.
            Our target is to offer support for almost every problem domain in future releases including connection-handling, file access, aop, regular expressions, ...<br />
            <br />
            <a href="download.php" title="Latest version of as2lib">Download our latest version</a>
          </div>
        </div>
        <br />
        <br />
        <br />
        <br />
        <br />
      </div>
<? include('footer.inc.php') ?>