#! /bin/bash

# define constants
declare -r TRUE=0
declare -r FALSE=1

# Script directory
thedir=`dirname $0`
cd $thedir
thedir=`pwd`

# default file names
filename="save.html"
imageditor="gwenview"
htmleditor="/home/olivier/Logiciels/bluegriffon/bluegriffon"
fileexplorer="dolphin"
cssarticle="css/article.css"
watermark="/home/olivier/Logiciels/xsr/logo.png"

# color definition
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# check command
function isCommandeExist() {
    # source : https://bash.cyberciti.biz/guide/Returning_from_a_function
    commande=$1
    result=`which $commande`
    [ "$result" == "" ] && echo $FALSE || echo $TRUE
}

# message
function displayMessage() {
    message=$1
    code=$2

    echo "--------------------------------------------------------------"
    case $code in
        "0")
            printf ">>> ${GREEN}$message${NC} <<<\n"
            notify-send --urgency=normal --icon=flag-green --expire-time=10000 "X Step Recording" "<font color=\"green\">$message</font>"
            ;;
        "1")
            printf ">>> ${RED}$message${NC} <<<\n"
            notify-send --urgency=normal --icon=flag-red --expire-time=10000 "X Step Recording" "<font color=\"red\">$message</font>"
            ;;
        "2")
            printf ">>> ${GREEN}$message${NC} <<<\n"
            ;;
        "3")
            printf ">>> ${RED}$message${NC} <<<\n"
            ;;
        *)
            printf ">>> ${RED}Unknow code : $code${NC} <<<\n"
            printf ">>> ${RED}$message${NC} <<<\n"
            ;;
    esac
    echo "--------------------------------------------------------------"
}

hasZenity=$(isCommandeExist "zenity");
hasPandoc=$(isCommandeExist "pandoc");

[ $hasZenity -eq $TRUE ] && displayMessage "[INFO] zenity is installed" 2 || displayMessage "[WARN] install zenity to choose another tutorial mode" 3
[ $hasPandoc -eq $TRUE ] && displayMessage "[INFO] pandoc is installed" 2 || displayMessage "[WARN] install pandoc to convert HTML file" 3

if [ $hasZenity -eq $TRUE ]; then
    # ask for file name
    filename=$(zenity --entry --title="1 - File" --text "Give a HTML file name" --entry-text "$filename" 2> /dev/null);
fi


if [ "$filename" != "" ]; then
    filename="$thedir/html/$filename"
    cssarticle="$thedir/$cssarticle"

    displayMessage "[INFO] Filer $filename" 2

    mode="Tutorial mail"

    if [ $hasZenity -eq $TRUE ]; then
        # choose mode
        mode=$(zenity --list --title="2 - Mode" --text "Which mode ?" --radiolist --height=270 --width=850\
                    --column "Choice" --column "Mode" --column "Description" \
                    FALSE "Tutorial full" "on edite tout : image + html + fichier"\
                    TRUE "Tutorial mail" "chemin absolu des images pour copier coller dans un mail (-p) + on edite : image + html"\
                    FALSE "Tutorial watermark" "chemin absolu des images pour copier coller dans un mail (-p) + on edite : image + html"\
                    FALSE "Tutorial zip" "chemin relatif des images pour pouvoir déplacer le HTML (pas de -p) + on edite : image + html"\
                    FALSE "Manual" "chemin relatif des images + selection + on edite : image + html"\
                    FALSE "Article" "chemin relatif des images (pas de -p) et mode article (css article) avec legende (-g) + on edite : image + html"\
                    2> /dev/null);
    fi

    if [ "$mode" != "" ]; then
        displayMessage "Mode $mode" 2

        case $mode in
            "Tutorial full")
                #- 1 -# on edite tout : image + html + fichier
                #echo ">>> Mode tuto avec chemin absolu image et screenshot focus seulement puis edition image, HTML et fichier final"
                ./bin/xsr.pl "$filename" --lang=fr -p -e --images-editor="$imageditor" -s --html-editor="$htmleditor" -r --file-explorer="$fileexplorer"
                ;;
            "Tutorial mail")
                #- 2 -# chemin absolu des images pour copier coller dans un mail (-p) + on edite : image + html
                echo ">>> Mode tuto avec chemin absolu image et screenshot focus seulement puis edition image et HTML"
                ./bin/xsr.pl "$filename" --lang=fr -p -e --images-editor="$imageditor" -s --html-editor="$htmleditor"
                ;;
            "Tutorial watermark")
                #- 2 -# chemin absolu des images pour copier coller dans un mail (-p) + watermark + on edite : image + html
                echo ">>> Mode tuto avec chemin absolu image, screenshot focus seulement et watermark puis edition image et HTML"
                ./bin/xsr.pl "$filename" --lang=fr -p -e -a --watermark="$watermark" --images-editor="$imageditor" -s --html-editor="$htmleditor"
                ;;
            "Tutorial zip")
                #- 3 -# chemin relatif des images pour pouvoir déplacer le HTML (pas de -p) + on edite : image + html
                #echo ">>> Mode tuto avec chemin relatif image et screenshot focus seulement puis edition image et HTML"
                ./bin/xsr.pl "$filename" --lang=fr -e --images-editor="$imageditor" -s --html-editor="$htmleditor"
                ;;
            "Manual")
                #- 2 -# chemin relatif des images + selection + on edite : image + html
                echo ">>> Mode tuto avec chemin absolu image et screenshot focus seulement puis edition image et HTML"
                ./bin/xsr.pl "$filename" --lang=fr -e --screenshot-mode="select" --images-editor="$imageditor" -s --html-editor="$htmleditor"
                ;;
            "Article")
                #- 4 -# chemin relatif des images (pas de -p) et mode article (css article) avec legende (-g) + on edite : image + html
                #echo ">>> Mode article avec chemin absolu image, screenshot focus seulement et legende image puis edition image et HTML"
                ./bin/xsr.pl "$filename" --lang=fr -p -g --css="$cssarticle" -e --images-editor="$imageditor" -s --html-editor="$htmleditor"
                ;;
            *)
                #echo "Unknown mode : $mode"
                ;;
        esac

        displayMessage "File $filename created" 2

        conversion="none"

        if [[ $hasPandoc -eq $TRUE && $hasZenity -eq $TRUE ]]; then
            # choose conversion mode
            conversion=$(zenity --list --title="3 - Conversion" --text "Which conversion ?" --radiolist --height=250 --width=300 \
                            --column "Choice" --column "Mode" --column "Description" \
                            TRUE "none" "None"\
                            FALSE "pdf" "PDF file"\
                            FALSE "md" "Markdown file"\
                            FALSE "zip" "Create zip archive"\
                            FALSE "odt" "Open Office Writer file"\
                            2> /dev/null);
        fi

        case $conversion in
            "none")
                displayMessage "[INFO] No conversion for file $filename" 2
                ;;
            "pdf")
                pandoc -s -f html -t pdf $filename > $filename.md
                ;;
            "md")
                pandoc -s -f html -t markdown $filename > $filename.md
                sed -i '/div/d' $filename.md
                ;;
            "zip")
                # todo : compress html and directory
                ;;
            "odt")
                pandoc -s -f html -t odt $filename > $filename.md
                ;;
            *)
                #echo "Unknown conversion : $conversion"
                ;;
        esac

        # conversion html to md with pandoc
        # pandoc --reference-links -s -f html -t markdown $filename > $filename.md

        if [[ "$conversion" != "none" && "$conversion" != "" ]]; then
            displayMessage "Conversion to $conversion format for $filename" 2
        fi

        echo "Press Return to finish"
        read
    fi
fi

