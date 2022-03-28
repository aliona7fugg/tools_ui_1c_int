&НаКлиенте
Перем ЗакрытиеФормыПодтверждено;
#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьАдресБиблиотекиНаСервере();

	Если Параметры.Свойство("СтрокаJSON") Тогда
		РедактируемаяСтрока=Параметры.СтрокаJSON;
		РежимРедактирования=Истина;
	КонецЕсли;

	Если Параметры.Свойство("РежимПросмотра") Тогда
		РежимРедактирования=Не Параметры.РежимПросмотра;
	КонецЕсли;
	Элементы.ФормаЗавершитьРедактирование.Видимость=РежимРедактирования;

	УИ_ОбщегоНазначения.ФормаИнструментаПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УИ_ОбщегоНазначенияКлиент.ПодключитьРасширениеРаботыСФайламиСВозможнойУстановкой(
		Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект));
КонецПроцедуры
&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Не ЗакрытиеФормыПодтверждено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	НачатьУдалениеФайлов(Новый ОписаниеОповещения("ПередЗакрытиемЗавершениеУдаленияФайлов", ЭтаФорма), КаталогСохраненияБибилиотеки);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершениеУдаленияФайлов(ДополнительныеПараметры) Экспорт
	
	

КонецПроцедуры

#КонецОбласти

#Область СобытияЭлементовФормы

