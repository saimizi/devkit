#!/bin/bash

# This tool is supposed to be run as current shell function.
# so all varibles used will be the environment variable of current shell and
# attention should be paid


# unset all variables here firstly to clear the old values.
unset smake_conf_top
unset smake_conf_file
unset smake_env
unset -f smake
unset -f smake_init
unset -f smake_list
unset -f smake_clear_config_settings
unset -f smake_forgetme
unset -f smake_is_broken

smake_forgetme(){
		unset smake_conf_top
		unset smake_conf_file
		unset smake_env
		unset -f smake
		unset -f smake_init
		unset -f smake_list
		unset -f smake_clear_config_settings
		unset -f smake_forgetme
}

smake_conf_top=`pwd`
smake_env=.smake
omake=/usr/bin/make

if [[ $smake_conf_top =~ "-" ]];then
	echo "smake can not be configured under a directory that has \"-\" in pathname."
	return
fi

# if both saved env file and .config exist,restore it from env file.
# otherwise remove env or .config

if [ -e ${smake_env} ];then
	if [ -e .config ];then
		smake_conf_file=`cat ${smake_env}`
		echo "Found config: $smake_conf_file"
	else
		rm ${smake_env}
	fi
else
	if [ -e .config ];then
		echo "Remove .config"
		rm .config 2>/dev/null
	fi
fi


# return value: 
# 0 means success, that is "smake is broken"
smake_is_broken(){
	local ret=0
	local reason=
	local e_conf_file=0
	local e_config=0
	local e_env=0


	while (true) 
	do
		if [ "x$smake_conf_top" = "x" -o ! -d $smake_conf_top ];then
			reason="Invalid smake_conf_top."
			break
		fi

		if [ "x$smake_conf_file" != "x" ];then
			e_conf_file=1
		else
			e_conf_file=0
		fi

		if [ -f $smake_conf_top/.config ];then
			e_config=1
		else
			e_config=0
		fi

		if [ -f $smake_conf_top/${smake_env} ];then
			e_env=1
		else
			e_env=0
		fi

		reason="smake_conf_file: $e_conf_file .config: $e_config e_env: $e_env"

		if [ "x$smake_conf_file" = "x" -a  -f $smake_conf_top/.config ];then
			break
		fi

		if [ "x$smake_conf_file" != "x" -a ! -f $smake_conf_top/.config ];then
			break
		fi

		if [ "x$smake_conf_file" = "x" -a  -f $smake_conf_top/${smake_env} ];then
			break
		fi

		if [ "x$smake_conf_file" != "x" -a ! -f $smake_conf_top/${smake_env} ];then
			break
		fi

		ret=1 
		break;
	done 

	if [ $ret -eq 0 ]; then
		smake_clear_config_settings
		echo "smake environment borken detected ($reason)."
		echo "please"
		echo "1. run \"smake smake_clear_config_settings\"."
		echo "2. run \"smake forgetme\"."
	fi

	return $ret
}

smake_clear_config_settings(){
	if [ "x$smake_conf_top" != "x" ];then
		smake_conf_file=""
		mv ${smake_conf_top}/.config ${smake_conf_top}/.config.old 2>/dev/null
		rm ${smake_conf_top}/$smake_env 2>/dev/null
	fi
}

smake_list(){
	local idx
	local config_files
	local ret=1

	if (smake_is_broken) then
		echo "smake environment borken. clear smake settings..."
		smake_clear_config_settings
		echo "Done, run \"smake forgetme\"."
		return $ret;
	fi

	config_files=`find ${smake_conf_top}/bconf/configs/*_defconfig | awk 'BEGIN{FS="/"}{print $NF}'`
	if [ "x$config_files" = "x" ];then
		echo "No configure files found."
		return $ret;
	fi

	echo 
	echo "Possible default configuration:"
	echo
	idx=1
	for tp in $config_files
	do
		if [ "x$smake_conf_file" = "x$tp" ]; then
			echo "->$idx) $tp"
		else
			echo "  $idx) $tp"
		fi
		idx=`echo $idx + 1 | bc`
	done
	
	echo
	echo "you can use smake init to select configuration."
	echo

	ret=0
	return $ret
}

