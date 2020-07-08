#!/bin/bash
 

# @tl;dr    Allow colored output for most svn commands    
# @desc     This script is now split in 2 functions. 
# 	    1) The first one, svn() allows us to make specific process for some svn subcommands, such as svn commit or svn update
# 	    2) The second one, beautifulSVN(), manage the colored output. We Pipe svn through awk to colorize the output.
# @author   4wk- (https://stackoverflow.com/users/1077650/4wk)
# @version  1.1, stable
# 
svn () {
  # IMPORTANT: if it's an update, we have to prevent SVN to prompt in case of conflict
  # svn indeed prompts things like: 
  # 	Conflict discovered in 'test.txt'.
  # 	Select: (p) postpone, (df) diff-full, (e) edit,
  # 	        (mc) mine-conflict, (tc) theirs-conflict,
  # 		(s) show all options:
  # then open a text editor.
  if [ "x$1" == "xup" ] || [ "x$1" == "xupdate" ]; then
    shift 1;
    # NB: --accept postpone is not enough to avoid all svn prompts
    command svn update --non-interactive "$@" | beautifulSVN;
  elif [ "x$1" = "xst" ] || [ "x$1" = "xstatus" ]; then
    # For svn status, we want to fix the messed sort brought by colors
    command svn "$@" | LC_ALL=C sort | beautifulSVN;
  elif [ "x$1" = "xstat" ] \
    || [ "x$1" = "xadd" ] \
    || [ "x$1" = "xdiff" ] \
    || [ "x$1" = "xco" ] || [ "x$1" = "xcheckout" ] \
    || [ "x$1" = "xdel" ] || [ "x$1" = "xdelete" ] \
    || [ "x$1" = "xrm" ] || [ "x$1" = "xremove" ] \
    || [ "x$1" = "xmv" ] || [ "x$1" = "xmove" ] \
    || [ "x$1" = "xren" ] || [ "x$1" = "xrename" ]; then
    command svn "$@" | beautifulSVN;
  else
    command svn "$@";
  fi
}

beautifulSVN () {
  awk '
    BEGIN {
      cpt_c=0;
      cpt_g=0;
      cpt_m=0;
    }
    {
      if ($1=="C") {
        cpt_c=cpt_c+1;
        print "\033[31m" $0 "\033[00m";                 # Conflicts are displayed in red
      }
      else if ($1=="M") {
        print "\033[36m" $0 "\033[00m";                 # Modified in light blue
      }
      else if ($1=="A") {
        print "\033[32m" $0 "\033[00m";                 # Add in green
      }
      else if ($1=="?") {
        print $0;                                       # New : no color
      }
      else if ($1=="D") {
        print "\033[31m" $0 "\033[00m";                 # Delete in red
      }
      else if ($1=="U") {
        print "\033[36m" $0 "\033[00m";                 # Updated in light blue
      }
      else if ($1=="G") {
        cpt_g=cpt_g+1;
        print "\033[33m" $0 "\033[00m";                 # Merged in yellow
      }
      else if ($1=="X") {
        print "\033[33m" $0 "\033[00m";                 # No changes in yellow
      }
      else if ($1=="!") {
        cpt_m=cpt_m+1;
        print "\033[31m" $0 "\033[00m";                 # Missing files in red
      }
      else if ($1=="At" || $1 == "External" || $1 == "Updated") {
        print "\033[33m" $0 "\033[00m";                 # Revision numbers in brown
      }
      # From there, this is about the svn diff
      else if ($1=="Index:" || $1=="+++" || $1=="---") {
        print "\033[32m" $0 "\033[00m";                 # Headline of svn diff in green
      }
      else if ($1=="@@") {
        print "\033[33m" $0 "\033[00m";                 # Modified line of svn diff in brown
      }
      else if ($0 ~ /^\+/) {
        print "\033[36m" $0 "\033[00m";                 # New line of svn diff in lightcyan
      }
      else if ($0 ~ /^\-/) {
        print "\033[35m" $0 "\033[00m";                 # Old line of svn diff in lightpurple
      }
      else {
        print $0;                                       # No color, just print the line
      }
    }
    END {
      if (cpt_g != 0) {
        print "\033[1;35m" "########" "\033[00m";
        print "\033[33m", cpt_g, "\033[00m", " merged files.";
      }
      if (cpt_m != 0) {
        print "\033[1;35m" "########" "\033[00m";
        print "\033[31m", cpt_m, "\033[00m", " missing files.";
      }
      if (cpt_c != 0) {
        print "\033[1;35m" "########" "\033[00m";
        print "\033[31m", cpt_c, "\033[00m", " conflicted files.";
      }
    }
  ';
}
