if [ "$1" = "Start" ]; 
then
	DIFF_FROM_ORIGIN=`git diff origin/master`
#	DIFF_FROM_ORIGIN=`ls -l`
	if [ ! $DIFF_FROM_ORIGIN ]; 
	then
		echo "Session Started Successfully"
	else
		echo "There is some commit in GIT.";
		echo "$DIFF_FROM_ORIGIN";
		read -p "Continue to Update?[Yy] " UPDATE
		case "$UPDATE" in 
   			 [Yy]*) 
				git merge origin/master 
				echo "Session Started Successfully"
				;;
        		 *)
            			echo "SESSION DIDN'T START PROPERLY. 
				      ARE YOU SURE TO CONTINUE WITHOUT SYNCING WITH THE ORIGIN?"
				;;
		esac
	fi
elif [ "$1" = "Stop" ];
then
	CHANGES_MADE=`git status`
	if [ "$CHANGES_MADE" = "Nothing to Commit" ];
	then
		echo "No changes made. Session Stopped successfully"
	else
		#echo $CHANGES_MADE
		DIFF_FROM_ORIGIN_STOP=`git diff origin/master`
		if [ -z "$DIFF_FROM_ORIGIN_STOP" ];
		then
			echo "Origin has changed. Will merge before commiting."
			git merge origin/master
		fi
		read -p "Commit Message?" MESSAGE_1
		git add --all
		git commit -m "$MESSAGE_1"
		git push origin master
		echo "Session Stopped successfully."
	fi
else
	echo "Run command: $/Session.sh [Start/Stop] to start or stop the session." 
fi

