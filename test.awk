#!/usr/bin/gawk -f
@load "filefuncs"
@load "json"
@load "readdir"

@include "include/fts.awk"
@include "include/dialog.awk"
@include "include/tools.awk"
@include "abspath"
@include "ini"
@include "arraytree"

BEGIN{
#main()
themefile="/home/joker/Документы/GitHub/Win98SE/SE98/index.theme"
themedir="/home/joker/Документы/GitHub/Win98SE/SE98"
readinif(themefile,theme_a)
#new(theme_a,example_a,example_a_s)
#arraytree(example_a,"example_a")
#arraytree(example_a_s,"example_a_s")
fs=FS
FS="/"
delete pathlist
while((getline<themedir)>0){
if($3~"d" && $2!~/^\.+$/){pathlist[$2]=$2}
}
FS=fs
arraytree(pathlist,"pathlist")
flags = FTS_LOGICAL
pwd=ENVIRON["PWD"]
chdir(themedir)
fts(pathlist, flags, fts_l)
flags = FTS_PHYSICAL
fts(pathlist, flags, fts_p)
chdir(pwd)
#arraytree(fts_p,"fts_p")
#exit
get_same_names(fts_l,same_names_a)
arraytree(same_names_a,"same_names_a")
#arraytree(fts_l,"fts_l")
get_dirs_links(fts_p,arr1)
arraytree(arr1,"arr1")
}



function new2(theme_a,tmp_a,example_a_s,	example,i,j){
	example=theme_a["Icon Theme"]["Example"]
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
}

function new1(	arr,arr1){
dir="test"
pwd=ENVIRON["PWD"]
while((getline<dir)>0){
split($0,a,"/")
a[2]~/\.+/?"":arr[a[2]]=a[2]
}
#arraytree(arr,"arr")
chdir(dir)
flags = or(FTS_PHYSICAL, FTS_COMFOLLOW)
#flags = FTS_PHYSICAL
fts(arr, flags, fts_p)

flags = FTS_LOGICAL
fts(arr, flags, fts_l)
chdir(pwd)

#arraytree(fts_l,"fts_l")
#exit
delete arr
get_all_files_data(fts_p,fts_l,arr)
arraytree(arr,"arr")
#arraytree(fts_p,"fts_p")
}

function main(){
#print abspath("22/../222")
#exit
dir="test"
pwd=ENVIRON["PWD"]
while((getline<dir)>0){
split($0,a,"/")
a[2]~/\.+/?"":arr[a[2]]=a[2]
}
arraytree(arr,"arr")
flags = or(FTS_PHYSICAL, FTS_COMFOLLOW)
flags = FTS_PHYSICAL
chdir(dir)
fts(arr, flags, fts_p)
chdir(pwd)
arraytree(fts_p,"fts_p")

#delete arr
#get_file_links(fts_p,arr1)
get_dirs_links(fts_p,arr1)
#arraytree(arr1,"arr1")
#arraytree(links,"links")


}
