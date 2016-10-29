#!/bin/bash

testit () {
	echo "hi"
}
get_text () {
	titlebar="$1"; question="$2"; def_text="$3"; shift; shift; shift
	echo "$(zenity --entry --text "$question" --title "$titlebar" --entry-text "$def_text" "$@")"
}
confirm () {
	titlebar="$1"; question="$2"; shift; shift;
	echo "$(zenity --question --text "$question" --title "$titlebar" "$@")"
}
warn () {
	titlebar="$1"; warning="$2"; shift; shift;
	echo "$(zenity --warning --text "$warning" --title "$titlebar" "$@")"
}
notify () { # THIS DOES NOT WORK
	titlebar="$1"; message="$2"; shift; shift;
	# also try:  --window-icon=update.png 
	echo "$(zenity --notification --text "$message" "$@")"
}
show_text () {
	titlebar="$1"; text="$2"; shift; shift;
	zenity --info --text "$text" --title "$titlebar" "$@";
}
show_error () {
	titlebar="$1"; text="$2"; shift; shift;
	zenity --error --text "$text" --title "$titlebar" "$@";
}
date_picker () {
	titlebar="$1"; question="$2"; d="$3"; m="$4"; y="$5"
	shift; shift; shift; shift
	echo "$(zenity --calendar --text "$question" --day $d --month $m --year $y "$@")"
}
save_dialog () {
	titlebar="$1"; shift # text (--text) tag seem to be ignored
	echo "$(zenity --file-selection --save --confirm-overwrite --title "$titlebar" "$@")"
}
hslide_int_picker () {
	titlebar="$1"; question="$2"; min="$3"; max="$4"; val="$5"; step="$6"
	shift; shift; shift; shift; shift; shift;
	echo "$(zenity --scale --text "$question" --title "$titlebar" --min-value=$min --max-value=$max --value=$val --step $step "$@")"
}
radio_list () {
	titlebar="$1"; question="$2"; shift; shift;
	# the rest of args alternate with TRUE or FALSE and entry, like: 
	# TRUE Amazing FALSE Average FALSE "Difficult to follow" FALSE "Not helpful"
	echo "$(zenity --list --text "$question" --title "$titlebar" --radiolist --column "Pick" --column "Entry" "$@")"
}
check_list () {
	titlebar="$1"; question="$2"; shift; shift
	# the rest of args could be: 
	# TRUE "More pictures" TRUE "More complete post" FALSE "Includes Installation guidelines" FALSE "Create a forum for question queries" --separator="\n"
	# --separator=":" means the return will separate each selected answer with newlines
	echo "$(zenity --list --text "$question" --title "$titlebar" --checklist --column "Pick" --column "Entry" "$@")"
}
# ans="$(check_list "TITLE bar" "pick one, fool" TRUE "More pictures" TRUE "More complete post" FALSE "Includes Installation guidelines" FALSE "Create a forum for question queries" --separator="\n")"
# show_text "title bar" "$ans" 

# zenity --info --text '<span foreground="blue" font="32">Some\nbig text</span>\n\n<i>(it is also blue)</i>'


# gksudo lsof | tee >(zenity --progress --pulsate) >lsof.txt 
# gksudo lsof | zenity --text-info --width 530

