#!/usr/bin/gawk -f
function xdg_select_file(infile,	cmd_get,cmd_run){
	#cmd_get="LC_MESSAGES=C gio info --attributes= " infile
	#while((cmd_get|getline)>0){
	#	if($1~/^uri:/){
	#	cmd_run="dbus-send --session --print-reply --dest=org.freedesktop.FileManager1 --type=method_call /org/freedesktop/FileManager1 org.freedesktop.FileManager1.ShowItems array:string:\""$2"\" string:\"\""
	#	break
	#	}
	#}
	#print infile
	cmd_run="dbus-send --session --print-reply --dest=org.freedesktop.FileManager1 --type=method_call /org/freedesktop/FileManager1 org.freedesktop.FileManager1.ShowItems array:string:\""infile"\" string:\"\""
	system(cmd_run)
	close(cmd_run)
}

function getexample(theme_a,example_a_s,tmp_a,	example,i,j){ # предоставить массив темы, получить массив значков -- образцов
delete example_a_s
#arraytree(theme_a,"theme_a")
	if(isarray(theme_a) && "Icon Theme" in theme_a && "Example" in theme_a["Icon Theme"]){
		example=theme_a["Icon Theme"]["Example"]
	}else{
		example="folder"
	}
	for(i in theme_a){
		if(i!~" Theme"){
			fs=FS
			FS="/"
			curdir=themedir"/"i
			while((getline<curdir)>0){
				if($2~"^"example".(png|svg|xpm)$"){
					tmp_a[theme_a[i]["Size"]]=i"/"$2
				}
			}
			FS=fs
		}
	}
	for(i in tmp_a){
		j++
		example_a_s[j]["s"]=i
		example_a_s[j]["p"]=tmp_a[i]
	}
	return example_a_s[length(example_a_s)]["p"]
}

function svg_head_read(svghead,array,	a,ar){
patsplit(svghead,a,/[^ ]*="[^"]*"/)
for(i in a){
match(a[i],/([^=]*)="([^"]*)"/,ar)
array[ar[1]]=ar[2]
}
}

function findupes(real_dirs_files_a,origs_dirs_names_a,cmd,	i,j,a,pwd,get_cmd,nf,totalf){ # mdsums_a["f50d5b417190c548901f4c4b907b599b"]["scalable/status/security-high.svg"]="scalable/status/security-high.svg"
	if(isarray(real_dirs_files_a) && themedir){
		#cmd?cmd="md5sum":""
		cmd="md5sum"
		get_cmd="command -v " cmd
		get_cmd|getline cmd
		close(get_cmd)
		#print cmd
		pwd=ENVIRON["PWD"]
		totalf=length(real_dirs_files_a)
		cmd="cd '"themedir"'; " cmd
		for(i in real_dirs_files_a){
			#print i
			#cmd="md5sum"
#			for(j in real_dirs_files_a[i]){
				#print "\t" j
				#print "\t\t" real_dirs_files_a[i][j]
#				cmd=cmd " \"" i"/"j "\""
				cmd=cmd " " i"/*"
#			}
			#print cmd
			#exit
			#print cmd
			#nf++
			#printf "\rfind duplicates: " int(nf/totalf*100) "% "
		}
		cmd=cmd " 2>/dev/null;cd '"pwd"'"
		#print cmd;exit
		#print cmd;system(cmd);close(cmd);exit
			while((cmd|getline)>0){
			#print $1 "=" $2
			if(match($0,/^([^ ]*)\s*(.*)$/,a)){
			if(a[2] in origs_dirs_names_a){ # что-то неладное с этим origs_dirs_names_a... Дубликаты есть, но они не обнаруживаются...
			mdupe_sums_a[a[1]][a[2]]=a[2]
			mdupe_files_a[a[2]]=a[1]
			}
			#print "\"" a[1] "\"=\"" a[2] "\""
			}
			#print "MD5: " $0
			#print a[2], origs_dirs_names_a[a[2]], mdupe_files_a[a[2]]
			#print arraytree(origs_dirs_names_a[a[2]],a[2])
			}
			#arraytree(origs_dirs_names_a,"origs_dirs_names_a")
			#print origs_dirs_names_a[a[2]], mdupe_files_a[a[2]]
		print ""
		for(i in mdupe_sums_a){
			if(length(mdupe_sums_a[i])<2){delete mdupe_sums_a[i]}
		}
		#arraytree(mdupe_sums_a,"mdupe_sums_a")
		#exit
		#print cmd
		#system(cmd)
		#while((cmd|getline)>0){print "MD5: " $0}
		#close(cmd)
	}
}

function get_name_previewer_a(icondata,name_previewer_a,	i,j,s,a){
for(i in icondata){

if("w" in icondata[i]){
s=icondata[i]["w"]
}

if("h" in icondata[i]){
s=s "x" icondata[i]["h"]
}

if(s){
#name_previewer_a[s][gensub(/(^.*\/|\.[^.]*$)/,"","g",i)]++
a[s][gensub(/(^.*\/|\.[^.]*$)/,"","g",i)]++
}
}
for(i in a){
#name_previewer_a[i]=length(a[i])
for(j in a[i]){
name_previewer_a[i]>=a[i][j]?"":name_previewer_a[i]=a[i][j]
}
}
}

