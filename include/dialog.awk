#!/usr/bin/gawk -f

function compiledialog(dir,	fs,a,b,i,filedata,window_xml){
	fs=FS
	FS="/"
	while((getline<dir)>0){
		if($3!~"d"){
			if(match($2,/^[0-9]+/,a)){
				i=a[0]
				b[i]=dir"/"$2
			}
		}
	}
	FS=fs
	#arraytree(b,"b")
	MAIN_DIALOG=readfile(b["0"])
	for(i=1;i<length(b);i++){
		print b[i]
		filedata=readfile(b[i])
		match(filedata,/(<window[^>]*>)(.*)(<\/window>).*$/,a)
		match(a[1],/title="(.*)"/,c)
		labels_a[i]=c[1]
		notes_a[i]=a[2]
	}

	# разбираем диалог, чтобы в пустой ноутбук вставить страницы
	match(MAIN_DIALOG,/^(.*)(<notebook[^>]*>)(\s*)(<\/notebook>)(.*)$/,a)
	labelstring="labels=\"" unsplit(labels_a,"|") "\""
	gsub(/labels=".*"/,labelstring,a[2])
	a[3]=a[3] unsplit(notes_a,"\n")

	# a[1] До ноута
	# a[2] заголовок ноута
	# a[3] Это то, что надо наполнять страничками!
	# a[4] закрытие ноута
	# a[5] башмак документа

	# собираем воедино
	for(i=1;i<length(a)/3;i++){
		window_xml=window_xml (window_xml?"\n":"") a[i]
	}
	return window_xml
}

function builddialog(xmlfile,	out,zamena,a,i,j,context_s_a,contpage,contpages){
	# подготовка замены
	#%columnames%
	zamena["%columnames%"]=columnames_str
	#columnames_str?zamena["Имя|Size|Scale|Context|Type|MaxSize|MinSize|Threshold|Ошибки"]=columnames_str:""
	zamena["%themedir%"]=themedir
	zamena["%themename%"]=theme_a["Icon Theme"]["Name"]
	zamena["%contexts%"]=get_string_from_firstmembers(dirs_in_contexts,"|") # замена строчки для контекстов строкой из имён первых веток массива, разделённых вертикальной чертой |
	split(zamena["%contexts%"],context_s_a,"|")

	# чтение XML
	while((getline<xmlfile)>0){
	# TODO дублировать vbox-ы в ноутбуке можно командой match(out,/<notebook.*%contexts%.*>[^<>]*(^\s*<vbox.*<\/vbox>)[^<>]*<\/notebook/,a); (out=out a[1])
	out=out (out?"\n":"") $0
	}
	close(xmlfile)
	out=compiledialog("notebook")

	# размножаем vbox с контекстами
	match(out,/(.*<notebook[^>]*%contexts%[^>]*>)(\s*<vbox.*tab_%context%<\/variable>\s*<\/vbox>)(\s*<\/notebook>.*)/,a) # достаём из ноутбука vbox
	for(i in context_s_a){
		contpage=a[2]
		gsub("%context%",context_s_a[i],contpage)
		gsub(/^(\n*)/,"",contpage)
		contpages=contpages (contpages?"\n":"") contpage
	}

	gsub(/^(\n*)/,"",a[2])
	gsub(/^\t/,"",a[2])
	out=a[1] "\n" contpages "\n" a[3]

	for(i in zamena){ # проход по массиву с заменами, поиск и замена строки
		gsub(i,zamena[i],out)
	}

	# размножаем поимённую вкладку
	#patsplit(out,a[1],/<!--NAME_HIDE_SHOW_BEGIN-->.*<!--NAME_HIDE_SHOW_END-->/,a[2])
	#gsub(/<!--[^<>]*-->/,"",a[1][1])
	if(isarray(name_previewer_a)){ # name_previewer_a[size][number] -- size: все размеры, какие есть в теме; number: все номера у каждого размера
	#arraytree(name_previewer_a,"name_previewer_a")
	#exit
	if(match(out,/^(.*)<!--NAME_HIDE_SHOW_BEGIN-->(.*)<!--NAME_HIDE_SHOW_END-->.*<!--PIX_NAME_HIDE_SHOW_BEGIN-->(.*)<!--PIX_NAME_HIDE_SHOW_END-->(.*)$/,a)){
	out=a[1]
	for(i in name_previewer_a){
		out_tmp=a[2]
		gsub(/%NAME_S%/,i,out_tmp)
		out=out out_tmp #"\n"
		#print i, name_previewer_a[i];exit
		for(j=1;j<=name_previewer_a[i];j++){
			out_tmp=a[3]
			gsub(/%NAME_S%/,i,out_tmp)
			gsub(/%NAME_N%/,j,out_tmp)
			out=out out_tmp #"\n"
		}
		#print out_tmp;exit
	}
	out=out a[4]
	}
	}

	return out
}

function get_string_from_firstmembers(arr,delimiter,	out,arr1){
delimiter?"":delimiter=" "
asorti(arr,arr1)
for(i in arr1){
out=out (out?delimiter:"") arr1[i]
}
return out
}


