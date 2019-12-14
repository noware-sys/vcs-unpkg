#! /bin/sh

set -e;
#set -x;

#local path_this _hash _time;

#this_path=$(dirname "${0}");
this_file=$(basename "${0}");
#source "${this_path}"'/../cfg/ndx.bash';
#this_ver='0.1';

# 
# Prelude
# 

if test ${#} -lt 1;
then
	1>&2 printf 'Usage: '"${this_file}"': -option [val] [-option [val] [...]]''\n';
	1>&2 printf '  See `'"${this_file}"' -h`''\n';
	exit 1;
fi;

# other options
declare -a opt_oth;
while getopts d:s:o:h arg;
do
	case "${arg}" in
		# Destination
		'd')
			dest="${OPTARG}";
			;;
		
		# Source
		's')
			src="${OPTARG}";
			;;
		
		# Other options
		'o')
			opt_oth+=("${OPTARG}");
			;;
		
		# Help/About/Usage
		'h')
			printf "${this_file}"': ''Version control system commitments unpacker''\n';
			printf "${this_file}"' -option [val] [-option [val] [...]]''\n';
			printf '  -d path''\n';
			printf '          Folder, destination''\n';
			printf '  -s path''\n';
			printf '          Folder, source''\n';
			printf '  -o opt''\n';
			printf '            Additional parameter passed to the''\n';
			printf '          command which displays the commitments.''\n';
			printf '            May be specified multiple times.''\n';
			printf '            If it is specified multiple times,''\n';
			printf '          the order which its instances are''\n';
			printf '          specified in, is the order which they are''\n';
			printf '          passed in, to the command.''\n';
			printf '  -h''\n';
			printf '          Help/About/Usage''\n';
			#printf '  -V''\n';
			#printf '          Version''\n';
			exit 0;
			;;
		
		## Version
		#'V')
		#	printf "${this_ver}"'\n';
		#	exit 0;
		#	;;
		
		# Unrecognized option
		*)
			#1>&2 printf "${this_file}"': '"${arg}"': Unrecognized option. See above''\n';
			1>&2 printf "${this_file}"': Unrecognized option. See above''\n';
			exit 1;
			;;
	esac;
done;
shift $((OPTIND-1));

# Sanity verification
if test ! -e "${src}";
then
	1>&2 printf "${this_file}"': '"[""${src}""]"': No such file or directory';
	exit 1;
fi

#if test ! -e "${dest}";
#then
#	printf >&2 "${this_file}"': '"[""${dest}""]"': No such file or directory';
#	exit 1;
#fi

# Parsing
#if test -n "${max}";
#then
#fi


# 
# Main
# 

cd "${src}";
#git log --pretty='format:%H|%ci' "${opt_oth[@]}" |
while IFS= read -r commitment || test -n "${commitment}";
do
	#printf "::commitment:[${commitment}]"'\n';
	_hash=$(printf "${commitment}"'\n' | cut --delimiter='|' --fields='1' -);
	_time=$(printf "${commitment}"'\n' | cut --delimiter='|' --fields='2' -);
	
	git checkout "${_hash}";
	mkdir --parents "${dest}"'/'"${_hash}";
	rsync -aHAXS --exclude='/.git' "${src}"'/' "${dest}"'/'"${_hash}"'/';
	touch --no-dereference --date="${_time}" "${dest}"'/'"${_hash}";
#done;
done <<< $(git log --pretty='format:%H|%ci' "${opt_oth[@]}");

#printf "_hash:[${_hash}]\n";
#printf "_time[${_time}]\n";
