#!/usr/bin/gawk -f
#@load "errno"
@load "filefuncs"
#@load "fnmatch"
#@load "fork"
#@load "gd"
#@load "inplace"
#@load "intdiv"
@load "json"
#@load "ordchr"
@load "readdir"
@load "readfile"
#@load "revoutput"
#@load "revtwoway"
#@load "rwarray"
#@load "select"
#@load "time"

@include "include/fts.awk"
@include "include/dialog.awk"
@include "include/tools.awk"
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
# функции для самовызова вызова программы из окна
if(ARGV[1]=="--type" && ARGV[2]){ # это функция узнавания типа. Вызывается из окна.
get_image_info(ARGV[2],arr)
print arr["type"]
exit
}

if(ARGV[1]=="--image" && ARGV[2]){ # это функция определения изображение/не изображение. Вызывается из окна.
get_image_info(ARGV[2],arr)
imagetypes["png"]
imagetypes["xpm"]
imagetypes["svg"]
imagetypes["gif"]
#print arr["type"];exit
if(arr["type"] in imagetypes){print "true"}else{print "false"}
exit
}

# узнаём локаль
ENVIRON["LC_MESSAGES"]?locale=gensub(/\..*$/,"",1,ENVIRON["LC_MESSAGES"]):(ENVIRON["LANG"]?locale=gensub(/\..*$/,"",1,ENVIRON["LANG"]):"")
locale?locale_sh=gensub(/_.*$/,"",1,locale):(ENVIRON["LANGUAGE"]?locale_sh=ENVIRON["LANGUAGE"]:"")
th_ini_header=hard_kde_detected?"KDE Icon Theme":"Icon Theme"


