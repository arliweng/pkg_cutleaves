#!/bin/sh
# req: pacman, grep, awk, cut
# by ArLi Weng, arliweng@gmail.com, last update: 20100512
# simple pkg_cutleaves on FreeBSD for ArchLinux

# conf file path here, for example: /etc/pkg_cutleaves.conf
_dir=`dirname $0`

if [ ${_dir} = "." ]
then
	_dir=`pwd`
fi

_conf="${_dir}/pkg_cutleaves.conf"
_conf_grps=`grep "@" $_conf | cut -d@ -f2`
_conf_pkgs=`grep -E "^[a-z]" $_conf`
_cmd=""

list() {
	_pkgs_qt=`pacman -Qttq`

	for _pkg_qt in $_pkgs_qt
	do
		_group=`pacman -Qi $_pkg_qt | grep "Groups" | awk '{print $3}'`
		filter_grps "$_group" "$_pkg_qt"
	done
}

filter_grps() {
	for _grp in $_conf_grps
	do
		if [ "$_grp" = "$1" ]
		then
			return 0
		fi
	done
	
	filter_pkgs "$2"
}

filter_pkgs() {
	for _pkg in $_conf_pkgs
	do
		if [ "$_pkg" = "$1" ]
		then
			return 0
		fi
	done
	
	hit_pkg "$1"
}

hit_pkg() {
	# pacman -Rsn "$1"
	_cmd="$_cmd $1"
	echo "$1"
}

LC_ALL=en_US.UTF-8 list
echo

if [ "$_cmd" = "" ]
then
	echo "clean !"
else
	if [ `id -u` == 0 ]
	then
		pacman -Rsn $_cmd
	else
		sudo pacman -Rsn $_cmd
	fi
fi
