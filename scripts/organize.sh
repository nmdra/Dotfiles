#!/bin/bash

# Go to the downloads folder
# cd Downloads

    echo "Organizing your messy downloads folder"

# First Create Some General Folders
mkdir Audios Videos PDFs Scripts Images Compressed Others

# Audio Files
mv -nv *.mp3 *.m4a *.flac *.aac *.ogg *.wav Audio_Files

# Video Files
mv -nv *.mp4 *.mov *.avi *.mpg *.mpeg *.webm *.mpv *.mp2 *.wmv *.mkv Videos

# PDFs
mv -nv *.pdf *.cbr *.cbz *.epub PDFs

# Word Docs and txt files
#mv *.doc *.docx *.txt *.odt Word_Docs

# Powerpoints
#mv *.ppt *.pptx Powerpoints

# Scripts
mv -nv *.py *.rb *.sh *.lua Scripts

# Image Files
mv -nv *.png *.jpg *.jpeg *.tif *.tiff *.bpm *.gif *.eps *.raw *.webp Images

# Notebooks
#mv *.ipynb Notebooks

#Debian File
# mv *.deb Debian_Files

#TXZ_Files

#RAR Files
mv -nv *.zip *.rar *.tar.* *.xz *.txz *.tgz Compressed

#Other
mv -nv *.* Others


# cd Scripts
# mv organize.sh .. #the organize script is also sorted into the scripts folder, so take it out.
# cd ..

notify-send "All sorted!!"