TMPD="data"
themefile=(ARGV[1]?ARGV[1]:"/home/joker/Документы/GitHub/Win98SE/SE98/index.theme")
themefile="../../../GitHub/Win98SE/SE98/index.theme"
readinif(themefile,theme_a)
th_ini_header=get_theme_header(theme_a)
themedir=gensub(/\/*[^/]*$/,"",1,themefile)
themedir~/^\//?"":themedir=abspath(ENVIRON["PWD"]"/"themedir)
#fts_p_f="fts_p.json"
#fts_l_f="fts_l.json"
#icondata_json_f="icondata.json"
#pr_action="pr_action.txt"

temp_files["icon_desc_txt"]=SYMTAB["icon_desc_txt"]=TMPD"/icon_desc.txt";print icon_desc_txt > "/dev/null"
temp_files["dir_desc_txt"]=SYMTAB["dir_desc_txt"]=TMPD"/dir_desc.txt";print dir_desc_txt > "/dev/null"
temp_files["duplist"]=SYMTAB["duplist"]=TMPD"/duplist.txt";print duplist > "/dev/null"
temp_files["dirs_descs_csv"]=SYMTAB["dirs_descs_csv"]=TMPD"/dirs_descs.csv";print dirs_descs_csv > "/dev/null"
temp_files["descr_html_file"]=SYMTAB["descr_html_file"]=TMPD"/descr.html";print descr_html_file > "/dev/null"
temp_files["error_html_file"]=SYMTAB["error_html_file"]=TMPD"/error.html";print error_html_file > "/dev/null"
temp_files["preview_dup"]=SYMTAB["preview_dup"]=TMPD"/preview_dup";print preview_dup > "/dev/null"
temp_files["dupinfo_txt"]=SYMTAB["dupinfo_txt"]=TMPD"/dupinfo.txt";print dupinfo_txt > "/dev/null"
temp_files["iconinfo_txt"]=SYMTAB["iconinfo_txt"]=TMPD"/iconinfo.txt";print iconinfo_txt > "/dev/null"
temp_files["dirinfo_csv"]=SYMTAB["dirinfo_csv"]=TMPD"/dirinfo.csv";print dirinfo_csv > "/dev/null"
temp_files["preview_icon"]=SYMTAB["preview_icon"]=TMPD"/preview_icon";print preview_icon > "/dev/null"
temp_files["preview_icon_names"]=SYMTAB["preview_icon_names"]=TMPD"/preview_icon_names";print preview_icon_names > "/dev/null"
temp_files["iconsindir_txt"]=SYMTAB["iconsindir_txt"]=TMPD"/iconsindir.txt";print iconsindir_txt > "/dev/null"
temp_files["icondata_json_f"]=SYMTAB["icondata_json_f"]="icondata.json";print icondata_json_f > "/dev/null"
temp_files["pr_action"]=SYMTAB["pr_action"]="pr_action.txt";print pr_action > "/dev/null"
temp_files["fts_p_f"]=SYMTAB["fts_p_f"]="fts_p.json";print fts_p_f > "/dev/null"
temp_files["fts_p_c_f"]=SYMTAB["fts_p_c_f"]="fts_p_c.json";print fts_p_c_f > "/dev/null"
temp_files["fts_l_f"]=SYMTAB["fts_l_f"]="fts_l.json";print fts_l_f > "/dev/null"
temp_files["icondata_ini"]=SYMTAB["icondata_ini"]="icondata.ini";print icondata_ini > "/dev/null"
temp_files["view_icon"]=SYMTAB["view_icon"]=TMPD"/view_icon";print view_icon > "/dev/null"
temp_files["example_icon"]=SYMTAB["example_icon"]=TMPD"/example_icon";print example_icon > "/dev/null"
temp_files["icons_by_name"]=SYMTAB["icons_by_name"]=TMPD"/icons_by_name.txt";print icons_by_name > "/dev/null"
temp_files["icon_of_name_list"]=SYMTAB["icon_of_name_list"]=TMPD"/icon_of_name_list.txt";print icon_of_name_list > "/dev/null"

temp_files["icon_link_array_j"]=SYMTAB["icon_link_array_j"]="json/icon_link_array.json";print icon_link_array_j > "/dev/null"
temp_files["same_names_a_j"]=SYMTAB["same_names_a_j"]="json/same_names_a.json";print same_names_a_j > "/dev/null"

# как сгенерировать строчки для этого списка:
# for i in aa bb cc; do echo 'temp_files["'$i'"]=SYMTAB["'$i'"]=TMPD"/'$i'";print '$i' > "/dev/null"';done

#exit

for(i in temp_files){
#SYMTAB[i]=temp_files[i];print error_html_file
#print i
system("unlink "temp_files[i])
close("unlink "temp_files[i])
print "" > temp_files[i]
close(temp_files[i])
}
#exit

#exit
main()
}

function get_dirs_descs_csv(theme_a,real_dirs_files_a,	i,j,a,dirinfo_a,errarr,columns_str,columns_a,dirinfo_csv_data_a){
# 1 2 4 (8-bit error)
errorline="есть только в строке|есть только в контекстах|отсутствует на диске|не учтена|нет в контекстах|нет в строке|ОК"
split(errorline,errarr,"|")

#arraytree(theme_a,"theme_a")
#exit

for(i in theme_a){
	if(i~" Theme" && "Directories" in theme_a[i]){
		split(theme_a[i]["Directories"],a,",")
		for(j in a){
			dirinfo_a[a[j]]["errcode"]++
		}
	}else{
		dirinfo_a[i]["errcode"]=dirinfo_a[i]["errcode"]+2
		if(isarray(theme_a[i])){
			for(j in theme_a[i]){
				dirinfo_a[i][j]=theme_a[i][j]
			}
		}
	}
}

for(i in real_dirs_files_a){
	if(isarray(real_dirs_files_a[i])){
		for(j in real_dirs_files_a[i]){
			if(real_dirs_files_a[i][j]~/\.(png|svg|xpm)$/){
				dirinfo_a[i]["errcode"]=dirinfo_a[i]["errcode"]+4
				dirinfo_a[i]["realfiles"]=length(real_dirs_files_a[i])
				break
			}
		}
	}
}

for(i in dirinfo_a){
	dirinfo_a[i]["errtext"]=errarr[dirinfo_a[i]["errcode"]]
	if(isarray(dir_file_links_a) && i in dir_file_links_a){
		dirinfo_a[i]["symlinks"]=length(dir_file_links_a[i])
	}
	if(isarray(dead_links_a) && i in dead_links_a){
		dirinfo_a[i]["deadlinks"]=length(dead_links_a[i])
	}
	if(isarray(unsized_a) && i in unsized_a){
		dirinfo_a[i]["unsized"]=length(unsized_a[i])
	}
}


columnames_str="Имя|Размер|Мин|Макс|Тип|Масштаб|Порог|Ошибки|Оригиналы|Симлинки|Битые|Не в размер"
columns_str="Name|Size|MinSize|MaxSize|Type|Scale|Threshold|errtext|realfiles|symlinks|deadlinks|unsized"
split(columns_str,columns_a,"|")
for(i in dirinfo_a){
dirinfo_a[i]["string"]=i
for(j=2;j<=length(columns_a);j++){
dirinfo_a[i]["string"]=dirinfo_a[i]["string"] "|"
if(columns_a[j] in dirinfo_a[i]){
dirinfo_a[i]["string"]=dirinfo_a[i]["string"] dirinfo_a[i][columns_a[j]]
}
}
}
#asorti(dirinfo_a,dirinfo_a_s)
for(i in dirinfo_a){
if(isarray(dirinfo_a[i]) && "string" in dirinfo_a[i]){
dirinfo_csv_data_a[i]=dirinfo_a[i]["string"]
}
#print dirinfo_a[dirinfo_a_s[i]]["string"]
#print i, dirinfo_a_s[i]
}
#exit
#close(dirinfo_csv)
print unsplit(dirinfo_csv_data_a,"\n") > dirs_descs_csv
#arraytree(dirinfo_csv_data_a,"dirinfo_csv_data_a")
#exit
#arraytree(dirinfo_a,"dirinfo_a")
#for(i in SYMTAB){print i}
#print json::to_json(dirinfo_a) > "json/dirs_descs.json"
#exit
}

function get_theme_header(theme_a,	out){ # У некоторых тем для KDE особенный заголовок :-/
	if("KDE Icon Theme" in theme_a){
		out="KDE Icon Theme"
	}
	if("Icon Theme" in theme_a){
		out="Icon Theme"
	}
	return out
}

function get_theme_info(theme_a,	descr_html,std_th_parameters,std_th_parameters_a,std_th_parameters_a_u,local_comment){
## вывод описания темы в HTML
	descr_html="<b>"theme_a[th_ini_header]["Name"]"</b>"
	if("Comment["locale"]" in theme_a[th_ini_header]){
		local_comment=theme_a[th_ini_header]["Comment["locale"]"]
	}else if("Comment["locale_sh"]" in theme_a[th_ini_header]){
		local_comment=theme_a[th_ini_header]["Comment["locale_sh"]"]
	}else{
		local_comment=theme_a[th_ini_header]["Comment"]
	}
	descr_html=descr_html "\n" local_comment
	descr_html=descr_html "\n<b>Inherits:</b> " theme_a[th_ini_header]["Inherits"]
	std_th_parameters="Name Comment Inherits Directories ScaledDirectories Hidden Example"
	split(std_th_parameters,std_th_parameters_a," ")
	for(i in std_th_parameters_a){std_th_parameters_a_u[std_th_parameters_a[i]]=std_th_parameters_a[i]}
	for(i in theme_a[th_ini_header]){
		if(i in std_th_parameters_a_u || i~/Comment/){}else{descr_html=descr_html "\n<b>" i ":</b> " theme_a[th_ini_header][i]} # печатать дополнительные параметры
	}
	return descr_html
}

function main(	cmd,examplepic){
getdata()
printf "json-fts..."
#fts_p_f="fts_p.json"
#fts_l_f="fts_l.json"
#fts_l_j=readfile(fts_l_f)
#print fts_l_j
#json::from_json(fts_l_j,fts_l)
#arraytree(fts_l,"fts_l")
#exit
json::from_json(readfile(fts_p_f),fts_p)
json::from_json(readfile(fts_p_c_f),fts_p_c)
json::from_json(readfile(fts_l_f),fts_l)
#delete arr
get_origs_dirs_names(fts_p,origs_dirs_names_a)
get_dirs_links(fts_p,dir_file_links_a)
print json::to_json(dir_file_links_a) > "json/dir_file_links.json"
#arraytree(origs_dirs_names_a,"origs_dirs_names_a")
#exit

get_file_links(fts_p,icon_link_array)
print json::to_json(icon_link_array) > icon_link_array_j
#arraytree(fts_p,"fts_p")
#arraytree(fts_l,"fts_l")
get_dead_links(fts_p,fts_l,dead_links_a)
#arraytree(dead_links_a,"dead_links_a")
#exit
print json::to_json(dead_links_a) > "json/dead_links.json"
get_all_files_data(fts_p_c,fts_l,filedata) # TODO deadlink не определяется! Надо найти дэдлинки
print json::to_json(filedata) > "json/filedata.json"
#arraytree(filedata,"filedata")
#exit
get_same_names(fts_l,same_names_a)
print get_icons_by_name_list(theme_a,same_names_a) > icons_by_name
#exit

print json::to_json(same_names_a) > same_names_a_j
for(i in same_names_a){
max_sames<length(same_names_a[i])?max_sames=length(same_names_a[i]):""
}
#print max_sames
#arraytree(icon_link_array,"icon_link_array")
#exit

#get_orig_dirs_files_fullpath_a(fts_p,orig_dirs_files_fullpath_a)
print ""
count=get_real_dirs_files(fts_p,real_dirs_files_a)
#arraytree(fts_p,"fts_p")
#arraytree(real_dirs_files_a,"real_dirs_files_a")
#exit
print json::to_json(real_dirs_files_a) > "json/real_dirs_files_a.json"
findupes(real_dirs_files_a,origs_dirs_names_a)

get_unsized(theme_a,icondata,unsized_a)
print json::to_json(unsized_a) > "json/unsized.json"
#arraytree(unsized_a,"unsized_a")
#exit

get_dirs_descs_csv(theme_a,real_dirs_files_a)
#exit

# печатаем таблицу дубликатов
for(i in mdupe_sums_a){
dupsheet=dupsheet (dupsheet?"\n":"")
for(j in mdupe_sums_a[i]){
dupsheet=dupsheet (dupsheet?"\n":"") j"|"i
}
}
print dupsheet > duplist



#print doini(mdupe_sums_a) > "INI/mdupe_sums_a.ini"
print json::to_json(mdupe_sums_a) > "json/mdupe_sums_a.json"
print json::to_json(mdupe_files_a) > "json/mdupe_files_a.json"
#arraytree(real_dirs_files_a,"real_dirs_files_a")
#exit
print " ready!"
#print readfile(fts_p_f)
#arraytree(fts_p,"fts_p")
#exit
#exit
#printf "getfiledirs..."
#getfiledirs(fts_p,local_dir_paths) #,dirs_files_a,iconsizes_a,iconplaces_a,dupnum_a,icon_link_array,orig_dirs_files_fullpath_a,dir_orig_count
#print "ready"
#arraytree(local_dir_paths,"local_dir_paths")

#filedir_arrays="local_dir_paths,dirs_files_a,iconsizes_a,iconplaces_a,dupnum_a,icon_link_array,orig_dirs_files_fullpath_a,dir_orig_count"
#split(filedir_arrays,filedir_arrays_a,",")
#for(i in filedir_arrays_a){

#print json::to_json(SYMTAB[filedir_arrays_a[i]]) > "json/"filedir_arrays_a[i]".json"
#}
#exit

for(i in theme_a){
	if(isarray(theme_a[i]) && "Context" in theme_a[i]){
		dirs_in_contexts[theme_a[i]["Context"]][i]
	}
}

# печатаем таблицу папок
# Папка|Размер|Масштаб|Контекст|Тип|Наибольший|Наименьший
for(i in theme_a){
if(i~/ /){}else{
dirinfo_sheet=dirinfo_sheet (dirinfo_sheet?"\n":"") i"|"theme_a[i]["Size"]"|"theme_a[i]["Scale"]"|"theme_a[i]["Context"]"|"theme_a[i]["Type"]"|"theme_a[i]["MaxSize"]"|"theme_a[i]["MinSize"]
#for(j in theme_a[i])
#}
}
}
print dirinfo_sheet > dirinfo_csv
close(dirinfo_csv)

descr_html=get_theme_info(theme_a)
print descr_html > descr_html_file
close(descr_html_file)
get_name_previewer_a(icondata,name_previewer_a)
print MAIN_DIALOG=builddialog("main.xml") > "out.xml"
examplepic=themedir "/" getexample(theme_a,example_a_s)
#arraytree(example_a_s,"example_a_s")
#exit
#cmd="cp " themedir "/" example_a_s[length(example_a_s)]["p"] " " example_icon
cmd="cp " examplepic " " example_icon
system(cmd)
close(cmd)
#list_user_arrays()
#exit
rundialog(MAIN_DIALOG)
}

function printfiledata(dir,file,	dirfile,outdata){
if(isarray(filedata) && dir in filedata && file in filedata[dir]){
dirfile=dir"/"file
for(i in filedata[dir][file]){
outdata=outdata i":\n\t"filedata[dir][file][i] "\n"
}
}
return outdata
}

function printicondata(dir,file,	th_s,s,err,th_ty,ty,dirfile,w,h,idata,ch_per_pix,ncolors,svghead_a,outdata,ext){
	#outfile?"":outfile="/dev/stdout"
	#outfile="/dev/stdout"
	dirfile=dir"/"file
	ext=gensub(/^.*\./,"",1,file)
	#print dirfile
	if(dir in theme_a){
		th_s=theme_a[dir]["Size"]
		th_ty=theme_a[dir]["Type"]
	}
	#print dirfile
	outdata="Файл:\n"file"\n\nПолный путь:\n"themedir"/"dirfile"\n\n"
	#arraytree(icondata,"icondata")
	if(dirfile in icondata){
		if("w" in icondata[dirfile]){
			w=icondata[dirfile]["w"]
			outdata=outdata "Ширина: " w (w==th_s?"":", а должна быть " th_s "!") "\n"
		}
		if("h" in icondata[dirfile]){
			h=icondata[dirfile]["h"]
			outdata=outdata "Высота: " h (h==th_s?"":", а должна быть " th_s "!") "\n"
		}
		if("type" in icondata[dirfile]){
			outdata=outdata "Тип: "icondata[dirfile]["type"]"\n"
			outdata=outdata "Расширение: " ext
			if(icondata[dirfile]["type"]!~"ini" && icondata[dirfile]["type"]!=ext){
				outdata=outdata "\n\t(не совпадает" (icondata[dirfile]["ext"]==ext?"!":", но ссылается на " icondata[dirfile]["ext"] ".") ")"
			}
			outdata=outdata "\n"
			switch(icondata[dirfile]["type"]){
			case /xpm/:
				ch_per_pix=icondata[dirfile]["ch_per_pix"]
				ncolors=icondata[dirfile]["ncolors"]
				outdata=outdata "Каналов на пиксель: " ch_per_pix "\n"
				outdata=outdata "Всего цветов: " ncolors "\n"
				break

			case /svg/:
				svghead=gensub(/\s/," ","g",icondata[dirfile]["svghead"])
				patsplit(svghead,svghead_a,/[^ =]+="*[^"]*"*/)
				outdata=outdata "\nЗаголовок SVG:\n"
				for(i in svghead_a){
					outdata=outdata "\t"svghead_a[i] "\n"
				}
				break

			case /ini/:
				for(i in icondata[dirfile]){
					if(i~":"){
						#outdata=outdata i "\n"
						outdata=outdata gensub(/^[^:]*:/,"",1,i) ":"
						if(icondata[dirfile][i]~"|"){
							split(icondata[dirfile][i],a,"|")
							for(i in a){
							outdata=outdata "\n\t" a[i]
							}
						}else{
							outdata=outdata "\n\t" icondata[dirfile][i]
						}
						#outdata=outdata "\n"
					}
				}
				break
			}
		}
		if("ext" in icondata[dirfile]){}
		#arraytree(icondata[dirfile],dirfile)
	}
	#print outdata > outfile
	#close(outfile)
	return outdata
}

