#Region ПрограммныйИнтерфейс

#Region СозданиеЭлементовФормы

Procedure FormOnCreateAtServer(Форма, ВидРедактора = Undefined) Экспорт
	If ВидРедактора = Undefined Then
		ПараметрыРедактора = ТекущиеПараметрыРедактораКода();
		ВидРедактора = ПараметрыРедактора.Вариант;
	EndIf;
	ВариантыРедактора = UT_CodeEditorClientServer.ВариантыРедактораКода();
	
	ЭтоWindowsКлиент = False;
	ЭтоВебКлиент = True;
	
	ПараметрыСеансаВХранилище = UT_CommonServerCall.CommonSettingsStorageLoad(
		UT_CommonClientServer.ObjectKeyInSettingsStorage(),
		UT_CommonClientServer.SessionParametersSettingsKey());
	If Type(ПараметрыСеансаВХранилище) = Type("Структура") Then
		If ПараметрыСеансаВХранилище.Свойство("HTMLFieldBasedOnWebkit") Then
			If Not ПараметрыСеансаВХранилище.HTMLFieldBasedOnWebkit Then
				ВидРедактора = ВариантыРедактора.Текст;
			EndIf;
		EndIf;
		If ПараметрыСеансаВХранилище.Свойство("IsWindowsClient") Then
			ЭтоWindowsКлиент = ПараметрыСеансаВХранилище.IsWindowsClient;
		EndIf;
		If ПараметрыСеансаВХранилище.Свойство("IsWebClient") Then
			ЭтоВебКлиент = ПараметрыСеансаВХранилище.IsWebClient;
		EndIf;
		
	EndIf;
	
	ИмяРеквизитаВидРедактора=UT_CodeEditorClientServer.ИмяРеквизитаРедактораКодаВидРедактора();
	ИмяРеквизитаАдресБиблиотеки=UT_CodeEditorClientServer.ИмяРеквизитаРедактораКодаАдресБиблиотеки();
	ИмяРеквизитаРедактораКодаСписокРедакторовФормы = UT_CodeEditorClientServer.ИмяРеквизитаРедактораКодаСписокРедакторовФормы();
	
	МассивРеквизитов=New Array;
	МассивРеквизитов.Add(New РеквизитФормы(ИмяРеквизитаВидРедактора, New TypeDescription("Строка", , New КвалификаторыСтроки(20,
		ДопустимаяДлина.Переменная)), "", "", True));
	МассивРеквизитов.Add(New РеквизитФормы(ИмяРеквизитаАдресБиблиотеки, New TypeDescription("Строка", , New КвалификаторыСтроки(0,
		ДопустимаяДлина.Переменная)), "", "", True));
	МассивРеквизитов.Add(New РеквизитФормы(ИмяРеквизитаРедактораКодаСписокРедакторовФормы, New TypeDescription, "", "", True));
		
	Форма.ИзменитьРеквизиты(МассивРеквизитов);
	
	Форма[ИмяРеквизитаВидРедактора]=ВидРедактора;
	Форма[ИмяРеквизитаАдресБиблиотеки] = ПоместитьБиблиотекуВоВременноеХранилище(Форма.УникальныйИдентификатор, ЭтоWindowsКлиент, ЭтоВебКлиент, ВидРедактора);
	Форма[ИмяРеквизитаРедактораКодаСписокРедакторовФормы] = New Structure;
EndProcedure

