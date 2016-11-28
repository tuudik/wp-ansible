#!/bin/bash
# This is a Bash Script to test result of WordPress Deployment

#Retrieve arguments
while [[ $# -gt 1 ]]
do
	arg="$1"

	case $arg in
		--host)
		HOST="$2"
		shift
		;;
		--result)
		RESULT="$2"
		shift
		;;
		--cookie)
		COOKIE="$2"
		shift
		;;
		*)
		;;
esac
shift
done

# Check if login available
if curl -b $COOKIE -c $COOKIE $HOST/wp-login.php | grep "user_login"
	then
		echo "Login to webadmin is available!" > $RESULT
	else
		echo "ERROR! Login not available!" > $RESULT
fi

# Check if login works
if curl -L -A "Ansible test" -b $COOKIE -c $COOKIE -d "log=admin&pwd=admin&testcookie=1" http://$HOST/wp-login.php | grep "Howdy, admin"
	then
		echo "Login to webadmin works and webadmin is available!" >> $RESULT
	else
		echo "ERROR! Not possible to log in to webadmin!" >> $RESULT
fi

rm $COOKIE