#!/bin/bash


# file="$1"

# [[ -z "$2" ]] && DST="_$file" || DST="$2"
# [[ -z "$3" ]] && thres="0.15%" || thres="$3"


# maxAmplitude="$(echo_max_amp $file)"



# # gain must be near 0db for sox silence suppression to work more reliably.
# over=`echo "$maxAmplitude>1.2" | bc`
# [ "$over" -ne "0" ] && printf "which is too loud. "
# under=`echo "$maxAmplitude<0.8" | bc` 
# [ "$under" -ne "0" ] && printf "which is too quiet."

# if [ "$over" -ne "0" ] || [ "$under" -ne "0" ] ; then 
# 	# Calculate multiplicator to raise amplitude to -0db
# 	multiplicator=$(perl -e "print 1 / $maxAmplitude")
# 	multiplicator="${multiplicator%\\n}" # like chomp($muliplicator) in perl
# 	printf "\nAdjusting volume by $multiplicator \n"
# 	amp_factor "$DST" $multiplicator
# else
# 	printf "which is acceptable."
# fi

# strip_leading_silence "$DST" "$thres"
# reverse_file "$DST"
# strip_leading_silence "$DST" "$thres"
# reverse_file "$DST"
# rm "$TMP"

## math functions ###----------------------------------------------------------

FP_SCALE=6

fpcalc () {
	result=`echo "scale=$FP_SCALE; $1" | bc`
	[[ $result == '.'* ]] && result="0$result"
	printf $result
}

## sox functions ###----------------------------------------------------------

prepare_output () {
	cp "$1" "sox_tmp_$1"
	cp "$1" "$2"
	[[ "$1" == "$2" ]] && cp "$1" "$1.bak"
}

get_max_amp () {
	# $1 is the file path
	local maxAmplitude=""
	maxAmplitude="$(sox "$1" -n stat 2>&1 | grep "^Maximum amplitude")"
	# maxAmplitude is now something like "Maximum amplitude:     0.935394"
	printf "${maxAmplitude##* }" # get the number at the end of the string
}
strip_leading_silence () {
	# $1 is the file path
	# $2 is the threshold: could be something like "-40d" or "0.15%""
	sox "$1" "sox_tmp_$1" silence 1 0 "sox_tmp_$1"; cp "$TMP" "$1"
}

get_amp_factor () {
	# $1 is the file path, $2 is the gain factor (multiplier)
	sox -v "$2" "$1" "sox_tmp_$1"; cp "sox_tmp_$1" "$1"
}
reverse_file () {
	# $1 is the file path
	sox "$1" "sox_tmp_$1" reverse; cp "sox_tmp_$1" "$1"
}

## macro functions ###----------------------------------------------------------