Procedure CreateCodeEditorItems(Форма, ИдентификаторРедактора, ПолеРедактора, ЯзыкРедактора = "bsl") Экспорт
	ИмяРеквизитаВидРедактора=UT_CodeEditorClientServer.ИмяРеквизитаРедактораКодаВидРедактора();
	
	ВидРедактора = Форма[ИмяРеквизитаВидРедактора];
	
	ДанныеРедактора = New Structure;

	If UT_CodeEditorClientServer.РедакторКодаИспользуетПолеHTML(ВидРедактора) Then
		If ПолеРедактора.Вид <> ВидПоляФормы.ПолеHTMLДокумента Then
			ПолеРедактора.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		EndIf;
		ПолеРедактора.УстановитьДействие("ДокументСформирован", "Подключаемый_ПолеРедактораДокументСформирован");
		ПолеРедактора.УстановитьДействие("ПриНажатии", "Подключаемый_ПолеРедактораПриНажатии");

		ДанныеРедактора.Insert("Инициализирован", False);

	Else
		ПолеРедактора.Вид = ВидПоляФормы.ПолеТекстовогоДокумента;
		ДанныеРедактора.Insert("Инициализирован", True);
	EndIf;

	ДанныеРедактора.Insert("Язык", ЯзыкРедактора);
	ДанныеРедактора.Insert("ПолеРедактора", ПолеРедактора.Имя);
	ДанныеРедактора.Insert("ИмяРеквизита", ПолеРедактора.ПутьКДанным);
	
	ВариантыРедактора = UT_CodeEditorClientServer.ВариантыРедактораКода();

	ПараметрыРедактора = ТекущиеПараметрыРедактораКода();
	ДанныеРедактора.Insert("ПараметрыРедактора", ПараметрыРедактора);

	If ВидРедактора = ВариантыРедактора.Monaco Then
		For Each КлючЗначение ИЗ ПараметрыРедактора.Monaco Do
			ДанныеРедактора.ПараметрыРедактора.Insert(КлючЗначение.Ключ, КлючЗначение.Значение);
		EndDo;
	EndIf;
	
	Форма[UT_CodeEditorClientServer.ИмяРеквизитаРедактораКодаСписокРедакторовФормы()].Insert(ИдентификаторРедактора,  ДанныеРедактора);	
EndProcedure

#EndRegion

Function ПоместитьБиблиотекуВоВременноеХранилище(ИдентификаторФормы, ЭтоWindowsКлиент, ЭтоВебКлиент, ВидРедактора=Undefined) Экспорт
	If ВидРедактора = Undefined Then
		ВидРедактора = ТекущийВариантРедактораКода1С();
	EndIf;
	ВариантыРедактора = UT_CodeEditorClientServer.ВариантыРедактораКода();
	
	If ВидРедактора = ВариантыРедактора.Monaco Then
		If ЭтоWindowsКлиент Then
			ДвоичныеДанныеБиблиотеки=ПолучитьОбщийМакет("UT_MonacoEditorWindows");
		Else
			ДвоичныеДанныеБиблиотеки=ПолучитьОбщийМакет("UT_MonacoEditor");
		EndIf;
	ElseIf ВидРедактора = ВариантыРедактора.Ace Then
		ДвоичныеДанныеБиблиотеки=ПолучитьОбщийМакет("UT_Ace");
	Else
		Return Undefined;
	EndIf;
	
	СтруктураБиблиотеки=New Map;

	If Not ЭтоВебКлиент Then
		СтруктураБиблиотеки.Insert("editor.zip",ДвоичныеДанныеБиблиотеки);

		Return ПоместитьВоВременноеХранилище(СтруктураБиблиотеки, ИдентификаторФормы);
	EndIf;
	
	КаталогНаСервере=ПолучитьИмяВременногоФайла();
	СоздатьКаталог(КаталогНаСервере);

	Поток=ДвоичныеДанныеБиблиотеки.ОткрытьПотокДляЧтения();

	ЧтениеZIP=New ЧтениеZipФайла(Поток);
	ЧтениеZIP.ИзвлечьВсе(КаталогНаСервере, РежимВосстановленияПутейФайловZIP.Восстанавливать);


	ФайлыАрхива=НайтиФайлы(КаталогНаСервере, "*", True);
	For Each ФайлБиблиотеки In ФайлыАрхива Do
		КлючФайла=СтрЗаменить(ФайлБиблиотеки.ПолноеИмя, КаталогНаСервере + ПолучитьРазделительПути(), "");
		If ФайлБиблиотеки.ЭтоКаталог() Then
			Continue;
		EndIf;

		СтруктураБиблиотеки.Insert(КлючФайла, New ДвоичныеДанные(ФайлБиблиотеки.ПолноеИмя));
	EndDo;

	АдресБиблиотеки=ПоместитьВоВременноеХранилище(СтруктураБиблиотеки, ИдентификаторФормы);

	Try
		УдалитьФайлы(КаталогНаСервере);
	Except
		// TODO:
	EndTry;

	Return АдресБиблиотеки;
