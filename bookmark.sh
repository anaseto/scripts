# USAGE: d [b]
#
# The function jumps to bookmarked directory selected by user with fzf.  If
# argument "b" is provided, current directory is bookmarked.
#
# The D_BOOKMARKS variable can be set to control bookmarks file location. The
# D_FUZZY_FINDER variable can be set to use a custom fuzzy finder (default is
# "fzf").
#
# The bookmarks file is kept sorted by usage, to allow easy removal by hand of
# unused bookmarks.
#
# Install: just source this file in your shell rc file.
d() {
	local cmd="$1"
	local bookmarks_file="${D_BOOKMARKS:-"$HOME/.d_bookmarks"}"
	local lock_file="${bookmarks_file}.lock"
	if [ ! -f "$bookmarks_file" ]; then
		touch "$bookmarks_file"
	fi
	local file
	if [ "$cmd" = "b" ]; then
		file="$(pwd)"
	elif [ -n "$cmd" ]; then
		echo "d: unknown argument: '$cmd'. Expected 'b' or no argument." >&2
		return 1
	else
		file="$(<"$bookmarks_file" ${D_FUZZY_FINDER:-fzf --tac})"
	fi
	if [ ! -d "$file" ]; then
		return
	fi
	cd "$file" || {
		echo "d: could not enter '$file' directory" >&2
		return 1
	}
	if mkdir "$lock_file" > /dev/null 2>&1; then
		# put $file at the end of the bookmarks file,
		# to keep it sorted by last time usage.
		perl -i.back -ne 'BEGIN{$f = quotemeta(shift);} print unless /^$f$/;' \
			"$file" "$bookmarks_file" &&
		echo "$file" >> "$bookmarks_file" ||
			echo "d: something went wrong updating bookmarks file" >&2
		rmdir "$lock_file" || {
			echo "d: could not remove lock file '$lock_file'" >&2
			return 1
		}
	else
		echo "d: lock file $lock_file already present" >&2
		return 1
	fi
}
