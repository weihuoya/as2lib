<?
  require('class.inc.php');
  $homepageInfo = new HomepageInfo;
  $homepageInfo->title = "Download";
  $homepageInfo->page = "download";
  $homepageInfo->path = "";
  include('header.inc.php');
?>
      <div id="sidebar">
        <div id="sidebarContent">
          <div class="contentArea">
            <h2>Related</h2>
            <div class="hr"></div>
            <ul class="links">
              <li><a href="nextRelease.php" title="What and When we plan our next release">Next Release</a></li>
              <li><a href="http://cvs.sourceforge.net/viewcvs.py/as2lib/" title="View CVS Support by Sourceforge (actual Version)">View CVS</a></li>
            </ul>
          </div>
        </div>
      </div>
      <div id="content">
        <div class="contentArea">
          <h2>Download</h2>
          <div class="hr"></div>
          <div class="text">
            <h3>Actual Release</h3>
            We actually have our first alpha release (0.1 alpha). This means the Software is in alpha stadium and needs still
            to be tested and there will be API changes (definitly).<br />
            <br />
            <a href="https://sourceforge.net/project/showfiles.php?group_id=94206" title="First release: 0.1 alpha" class="bigLink">0.1 alpha Download</a><br />
            <a href="features.php" title="Features of 0.1 alpha" class="bigLink">Features</a><br />
            <a href="roadmap.php" title="Roadmap for future releases." class="bigLink">Planned Future Releases - Roadmap</a>
          </div>
        </div>
      </div>
<? include('footer.inc.php') ?>