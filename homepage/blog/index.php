<?php 
/* Don't remove these lines. */
$blog = 1;
require('wp-blog-header.php');
// Uncomment the next line if you want to track blog updates from weblogs.com
//include_once(ABSPATH.WPINC.'/links-update-xml.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head  profile="http://gmpg.org/xfn/1">
	<title><?php bloginfo('name'); ?><?php wp_title(); ?></title>
	
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<meta name="generator" content="WordPress <?php echo $wp_version; ?>" /> <!-- leave this for stats -->

	<style type="text/css" media="screen">
		@import url( <?php echo $siteurl; ?>/wp-layout.css );
		@import url(../css/screen.css);
	</style>
	
	<link rel="stylesheet" type="text/css" media="print" href="<?php echo $siteurl; ?>/print.css" />
	<link rel="alternate" type="text/xml" title="RDF" href="<?php bloginfo('rdf_url'); ?>" />
	<link rel="alternate" type="text/xml" title="RSS 2.0" href="<?php bloginfo('rss2_url'); ?>" />
	<link rel="alternate" type="text/xml" title="RSS .92" href="<?php bloginfo('rss_url'); ?>" />
	<link rel="alternate" type="application/atom+xml" title="Atom 0.3" href="<?php bloginfo('atom_url'); ?>" />
	
	<link rel="pingback" href="<?php bloginfo('pingback_url'); ?>" />
    <?php get_archives('monthly', '', 'link'); ?>
	<?php //comments_popup_script(); // off by default 
  ?>

</head>

<body>
<center>
      <table class="mainTable">
        <tr>
          <td class="logo" align="right"><a href="<?php echo $siteurl; ?>" title="<?php bloginfo('name'); ?>"><img src="../images/logo.gif" alt="<?php bloginfo('name'); ?>" class="imageLogo"/></a></td>
        </tr>
        <tr>
          <td valign="top">
            <table cellspacing="0" cellpadding="0" class="content">

              <colgroup>
                <col class="left"/>
                <col class="center"/>
                <col class="right"/>
              </colgroup>
              <tr>
                <td><img src="../images/borderTopLeft.gif" alt="" class="imageBorderTopLeft"/></td>
                <td><img src="../images/borderTopCenter.gif" alt="" class="imageBorderTopCenter"/></td>
                <td><div style="position:absolute"><img src="../images/borderTopRight.gif" alt="" class="imageBorderTopRight"/></div></td>

              </tr>
              <tr>
                <td><img src="../images/borderMiddleLeft.gif" class="imageBorderMiddleLeft" alt=""/></td>
                <td>
                  <table cellspacing="0" cellpadding="0" class="menuTable">
                    <tr>
                      <td valign="top">
                        <div class="menu">
                          <b>Categories</b>
                          <ul>
                          <?php list_cats(0, 'All', 'name'); ?>
                          </ul>
                          <b>Links</b>
                          <ul>
                          <?php get_links_list(); ?>
                          </ul>
                          <b>Search</b>
                          <form id="searchform" method="get" action="<?php echo $PHP_SELF;                                                    /*$siteurl."/".$blogfilename*/ ?>">
                          <input type="text" name="s" size="10" />
                          <input id="submit" type="submit" name="submit" value="go" class="submit"/>
                          </form>
                          <b>Archives</b>
                          <ul>
                            <?php get_archives('monthly'); ?>
                          </ul>
                          <div class="blogCalendar"><?php get_calendar(); ?><br>
                          <a href="<?php bloginfo('rss2_url'); ?>" title="Syndicate this site using RSS"><abbr title="Really Simple Syndication">RSS</abbr> 2.0</a>
                          <a href="<?php bloginfo('comments_rss2_url'); ?>" title="The latest comments to all posts in RSS">Comments</a>
                          <a href="http://wordpress.org" title="Powered by WordPress, state-of-the-art semantic personal publishing platform">WordPress</a>
                          </div>
                        </div>
                        <a href="http://sourceforge.net/projects/as2lib" class="externalIcons"><img src="http://sourceforge.net/sflogo.php?group_id=as2lib&amp;type=1" width="88" height="31" border="0" alt="SourceForge.net Logo"/></a>
                        <a href="http://validator.w3.org/check/referer" class="externalIcons"><img src="http://www.w3.org/Icons/valid-xhtml10" alt="Valid XHTML 1.0!" height="31" width="88" /></a>
                        <a href="http://jigsaw.w3.org/css-validator/" class="externalIcons"><img src="http://jigsaw.w3.org/css-validator/images/vcss" alt="Valid CSS!" height="31" width="88"/></a><br>
                        <br>
                      </td>
                      <td><img src="images/seperatorVertical.gif" class="imageSeparatorVertical" alt="" /></td>
                      <td id="blogContent">
                        <h1><?php blogInfo('description'); ?></h1>
                        <div class="eyecatcher"><?php if ($posts) { foreach ($posts as $post) { start_wp(); ?>
                        <?php the_date('','<b>','</b>'); ?><br> 
                        <div class="post">
                          <h3 class="storytitle" id="post-<?php the_ID(); ?>"><a href="<?php echo get_permalink() ?>" rel="bookmark" title="Permanent Link: <?php the_title(); ?>"><?php the_title(); ?></a></h3>
                          <div class="meta">Filed under: <?php the_category() ?> &#8212; <?php the_author() ?> @ <?php the_time() ?> <?php edit_post_link(); ?></div>
                          
                          <div class="storycontent">
                            <?php the_content(); ?>
                          </div>
                          
                          <div class="feedback">
                            <?php link_pages('<br />Pages: ', '<br />', 'number'); ?> 
                            <?php comments_popup_link('No Comments', 'Comments (1)', 'Comments (%)'); ?> 
                          </div>
                          
                          <!--
                          <?php trackback_rdf(); ?>
                          -->
                        
                        <?php include(ABSPATH . 'wp-comments.php'); ?>
                        </div>
                        
                        <?php } } else { // end foreach, end if any posts ?>
                        <p>Sorry, no posts matched your criteria.</p>
                        <?php } ?>
                        </div>
                      </td>
                    </tr>
                  </table>
                </td>
                <td><img src="../images/borderMiddleRight.gif" class="imageBorderMiddleRight" alt=""/></td>
              </tr>

              <tr>
                <td><img src="../images/borderBottomLeft.gif" alt="" class="imageBorderBottomLeft"/></td>
                <td><img src="../images/borderBottomCenter.gif" alt="" class="imageBorderBottomCenter"/></td>
                <td><img src="../images/borderBottomRight.gif" alt="" class="imageBorderBottomRight"/></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>

    </center>
  </body>
</html>