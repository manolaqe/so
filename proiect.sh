#!/bin/bash

#Cerinta:
#Să se scrie un shell script care creează câte un fișier editabil pentru fiecare utilizator.
#Denumirea fișierului respectă următorul șablon: file_nr_numeutilizator.

echo "Shell script care creeaza cate un fisier editabil pentru fiecare utilizator."

echo "Doriti sa salvati fisierele la calea curenta (raspuns: "caleacurenta") sau in directorul specific fiecarui utilizator (raspuns: "director")?"

read raspuns

caleacurenta="caleacurenta"
director="director"

var=1

while [ $var -eq 1 ]
do
	if [ "$raspuns" != "$caleacurenta" ]
		then
			if [ "$raspuns" != "$director" ]
				then
					echo "Nu ati introdus o optiune valida"
					echo "Incercati din nou:"
        				read raspuns
				else
					var=`expr $var + 1`
				fi
	else
		var=`expr $var + 1`
	fi
done

uid=1000

a=`expr $(getent passwd | grep :/bin/bash | wc -l) - 1`
#a reprezinta numarul de utilizatori propriu-zisi din sistem

echo "$a utilizatori propriu-zisi"

case $raspuns in
caleacurenta)
while [ $uid -lt $(($a + 1000)) ]
do
	echo "Utilizator cu uid $uid: "
	echo $(getent passwd "$uid" | grep :x:$uid)
#Am observat ca uid-urile corespunzatoare utilizatorilor propriu-zisi sunt de forma 1000, 1001 etc., asa ca am filtrat lista de utilizatori cu ajutorul unui pipeline cu grep :x:$uid
	touch file_"$uid"_$(getent passwd "$uid" | cut -d: -f1)
	chmod 777 file_"$uid"_$(getent passwd "$uid" | cut -d: -f1)
#f1, f2 etc. fac referire la campul din afisarea extinsa a unui utilizator. Astfel, f1 corespunde numelui de utilizator
	uid=`expr $uid + 1`
done ;;
director)
while [ $uid -lt $(($a + 1000)) ]
do
	echo "Utilizator cu uid $uid: "
	echo $(getent passwd "$uid" | grep :x:$uid)
	touch $(getent passwd  "$uid" | cut -d: -f6)/file_"$uid"_$(getent passwd "$uid" | cut -d: -f1)
	chmod 777 $(getent passwd  "$uid" | cut -d: -f6)/file_"$uid"_$(getent passwd "$uid" | cut -d: -f1)
#Operatie similara cu cea folosita mai sus, f6 corespunde adresei directorului corespondent
	uid=`expr $uid + 1`
done ;;
esac
