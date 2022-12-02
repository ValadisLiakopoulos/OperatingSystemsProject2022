#! /usr/bin/bash

miningusernames(){
        nullcount1=$(grep -o '127.0.0.1 - - ' access.log |wc -l)
        nullcount2=$(grep -o '::1 - -' access.log |wc -l)
        nullsum=$(($nullcount1+$nullcount2))
        echo "  $nullsum -"  
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
}

case  $1 in
        "")
        echo "1088096|1088088|"
        ;; 

        access.log)
        case $2 in
                "")     
                cat access.log
                ;;
                --usrid)
                miningusernames
                ;;
                esac
        ;;
 
esac
