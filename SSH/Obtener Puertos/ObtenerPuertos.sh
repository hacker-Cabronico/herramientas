#!/bin/bash
# -------------------------------------------------------------------------------
# Creador: Erick Brenes
# Actualizacion: Mayo 02, 2023
# Version: 1.02
# -------------------------------------------------------------------------------

mostrar_reporte() {
  local archivo="$1"
  local color="$2"
  
  read -p "¿Quiere ver el reporte ${archivo}? [1 Si] " ver_reporte
  if [ $ver_reporte -eq 1 ]; then
    echo -e "\e[34m\n\n\n3) RESULTADO DEL REPORTE ${archivo}.\n\e[0m"
    echo -e "${color}"
    cat "${archivo}"
    echo -e "\e[0m"
  fi
  ver_reporte=0
}

# Solicitar la dirección IP y el nombre del archivo para guardar los resultados
read -p "Introduzca la dirección IP a escanear: " ip
read -p "Introduzca el nombre del archivo para guardar los resultados: " file_name
read -p "¿Desea ejecutar el escaneo en modo verbose? [1 Si] " verbose
vvv=""
  
if [ $verbose -eq 1 ]; then
  vvv="-vvv"
fi

file="$(pwd)/$file_name"

echo  -e "\e[34m\n\n\n1) ESCANEO INICIAL (Reporte en ${file}.txt).\n\e[0m"
# Ejecutar el escaneo de puertos y guardar los resultados en el archivo especificado
sudo nmap -p- $vvv --min-rate 5000 "$ip" -oN "${file}.txt"

echo -e "\e[34m\n\n\n2) OBTENER LA LISTA DE PUERTOS\n\e[0m"
# Almacenar y mostrar la lista de puertos en una variable
puertos=$(cat "${file}.txt" | grep open | grep tcp | awk '{print $1}' FS=/ | tr '\n' ',' | sed 's/,$/\n/')
echo "La lista de puertos: $puertos"

echo -e "\e[34m\n\n\n3) ESCANEANDO PUERTOS\n\e[0m"
# Ejecutar el escaneo de puertos especificos y guardar los resultados en el archivo nuevo prefijo Escaneado
sudo nmap -p"$puertos" $vvv -sC  -n -O "$ip" -oX "${file}_escaneado.xml"

echo -e "\e[34m\n\n\n5) ESCANEANDO PUERTOS VULNERABLES\n\e[0m"
# Ejecutar el escaneo de puertos específicos vulnerables y guardar los resultados en un archivo
sudo nmap -p"$puertos" $vvv --script="vuln"  -n -O "$ip" -oX "${file}_PuertosVulnerables.xml"

echo -e "\e[34m\n\n\n3) ESCANEANDO PUERTOS A SALVO\n\e[0m"
# Ejecutar el escaneo de puertos específicos seguros y guardar los resultados en un archivo
sudo nmap -p"$puertos" $vvv --script="safe"  -n -O "$ip" -oX "${file}_PuertosSeguros.xml"

# Exportar reportes a XML y TXT
echo -e "\e[34m\n\n\n4) EXPORTAR REPORTES A XML Y TXT\n\e[0m"
sudo xsltproc "${file}_escaneado.xml" -o "${file}_escaneado.txt"
sudo xsltproc "${file}_PuertosVulnerables.xml" -o "${file}_PuertosVulnerables.txt"
sudo xsltproc "${file}_PuertosSeguros.xml" -o "${file}_PuertosSeguros.txt"

echo -e "\e[34m\n\n\n5) EXPORTAR REPORTES A HTML\n\e[0m"
sudo xsltproc "${file}.xml" -o "${file}.html"
sudo xsltproc "${file}_escaneado.xml" -o "${file}_escaneado.html"
sudo xsltproc "${file}_PuertosVulnerables.xml" -o "${file}_PuertosVulnerables.html"
sudo xsltproc "${file}_PuertosSeguros.xml" -o "${file}_PuertosSeguros.html"

# Mostrar reportes en TXT
mostrar_reporte "${file}_escaneado.txt" "\e[35m"
mostrar_reporte "${file}_PuertosVulnerables.txt" "\e[31m"
mostrar_reporte "${file}_PuertosSeguros.txt" "\e[32m"

# Mostrar reportes en HTML
mostrar_reporte "${file}.txt" "\e[35m"
mostrar_reporte "${file}_escaneado.txt" "\e[31m"
mostrar_reporte "${file}_PuertosVulnerables.txt" "\e[32m"
mostrar_reporte "${file}_PuertosSeguros.txt" "\e[33m"