EndFunction

#Region НастройкиИнструментов


Function ТекущийВариантРедактораКода1С() Экспорт
	ПараметрыРедактораКода = ТекущиеПараметрыРедактораКода();
	
	РедакторКода = ПараметрыРедактораКода.Вариант;
	
	УИ_ПараметрыСеанса = UT_Common.CommonSettingsStorageLoad(
		UT_CommonClientServer.ObjectKeyInSettingsStorage(),
		UT_CommonClientServer.SessionParametersSettingsKey());
		
	If Type(УИ_ПараметрыСеанса) = Type("Структура") Then
		If УИ_ПараметрыСеанса.HTMLFieldBasedOnWebkit<>True Then
			РедакторКода = UT_CodeEditorClientServer.ВариантыРедактораКода().Текст;
		EndIf;
	EndIf;
	
	Return РедакторКода;
EndFunction

Procedure УстановитьНовыеНастройкиРедактораКода(НовыеНастройки) Экспорт
	UT_Common.CommonSettingsStorageSave(
		UT_CommonClientServer.SettingsDataKeyInSettingsStorage(), "ПараметрыРедактораКода",
		НовыеНастройки);
EndProcedure

Function ТекущиеПараметрыРедактораКода() Экспорт
	СохраненныеПараметрыРедактора = UT_Common.CommonSettingsStorageLoad(
		UT_CommonClientServer.SettingsDataKeyInSettingsStorage(), "ПараметрыРедактораКода");

	ПараметрыПоУмолчанию = UT_CodeEditorClientServer.ПараметрыРедактораКодаПоУмолчанию();
	If СохраненныеПараметрыРедактора = Undefined Then		
		ПараметрыРедактораMonaco = ТекущиеПараметрыРедактораMonaco();
		
		FillPropertyValues(ПараметрыПоУмолчанию.Monaco, ПараметрыРедактораMonaco);
	Else
		FillPropertyValues(ПараметрыПоУмолчанию, СохраненныеПараметрыРедактора,,"Monaco");
		FillPropertyValues(ПараметрыПоУмолчанию.Monaco, СохраненныеПараметрыРедактора.Monaco);
	EndIf;
	
	Return ПараметрыПоУмолчанию;
	
EndFunction

#EndRegion

#Region Metadata

Function ConfigurationScriptVariant() Экспорт
	If Metadata.ВариантВстроенногоЯзыка = Metadata.СвойстваОбъектов.ВариантВстроенногоЯзыка.Английский Then
		Return "Английский";
	Else
		Return "Русский";
	EndIf;
EndFunction

Function ОбъектМетаданныхИмеетПредопределенные(ИмяТипаМетаданного)
	
	Объекты = New Array();
	Объекты.Add("справочник");
	Объекты.Add("справочники");
	Объекты.Add("плансчетов");	
	Объекты.Add("планысчетов");	
	Объекты.Add("планвидовхарактеристик");
	Объекты.Add("планывидовхарактеристик");
	Объекты.Add("планвидоврасчета");
	Объекты.Add("планывидоврасчета");
	
	Return Объекты.Find(НРег(ИмяТипаМетаданного)) <> Undefined;
	
EndFunction

