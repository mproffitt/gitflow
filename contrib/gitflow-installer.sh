#!/bin/bash

# git-flow make-less installer for *nix systems, by Rick Osborne
# Based on the git-flow core Makefile:
# http://github.com/nvie/gitflow/blob/master/Makefile

# Licensed under the same restrictions as git-flow:
# http://github.com/nvie/gitflow/blob/develop/LICENSE

# Does this need to be smarter for each host OS?
if [ -z "$INSTALL_PREFIX" ] ; then
	INSTALL_PREFIX="/usr/local/bin"
fi

if [ -z "$REPO_NAME" ] ; then
	REPO_NAME="GitFlow"
fi

if [ -z "$REPO_HOME" ] ; then
	REPO_HOME="http://git.internal.plus.net/plusnet/GitFlow.git"
fi

EXEC_FILES="git-flow"
SCRIPT_FILES="git-flow-init git-flow-feature git-flow-hotfix git-flow-release git-flow-support git-flow-version gitflow-common gitflow-shFlags"
SUBMODULE_FILE="gitflow-shFlags"

echo "### gitflow no-make installer ###"

case "$1" in
	uninstall)
		echo "Uninstalling git-flow from $INSTALL_PREFIX"
		if [ -d "$INSTALL_PREFIX" ] ; then
			for script_file in $SCRIPT_FILES $EXEC_FILES ; do
				echo "rm -vf $INSTALL_PREFIX/$script_file"
				rm -vf "$INSTALL_PREFIX/$script_file"
			done
		else
			echo "The '$INSTALL_PREFIX' directory was not found."
			echo "Do you need to set INSTALL_PREFIX ?"
		fi
		exit
		;;
	help)
		echo "Usage: [environment] gitflow-installer.sh [install|uninstall]"
		echo "Environment:"
		echo "   INSTALL_PREFIX=$INSTALL_PREFIX"
		echo "   REPO_HOME=$REPO_HOME"
		echo "   REPO_NAME=$REPO_NAME"
		exit
		;;
	*)
		gitstatus=$(git st 2>&1 | cut -d: -f1);
		if [ "$(basename `pwd`)" != "$REPO_NAME" ] || [ "fatal" == "$gitstatus" ] ; then
			echo "Installing git-flow to $INSTALL_PREFIX"
			if [ -d "$REPO_NAME" -a -d "$REPO_NAME/.git" ] ; then
				echo "Using existing repo: $REPO_NAME"
			else
				echo "Cloning repo from Plusnet to $REPO_NAME"
				git clone "$REPO_HOME" "$REPO_NAME"
			fi
			cd "$REPO_NAME"
		fi
		if [ -f "$SUBMODULE_FILE" ] ; then
			echo "Submodules look up to date"
		else
			echo "Updating submodules"
			git submodule init
			git submodule update
		fi

		install -v -d -m 0755 "$INSTALL_PREFIX"
		for exec_file in $EXEC_FILES ; do
			ln -s -f "$(pwd)/$exec_file" "$INSTALL_PREFIX"
		done
		for script_file in $SCRIPT_FILES ; do
			ln -s -f "$(pwd)/$script_file" "$INSTALL_PREFIX"
		done
		exit
		;;
esac