smake_init(){
	local idx
	local config_f
	local config_files
	local ret=1

	if ( smake_is_broken ) then
		echo "smake environment borken. clear smake settings..."
		smake_clear_config_settings
		echo "Done, run \"smake forgetme\"."
		return $ret;
	fi

	if [ "x$smake_conf_file" != "x" ];then
		echo
		echo -e "Current configuration has been set to following \n(run \"smake info\")"
		echo
		echo "  $smake_conf_file"
		echo
		echo -e "If you want to reconfig to a new one,\nrun \"smake distclean\" first."
		echo
		return $ret
	fi

	cd $smake_conf_top

	if [ "x$1" != "x"  ];then
		if [[ ! $1 =~ ^[0-9]+$ ]];then
			$omake BR2_EXTERNAL=../bconf $1 O=.. -C buildroot
			if [  -f .config ];then
				smake_conf_file=$1
				echo
				echo "$smake_conf_file is selected."
				echo

				echo $smake_conf_file > ${smake_conf_top}/${smake_env}
				ret=0
			else
				smake_clear_config_settings
				ret=1
			fi
			return $ret
		fi
	fi

	config_files=`ls bconf/configs`
	if [ "x$config_files" = "x" ];then
		echo "No configure files found."
		return $ret;
	fi

	if [ "x$1" == "x" ];then
		smake_list
		echo -n "Please select configuration(1-n), or press Enter to make a new cofig:"
		read sel
	else
		sel=$1
	fi

	if [ "x$sel" == "x" ];then
		$omake BR2_EXTERNAL=../bconf menuconfig O=.. -C buildroot
		if [ -f .config ];then
			$omake savedefconfig
			echo 
			echo "New created configuration (defconfig) created, move it to bconf/configs with a meaningful name."
			echo "Seletct it by running smake init again."
		fi
		smake_clear_config_settings
		ret=0
		return $ret
	fi

	if [[ ! $sel =~ ^[0-9]+$ ]];then
		echo "Wrong selection."
		return $ret
	fi

	idx=1
	config_f=""
	for tp in $config_files
	do
		if [ $idx -eq $sel ];then
			config_f=$tp
			break;
		fi
		idx=`echo $idx + 1 | bc`
	done
	
	if [ "x$config_f" != "x" ];then
		$omake BR2_EXTERNAL=../bconf $config_f O=.. -C buildroot
		if [  -f .config ];then
			smake_conf_file=$config_f
			echo
			echo "$smake_conf_file is selected."
			echo

			echo $smake_conf_file > ${smake_conf_top}/${smake_env}
			ret=0
		else
			smake_clear_config_settings
			ret=1
		fi
	fi

	return $ret;
}


smake(){
	local here
	local package
	local package_matched
	local sel

	if [ "x$1" = "xforgetme" ];then
		smake_forgetme	
		return
	fi

	if [ "x$1" = "x--help" -o  "x$1" = "xhelp" ];then
		echo "smake [top|init|conf|forgetme|Buildroot make command]"
		echo -e "\t top     : goto smake top directory."
		echo -e "\t init    : setup build environment."
		echo -e "\t list    : list default configuration files"
		echo -e "\t info    : show conf file path."
		echo -e "\t forgetme: clear smake environment."
		return
	fi

	here=`pwd`
	package=""

	if (smake_is_broken) then
		return $ret
	fi

	cd $smake_conf_top

	if [ "x$1" = "xtop" ];then
		return
	fi

	if [ "x$1" = "xinit" ];then
		smake_init $2
		return
	fi

	if [ "x$1" = "xlist" ];then
		smake_list
		return
	fi

	if [ "x$1" = "xinfo" ];then
		echo
		echo -e "Top dir\t\t\t: $smake_conf_top"
		if [ "x$smake_conf_file" != "x" ]; then
			echo -e "Current configuration\t: $smake_conf_file"
		else
			echo -e "Current configuration\t: Not selected."
		fi
		smake_list
		cd $here
		return
	fi


	if [[ $here =~ $smake_conf_top ]];then
		package_matched=no
		if [[ $here =~ /build/ ]];then
			package=${here##*build/}
			package_matched=yes
		fi

		if [ "x$package_matched" = "xyes" ];then
			package=${package%%-*}
		fi
	else
		cd $here
		return
	fi

	if [ "x$1" = "xdistclean" -o "x$1" = "xclean" ];then
		if [ "x${package}" = "x" ];then
			echo
			echo "Full tree clean/distclean will remove the whole build directory."
			echo "All local changes on these packages will be lost. "
			echo -n "Are you sure? [y/n] : "
			read sel
			echo

			if [ "x$sel" = "xy" ];then
				if [ -d ${smake_conf_top}/nfsroot ];then
					rm -fr ${smake_conf_top}/nfsroot
				fi
				if [ "x$1" = "xdistclean" ];then
					if [ -f Makefile ];then
						$omake distclean
						rm Makefile 2>/dev/null
					fi
					smake_clear_config_settings
				else
					if [ -f Makefile ];then
						$omake clean
					fi
				fi
			fi

			return
		fi
	fi

	if [ ! -f Makefile -o ! -f .config ]; then
		smake_init 
		if [ $? -eq 1 ];then
			return
		fi
	fi

	if [ "x$package" != "x" ];then
		if [ "x$1" != "x" ];then
			cmd=$1
			shift
			echo "Exec: make ${package}-${cmd} $*"
			$omake ${package}-${cmd} $*
		else
			cmd=rebuild
			shift
			echo "Exec: make ${package}-rebuild $*"
			$omake ${package}-${cmd} $*
		fi
	else
		echo "Exec: make ${*}"
		$omake $*
	fi

	cd $here	
}

make(){
	local here

	here=`pwd`
	if [[ $here =~ $smake_conf_top ]];then
		smake $*
	else
		$omake $*
	fi

}

echo "smake configured."
