#! /bin/sh

set -e;
#set -x;

#local path_this _hash _time;

path_this=$(dirname "${0}");
source "${path_this}"'/../cfg/ndx.bash';

if test ! -d "${path_this}"'/../site/struct/repo/orig';
then
	git clone --depth=3 "${repo_src_uri}" "${path_this}"'/../site/struct/repo/orig';
	cd "${path_this}"'/../site/struct/repo/orig';
	git update-server-info;
	#cd "${path_this}";
fi

#cp objects/pack/*.pack '../unpacked';
#git unpack-objects < ./*pack;
##rm ./*pack;

cd "${path_this}"'/../site/struct/repo/orig';
#for commitment in $(git log --oneline --pretty='format:%H|%ci' -3);
git log --oneline --pretty='format:%H|%ci' -3 |
while IFS= read -r commitment || [[ -n "${commitment}" ]];
do
	_hash=$(echo "${commitment}" | cut --delimiter='|' --fields='1' -);
	
	if test ! -d "${path_this}"'/../site/struct/repo/unpkg/'"${_hash}";
	then
		_time=$(echo "${commitment}" | cut --delimiter='|' --fields='2' -);
		
		git checkout "${_hash}";
		mkdir --parents "${path_this}"'/../site/struct/repo/unpkg/'"${_hash}";
		rsync -aHAXS --exclude='/.git' "${path_this}"'/../site/struct/repo/orig/' "${path_this}"'/../site/struct/repo/unpkg/'"${_hash}"'/';
		#rsync -aHAXS --exclude='/.git' './' '../unpkg/'"${_hash}"'/';
	fi;
	
	#touch --no-dereference --date="${_time}" '../unpkg/'"${_hash}";
	touch --no-dereference --date="${_time}" "${path_this}"'/../site/struct/repo/unpkg/'"${_hash}";
done;