function unsplit(arr,s,	i,out){
# Превращаем массив в строку
	if(!isarray(arr) && !arr){
		print "\033[1mUnsplit GAWK function.\033[0m Returns string welded from flat array members.\n\033[1mSyntax:\033[0m\n\tstring=unsplit(array, [separator])"
		exit
	}
	if(isarray(arr)){
		if(!s){
			s=" "
		}
		if(isarray(s)){
			print "\033[1;31mUnsplit error!\033[0m Arrays as separators are not supported yet!"
		}else{
			for(i in arr){
				out=out (out?s:"") arr[i]
			}
		}
		return out
	}else{
		print "\033[1;31mUnsplit error!\033[0m First argument must be array!"
		exit -1
	}
}

function get_image_info(imgfile,icondata,filetype,	imgW,imgH,i,j,rs,nf,nc,chline,svghead,svgstart,aaline,img,arr,varr,vall,ext,nr,sect,a){ # три аргумента: файл,получаемый массив с данными, указание типа файла. Возвращает 1, если тип соответствует расширению, иначе 0.
	if(imgfile!~/^$/){
		ext=match(imgfile,/[^/]+\.([^.]*)$/,a)?a[1]:""
		while((getline chline<imgfile)>0 && nc<1 && nr<60){
			if(chline!~/^( *|\t*)$/ && !filetype){
				nr++
				if(!filetype){
					switch(chline){
						case /^\x89PNG/: # PNG
							filetype="png"
							nc=1
							break
						case /^GIF[0-9]+/: # GIF
							filetype="gif"
							nc=1
							break
						case /^\/\* XPM \*\//: # old XPM
							filetype="xpm"
							nc=1
							break
						case /(<[?a-zA-Z]+)/: # <> markup SVG/XML/HTML
							filetype="svg"
							break
						case /(\[.*\])/: # INI [Section] *.icon *.theme
							filetype="ini"
							nc=1
							break
						default:
							filetype="raw"
							nc=1
							break
					}
				}
				icondata["type"]=filetype
				icondata["ext"]=ext
			}
		}
		close(imgfile)

	## get SVG header
		if(filetype=="svg"){
			aaline=""
			nc=0
			svghead=""
			rs=RS
			RS="\n|\r"
			#RS="><"
			while((getline<imgfile)>0 && nc<1){
				if(tolower($0)~/<[^<>]*html>/){
					filetype="html"
					icondata["type"]=filetype
					nc=1
					break
				}else{
					aaline=aaline (aaline?" ":"") $0
					if(match(aaline,/<svg[^>]*>/,a)){
						svghead=gensub(/\s\s+/," ","g",a[0])
					nc=1
					}
				}
			}
			svghead?icondata["svghead"]=svghead:""
			RS=rs
			nc=1
		}
		
	## get sizes
		if(filetype=="svg" && svghead){
			if(svghead~/(width|height)=/){
			if(match(svghead,/width=[^0-9]*([0-9]*)(px)*/,arr)){if(2 in arr){arr[2]=="px"?imgW=arr[1]:""}else{imgW=arr[1]}}
			if(match(svghead,/height=[^0-9]*([0-9]*)(px)*/,arr)){if(2 in arr){arr[2]=="px"?imgH=arr[1]:""}else{imgH=arr[1]}}
			}else{
				match(svghead,/viewBox=[^0-9]*[0-9]+ [0-9]+ ([0-9]+) ([0-9]+)[^0-9]*/,arr)
				imgW=arr[1];imgH=arr[2]
			}
		}

		if(filetype=="png"){
			if("gdImageCreateFromFile" in FUNCTAB){
				ERRNO=""
				img=gdImageCreateFromFile(imgfile,"GDFILE_PNG")
				ERRNO~/^$/?"":icondata["error"][ERRNO]=ERRNO
				if(ERRNO~/^$/){
					imgW=gdImageSX(img)
					imgH=gdImageSY(img)
					ERRNO~/^$/?"":icondata["error"][ERRNO]=ERRNO
					ERRNO=""
					gdImageDestroy(img)
					ERRNO~/^$/?"":icondata["error"][ERRNO]=ERRNO
				}else{
					imgH=imgW="-1"
					icondata["error"][ERRNO]=ERRNO
				}
				ERRNO=""
			}
		}

		if(filetype=="xpm"){
			nc=""
			while((getline<imgfile)>0 && nc<1){
				aaline=$0
				if(aaline~/[0-9]+/){
					if(match(aaline,/" *([0-9]*) ([0-9]*) ([0-9]*) ([0-9]*) *"/,arr)){
						imgW=arr[1]
						imgH=arr[2]
						icondata["ncolors"]=arr[3]
						icondata["ch_per_pix"]=arr[4]
						nc=1
					}
				}
			}
		}

		if(filetype=="ini"){
			rs=RS
			RS="\n|\r"
			while((getline<imgfile)>0){
				if($0!~"^#|^;|^$"){
					gsub(" *[;#].*$","")
					if(match($0,/^\[(.*)\]/,a)){
						sect=a[1]
					}else{
						gsub(/ *$/,"") # delete spaces at end
						match($0,/ *([^ $]*) *= *(.*)$/,a) # get (parameter) and (value)
						icondata[sect ":" a[1]]=a[2]
					}
				}
			}
			RS=rs
			if(ext == "icon"){
				filetype="icon"
			}
		}

		if(filetype~/(xpm|png|svg)/){
			icondata["w"]=imgW
			icondata["h"]=imgH
		}

		if(2==3 && filetype=="ini" && ext == "icon"){
			rs=RS
			RS="\n|\r"
			while((getline<imgfile)>0){
				if($0!~"^#|^;|^$|[^[]"){
					gsub(/ +$/,"")
					match($0,/ *([^ $]*) *= *(.*) *$/,a)
					gsub(" *[;#].*$","")
					icondata[a[1]]=a[2]
				}
			}
			RS=rs
			filetype="icon"
		}

		if(2==3 && filetype=="ini" && ext != "icon"){
			rs=RS
			RS="\n|\r"
			while((getline<imgfile)>0){
				if($0!~"^#|^;|^$"){
					gsub(" *[;#].*$","")
					gsub(/ *$/,"")
					if($0~/^\[.*\]$/){
						sect=$0;gsub(/^\[|\].*$/,"",sect)
						icondata[sect]["#"]
						delete icondata[sect]["#"]
					}else{
						varr=vall=$0
						gsub(/ *=.*$/,"",varr)
						gsub(/^[^=]*= */,"",vall)
						icondata[sect][varr]=vall
					}
				}
			}
			RS=rs
		}

		#close(imgfile)
		ext~/(icon|theme)/?ext="ini":""
		#ext~/(theme)/?ext="ini":""
		return (ext?(ext==filetype?1:(filetype~"raw"?1:0)):1)
	}
}

