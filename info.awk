#!/usr/bin/gawk -f
@load "json"
@include "arraytree"
#@include "ini"

function readinif(file,arr,	rs,var,val,sect,varr,vall){	#read ini file and convert it to a 2D gawk array.
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


BEGIN{
#getline json < "icondata.json"
#json::from_json(json,a)
readinif("icondata.ini",a)
#arraytree(a[ARGV[1]],"a")
#print length(a)
#main()
main(ARGV[1],a)
}

function main(string,a){
#print string
split(string,pf,"!")
#arraytree(pf,"pf")
#exit
if(pf[1]"/"pf[2] in a){
arraytree(a[pf[1]"/"pf[2]],pf[2])
print pf[2] ":" > "data/iconinfo.txt"
for(i in a[pf[1]"/"pf[2]]){
print "\t"i"="a[pf[1]"/"pf[2]][i] > "data/iconinfo.txt"
}
close("data/iconinfo.txt")
}
#arraytree(a[pf[1]]"/"a[pf[2]],"a["pf[1]"/a"pf[2]"]")
#arraytree(a[pf[1]][pf[2]],"a["pf[1]"]["pf[2]"]")
}