Function ОбъектМетаданныхИмеетВиртуальныеТаблицы(ИмяТипаМетаданного)
	
	Объекты = New Array();
	Объекты.Add("РегистрыСведений");
	Объекты.Add("РегистрыНакопления");	
	Объекты.Add("РегистрыРасчета");
	Объекты.Add("РегистрыБухгалтерии");
	
	Return Объекты.Find(ИмяТипаМетаданного) <> Undefined;
	
EndFunction


Function ОписаниеРеквизитаОбъектаМетаданных(Реквизит,ТипВсеСсылки)
	Описание = New Structure;
	Описание.Insert("Имя", Реквизит.Имя);
	Описание.Insert("Синоним", Реквизит.Синоним);
	Описание.Insert("Комментарий", Реквизит.Комментарий);
	
	СсылочныеТипы = New Array;
	For каждого ТекТ In Реквизит.Тип.Типы() Do
		If ТипВсеСсылки.СодержитType(ТекТ) Then
			СсылочныеТипы.Add(ТекТ);
		EndIf;
	EndDo;
	Описание.Insert("Тип", New TypeDescription(СсылочныеТипы));
	
	Return Описание;
EndFunction

Function ОписаниеОбъектаМетаданныхКонфигурацииПоИмени(ВидОбъекта, ИмяОбъекта) Экспорт
	ТипВсеСсылки = UT_Common.AllRefsTypeDescription();

	Return ОписаниеОбъектаМетаданныхКонфигурации(Metadata[ВидОбъекта][ИмяОбъекта], ВидОбъекта, ТипВсеСсылки);	
EndFunction

