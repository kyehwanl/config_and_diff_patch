#!/bin/sh -x

cd /tmp
sudo git clone https://github.com/kyehwanl/note
sudo chown -R kyehwanl note

mkdir note0
cp -rf ~/Emulab/config_and_diff_patch/ /tmp/note0
cp -rf ~/Emulab/Shell_Script/ /tmp/note0
cp -rf ~/Emulab/DEBUGGING_NOTE/  /tmp/note0


rsync -avPuiz --delete note0/config_and_diff_patch/ note/config_and_diff_patch/
rsync -avPuiz --delete note0/Shell_Script/ note/Shell_Script/
rsync -avPuiz --delete note0/DEBUGGING_NOTE/ note/DEBUGGING_NOTE/

cd note
git add .
git commit -m "auto-updated $(date +"%D %T")"

cp ~/Emulab/Shell_Script/input-expect.sh /tmp/
sudo /tmp/input-expect.sh

rm -rf /tmp/note /tmp/note0
rm -rf /tmp/input-expect.sh



