<?
  require('class.inc.php');
  $homepageInfo = new HomepageInfo;
  $homepageInfo->title = "Next Release";
  $homepageInfo->page = "download";
  $homepageInfo->path = "";
  include('header.inc.php');
?>
      <div id="sidebar">
        <div id="sidebarContent">
          <div class="contentArea">
            <a href="download.php" title="Download page" class="levelUp">Back to Download</a>
          </div>
          <div class="contentArea">
            <h2>Related</h2>
            <div class="hr"></div>
            <ul class="links">
              <li><a href="nextRelease.php" title="What and When we plan our next release">Informations about the next release.</a></li>
              <li><a href="http://cvs.sourceforge.net/viewcvs.py/as2lib/" title="View CVS Support by Sourceforge (actual Version)">View CVS</a></li>
            </ul>
          </div>
        </div>
      </div>
      <div id="content">
        <div class="contentArea">
          <h2>Next Release</h2>
          <div class="hr"></div>
          <div class="text">
            <h3>What do we plan for the next release?</h3>
            The next release will contain an enhanced Unit-Testing System API as well as a I/O Package.
            <h3>When do we plan the next release?</h3>
            The next release (0.1 beta) shall take place within the next two weeks. (7-16 June)
          </div>
        </div>
      </div>
<? include('footer.inc.php') ?>