#!/bin/bash
# -------------------------------------------------------------------------------
# Creador: Erick Brenes
# Actualizacion: Mayo 02, 2023
# Version: 1.01
# -------------------------------------------------------------------------------
# Solicitar la dirección IP y el nombre del archivo para guardar los resultados
read -p "Introduzca la dirección IP a escanear: " ip
read -p "Introduzca el nombre del archivo para guardar los resultados: " file
read -p "¿Desea ejecutar el escaneo en modo verbose? [1 Si] " verbose
vvv=""
  
if [ $verbose -eq 1 ];  
then  
  vvv="-vvv"
fi  


echo  "\e[34m\n\n\n1)ESCANEO INICIAL (Reporte en $file.txt).\n\e[0m"
# Ejecutar el escaneo de puertos y guardar los resultados en el archivo especificado
sudo nmap -p- $vvv --min-rate 5000 "$ip" -oN "$file.txt"

echo "\e[34m\n\n\n2)OBTENER LA LISTA DE PUERTOS\n\e[0m"
# Almacenar y mostrar la lista de puertos en una variable
puertos=$(cat "$file.txt" | grep open | grep tcp | awk '{print $1}' FS=/ | tr '\n' ',' | sed 's/,$/\n/')
echo "La lista de puertos: $puertos"

echo "\e[34m\n\n\n3)ESCANEANDO PUERTOS\n\e[0m"
# Ejecutar el escaneo de puertos especificos y guardar los resultados en el archivo nuevo prefijo Escaneado
sudo nmap -p"$puertos" $vvv -sC  -n -O "$ip" -oN "${file}_escaneado.txt"

echo "\e[34m\n\n\n5)ESCANEANDO PUERTOS VULNERABLES\n\e[0m"
# Ejecutar el escaneo de puertos específicos vulnerables y guardar los resultados en un archivo
sudo nmap -p"$puertos" $vvv --script="vuln"  -n -O "$ip" -oN "${file}_PuertosVulnerables.txt"

echo "\e[34m\n\n\n3)ESCANEANDO PUERTOS A SALVO\n\e[0m"
# Ejecutar el escaneo de puertos específicos seguros y guardar los resultados en un archivo
sudo nmap -p"$puertos" $vvv --script="safe"  -n -O "$ip" -oN "${file}_PuertosSeguros.txt"

read -p "¿Quiere ver el reporte ${file}_escaneado.txt? [1 Si] " ver_reporte
if [ $ver_reporte -eq 1 ];  
then
	echo "\e[34m\n\n\n3)RESULTADO DEL REPORTE ${file}_escaneado.\n\e[0m"
	echo "\e[35m"
	cat "${file}_escaneado.txt"
	echo "\e[0m"
fi
ver_reporte=0

read -p "¿Quiere ver el reporte ${file}_PuertosVulnerables.txt? [1 Si] " ver_reporte
if [ $ver_reporte -eq 1 ];  
then
	echo "\e[34m\n\n\n3)RESULTADO DEL REPORTE ${file}_PuertosVulnerables.\n\e[0m"
	echo "\e[31m"
	cat "${file}_PuertosVulnerables.txt"
	echo "\e[0m"
fi
ver_reporte=0

read -p "¿Quiere ver el reporte ${file}_PuertosSeguros.txt? [1 Si] " ver_reporte
if [ $ver_reporte -eq 1 ];  
then
	echo "\e[34m\n\n\n3)RESULTADO DEL REPORTE ${file}_PuertosSeguros.\n\e[0m"
	echo "\e[32m"
	cat "${file}_PuertosSeguros.txt"
	echo "\e[0m"

fi
