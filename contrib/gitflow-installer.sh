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

EXEC_FILES="git-flow contrib/completion/git-flow-completion.bash link-jira-issue"
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
        if [ "$(uname)" = "Linux" ] && [ "$1" != '-f' ] ; then
            installed=1;
            if which dpgk &>/dev/null ; then
                dpkg -s git-flow | grep -q 'installed';
                installed=$?;
            elif which rpm &>/dev/null ; then
                rpm -qa | grep -q git-flow;
                installed=$?;
            elif ls /usr/lib/git-core/git-flow &>/dev/null ; then
                installed=0;
            fi

            if [ $installed -eq 0 ] ; then
                echo "/usr/lib/git-core/git-flow exists.";
                echo "Do you have git-flow.deb or git-flow.rpm installed?";
                echo "If so, you must remove it before installing this version.";
                echo "Alternatively you may force installation by re-running the installer with the -f flag";
                echo "Aborting installation.";
                exit 1;
            fi
        fi

		gitstatus=$(git status 2>&1 | cut -d: -f1);
		if [ "$(basename `pwd`)" != "$REPO_NAME" ] || [ "fatal" = "$gitstatus" ] ; then
			echo "Installing git-flow to $INSTALL_PREFIX"
			if [ -d "$REPO_NAME" -a -d "$REPO_NAME/.git" ] ; then
				echo "Using existing repo: $REPO_NAME"
                echo "Updating $REPO_NAME.";
                cd $REPO_NAME;
                git checkout master;
                git pull origin master;
                git checkout develop;
                git pull origin develop;
			else
				echo "Cloning repo from Plusnet to $REPO_NAME"
				git clone "$REPO_HOME" "$REPO_NAME"
			    cd "$REPO_NAME"
			fi
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
		;;
esac

echo;
echo "Git flow tab completion file installed to '$INSTALL_PREFIX/git-flow-completion.bash'";
echo "To enable, please add the following to your '~/.bash_profile' or '~/.bashrc' file";
echo;
echo "    source $INSTALL_PREFIX/git-flow-completion.bash";
echo;
echo "Installation complete";

exit;