function rundialog(var,	gtkcmd,i,j,a,filelist,w,h){
	
	if("command -v gtkdialog"|getline gtkdialog){}else{print "gtkdialog not found!"; exit}
	ENVIRON["MAIN_DIALOG"]=var
	gtkcmd=gtkdialog " -p MAIN_DIALOG"
	while((gtkcmd|getline)>0){
	print
	switch($1){
	case /^INFO/:
		if($2){
		#print $2
		split($2,a,"!")
		print printicondata(a[1],a[2]) > iconinfo_txt
		print printfiledata(a[1],a[2]) > iconinfo_txt
		close(iconinfo_txt)
		system("cp " themedir"/"a[1]"/"a[2] " "view_icon)
		close("cp " themedir"/"a[1]"/"a[2] " "view_icon)
		#list_user_arrays()
		}
		break
	case /^LIST/:
		if(isarray(filedata) && $2 in filedata && isarray(filedata[$2])){
		filelist=""
		for(i in filedata[$2]){
		#print i
		w=h=""
		if("w" in icondata[$2 "/" i]){w=icondata[$2 "/" i]["w"]}
		if("h" in icondata[$2 "/" i]){h=icondata[$2 "/" i]["h"]}
		#filelist=filelist (filelist?"\n":"") $2 "/" i "|" i
		if(match(i,/\.([^.]*)$/,a)){}else{a[1]=""}
		filelist=filelist $2 "!" i "|" i "|" gensub(/\.[^.]*$/,"",1,i) "|" a[1] #(w?"!"w:"") (h?"!"h:"") 
		if(isarray(icondata) && $2 "/" i in icondata){
		filelist=filelist "|" icondata[$2 "/" i]["type"]
		filelist=filelist "|";if("w" in icondata[$2 "/" i]){filelist=filelist icondata[$2 "/" i]["w"]}else{filelist=filelist "|"}
		filelist=filelist "|";if("h" in icondata[$2 "/" i]){filelist=filelist icondata[$2 "/" i]["h"]}else{filelist=filelist "|"}
		}else{
		filelist=filelist "|||"
		}
		filelist=filelist "|" filedata[$2][i]["size"] "|" filedata[$2][i]["type"]
		filelist=filelist "\n"
		}
		print gensub("\n$","",1,filelist) > iconsindir_txt
		close(iconsindir_txt)
		}
		break
	case /^INAME/:
		if(isarray(same_names_a) && $2 in same_names_a){
			for(i in same_names_a[$2]){
				if(match(i,/^(.+)\/([^/]+)$/,a)){
					print i "|" a[1] "|" theme_a[a[1]]["Type"] "|" theme_a[a[1]]["Context"] "|" theme_a[a[1]]["Size"] > icon_of_name_list
				}
			}
			close(icon_of_name_list)
		}
		#print $2
		break
	case /^XDG-SELECT/:
		#print themedir"/"gensub("!","/",1,$2)
		xdg_select_file(themedir"/"gensub("!","/",1,$2))
		break
	}
	}
}

