#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

MAIN_MENU(){
  if [[ -z $1 ]]
  then
  
  echo -e "\nWelcome to My Salon, how can I help you?\n"

  else 

  echo -e "\n$1"

  fi

  RESULT_DIS_SERVICES=$($PSQL "SELECT service_id , name FROM services") 
  echo "$RESULT_DIS_SERVICES" | sed 's/"service_id | name "//g' | sed 's/|//g' |   while read SERVICE_ID  SERVICE
  do
  if [[ $SERVICE_ID =~ ^-?[0-9]+$  ]]
  then
   echo -e "$SERVICE_ID) $SERVICE"
  fi
  done
  read SERVICE_ID_SELECTED

  SERVICE_WANTED=$( $PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED "   )  
  echo $SERVICE_WANTED | sed 's/\n//g' | sed 's/-//g' | sed 's/service_id//g' | sed 's/ //g' | sed 's/(1row)//g' |  read SERVICE_ID_WANTED
  SNAME=$(echo $( $PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED "  ) | sed 's/\n//g' | sed 's/-//g' | sed 's/name//g' | sed 's/ //g' | sed -E 's/([0-9]row)//g' | sed 's/(//g' | sed 's/)//g' | sed 's/s//g' )

  if [[  -z $SNAME ]]
  then 
   MAIN_MENU "I could not find that service. What would you like today"
  else

  
echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CLIENT_ID=$( echo $( $PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'" )  | sed 's/\n//g' | sed 's/-//g' | sed 's/customer_id//g' |  sed 's/ //g' | sed -E 's/([0-9]row)//g' | sed 's/(//g' | sed 's/)//g' | sed 's/s//g' )
  
  if [[ -z $CLIENT_ID  ]]
  then
  echo -e "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME 
  RESULT_OF_INSERT=$( $PSQL "INSERT INTO  customers(name , phone)  VALUES('$CUSTOMER_NAME' , '$CUSTOMER_PHONE' ) " ) 
  CLIENT_ID=$( echo $( $PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'" )  | sed 's/\n//g' | sed 's/-//g' | sed 's/customer_id//g' |  sed 's/ //g' | sed -E 's/([0-9]row)//g' | sed 's/(//g' | sed 's/)//g' | sed 's/s//g' )
  
  else
  CUSTOMER_NAME=$( echo '$( $PSQL "SELECT name FROM customers WHERE phone = '$PHONE_NUMBER'" )' | sed 's/\n//g' | sed 's/-//g' | sed 's/name//g' | sed 's/ //g' | sed -E 's/([0-9]row)//g' | sed 's/(//g' | sed 's/)//g' | sed 's/s//g' )

  fi
  echo -e "\nWhat time would you like your $SNAME, $CUSTOMER_NAME?" 
  read SERVICE_TIME
  RESULT_OF_INSERT1=$( $PSQL "INSERT INTO  appointments(service_id, customer_id , time)  VALUES($SERVICE_ID_SELECTED , $CLIENT_ID , '$SERVICE_TIME' ) " ) 
  echo -e "\nI have put you down for a $SNAME at $SERVICE_TIME, $CUSTOMER_NAME."


 

    


  fi
  

  }

MAIN_MENU
