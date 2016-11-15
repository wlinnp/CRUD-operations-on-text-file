#! /bin/bash

phoneDB="datebook"

# check file exist. if not leave program
if [ ! -f $phoneDB ]; then
	echo "Database file not found. exiting. bye bye. "
	exit
fi
insertRecord()
{
# get mobile phone number (unique)

ph=""
echo "Please enter your mobile phone number: "
read ph
while (( 1 ))
do
    while (( 1 ))
    do
        if [[ $ph =~ ^[0-9]{10}$ ]]; then
            break
        else
            echo "Invalid format. phone should contain 10 digits 0 to 9. enter again. "
            read ph
        fi
    done
    ph=`expr substr "$ph" 1 3 `"-"`expr substr "$ph" 4 3 `"-"`expr substr "$ph" 7 4 `
    res="no" # bool variable (sort of) with false
    res=`awk -F: -v var="$ph" '{if ($3 ~ var ) {print "yes";}}' "$phoneDB" ` #if exist, switch to true
    if [[ $res =~ "yes" ]]; then
        echo "primary key (ph) exists. enter a new phone. "
        read ph
    else
        break
    fi

done
echo "You entered " $ph
echo



# get first name
fName=""
echo "Please enter your first name:"
read fName
while (( 1 ))
do
    if [[ $fName =~ ^[A-Z][a-z]+$  ]]; then
        break
    else
        echo "Invalid format. first name should contain only alphabets. enter again. "
        read fName
    fi
done
echo "You entered " $fName
echo

# get last name
lName=""
echo "Please enter your last name:"
read lName
while (( 1 ))
do
    if [[ $lName =~ ^[A-Z][a-z]+$  ]]; then
        break
    else
        echo "Invalid format. last name should contain only alphabets. enter again. "
        read lName
    fi
done
echo "You entered " $lName
echo

# get home phone number

phHm=""
echo "Please enter your home phone number: "
read phHm
while (( 1 ))
do
    if [[ $phHm =~ ^[0-9]{10}$ ]]; then
        break
    else
        echo "Invalid format. phone should contain 10 digits 0 to 9. enter again. "
        read phHm
    fi
done
phHm=`expr substr "$phHm" 1 3 `"-"`expr substr "$phHm" 4 3 `"-"`expr substr "$phHm" 7 4 `
echo "You entered " $phHm


#get address w/o ZIPcode
address=""
echo "Please enter your address w/o ZIPcode:(NOTE: no validation. type the correct format. ( Address: Street address, City, State) ) "
read address
echo

# get ZIP code

zip=""
echo "Please enter your Zip code: "
read zip

while (( 1 ))
do
    if [[ $zip =~ ^[0-9]{5}$ ]]; then
        break
    else

        echo "Invalid format. zipcode should contain 5 digits 0 to 9. enter again. "
        read zip
    fi
done

echo "You entered " $zip
echo

#get birthday
birthday=""
echo "Please enter your birthday: (NOTE: no validation. type the correct format. (MM/DD/YY) ) "
read birthday
echo
# get salary

salary=""
echo "Please enter your Salary: "
read salary

while (( 1 ))
do
    if [[ $salary =~ ^[0-9]{1,}$ ]]; then
        break
    else
        echo "Invalid format. phone should contain digits only. enter again. "
        read salary
    fi
done

echo "You entered " $salary
echo

newRecord=$fName" "$lName":"$phHm":"$ph":"$address" "$zip":"$birthday":"$salary
echo "Record to be inserted: "$newRecord
echo " =============================="
echo "$newRecord" >> "$phoneDB"
#sorting
sort -k1d -t" " "$phoneDB" > "temp" #sorting and copying to temp file
cp "temp" "$phoneDB" #copy temp file to actual file
rm "temp" # remove temp file
cat "$phoneDB" # show sorted file
}

