#!/bin/bash

# Verificar si se proporcionó un nombre de carpeta como parámetro
if [ -z "$1" ]; then
  echo "Se debe proporcionar un nombre de carpeta como parámetro."
  exit 1
fi

# Crear la carpeta principal
mkdir "$1"

# Entrar a la carpeta
cd "$1" || exit

# Crear subcarpetas
mkdir Reportes
mkdir Evidencias
mkdir Sploits

echo "Se ha creado la estructura de $1."
echo "Contenido de la carpeta:"
ls
