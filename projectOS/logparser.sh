#!/bin/bash

#Andreas Papandreou, 1088088

#Eleutherios Drakopoulos, 1051947

#Chrusovalantis Michail Liakopoulos, 1088096





inputv=$3
miningusernames(){
case $inputv in
	"")        
		nullcount1=$(grep -o '127.0.0.1 - - ' access.log |wc -l)
        	nullcount2=$(grep -o '::1 - -' access.log |wc -l)
        	nullsum=$(($nullcount1+$nullcount2))
        	echo "	$nullsum -"  
        	admincount=$(grep -o ' admin ' access.log |wc -w)
        	echo "   $admincount admin"
        	rootcount=$(grep -o ' root ' access.log |wc -w) 
        	echo "   $rootcount root"
        	user1count=$(grep -o ' user1 ' access.log |wc -w)
        	echo "   $user1count user1"
        	user2count=$(grep -o ' user2 ' access.log |wc -w)
        	echo "   $user2count user2"
        	user3count=$(grep -o ' user3 ' access.log |wc -w)
        	echo "   $user3count user3"
		;;
	-)
		sed -n  '/1 - - /p' access.log
		;;

	admin)
		sed -n '/ admin /p' access.log
		;;
	root)
		
	
		sed -n '/ root /p' access.log
		;;
	user1)
		sed -n '/ user1 /p' access.log
		;;
	user2)	
		sed -n '/ user2 /p' access.log
		;;
	user3)
		sed -n '/ user3 /p' access.log
		;;
	*)
		echo "User does not exist."
		;;
esac
}
count_browsers(){
mozillacount=$(grep -o 'Mozilla' access.log |wc -w)
chromecount=$(grep -o 'Chrome' access.log |wc -w)
safaricount=$(grep -o 'Safari' access.log |wc -w)
edgcount=$(grep -o 'Edg' access.log |wc -w)
	
match(){
echo "Mozila $mozillacount"
echo "Chrome $chromecount"
echo "Safari $safaricount"
echo "Edg $edgcount"
}
match

}
case  $1 in
        "")
        echo "1088096|1088088|1051947"
        exit
	;; 

        access.log)
        	case $2 in
                	"")     
                		cat access.log
                		;;
                	--usrid)
				miningusernames
                		;;
	 		-method)
			case $3 in
				GET)
					awk '/GET/' access.log
					;;
				POST)
					awk '/POST/' access.log
					;;
				*)
					echo "Wrong method name."
					;;
			esac
			;;
			--servprot)
				case $3 in
					IPv4)
						awk '/127.0.0.1/' access.log
						;;
					IPv6)
						awk '/::1/' access.log
						;;		
					*)
						echo "Wrong Network Protocol."
						;;
				esac
				;;
			--browsers)
				count_browsers
			;;

			--datum)
				case $3 in
					Jan)
						grep '/Jan/' access.log
						;;
					Feb)
						grep '/Feb/' access.log
						;;
					Mar)
						grep '/Mar/' access.log
						;;
					Apr)
						grep '/Apr/' access.log
						;;
					May)
						grep '/May/' access.log
						;;
					Jun)
						grep '/Jun/' access.log
						;;
					Jul)
						grep '/Jul/' access.log
						;;
					Aug)
						grep '/Aug/' access.log
						;;
					Sep)
						grep '/Sep/' access.log
						;;
					Oct)
						grep '/Oct/' access.log
						;;
					Nov)
						grep '/Nov/' access.log
						;;
					Dec)
						grep '/Dec/' access.log
						;;
					*)
						echo "Wrong Date."
						;;
				esac
			;;	
			*)
			echo "Wrong argument."
			;;
		esac
	;;	
*)
	if ! [[ $1 == *".log"* ]]
	then
        	echo "Wrong file format."
        	exit
	fi
	echo "File with name $1 does not exist."
esac
	

