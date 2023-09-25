#!/usr/bin/gawk -f
## Функции, связанные с физическим и логическим массивами fts, получение из них данных.

function get_real_dirs_files(fts_p,arr,	i,j,k,dir){
	for(i in fts_p){
		if("stat" in fts_p[i]){
			if(fts_p[i]["stat"]["type"]=="file"){
				dir=gensub(/(\/[^/]*$)/,"","g",fts_p[i]["path"])
				# print i, dir, fts_p[i]["stat"]["name"] #> "/home/joker/Документы/scripts/gtkdialog/icon-theme-tool/fts_p.txt"
				count++
				arr[dir][i]=(themedir?themedir"/"dir"/":"") i
			}
		}else{
			get_real_dirs_files(fts_p[i],arr)
		}
	}
	return count
}

function get_origs_dirs_names(fts_p,arr,	i,j,k,dir,name){
	for(i in fts_p){
		if("stat" in fts_p[i]){
			if(fts_p[i]["stat"]["type"]=="file"){
				dir=gensub(/(\/[^/]*$)/,"","g",fts_p[i]["path"])
				# print i, dir, fts_p[i]["stat"]["name"] #> "/home/joker/Документы/scripts/gtkdialog/icon-theme-tool/fts_p.txt"
				count++
				name=fts_p[i]["stat"]["name"]
				arr[dir"/"name]["dir"]=dir
				arr[dir"/"name]["name"]=name
				#[i]=(themedir?themedir"/"dir"/":"") i
			}
		}else{
			get_origs_dirs_names(fts_p[i],arr)
		}
	}
	return count
}

function get_same_names(fts_l,same_names_a,	i){
	if(isarray(fts_l)){
		if("stat" in fts_l && fts_l["stat"]["type"]!="directory"){
		#print i
		same_names_a[gensub(/\.[^.]*/,"",1,fts_l["stat"]["name"])][fts_l["path"]]
		}else{
			for(i in fts_l){
				get_same_names(fts_l[i],same_names_a)
			}
		}
	}
}

function get_all_files_data(fts_p,fts_l,arr,	i,j,k,dir,name,a){
	if("stat" in fts_l){
	if(match(fts_l["path"],/^(.*)\/([^/]*$)/,a)){
		dir=a[1]
		name=a[2]
	}else{
		dir="."
		name=fts_l["stat"]["name"]
	}
	#print "\033[1;33m"i"\033[0m"
	#print "arr["dir"]""["name"]"
	fts_l["stat"]["type"]=="symlink"?arr[dir][name]["type"]="deadlink":""
	if(fts_p["stat"]["type"]=="symlink"){
		arr[dir][name]["type"]="symlink"
		arr[dir][name]["linkval"]=fts_p["stat"]["linkval"]
	}
	if(fts_p["stat"]["type"]=="file"){
		arr[dir][name]["type"]="file"
	}
	if(fts_p["stat"]["type"]=="directory"){
		arr[dir][name]["type"]="directory"
	}
	arr[dir][name]["size"]=fts_l["stat"]["size"]
	#arraytree(fts_p,dir"/p/"name)
	#arraytree(fts_l,dir"/l/"name)
	}else{
		for(i in fts_l){
			get_all_files_data(fts_l[i],fts_p[i],arr,i)
		}
	}
}

#origs_dirs_names_a

# получить дерево файл=симлинк
# надо так же и директории залинковать
function get_dirs_links(fts_p,arr,	name,linkval,type,dir,a,i){
	for(i in fts_p){
	#print i
		if("stat" in fts_p[i]){
			if(fts_p[i]["stat"]["type"]=="symlink"){
				match(fts_p[i]["path"],/^(.*)\/([^/]*)$/,a)
				arr[a[1]][a[2]]=fts_p[i]["stat"]["linkval"]
				#print fts_p[i]["path"]" > "fts_p[i]["stat"]["linkval"] "("")"
			}
			if(fts_p[i]["stat"]["type"]=="directory"){
				#print " "fts_p[i]["path"]
			}
		}else{
			get_dirs_links(fts_p[i],arr)
		}
	}
	return count
}

function get_dead_links(fts_p,fts_l,arr,	i,a){
	for(i in fts_l){
		if("stat" in fts_l[i]){
			if("type" in fts_l[i]["stat"] && fts_l[i]["stat"]["type"]=="symlink"){
				match(fts_l[i]["path"],/^(.*)\/([^/]*)$/,a)
				arr[a[1]][a[2]]=fts_p[i]["stat"]["linkval"]
			}
		}else{
			get_dead_links(fts_p[i],fts_l[i],arr)
		}
	}
}

