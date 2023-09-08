#! /bin/env bash

# +----->>
# | args :
# | $1 : fichier à convertir
# | $2 : fichier de sortie
# +----->>

# read -r in_file

# pandoc "$1" --pdf-engine pajedjs-cli -o "$2" && pkill -HUP mupdf &
pandoc "$1" -N -o "$2" && pkill -HUP mupdf &
# pandoc --pdf-engine=pagedjs-cli "$1" -o "$2" && pkill -HUP mupdf &
# pandoc --pdf-engine=pagedjs-cli "TD1.md" -o "test.pdf"

# pandoc -s "$1" --css ~/Code/md_style_sheet.css > tmp.html && wkhtmltopdf tmp.html "$2" && rm tmp.html && pkill -HUP mupdf &

# pandoc -s compte_rendu.md --css ~/Code/md_style_sheet.css > tmp.html && wkhtmltopdf tmp.html compte_rendu_lepin_cazenave.pdf && rm tmp.html && pkill -HUP mupdf &
# pandoc -s compte_rendu.md --css ~/Code/md_style_sheet.css | wkhtmltopdf compte_rendu_lepin_cazenave.pdf && pkill -HUP mupdf &