&НаКлиенте
Процедура ПолеРедактораДокументСформирован(Элемент)
	Если ЗначениеЗаполнено(РедактируемаяСтрока) Тогда
		ПодключитьОбработчикОжидания("ОбработчикОжиданияУстановитьРедактируемуюСтрокуВРедакторДерево", 0.5, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолеРедактораСтрокаДокументСформирован(Элемент)
	Если ЗначениеЗаполнено(РедактируемаяСтрока) Тогда
		ПодключитьОбработчикОжидания("ОбработчикОжиданияУстановитьРедактируемуюСтрокуВРедакторСтроки", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьИзСтрокиВДерево(Команда)
	СтрокаJSON=СтрокаJSONИзПоляРедактора(Элементы.ПолеРедактораСтрока);
	СтрокаДерева=СтрокаJSONИзПоляРедактора(Элементы.ПолеРедактораДерево);

	УстановитьJSONВHTML(Элементы.ПолеРедактораДерево, СтрокаJSON);
	Если Не ЗначениеЗаполнено(СтрокаДерева) Тогда
		РазвернутьСтрокиДереваJSON(Элементы.ПолеРедактораДерево);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьИзДереваВСтроку(Команда)
	СтрокаJSON=СтрокаJSONИзПоляРедактора(Элементы.ПолеРедактораДерево);
	УстановитьJSONВHTML(Элементы.ПолеРедактораСтрока, СтрокаJSON);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	ЗакрытиеФормыПодтверждено=Истина;
	Закрыть(СтрокаJSONИзПоляРедактора(Элементы.ПолеРедактораСтрока));
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбщуюКомандуИнструментов(Команда) 
	УИ_ОбщегоНазначенияКлиент.Подключаемый_ВыполнитьОбщуюКомандуИнструментов(ЭтотОбъект, Команда);
КонецПроцедуры



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	СтруктураФайловыхПеременных=УИ_ОбщегоНазначенияКлиент.СтруктураФайловыхПеременныхСеанса();
	КаталогСохраненияБибилиотеки=СтруктураФайловыхПеременных.КаталогВременныхФайлов + "tools_ui_1c"
		+ ПолучитьРазделительПути() + Формат(УИ_ОбщегоНазначенияКлиент.НомерСеанса(), "ЧГ=0;") + ПолучитьРазделительПути() + "jsoneditor";
	ФайлРедактора=Новый Файл(КаталогСохраненияБибилиотеки);
	ФайлРедактора.НачатьПроверкуСуществования(Новый ОписаниеОповещения("ПриОткрытииЗавершениеПроверкиСуществованияБиблиотеки", ЭтаФорма));

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершениеПроверкиСуществованияБиблиотеки(Существует, ДополнительныеПараметры1) Экспорт
	
	Если Существует Тогда
		НачатьУдалениеФайлов(Новый ОписаниеОповещения("ПриОткрытииЗавершениеПроверкиСуществованияБиблиотекиЗавершениеУдаленияФайлов", ЭтаФорма,,"ПриОткрытииЗавершениеПроверкиСуществованияБиблиотекиЗавершениеОшибкаУдаленияФайлов", ЭтотОбъект), КаталогСохраненияБибилиотеки);
	Иначе
		ПриОткрытииЗавершениеПроверкиСуществованияБиблиотекиФрагмент();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершениеПроверкиСуществованияБиблиотекиЗавершениеУдаленияФайлов(ДополнительныеПараметры) Экспорт
	ПриОткрытииЗавершениеПроверкиСуществованияБиблиотекиФрагмент();
КонецПроцедуры  

&НаКлиенте
Процедура ПриОткрытииЗавершениеПроверкиСуществованияБиблиотекиЗавершениеОшибкаУдаленияФайлов(ДополнительныеПараметры) Экспорт
	КаталогСохраненияБибилиотеки=КаталогСохраненияБибилиотеки + "1";
	
	НачатьУдалениеФайлов(Новый ОписаниеОповещения("ПриОткрытииЗавершениеПроверкиСуществованияБиблиотекиЗавершениеУдаленияФайлов", ЭтаФорма,,"ПриОткрытииЗавершениеПроверкиСуществованияБиблиотекиЗавершениеОшибкаУдаленияФайлов", ЭтотОбъект), КаталогСохраненияБибилиотеки);
КонецПроцедуры  



&НаКлиенте
Процедура ПриОткрытииЗавершениеПроверкиСуществованияБиблиотекиФрагмент()
	
	НачатьСозданиеКаталога(Новый ОписаниеОповещения("ПриОткрытииЗавершениеСозданияКаталогаБиблиотеки", ЭтаФорма), КаталогСохраненияБибилиотеки);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершениеСозданияКаталогаБиблиотеки(ИмяКаталога, ДополнительныеПараметры) Экспорт
	
	СохранитьБиблиотекуРедактораНаДиск();
	УстановитьТекстHTMLПоляРедактора();

КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияУстановитьРедактируемуюСтрокуВРедакторДерево()
	Попытка
		УстановитьJSONВHTML(Элементы.ПолеРедактораДерево, РедактируемаяСтрока);
		РазвернутьСтрокиДереваJSON(Элементы.ПолеРедактораДерево);
	Исключение
		ПодключитьОбработчикОжидания("ОбработчикОжиданияУстановитьРедактируемуюСтрокуВРедакторДерево", 0.5, Истина);
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияУстановитьРедактируемуюСтрокуВРедакторСтроки()
	Попытка
		УстановитьJSONВHTML(Элементы.ПолеРедактораСтрока, РедактируемаяСтрока);
		//Форматируем строку JSON по формату редактора
		УстановитьJSONВHTML(Элементы.ПолеРедактораСтрока, СтрокаJSONИзПоляРедактора(Элементы.ПолеРедактораСтрока));

	Исключение
		ПодключитьОбработчикОжидания("ОбработчикОжиданияУстановитьРедактируемуюСтрокуВРедакторСтроки", 0.5, Истина);
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьJSONВHTML(ЭлементПоляРедактора, СтрокаJSON)
	ДокументHTML=ЭлементПоляРедактора.Документ;
	Если ДокументHTML.parentWindow = Неопределено Тогда
		СтруктураДокументаДОМ = ДокументHTML.defaultView;
	Иначе
		СтруктураДокументаДОМ = ДокументHTML.parentWindow;
	КонецЕсли;
	СтруктураДокументаДОМ.editor.setText(СтрокаJSON);

КонецПроцедуры

&НаКлиенте
Процедура РазвернутьСтрокиДереваJSON(ЭлементПоляРедактора)
	ДокументHTML=ЭлементПоляРедактора.Документ;
	Если ДокументHTML.parentWindow = Неопределено Тогда
		СтруктураДокументаДОМ = ДокументHTML.defaultView;
	Иначе
		СтруктураДокументаДОМ = ДокументHTML.parentWindow;
	КонецЕсли;
	СтруктураДокументаДОМ.editor.expandAll();

КонецПроцедуры

&НаКлиенте
Функция СтрокаJSONИзПоляРедактора(ЭлементПоляРедактора)
	ДокументHTML=ЭлементПоляРедактора.Документ;
	Если ДокументHTML.parentWindow = Неопределено Тогда
		СтруктураДокументаДОМ = ДокументHTML.defaultView;
	Иначе
		СтруктураДокументаДОМ = ДокументHTML.parentWindow;
	КонецЕсли;
//	Возврат СтруктураДокументаДОМ.editor.getText();
	Возврат СтруктураДокументаДОМ.getJSON();

КонецФункции

&НаКлиенте
Процедура УстановитьТекстHTMLПоляРедактора()
	ТекстCSS=КаталогСохраненияБибилиотеки + ПолучитьРазделительПути() + "jsoneditor.css";
	ТекстJS=КаталогСохраненияБибилиотеки + ПолучитьРазделительПути() + "jsoneditor.js";

	Шаблон= "<!DOCTYPE HTML>
			|<html>
			|<head>
			|  <title>JSONEditor | Synchronize two editors</title>
			|
			|	<link href=""" + ТекстCSS + """ rel=""stylesheet"" type=""text/css"">
											 |  <script src=""" + ТекстJS + """></script>
																			|
																			|  <style type=""text/css"">
																			|    body {
																			|      font-family: sans-serif;
																			|    }
																			|
																			|   .jsoneditor {
																			|      width: 100%;
																			|      height: 100%;
																			|    }
																			|  </style>
																			|</head>
																			|<body>
																			|	<div class=""jsoneditor"" id=""jsoneditor""></div>
																			|
																			|<script>
																			|
																			|  var container = document.getElementById('jsoneditor')
																			|  var options = {
																			|    // switch between pt-BR or en for testing forcing a language
																			|    // leave blank to get language
																			|   'language': 'ru-RU',
																			|   mode: '###РежимРедактора###'
																			|  }
																			|  var editor = new JSONEditor(container, options)
																			|
																			|	function getJSON(){
																			|		return JSON.stringify(editor.get(), null, 2);
																			|	}
																			|
																			|
																			|</script>
																			|	<div id=""footer""></div>
																			|
																			|</body>
																			|</html>";

	СохранитьФайлHTMLПоляРедатора(СтрЗаменить(Шаблон, "###РежимРедактора###", "tree"), КаталогСохраненияБибилиотеки + ПолучитьРазделительПути() + "tree.html" ,"ПолеРедактораДерево");
	СохранитьФайлHTMLПоляРедатора(СтрЗаменить(Шаблон, "###РежимРедактора###", "code"), КаталогСохраненияБибилиотеки + ПолучитьРазделительПути() + "code.html","ПолеРедактораСтрока");
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлHTMLПоляРедатора(ТекстHTML, ИмяФайла, ИмяПоляРедактора)
	Текст=Новый ТекстовыйДокумент;
	Текст.УстановитьТекст(ТекстHTML);
	
	ДопПараметры=Новый Структура;
	ДопПараметры.Вставить("ИмяПоляРедактора", ИмяПоляРедактора);
	ДопПараметры.Вставить("ИмяФайла", ИмяФайла);
	
	Текст.НачатьЗапись(Новый ОписаниеОповещения("СохранитьФайлHTMLПоляРедатораЗаверешение", ЭтотОбъект, ДопПараметры), ИмяФайла);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлHTMLПоляРедатораЗаверешение(Результат, ДополнительныеПараметры) Экспорт
	ЭтотОбъект[ДополнительныеПараметры.ИмяПоляРедактора] = ДополнительныеПараметры.ИмяФайла;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьБиблиотекуРедактораНаДиск()
	СоответствиеФайловБиблиотеки=ПолучитьИзВременногоХранилища(АдресБиблиотеки);
	Для Каждого КлючЗначение Из СоответствиеФайловБиблиотеки Цикл
		ИмяФайла=КаталогСохраненияБибилиотеки + ПолучитьРазделительПути() + КлючЗначение.Ключ;

		КлючЗначение.Значение.Записать(ИмяФайла);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьАдресБиблиотекиНаСервере()
	ОбработкаОбъект=РеквизитФормыВЗначение("Объект");

	ДвоичныеДанныеБиблиотеки=ОбработкаОбъект.ПолучитьМакет("jsoneditor");

	КаталогНаСервере=ПолучитьИмяВременногоФайла();
	СоздатьКаталог(КаталогНаСервере);

	Поток=ДвоичныеДанныеБиблиотеки.ОткрытьПотокДляЧтения();

	ЧтениеZIP=Новый ЧтениеZipФайла(Поток);
	ЧтениеZIP.ИзвлечьВсе(КаталогНаСервере, РежимВосстановленияПутейФайловZIP.Восстанавливать);

	СтруктураБиблиотеки=Новый Соответствие;

	ФайлыАрхива=НайтиФайлы(КаталогНаСервере, "*", Истина);
	Для Каждого ФайлБиблиотеки Из ФайлыАрхива Цикл
		КлючФайла=СтрЗаменить(ФайлБиблиотеки.ПолноеИмя, КаталогНаСервере + ПолучитьРазделительПути(), "");
		Если ФайлБиблиотеки.ЭтоКаталог() Тогда
			Продолжить;
		КонецЕсли;

		СтруктураБиблиотеки.Вставить(КлючФайла, Новый ДвоичныеДанные(ФайлБиблиотеки.ПолноеИмя));
	КонецЦикла;

	АдресБиблиотеки=ПоместитьВоВременноеХранилище(СтруктураБиблиотеки, УникальныйИдентификатор);

	Попытка
		УдалитьФайлы(КаталогНаСервере);
	Исключение
		// TODO:
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#Область СтандартныеПроцедурыИнструментов

&НаКлиенте
Функция СтруктураОписанияСохраняемогоФайла()
	Структура=УИ_ОбщегоНазначенияКлиент.ПустаяСтруктураОписанияВыбираемогоФайла();
	Структура.ИмяФайла=ИмяФайлаДанныхИнструмента;

	УИ_ОбщегоНазначенияКлиент.ДобавитьФорматВОписаниеФайлаСохранения(Структура, "Файл JSOM(*.json)", "json");
	Возврат Структура;
КонецФункции
&НаКлиенте
Процедура ОткрытьФайл(Команда)
	УИ_ОбщегоНазначенияКлиент.ПрочитатьДанныеКонсолиИзФайла("РедактовJSON", СтруктураОписанияСохраняемогоФайла(),
		Новый ОписаниеОповещения("ОткрытьФайлЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Модифицированность=Ложь;
	ИмяФайлаДанныхИнструмента = Результат.ИмяФайла;

	ДанныеФайла=ПолучитьИзВременногоХранилища(Результат.Адрес);

	Текст=Новый ТекстовыйДокумент;
	Текст.НачатьЧтение(Новый ОписаниеОповещения("ОткрытьФайлЗавершениеЧтенияТекста", ЭтаФорма, Новый Структура("Текст", Текст)), ДанныеФайла.ОткрытьПотокДляЧтения());
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлЗавершениеЧтенияТекста(ДополнительныеПараметры1) Экспорт
	
	Текст = ДополнительныеПараметры1.Текст;
	
	УстановитьJSONВHTML(Элементы.ПолеРедактораСтрока, Текст.ПолучитьТекст());
	УстановитьJSONВHTML(Элементы.ПолеРедактораДерево, Текст.ПолучитьТекст());
	УстановитьЗаголовок();

КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайл(Команда)
	СохранитьФайлНаДиск();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлКак(Команда)
	СохранитьФайлНаДиск(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлНаДиск(СохранитьКак = Ложь)
	УИ_ОбщегоНазначенияКлиент.СохранитьДанныеКонсолиВФайл("РедактовHTML", СохранитьКак,
		СтруктураОписанияСохраняемогоФайла(), СтрокаJSONИзПоляРедактора(Элементы.ПолеРедактораСтрока),
		Новый ОписаниеОповещения("СохранитьФайлЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлЗавершение(ИмяФайлаСохранения, ДополнительныеПараметры) Экспорт
	Если ИмяФайлаСохранения = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ИмяФайлаСохранения) Тогда
		Возврат;
	КонецЕсли;

	Модифицированность=Ложь;
	ИмяФайлаДанныхИнструмента=ИмяФайлаСохранения;
	УстановитьЗаголовок();
КонецПроцедуры

&НаКлиенте
Процедура НовыйФайл(Команда)
	ИмяФайлаДанныхИнструмента="";

	УстановитьJSONВHTML(Элементы.ПолеРедактораСтрока, "");
	УстановитьJSONВHTML(Элементы.ПолеРедактораДерево, "");

	УстановитьЗаголовок();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовок()
	Заголовок=ИмяФайлаДанныхИнструмента;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьИнструмент(Команда)
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗакрытьИнструментЗавершение", ЭтаФорма), "Выйти из редактора?",
		РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьИнструментЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗакрытиеФормыПодтверждено = Истина;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

ЗакрытиеФормыПодтверждено=Ложь;