function get_file_links(fts_a,icon_link_array,	i,member,arrnum,dirinar,scale,dupnum,noext,linkval,l,j){ # создание массивов из массива fts (фрактальная функция)
	gotten?"":gotten=1
	if(isarray(fts_a)){
		if("stat" in fts_a){
			dirinar=member
			#gsub(/(^[^/]*\/|\/$)/,"",dirinar)
			if(fts_a["stat"]["type"]=="directory"){ # если это папка
				if(dirinar){
					#local_dir_paths[dirinar]=fts_a["path"]
				}
			}else{ # если это не папка
				noext=gensub(/\.[^.]*$/,"",1,fts_a["stat"]["name"])
				if(dirinar){
					#dirs_files_a[dirinar][fts_a["stat"]["name"]]["path"]=dirinar "/" fts_a["stat"]["name"] # массив с файлами
					#if(dirinar in themearr && "Scale" in themearr[dirinar]){scale=themearr[dirinar]["Scale"]}else{scale=1} # выставляем масштаб для папки, если не указан, то 1
					#iconplaces_a[fts_a["stat"]["name"]][dirinar]=dirinar # массив с папками, в которых есть файл с таким именем
					#dupnum_a[gensub(/\.[^.]*$/,"",1,fts_a["stat"]["name"])][themearr[dirinar]["Type"]][themearr[dirinar]["Size"]]["@"scale]++
					#if(dirinar in themearr && "Type" in themearr[dirinar] && "Size" in themearr[dirinar]){
					#	dupnum=++dupnum_a[gensub(/\.[^.]*$/,"",1,fts_a["stat"]["name"])][themearr[dirinar]["Type"]][themearr[dirinar]["Size"]]["@"scale]
					#	dupnum>1?icondupespresent[noext]=dupnum:""
					#}
					if(fts_a["stat"]["type"]=="symlink"){ # если это симлинк
						#dir_symlink_count[dirinar]++
						#print dirinar " " fts_a["stat"]["name"] " " fts_a["stat"]["type"]
						linkval=gensub(/[^/]*$/,"",1,fts_a["path"]) fts_a["stat"]["linkval"]
						#dirs_files_a[dirinar][fts_a["stat"]["name"]]["linkval"]=linkval
						#print dirinar "/" fts_a["stat"]["name"] " => " linkval
						totalpath=fts_a["path"]
						if("abspath" in FUNCTAB){
						linkval=abspath(linkval)
						#totalpath=abspath(totalpath)
						}
						icon_link_array[linkval][totalpath]=totalpath
					}else{ # если это НЕ симлинк
						if(fts_a["stat"]["type"]=="file"){
							#orig_dirs_files_fullpath_a[dirinar][fts_a["stat"]["name"]]=fts_a["path"]
							#dir_orig_count[dirinar]++
						}
					}
				}
			}
		}else{
			arrnum=i
			member=i?member i "/":"" # добавляем к папке подпапку
			for(i in fts_a){
				get_file_links(fts_a[i],icon_link_array,i,member,arrnum)
			}
		}
	}
}


