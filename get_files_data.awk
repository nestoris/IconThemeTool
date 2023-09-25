#!/usr/bin/gawk -f

## Утилита для получения массива данных о файлах.

# На входе: массив со значками
# На выходе: массив с данными о них
# С симлинками что? Надо пройтись по полученному массиву и применить к симлинкам эти данные.

#@load "errno"
@load "filefuncs"
#@load "fnmatch"
#@load "fork"
@load "gd"
#@load "inplace"
#@load "intdiv"
@load "json"
#@load "ordchr"
@load "readdir"
#@load "readfile"
#@load "revoutput"
#@load "revtwoway"
#@load "rwarray"
#@load "select"
#@load "time"

@include "include/tools.awk"
@include "include/fts.awk"
@include "abspath"
@include "arraytree"
#@include "assert"
#@include "bits2str"
#@include "cliff_rand"
#@include "ctime"
#@include "ftrans"
#@include "getopt"
#@include "gettime"
#@include "group"
#@include "gtk-server"
#@include "have_mpfr"
@include "ini"
#@include "inplace"
#@include "intdiv0"
#@include "isnumeric"
#@include "join"
#@include "libintl"
#@include "noassign"
#@include "ns_passwd"
#@include "ord"
#@include "passwd"
#@include "processarray"
#@include "quicksort"
#@include "readable"
#@include "readfile"
#@include "rewind"
#@include "round"
#@include "shellquote"
#@include "strtonum"
#@include "walkarray"
#@include "zerofile"

BEGIN{
## короче, нужен массив со всеми файлами в теме... ну кроме index.theme, наверное. Это FTS и прбежка по нему. А давай сделаем FTS_PH.json и logical
#print ARGV[1]
	#arraytree(real_dirs_files_a,"real_dirs_files_a")
#arraytree(ARGV,"argv")
#exit

	for(i=1;i<ARGC;i++){
		if(ARGV[i]~/^--/){
			match(ARGV[i],/--([^=]*)=(.*)$/,a)
			param[a[1]]=a[2]
		}
	}
#exit
	delete ARGV[0]
#for(i in ARGV){print ARGV[i]}
#print ARGC, length(ARGV)
#if(length(ARGV)>1){print "Только 1 аргумент -- папка темы"; exit}
#if(go_cli){print go_cli}

#arraytree(param,"param")

	themedir=param["themedir"]
	if("labelfile" in param){labelfile=param["labelfile"]
	}else{
	labelfile="pr_action.txt"
	}
	print "" > labelfile
	close(labelfile)

	if(param["go_cli"]){
		print "1"
		print "Чтение директорий" > labelfile
		close(labelfile)
		fts_arrays(themedir,fts_p,fts_l,fts_p_c)
		#arraytree(fts_p,"fts_p")
		#exit
		print json::to_json(fts_p) > "fts_p.json"
		close("fts_p.json")
		print json::to_json(fts_p_c) > "fts_p_c.json"
		close("fts_p_c.json")
		print json::to_json(fts_l) > "fts_l.json"
		close("fts_l.json")
		count=get_real_dirs_files(fts_p,real_dirs_files_a)
		print "Чтение файлов" > labelfile
		close(labelfile)
		get_file_links(fts_p,icon_link_array)
		cli(real_dirs_files_a,icon_link_array)
		count=""
	}else{
		gui()
	}
}

function fts_arrays(path,fts_p,fts_l,fts_p_c,	pathlist,pwd,paths,prev,per,k){ # создать json из массива файлов
	pwd=ENVIRON["PWD"]
	chdir(path)
	fs=FS
	FS="/"
	while((getline<path)>0){
		$3~"d"?$2~/\.+/?"":paths[$2]=$2:""
	}
	FS=fs
	for(i in paths){
		k++
		pathlist[1]=i
		flags = or(FTS_PHYSICAL, FTS_COMFOLLOW)
		fts(pathlist, flags, fts_p_c[i])
		flags = FTS_PHYSICAL
		fts(pathlist, flags, fts_p[i])
		flags = FTS_LOGICAL
		fts(pathlist, flags, fts_l[i])
		per=int(k/length(paths)*99)
		#print per
		if(per>prev){print per}
		prev=per
	}
	chdir(pwd)
}

