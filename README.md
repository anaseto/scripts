Description
-----------

This repository contains some scripts. Details on usage and install are in
comments at the top of each script. Here is a summary:

+ `bookmarks.sh` defines a command `d` that allows to bookmark directories and
  then later jump to them using a fuzzy finder (by default
  [fzf](https://github.com/junegunn/fzf)).
+ `o` launches a fuzzy finder to select a file, and opens it using `xdg-open`
  by default or a custom command. The list of files is generated by git or
  fossil if current working directory is within a repository. The script can be
  integrated with other tools, such as vim.