function get_file_links1(fts_p,arr,	name,linkval,type,dir){
	for(i in fts_p){
		if("." in fts_p[i]){
		#print "D "i " " fts_p[i]["."]["path"]
		#dirs[fts_p[i]["."]["path"]]=fts_p[i]["."]["path"]
			#print fts_p[33]["."]["path"]
			#print dirs[fts_p[i]["."]["path"]]=fts_p[i]["."]["path"]
		}
		if("stat" in fts_p[i]){
		#print fts_p[i]["stat"]["name"] "==" fts_p[i]["stat"]["type"]
			dir=gensub(/(\/*[^/]*$)/,"","g",fts_p[i]["path"])
			name=fts_p[i]["stat"]["name"]
			type=fts_p[i]["stat"]["type"]
			#path=dir (dir?"/":"") or(fts_p[i]["path"], "somewhere")
			#path=dir (dir?"/":"") fts_p[i]["path"]
			path=fts_p[i]["path"]
			#print " " path
			if(fts_p[i]["stat"]["type"]=="symlink"){
				#linkval=dir (dir?"/":"") fts_p[i]["stat"]["linkval"]
				#print " "path " > " linkval
				#link_type=fts_p[linkval]["stat"]["type"]
				#print "linkval=["linkval"] path=["path"]"
				# print i, dir, fts_p[i]["stat"]["name"] #> "/home/joker/Документы/scripts/gtkdialog/icon-theme-tool/fts_p.txt"
				#count++
				linkval=dir (dir?"/":"") fts_p[i]["stat"]["linkval"]
				if("abspath" in FUNCTAB){linkval=abspath(linkval)}
				links[path]=linkval
				arr[linkval][path]=path	#"="link_type
				print linkval " = " fts_p[linkval]["stat"]["type"]
				print "  " linkval
				#arr[dir][i]=(themedir?themedir"/"dir"/":"") i
			}else{
			linkval=""
			#print name, type
			}
			#if(linkval in dirs){print "\t"linkval}
		}else{
		#print i
			get_file_links(fts_p[i],arr)
		}
	}
	return count
}

function getfiledirs_1(fts_a,local_dir_paths,	i,member,arrnum,dirinar,scale,dupnum,noext,linkval,l,j){ # создание массивов из массива fts (фрактальная функция)
	gotten?"":gotten=1
	if(!isarray(themearr)&&themefile&&"readinif" in FUNCTAB){
		readinif(themefile,themearr)
	}
	if(isarray(fts_a)){
		if("stat" in fts_a){
			dirinar=member
			gsub(/(^[^/]*\/|\/$)/,"",dirinar)
			if(fts_a["stat"]["type"]=="directory"){ # если это папка
				if(dirinar){
					local_dir_paths[dirinar]=fts_a["path"]
				}
			}else{ # если это не папка
				noext=gensub(/\.[^.]*$/,"",1,fts_a["stat"]["name"])
				if(dirinar){
					dirs_files_a[dirinar][fts_a["stat"]["name"]]["path"]=dirinar "/" fts_a["stat"]["name"] # массив с файлами
					if(dirinar in themearr && "Scale" in themearr[dirinar]){scale=themearr[dirinar]["Scale"]}else{scale=1} # выставляем масштаб для папки, если не указан, то 1
					iconplaces_a[fts_a["stat"]["name"]][dirinar]=dirinar # массив с папками, в которых есть файл с таким именем
					#dupnum_a[gensub(/\.[^.]*$/,"",1,fts_a["stat"]["name"])][themearr[dirinar]["Type"]][themearr[dirinar]["Size"]]["@"scale]++
					if(dirinar in themearr && "Type" in themearr[dirinar] && "Size" in themearr[dirinar]){
						dupnum=++dupnum_a[gensub(/\.[^.]*$/,"",1,fts_a["stat"]["name"])][themearr[dirinar]["Type"]][themearr[dirinar]["Size"]]["@"scale]
						dupnum>1?icondupespresent[noext]=dupnum:""
						#icondupespresent[noext]=icondupespresent[noext] (icondupespresent[noext]?";":"") dirinar
						iconsizes_a[noext][themearr[dirinar]["Type"]][themearr[dirinar]["Size"]]["@"scale][dirinar]=fts_a["path"] # TODO вот это, может, переписать под fts_logical, потому что он найдёт файлы в линко-папках?
					}
					if(fts_a["stat"]["type"]=="symlink"){ # если это симлинк
						dir_symlink_count[dirinar]++
						#print dirinar " " fts_a["stat"]["name"] " " fts_a["stat"]["type"]
						linkval=abspath(dirinar "/" fts_a["stat"]["linkval"])
						dirs_files_a[dirinar][fts_a["stat"]["name"]]["linkval"]=linkval
						#print dirinar "/" fts_a["stat"]["name"] " => " linkval
						icon_link_array[linkval][dirinar "/" fts_a["stat"]["name"]]=dirinar "/" fts_a["stat"]["name"]
					}else{ # если это НЕ симлинк
						if(fts_a["stat"]["type"]=="file"){
							orig_dirs_files_fullpath_a[dirinar][fts_a["stat"]["name"]]=fts_a["path"]
							dir_orig_count[dirinar]++
						}
					}
				}
			}
		}else{
			arrnum=i
			member=i?member i "/":"" # добавляем к папке подпапку
			for(i in fts_a){
				getfiledirs(fts_a[i],local_dir_paths,i,member,arrnum)
			}
		}
	}
}