function cli(arr,icon_link_array,	prev,per_prev,i,j,k,l,m,picfile){ # функция создаёт json с данными о значках
param[icondata_json]?"":param[icondata_json]="icondata.json"
	for(i in arr){
		for(j in arr[i]){
			picfile=themedir"/"i"/"j
			get_image_info(picfile,icondata[i"/"j]) # функция из tools.awk
			openfiles[picfile]
			if(length(openfiles)>10000){
				for(j in openfiles){
						close(j)
						delete openfiles[j]
						#print "cache"
				}
			}
			per_prev=int(k/count*100)
			k++
			per=int(k/count*100)
			if(3==2 && ERRNO){
				print i"/"j " : " ERRNO > "getdata.log"
			}
			if(per==82){print i"/"j}
			if(per>per_prev){
				print per
				#print i"/"j
			}
		}
	}
	if(isarray(icon_link_array)){
	#print "ICON!!";exit
	for(i in icondata){
	#print i
#arraytree(icon_link_array,"icon_link_array")
	#exit

	if(i in icon_link_array){
	for(j in icon_link_array[i]){
	for(k in icondata[i]){
	icondata[j][k]=icondata[i][k]
	}
	}
	}
	}
	}

	#arraytree(iconlinkdata,"iconlinkdata")
	#exit
	#arraytree(icondata,"icondata")
	#exit
	for(i in openfiles){
		close(i)
		delete openfiles[i]
	}
	print doini(icondata) > "icondata.ini"
	#exit
	print json::to_json(icondata) > param[icondata_json]
	openfiles["getdata.log"]
	openfiles[icondata_json]
	for(i in openfiles){
		close(i)
	}
}

function gui(){
	getline cmdline <("/proc/"PROCINFO["pid"]"/cmdline")
	close(("/proc/"PROCINFO["pid"]"/cmdline"))
	nf=split(cmdline,fields,/\0/)
	noargs=fields[1] " " fields[2] " " fields[3]
	for(i in ARGV){args=args (args?" ":"") ARGV[i]}
	#args="--themedir=\"/home/joker/Документы/GitHub/Win98SE/SE98\" --fts_p_f=fts_p.json --fts_l_f=fts_l.json --icondata_json=icondata.json"
	dialog(args,labelfile)
}

function dialog(args,labelfile){

MAIN_DIALOG="\n\
<window title=\"Icon Theme Tool\">\n\
	<vbox>\n\
			<text auto-refresh=\"true\">\n\
				<input file>"labelfile"</input>\n\
			</text>\n\
			<progressbar>\n\
				<!--input>"noargs" --go_cli=1 "args"</input-->\n\
				<input>"noargs" --go_cli=1 --themedir=\"/home/joker/Документы/GitHub/Win98SE/SE98\" --fts_p_f=fts_p.json --fts_l_f=fts_l.json --icondata_json=icondata.json  --labelfile=pr_action.txt</input>\n\
				<action function=\"exit\">Ready</action>\n\
			</progressbar>\n\
		<hbox>\n\
			<button cancel></button>\n\
		</hbox>\n\
	</vbox>\n\
</window>"
	ENVIRON["MAIN_DIALOG"]=(error?ERROR_DIALOG:MAIN_DIALOG)
	cmd="gtkdialog -p MAIN_DIALOG"
	while((cmd|getline)>0){
		print
	}
	close(cmd)
}

function main(themedir,icondir,arr){
	fs=FS
	FS="/"
	iconsdir=themedir "/" icondir
	#print iconsdir
	while((getline<iconsdir)>0){
		if($3~/f|l/){
			filecount[1]++
		}
	}
	close(iconsdir)
	while((getline<iconsdir)>0){
		if($3~/f|l/){
			#print themedir "/" icondir "/" $2
			get_image_info(themedir "/" icondir "/" $2,arr[icondir][$2])
			openfiles[themedir "/" icondir "/" $2]
			filecount[2]++
			print int(filecount[2]/filecount[1]*100)
		}
	}
	FS=fs
	for(i in openfiles){
	close(i)
	}
}

















