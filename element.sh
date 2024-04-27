#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"
MAIN_MENU(){
  if [[ $1 ]]
  then
    #判断输入为数字还是字符
    if [[ $1 =~ [0-9]+ ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
    else
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1';")
    fi

    #判断是否存在于db
    if [[ -z $ATOMIC_NUMBER ]]
    then 
      echo I could not find that element in the database.
    else
      RESULT=$($PSQL "SELECT atomic_number, melting_point_celsius,boiling_point_celsius,atomic_mass,symbol,name,type FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
      echo $RESULT | while read A_NUMBER BAR MELTING_POINT BAR BOILING_POINT BAR ATOMIC_MASS BAR SYMBOL BAR NAME BAR TYPE
      do
        
        echo "The element with atomic number $A_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
    

  else
    echo Please provide an element as an argument.
  fi
 
}

MAIN_MENU $1