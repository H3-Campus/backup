#!/bin/sh
mois=`date +%B`
jour=`date +%d-%m-%Y`
heure=`date +%T`
log="/var/log/backups"
local="/media/NasParis/"
distant="/media/NasPoissy"

compteur=5
retention=`date +%B --date='1 month ago'`
nom()
{
echo "-------------------------------------------------------------" > $log/poissy_$jour.log
echo -e "Sauvegarde de $local du $(date +%d-%B-%Y)" >> $log/poissy_$jour.log
echo "-------------------------------------------------------------" >> $log/poissy_$jour.log
}
# Si le répertoire contenant les logs n'existe pas, celui-ci sera crée.
if [ ! -d $log ];then
mkdir $log
fi
# On teste la présence du dossier source
if [ ! -d $local ];then
nom
echo -e "$jour-$heure : $local n'existe plus ou est inaccessible.\n\nAucune sauvegarde effectuée." >> $log/poissy_$jour.log
exit
fi
echo "-------------------------------------------------------------" > $log/poissy_$jour.log
echo "Sauvegarde de $local du $(date +%d-%B-%Y)" >> $log/poissy$jour.log
echo "-------------------------------------------------------------" >> $log/poissy_$jour.log
# Heure de début du transfert dans le journal
echo "Heure de demarrage de la sauvegarde : $(date +%T)" >> $log/poissy_$jour.log
echo "-------------------------------------------------------------" >> $log/poissy_$jour.log
# Transfert des fichiers
rsync -avzr --stats --protect-args --delete-after $local $distant >> $log/poissy_$jour.log
# -a : mode archivage ( équivalent -rlptgoD ).
# -z : compression des données pendant le transfert.
# -e : pour spécifier l’utilisation de ssh
# -- stats : donne des informations sur le transfert (nombre de fichiers…).
# --protect -args : Si vous avez besoin de transférer un nom de fichier qui contient des espaces , vous pouvez le spécifier avec cette option.
# --delete-after : supprime les fichiers qui n’existent plus dans la source après le transfert dans le dossier de destination.
status=$?
echo "" >> $log/poissy_$jour.log
# Codes de retour rsync
case $status in
0) echo Succès >> $log/poissy_$jour.log;;
1) echo "Erreur de syntaxe ou d'utilisation" >> $log/poissy_$jour.log;;
2) echo "Incompatibilité de protocole" >> $log/poissy_$jour.log;;
3) echo "Erreurs lors de la sélection des fichiers et des répertoires d'entrée/sortie" >> $log/poissy_$jour.log;;
4) echo "Action non supportée : une tentative de manipulation de fichiers 64-bits sur une plate-forme qui ne les supporte pas \
; ou une option qui est supportée par le client mais pas par le serveur." >> $log/poissy_$jour.log;;
5) echo "Erreur lors du démarrage du protocole client-serveur" >> $log/poissy_$jour.log;;
6) echo "Démon incapable d'écrire dans le fichier de log" >> $log/poissy_$jour.log;;
10) echo "Erreur dans la socket E/S " >> $log/poissy_$jour.log;;
11) echo "Erreur d'E/S fichier " >> $log/poissy_$jour.log;;
12) echo "Erreur dans le flux de donnée du protocole rsync" >> $log/poissy_$jour.log;;
13) echo "Erreur avec les diagnostics du programme" >> $log/poissy_$jour.log;;
14) echo "Erreur dans le code IPC" >> $log/poissy_$jour.log;;
20) echo "SIGUSR1 ou SIGINT reçu " >> $log/poissy_$jour.log;;
21) echo "Une erreur retournée par waitpid()" >> $log/poissy_$jour.log;;
22) echo "Erreur lors de l'allocation des tampons de mémoire principaux ">> $log/poissy_$jour.log;;
23) echo "Transfert partiel du à une erreur " >> $log/poissy_$jour.log;;
24) echo "Transfert partiel du à la disparition d'un fichier source" >> $log/poissy_$jour.log;;
25) echo "La limite --max-delete a été atteinte" >> $log/poissy_$jour.log;;
30) echo "Dépassement du temps d'attente maximal lors d'envoi/réception de données" >> $log/poissy_$jour.log;;
35) echo "Temps d’attente dépassé en attendant une connection" >> $log/poissy_$jour.log;;
255) echo "Erreur inexpliquée" >> $log/poissy_$jour.log;;
esac
echo "-------------------------------------------------------------" >> $log/poissy_$jour.log
# Heure de fin dans le journal
echo "Heure de fin de la sauvegarde : $(date +%T)" >> $log/poissy_$jour.log
echo "-------------------------------------------------------------" >> $log/poissy_$jour.log

exit