# infinite loop for menu
while (( 1 ))
do
	echo "1 for Listing of records in alphabetical order of first name"
	echo "2 for Listing of records in alphabetical order of last name"
	echo "3 for Listing of records in reverse alphabetical order of first name"
	echo "4 for Listing of records in reverse alphabetical order of last name"
	echo "5 for Search for a record by Last Name"
	echo "6 for Search for a record by birthday in a given year"
	echo "7 for Search for a record by birthday in a given month"
	echo "8 for Delete for a record by Last Name"
	echo "9 for Delete for a record by Phone Number"
	echo "10 for Insert a record"
	echo "0 for exit"
	read option

	case $option in
	"1")
		echo "Listing of records in alphabetical order of first name"
		echo "------------------------------------------------------"
		sort -k1d -t" " "$phoneDB" > "temp" #sorting and copying to temp file
		cp "temp" "$phoneDB" #copy temp file to actual file
		rm "temp" # remove temp file
		cat "$phoneDB" # show sorted file
		;;
	"2")
		echo "Listing of records in alphabetical order of last name"
		echo "-----------------------------------------------------"
		sort -k2d -t" " "$phoneDB" > "temp" #similar concept
		cp "temp" "$phoneDB"
		rm "temp"
		cat "$phoneDB"
		;;
	"3")
		echo "Listing of records in reverse alphabetical order of first name"
		echo "--------------------------------------------------------------"
		sort -k1dr -t" " "$phoneDB" > "temp" #similar concept
		cp "temp" "$phoneDB"
		rm "temp"
		cat "$phoneDB"
		;;
	"4")
		echo "Listing of records in reverse alphabetical order of last name"
		echo "-------------------------------------------------------------"
		sort -k2dr -t" " "$phoneDB" > "temp" #similar concept
		cp "temp" "$phoneDB"
		rm "temp"
		cat "$phoneDB"
		;;
	"5")
		echo "Search for a record by Last Name"
		echo "--------------------------------"
		echo "Enter the last name you want to search: "
		read lName # get last name
		awk -v var="$lName" -F'[ :]' '{if ($2 ~ var) {print;} }' "$phoneDB"
		;;
	"6")
		echo "Search for a record by birthday in a given year"
		echo "-----------------------------------------------"
		echo "Enter the year you want to search: "
		read year
		awk -v var="$year" -F'[/:]' '{if ($7 == var) {print;} }' "$phoneDB"
		;;
	"7")
		echo "Search for a record by birthday in a given month"
		echo "------------------------------------------------"
		echo "Enter the month you want to search: "
		read month
		awk -v var="$month" -F'[/:]' '{if ($5 == var) {print;} }' "$phoneDB"
		;;
	"8")
		echo "Delete for a record by Last Name"
		echo "--------------------------------"
		echo "Enter the last name you want to delete: "
		read lName # get last name
		echo "Records with last name: $lName"
		awk -v var="$lName" -F'[ :]' '{if ($2 ~ var) {print;} }' "$phoneDB"
		echo "deleting them. New database file"
		echo "--------------------------------"
		awk -v var="$lName" -F'[ :]' '{if ($2 !~ var) {print;} }' "$phoneDB" > "temp" #sorting and copying to temp file
		cp "temp" "$phoneDB" #copy temp file to actual file
		rm "temp" # remove temp file
		cat "$phoneDB" # show sorted file
		;;
	"9")
		echo "Delete for a record by Phone Number"
		echo "-----------------------------------"
		echo "Enter the mobile phone number you want to delete: (10 digit without dashes or parenthesis) "
		read ph # get mobile phone number
		while (( 1 ))
		do
			if [[ $ph =~ ^[0-9]{10}$ ]]; then
				break
			else
				echo "Invalid format. phone should contain 10 digits 0 to 9. enter again. "
				read ph
			fi
		done
		ph=`expr substr "$ph" 1 3 `"-"`expr substr "$ph" 4 3 `"-"`expr substr "$ph" 7 4 `

		echo "Records with mobile phone number: $ph"
		awk -v var="$ph" -F'[:]' '{if ($3 ~ var) {print;} }' "$phoneDB"
		echo "deleting them. New database file"
		echo "--------------------------------"
		awk -v var="$ph" -F'[:]' '{if ($3 !~ var) {print;} }' "$phoneDB" > "temp" #sorting and copying to temp file
		cp "temp" "$phoneDB" #copy temp file to actual file
		rm "temp" # remove temp file
		cat "$phoneDB" # show sorted file
		;;
	"10")
		insertRecord
		;;
	"0")
		echo "Exiting the program. Bye bye"
		break
		;;
	*)
		echo "Invalid option. "
		;;
	esac

done

