# beautifulSVN
##### Adds color to the output of svn commands, such like `svn status`, `svn update`, `svn diff myfile`. See [#Usage](#usage)
##### The original version of the script was posted by me on [stack*overflow*](https://stackoverflow.com/questions/8786400/svn-add-colors-on-command-line-svn-with-awk-in-bash)

---

### History
I initially wrote this snippet back in January 2012, for personal purpose. I wanted a beautiful colored output when I use `svn` commands, so I used the powerful `awk` programming language to manage this behavior. Basically, it just looks for specific patterns and prepend some non-printable char, interpreted by the term.

I was no idea this could be useful for others, but when I did post a snippet on StackOverFlow, @johnjohndoe had the great idea to bring it on GitHub.

After years of using this function on my side, I've decided it is time for me to contribute on GitHub, and to manage it all by myself ;)

### Usage
You can add the content of `beautifulSVN.sh` in any of your environment file such as `.bashrc` or `.profile` files;
Or you can also simply download the script, and add the following in your `.bashrc`:

```bash
if [ -f /path/to/beautifulSVN.sh ]; then
. /path/to/beautifulSVN.sh
fi
```

### Changelog
* v0.1 - January 2012: first time I share this snippet on stackoverflow
* v0.2 - January 2012: small contribution by [johnjohndoe](https://gist.github.com/johnjohndoe)
* v1.0 - From 2012 to 2017, I've made many improvements leaded by a daily usage of SVN in my company. And obviously, I didn't write them down :dash:. However, off the top of my head:
  * Specific handling for some sub-command, in particular svn prompts when the `svn update` leads to conflicts
  * Fixing the file sorting for `svn status` due to non-printable char
  * More svn sub-commands handled, such as `svn diff` now in color
  * Summary of conflicted / merged / missing files for more clearness
  * Script splits in two functions to make it smoother