function get_icons_by_name_list(theme_a,same_names_a,	i,j,out,a,conts_a,sizes_a){
out=""
#arraytree(same_names_a,"same_names_a")
#exit
# computer|devices,places|48, 22, 16|48:1 22:2 16:2|
	for(i in same_names_a){
	#print "+"i"+"
		for(j in same_names_a[i]){
			if(match(j,/^(.+)\/([^/]+)$/,a) && a[1] in theme_a){
				if("Context" in theme_a[a[1]]){
				#arraytree(theme_a[a[1]],"a")
				#exit
					conts_a[theme_a[a[1]]["Context"]]=theme_a[a[1]]["Context"]
				}
				if("Size" in theme_a[a[1]]){
					sizes_a[theme_a[a[1]]["Size"]]=theme_a[a[1]]["Size"]
				}
			}
		}
		out = out (out?"\n":"") i "|" unsplit(conts_a,", ") "|" unsplit(sizes_a,", ")
		#arraytree(conts_a,i"_conts")
		#arraytree(sizes_a,i"_sizes")
		delete conts_a
		delete sizes_a
	}
	#exit
	return out
}

function get_unsized(theme_a,icondata,unsized_a,	i,a){
	for(i in icondata){
		match(i,/^(.*)\/([^/]*)$/,a)
		if(a[1] in theme_a && "Size" in theme_a[a[1]]){
			if("w" in icondata[i] && "h" in icondata[i]){
			#((!"MaxSize" in theme_a[a[1]] || "MaxSize" in theme_a[a[1]] && (icondata[i]["w"] > theme_a[a[1]]["MaxSize"] || icondata[i]["h"] > theme_a[a[1]]["MaxSize"])) && (!"MinSize" in theme_a[a[1]] || "MinSize" in theme_a[a[1]] && (icondata[i]["w"] > theme_a[a[1]]["MinSize"] || icondata[i]["h"] > theme_a[a[1]]["MinSize"]))){
				if(("MaxSize" in theme_a[a[1]] && (icondata[i]["w"] > theme_a[a[1]]["MaxSize"] || icondata[i]["h"] > theme_a[a[1]]["MaxSize"])) || ("MinSize" in theme_a[a[1]] && (icondata[i]["w"] < theme_a[a[1]]["MinSize"] || icondata[i]["h"] < theme_a[a[1]]["MinSize"]))){
					unsized_a[a[1]][a[2]]["w"]=icondata[i]["w"]
					unsized_a[a[1]][a[2]]["h"]=icondata[i]["h"]
				}else{
					if(icondata[i]["w"]!=theme_a[a[1]]["Size"] || icondata[i]["h"]!=theme_a[a[1]]["Size"]){
						unsized_a[a[1]][a[2]]["w"]=icondata[i]["w"]
						unsized_a[a[1]][a[2]]["h"]=icondata[i]["h"]
					}
				}
			}
		}
	}
}

function list_user_arrays(	i,j){
	for(i in PROCINFO["identifiers"]){
		if(PROCINFO["identifiers"][i]=="untyped"){
			if(!j){
				print "Массивы:"
			}
			if(i in SYMTAB && isarray(SYMTAB[i])){
				print "\t"i " ("length(SYMTAB[i])")"
			}
			j=1
		}
	}
}