Function ОписаниеОбъектаМетаданныхКонфигурации(ОбъектМетаданных, ВидОбъекта, ТипВсеСсылки, ВключатьОписаниеРеквизитов = True) Экспорт
	ОписаниеЭлемента = New Structure;
	ОписаниеЭлемента.Insert("ВидОбъекта", ВидОбъекта);
	ОписаниеЭлемента.Insert("Имя", ОбъектМетаданных.Имя);
	ОписаниеЭлемента.Insert("Синоним", ОбъектМетаданных.Синоним);
	ОписаниеЭлемента.Insert("Комментарий", ОбъектМетаданных.Комментарий);
	
	Расширение = ОбъектМетаданных.РасширениеКонфигурации();
	If Расширение <> Undefined Then
		ОписаниеЭлемента.Insert("Расширение", Расширение.Имя);
	Else
		ОписаниеЭлемента.Insert("Расширение", Undefined);
	EndIf;
	If НРег(ВидОбъекта) = "константа"
		Или НРег(ВидОбъекта) = "константы" Then
		ОписаниеЭлемента.Insert("Тип", ОбъектМетаданных.Тип);
	ElseIf НРег(ВидОбъекта) = "перечисление"
		Или НРег(ВидОбъекта) = "перечисления"Then
		ЗначенияПеречисления = New Structure;

		For Each ТекЗнч In ОбъектМетаданных.ЗначенияПеречисления Do
			ЗначенияПеречисления.Insert(ТекЗнч.Имя, ТекЗнч.Синоним);
		EndDo;

		ОписаниеЭлемента.Insert("ЗначенияПеречисления", ЗначенияПеречисления);
	EndIf;

	If Not ВключатьОписаниеРеквизитов Then
		Return ОписаниеЭлемента;
	EndIf;
	
	КоллекцииРеквизитов = New Structure("Реквизиты, СтандартныеРеквизиты, Измерения, Ресурсы, РеквизитыАдресации, ПризнакиУчета");
	КоллекцииТЧ = New Structure("ТабличныеЧасти, СтандартныеТабличныеЧасти");
	FillPropertyValues(КоллекцииРеквизитов, ОбъектМетаданных);
	FillPropertyValues(КоллекцииТЧ, ОбъектМетаданных);

	For Each КлючЗначение In КоллекцииРеквизитов Do
		If КлючЗначение.Значение = Undefined Then
			Continue;
		EndIf;

		ОписаниеКоллекцииРеквизитов= New Structure;

		For Each ТекРеквизит In КлючЗначение.Значение Do
			ОписаниеКоллекцииРеквизитов.Insert(ТекРеквизит.Имя, ОписаниеРеквизитаОбъектаМетаданных(ТекРеквизит,
				ТипВсеСсылки));
		EndDo;

		ОписаниеЭлемента.Insert(КлючЗначение.Ключ, ОписаниеКоллекцииРеквизитов);
	EndDo;

	For Each КлючЗначение In КоллекцииТЧ Do
		If КлючЗначение.Значение = Undefined Then
			Continue;
		EndIf;

		ОписаниеКоллекцииТЧ = New Structure;

		For Each ТЧ In КлючЗначение.Значение Do
			ОписаниеТЧ = New Structure;
			ОписаниеТЧ.Insert("Имя", ТЧ.Имя);
			ОписаниеТЧ.Insert("Синоним", ТЧ.Синоним);
			ОписаниеТЧ.Insert("Комментарий", ТЧ.Комментарий);

			КоллекцииРеквизитовТЧ = New Structure("Реквизиты, СтандартныеРеквизиты");
			FillPropertyValues(КоллекцииРеквизитовТЧ, ТЧ);
			For Each ТекКоллекцияРеквизитовТЧ In КоллекцииРеквизитовТЧ Do
				If ТекКоллекцияРеквизитовТЧ.Значение = Undefined Then
					Continue;
				EndIf;

				ОписаниеКоллекцииРеквизитовТЧ = New Structure;

				For Each ТекРеквизит In ТекКоллекцияРеквизитовТЧ.Значение Do
					ОписаниеКоллекцииРеквизитовТЧ.Insert(ТекРеквизит.Имя, ОписаниеРеквизитаОбъектаМетаданных(
						ТекРеквизит, ТипВсеСсылки));
				EndDo;

				ОписаниеТЧ.Insert(ТекКоллекцияРеквизитовТЧ.Ключ, ОписаниеКоллекцииРеквизитовТЧ);
			EndDo;
			ОписаниеКоллекцииТЧ.Insert(ТЧ.Имя, ОписаниеТЧ);
		EndDo;

		ОписаниеЭлемента.Insert(КлючЗначение.Ключ, ОписаниеКоллекцииТЧ);
	EndDo;


	If ОбъектМетаданныхИмеетПредопределенные(ВидОбъекта) Then

		Предопределенные = ОбъектМетаданных.ПолучитьИменаПредопределенных();

		ОписаниеПредопределенных = New Structure;
		For Each Имя In Предопределенные Do
			ОписаниеПредопределенных.Insert(Имя, "");
		EndDo;

		ОписаниеЭлемента.Insert("Предопределенные", ОписаниеПредопределенных);
	EndIf;
	
	Return ОписаниеЭлемента;
EndFunction

Function ОписаниеКоллекцииМетаданныхКонфигурации(Коллекция, ВидОбъекта, СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов) 
	ОписаниеКоллекции = New Structure();

	For Each ОбъектМетаданных In Коллекция Do
		ОписаниеЭлемента = ОписаниеОбъектаМетаданныхКонфигурации(ОбъектМетаданных, ВидОбъекта, ТипВсеСсылки, ВключатьОписаниеРеквизитов);
			
		ОписаниеКоллекции.Insert(ОбъектМетаданных.Имя, ОписаниеЭлемента);
		
		If UT_Common.IsRefTypeObject(ОбъектМетаданных) Then
			СоответствиеТипов.Insert(Type(ВидОбъекта+"Ссылка."+ОписаниеЭлемента.Имя), ОписаниеЭлемента);
		EndIf;
		
	EndDo;
	
	Return ОписаниеКоллекции;
EndFunction

