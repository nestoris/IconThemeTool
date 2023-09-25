#!/usr/bin/gawk -f
#@load "readfile"
# TODO надо, чтобы редактировался .icon, чтобы была вкладка с информацией о каждом файле, предпросмотр, вкладка с точками и редактированием описания.
# описание надо делать для всех папок-размеров, точки для каждого фиксированного размера -- это должно быть отдельное табло для описания, отдельно переключаемый комбобокс с разными найденными файлами, чтобы там сделать точки.
# а если найдено несколько .icon с разными описаниями? Надо предложить выбрать одно из них.
# кнопочка save сохраняет все файлы или один. Наверное, надо 'save all' для всех, там, где описание.

BEGIN{

MAIN_DIALOG=readfile("main.xml")
#exit
tmpdir="/tmp/gtkdialog_main"
cmd_xml="mkdir -p "tmpdir"; echo '"MAIN_DIALOG"' > " tmpdir"/main.xml"
system(cmd_xml)
close(cmd_xml)
#print MAIN_DIALOG >> tmpdir"/main.xml"
print cmd=startdialog(tmpdir"/main.xml")
main(cmd)
cmd_xml="rm -rf "tmpdir
system(cmd_xml)
close(cmd_xml)
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

function readfile(file,	out){while((getline<file)>0){out=out (out?"\n":"") $0};return out}

