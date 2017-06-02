#!/bin/bash
 

# @desc     This function allows us to benefit from a colored output for all svn commands
#
# @author   4wk- (https://stackoverflow.com/users/1077650/4wk)
# @version  0.2, adding more color and skipping svn commit
# 
function svn {
  # Skip the color script when running an svn commit.
  if [ "x$@" = "xci" ] || [ "x$@" =  "xcommit" ]
  then
    command svn "$@";
    return;
  fi

  # Pipe svn through awk to colorize its output.
  command svn "$@" | awk '
  BEGIN {
    cpt_c=0;
  }
  {
    if        ($1=="C") {
      cpt_c=cpt_c+1;
      print "\033[31m" $0 "\033[00m";  # Conflicts are displayed in red
    }
    else if   ($1=="M") {
      print "\033[31m" $0 "\033[00m";  # Modified in red
    }
    else if   ($1=="A") {
      print "\033[32m" $0 "\033[00m";  # Add in green
    }
    else if   ($1=="?") {
      print "\033[36m" $0 "\033[00m";  # New in cyan
    }
    else if   ($1=="D") {
      print "\033[31m" $0 "\033[00m";  # Delete in red
    }
    else if   ($1=="U") {
      print "\033[35m" $0 "\033[00m";  # Updated in light magenta
    }
    else if   ($1=="X") {
      print "\033[33m" $0 "\033[00m";  # No changes in yellow.
    }
    else if   ($1=="At" || $1 == "External") {
      print "\033[33m" $0 "\033[00m";  # Revision numbers in brown.
    }
    else                {
      print $0;                        # No color, just print the line
    }
  }
  END {
    print cpt_c, " conflicts are found.";
  }';
}
