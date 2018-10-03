#!/bin/bash -x


cat >/tmp/lst.txt <<EOF
winxp
vcrun6
mfc40
comctl32
comdlg32ocx
vcrun2003
vcrun2005
vcrun2008
vcrun2010
vb6run
dotnet20
dotnet20sp2
fontfix
w_workaround_wine_bug-22521
vb5run
ie6
ie7
ie8
msls31
w_workaround_wine_bug-25648
w_workaround_wine_bug-21947
dotnet40
winetricks mdac27
msxml
EOF

cat /tmp/lst.txt | while read x; do
    winetricks "$x"
done