Function ОписаниеОбщихМодулейКонфигурации() Экспорт
	ОписаниеКоллекции = New Structure();

	For Each ОбъектМетаданных In Metadata.ОбщиеМодули Do
			
		ОписаниеКоллекции.Insert(ОбъектМетаданных.Имя, New Structure);
		
	EndDo;
	
	Return ОписаниеКоллекции;
EndFunction

Function ОписнаиеМетаданныйДляИнициализацииРедактораMonaco() Экспорт
	СоответствиеТипов = New Map;
	ТипВсеСсылки = UT_Common.AllRefsTypeDescription();

	ОписаниеМетаданных = New Structure;
	ОписаниеМетаданных.Insert("ОбщиеМодули", ОписаниеОбщихМодулейКонфигурации());
//	ОписаниеМетаданных.Insert("Роли", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.Роли, "Роль", СоответствиеТипов, ТипВсеСсылки));
//	ОписаниеМетаданных.Insert("ОбщиеФормы", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.ОбщиеФормы, "ОбщаяФорма", СоответствиеТипов, ТипВсеСсылки));

	Return ОписаниеМетаданных;	
EndFunction

Function ОписаниеМетаданныхКонфигурации(ВключатьОписаниеРеквизитов = True) Экспорт
	ТипВсеСсылки = UT_Common.AllRefsTypeDescription();
	
	ОписаниеМетаданных = New Structure;
	
	СоответствиеТипов = New Map;
	
	ОписаниеМетаданных.Insert("Имя", Metadata.Имя);
	ОписаниеМетаданных.Insert("Версия", Metadata.Версия);
	ОписаниеМетаданных.Insert("ТипВсеСсылки", ТипВсеСсылки);
	
	ОписаниеМетаданных.Insert("Справочники", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.Справочники, "Справочник", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("Документы", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.Документы, "Документ", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("РегистрыСведений", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.РегистрыСведений, "РегистрСведений", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("РегистрыНакопления", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.РегистрыНакопления, "РегистрНакопления", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("РегистрыБухгалтерии", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.РегистрыБухгалтерии, "РегистрБухгалтерии", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("РегистрыРасчета", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.РегистрыРасчета, "РегистрРасчета", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("Обработки", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.Обработки, "Обработка", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("Отчеты", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.Отчеты, "Отчет", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("Перечисления", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.Перечисления, "Перечисление", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("ОбщиеМодули", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.ОбщиеМодули, "ОбщийМодуль", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("ПланыСчетов", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.ПланыСчетов, "ПланСчетов", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("БизнесПроцессы", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.БизнесПроцессы, "БизнесПроцесс", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("Задачи", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.Задачи, "Задача", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("ПланыСчетов", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.ПланыСчетов, "ПланСчетов", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("ПланыОбмена", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.ПланыОбмена, "ПланОбмена", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("ПланыВидовХарактеристик", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.ПланыВидовХарактеристик, "ПланВидовХарактеристик", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("ПланыВидовРасчета", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.ПланыВидовРасчета, "ПланВидовРасчета", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("Константы", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.Константы, "Константа", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	ОписаниеМетаданных.Insert("ПараметрыСеанса", ОписаниеКоллекцииМетаданныхКонфигурации(Metadata.ПараметрыСеанса, "ПараметрСеанса", СоответствиеТипов, ТипВсеСсылки, ВключатьОписаниеРеквизитов));
	
	ОписаниеМетаданных.Insert("СоответствиеСсылочныхТипов", СоответствиеТипов);
	
	Return ОписаниеМетаданных;
EndFunction

Function АдресОписанияМетаданныхКонфигурации() Экспорт
	ОПисание = ОписаниеМетаданныхКонфигурации();
	
	Return ПоместитьВоВременноеХранилище(ОПисание, New УникальныйИдентификатор);
EndFunction

Function СписокМетаданныхПоВиду(ВидМетаданных) Экспорт
	КоллекцияМетаданных = Metadata[ВидМетаданных];
	
	МассивИмен = New Array;
	For Each ОбъектМетаданных In КоллекцияМетаданных Do
		МассивИмен.Add(ОбъектМетаданных.Имя);
	EndDo;
	
	Return МассивИмен;
EndFunction

Procedure ДобавитьКоллекциюМетаданныхВСоответствиеСсылочныхТипов(СоответствиеТипов, Коллекция, ВидОбъекта)
	For Each ОбъектМетаданных In Коллекция Do
		ОписаниеЭлемента = New Structure;
		ОписаниеЭлемента.Insert("Имя", ОбъектМетаданных.Имя);
		ОписаниеЭлемента.Insert("ВидОбъекта", ВидОбъекта);
			
		СоответствиеТипов.Insert(Type(ВидОбъекта+"Ссылка."+ОбъектМетаданных.Имя), ОписаниеЭлемента);
	EndDo;
	
EndProcedure

Function СоответствиеСсылочныхТипов() Экспорт
	Соответствие = New Map;
	ДобавитьКоллекциюМетаданныхВСоответствиеСсылочныхТипов(Соответствие, Metadata.Справочники, "Справочник");
	ДобавитьКоллекциюМетаданныхВСоответствиеСсылочныхТипов(Соответствие, Metadata.Документы, "Документ");
	ДобавитьКоллекциюМетаданныхВСоответствиеСсылочныхТипов(Соответствие, Metadata.Перечисления, "Перечисление");
	ДобавитьКоллекциюМетаданныхВСоответствиеСсылочныхТипов(Соответствие, Metadata.ПланыСчетов, "ПланСчетов");
	ДобавитьКоллекциюМетаданныхВСоответствиеСсылочныхТипов(Соответствие, Metadata.БизнесПроцессы, "БизнесПроцесс");
	ДобавитьКоллекциюМетаданныхВСоответствиеСсылочныхТипов(Соответствие, Metadata.Задачи, "Задача");
	ДобавитьКоллекциюМетаданныхВСоответствиеСсылочныхТипов(Соответствие, Metadata.ПланыСчетов, "ПланСчетов");
	ДобавитьКоллекциюМетаданныхВСоответствиеСсылочныхТипов(Соответствие, Metadata.ПланыОбмена, "ПланОбмена");
	ДобавитьКоллекциюМетаданныхВСоответствиеСсылочныхТипов(Соответствие, Metadata.ПланыВидовХарактеристик, "ПланВидовХарактеристик");
	ДобавитьКоллекциюМетаданныхВСоответствиеСсылочныхТипов(Соответствие, Metadata.ПланыВидовРасчета, "ПланВидовРасчета");

	Return Соответствие;
EndFunction

#EndRegion


#EndRegion

#Region СлужебныйПрограммныйИнтерфейс

Function ТекущиеПараметрыРедактораMonaco() Экспорт
	ПараметрыИзХранилища =  UT_Common.CommonSettingsStorageLoad(
		UT_CommonClientServer.SettingsDataKeyInSettingsStorage(), "ПараметрыРедактораMonaco",
		UT_CodeEditorClientServer.ПараметрыРедактораMonacoПоУмолчанию());

	ПараметрыПоУмолчанию = UT_CodeEditorClientServer.ПараметрыРедактораMonacoПоУмолчанию();
	FillPropertyValues(ПараметрыПоУмолчанию, ПараметрыИзХранилища);

	Return ПараметрыПоУмолчанию;
EndFunction

Function ДоступныеИсточникиИсходногоКода() Экспорт
	Массив = New СписокЗначений();
	
	Массив.Add("ОсновнаяКонфигурация", "Основная конфигурация");
	
	МассивРасширений = РасширенияКонфигурации.Получить();
	For Each ТекРасширение In МассивРасширений Do
		Массив.Add(ТекРасширение.Имя, ТекРасширение.Синоним);
	EndDo;
	
	Return Массив;
EndFunction

#EndRegion

#Region Internal

#EndRegion