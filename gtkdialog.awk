#!/usr/bin/gawk -f
BEGIN{

MAIN_DIALOG="\
<window title=\"Chooser 2022 Basic\" resizable=\"true\">\n\
	<vbox border-width=\"0\">\n\
		<chooser>\n\
			<variable export=\"false\">chooser</variable>\n\
			<default>/usr/share</default>\n\
			<width>600</width>\n\
			<height>600</height>\n\
			<sensitive>true</sensitive>\n\
			<action signal=\"current-folder-changed\">echo current-folder-changed</action>\n\
			<action signal=\"file-activated\">echo file-activated</action>\n\
			<action signal=\"selection-changed\">echo selection-changed</action>\n\
			<action signal=\"update-preview\">echo update-preview</action>\n\
		</chooser>\n\
		<hbox>\n\
			<button ok></button>\n\
			<button cancel></button>\n\
		</hbox>\n\
	</vbox>\n\
</window>\
"

tmpdir="/tmp/gtkdialog_main"
cmd_xml="mkdir -p "tmpdir"; echo '"MAIN_DIALOG"' > " tmpdir"/main.xml"
system(cmd_xml)
close(cmd_xml)
#print MAIN_DIALOG >> tmpdir"/main.xml"
print cmd=startdialog(tmpdir"/main.xml")
main(cmd)
}


function main(cmd){
while((cmd|getline)>0){
print
}
close(cmd)
}

function startdialog(file,variable,	cmd){
if(("command -v gtkdialog"|getline gtkdialog)<1){print "No GTKDIALOG!";exit -1}
if(file){cmd=gtkdialog" --file='"file"'"}else{variable?MAIN_DIALOG=variable:"";gsub(/#[^\n]*\n/,"",MAIN_DIALOG);ENVIRON["MAIN_DIALOG"]=MAIN_DIALOG;cmd=gtkdialog" --program=MAIN_DIALOG"}
return cmd
}

function readfile(file,	out){while((getline<file)>0){out=out out?"\n":"" $0}return out}