function getdata(	cmd,openfiles){
	cmd="./get_files_data.awk --themedir=\""themedir"\" --fts_p_f="fts_p_f" --fts_l_f="fts_l_f" --icondata_json="icondata_json_f" --labelfile="pr_action
	system(cmd)
	openfiles[cmd]

	getline fts_p_j < fts_p_f
	getline fts_l_j < fts_l_f
	getline icondata_json < icondata_json_f
	openfiles[fts_p_f]
	openfiles[fts_l_f]
	openfiles[icondata_json_f]
	json::from_json(fts_p_j,fts_p)
	json::from_json(fts_l_j,fts_l)
	readinif_nohash(icondata_ini,icondata)
	#json::from_json(icondata_json,icondata)

	for(i in openfiles){close(i);delete openfiles[i]}
#arraytree(icondata,"icondata")
}

function readinif_nohash(file,arr,	rs,var,val,sect,varr,vall){	#read ini file and convert it to a 2D gawk array.
	rs=RS
	RS="\n|\r"
	while((getline<file)>0){
		if($0!~"^#|^;|^$"){
			#gsub(" *;.*$","")
			if($0~/^\[.*\]$/){
				sect=$0;gsub(/^\[|\].*$/,"",sect);arr[sect]["#"]
				delete arr[sect]["#"]
			}else{
				varr=vall=$0
				gsub(/ *=.*$/,"",varr)
				gsub(/^[^=]*= */,"",vall)
				arr[sect][varr]=vall
#				split($0,va,"=");arr[sect][va[1]]=va[2]
			}
		}
	}
	RS=rs
}





