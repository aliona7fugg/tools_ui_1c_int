

#Область ОписаниеПеременных

#КонецОбласти

#Область EventHandlers

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ИсточникиКода = UT_CodeEditorServer.ДоступныеИсточникиИсходногоКода();
	
	Для Каждого ТекИсточник ИЗ ИсточникиКода Цикл
		НС = КаталогиСохранения.Добавить();
		НС.Пометка = Истина;
		НС.Источник = ТекИсточник.Значение;
		НС.ТолькоМодули = Истина;
		
		НС.Каталог = Параметры.ТекущиеКаталоги[НС.Источник];
	КонецЦикла;

	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();

	МассивПоказателейСтрокиСоединения = СтрРазделить(СтрокаСоединения, ";");
	СоответствиеПоказателейСтрокиСоединения = Новый Структура;
	Для Каждого СтрокаПоказателяСтрокиСоединения Из МассивПоказателейСтрокиСоединения Цикл
		МассивПоказателя = СтрРазделить(СтрокаПоказателяСтрокиСоединения, "=");
		Если МассивПоказателя.Количество() <> 2 Тогда
			Продолжить;
		КонецЕсли;
		Показатель = НРег(МассивПоказателя[0]);
		ЗначениеПоказателя = МассивПоказателя[1];
		СоответствиеПоказателейСтрокиСоединения.Вставить(Показатель, ЗначениеПоказателя);
	КонецЦикла;

	Если СоответствиеПоказателейСтрокиСоединения.Свойство("file") Тогда
		РасположениеБазы = 0;
		КаталогИнформационнойБазы = UT_StringFunctionsClientServer.PathWithoutQuotes(
			СоответствиеПоказателейСтрокиСоединения.File);
	ИначеЕсли СоответствиеПоказателейСтрокиСоединения.Свойство("srvr") Тогда
		РасположениеБазы = 1;
		СерверИБ = UT_StringFunctionsClientServer.PathWithoutQuotes(СоответствиеПоказателейСтрокиСоединения.srvr);
		ИмяБазы = UT_StringFunctionsClientServer.PathWithoutQuotes(СоответствиеПоказателейСтрокиСоединения.ref);
	КонецЕсли;
	Пользователь = ИмяПользователя();

	УстановитьВидимостьДоступность();
КонецПроцедуры


&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Для Каждого Стр Из КаталогиСохранения Цикл
		Если Не Стр.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Стр.Каталог) Тогда
			UT_CommonClientServer.MessageToUser("Для источника "+Стр.Источник+" не указан каталог сохранения", , , , Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Если РасположениеБазы = 0 Тогда
		ПроверяемыеРеквизиты.Добавить("КаталогИнформационнойБазы");
	Иначе
		ПроверяемыеРеквизиты.Добавить("СерверИБ");
		ПроверяемыеРеквизиты.Добавить("ИмяБазы");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если Не ВебКлиент И Не МобильныйКлиент Тогда
	ФайлЗапускаПлатформы = КаталогПрограммы();
	Если Прав(ФайлЗапускаПлатформы, 1) <> ПолучитьРазделительПути() Тогда
		ФайлЗапускаПлатформы = ФайлЗапускаПлатформы + ПолучитьРазделительПути();
	КонецЕсли;
	
	ФайлЗапускаПлатформы = ФайлЗапускаПлатформы + "1cv8";	
	Если UT_CommonClientServer.IsWindows() Тогда
		ФайлЗапускаПлатформы = ФайлЗапускаПлатформы + ".exe";
	КонецЕсли;
	
	#КонецЕсли
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы


&НаКлиенте
Процедура РасположениеБазыПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ФайлЗапускаПлатформыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОписаниеФайла = UT_CommonClient.EmptyDescriptionStructureOfSelectedFile();
	ОписаниеФайла.ИмяФайла = ФайлЗапускаПлатформы;

	ИмяФайла = "1cv8";
	
	Если UT_CommonClientServer.IsWindows() Тогда
		ИмяФайла = ИмяФайла+".exe";
	КонецЕсли;
	
	UT_CommonClient.AddFormatToSavingFileDescription(ОписаниеФайла, "Файл толстого клиента 1С("+ИмяФайла+")", "",ИмяФайла);
	
	UT_CommonClient.FormFieldFileNameStartChoice(ОписаниеФайла, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		РежимДиалогаВыбораФайла.Открытие,
		Новый ОписаниеОповещения("ФайлЗапускаПлатформыНачалоВыбораЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура КаталогиСохраненияКаталогНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекДанные = Элементы.КаталогиСохранения.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеФайла = UT_CommonClient.EmptyDescriptionStructureOfSelectedFile();
	ОписаниеФайла.ИмяФайла = ТекДанные.Каталог;
	
	ДопПараметрыОповещения = Новый Структура;
	ДопПараметрыОповещения.Вставить("ТекущаяСтрока", Элементы.КаталогиСохранения.ТекущаяСтрока);
	
	UT_CommonClient.FormFieldFileNameStartChoice(ОписаниеФайла, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		РежимДиалогаВыбораФайла.ВыборКаталога,
		Новый ОписаниеОповещения("КаталогиСохраненияКаталогНачалоВыбораЗаверешение", ЭтотОбъект,
		ДопПараметрыОповещения));
КонецПроцедуры

&НаКлиенте
Процедура КаталогИнформационнойБазыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОписаниеФайла = UT_CommonClient.EmptyDescriptionStructureOfSelectedFile();
	ОписаниеФайла.ИмяФайла = КаталогИнформационнойБазы;
	
	UT_CommonClient.FormFieldFileNameStartChoice(ОписаниеФайла, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		РежимДиалогаВыбораФайла.ВыборКаталога,
		Новый ОписаниеОповещения("КаталогиСохраненияКаталогНачалоВыбораЗаверешение", ЭтотОбъект));
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы


&НаКлиенте
Процедура ВыбратьОбщийКаталогСохранения(Команда)
	ДВФ = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДВФ.МножественныйВыбор = Ложь;
	ДВФ.Показать(Новый ОписаниеОповещения("ВыбратьОбщийКаталогСохраненияЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Команда)
	Для Каждого Стр Из КаталогиСохранения Цикл
		Стр.Пометка = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	Для Каждого Стр Из КаталогиСохранения Цикл
		Стр.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьИсходныеМодули(Команда)
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	КаталогиИсточников= Новый Массив();
	
	Для Каждого Стр Из КаталогиСохранения Цикл
		Если Не Стр.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеИсточника = Новый Структура;
		ОписаниеИсточника.Вставить("Источник", Стр.Источник);
		ОписаниеИсточника.Вставить("Каталог", Стр.Каталог);
		ОписаниеИсточника.Вставить("ТолькоМодули", Стр.ТолькоМодули);
		
		КаталогиИсточников.Добавить(ОписаниеИсточника);
	КонецЦикла;
	
	НастройкиСохранения = Новый Структура;
	НастройкиСохранения.Вставить("ФайлЗапускаПлатформы", ФайлЗапускаПлатформы);
	НастройкиСохранения.Вставить("Пользователь", Пользователь);
	НастройкиСохранения.Вставить("Пароль", Пароль);
	НастройкиСохранения.Вставить("КаталогиИсточников", КаталогиИсточников);
	НастройкиСохранения.Вставить("РасположениеБазы", РасположениеБазы);
	Если РасположениеБазы = 0 Тогда
		НастройкиСохранения.Вставить("КаталогИнформационнойБазы", КаталогИнформационнойБазы);
	Иначе
		НастройкиСохранения.Вставить("СерверИБ", СерверИБ);
		НастройкиСохранения.Вставить("ИмяБазы", ИмяБазы);
	КонецЕсли;
	
	Закрыть(НастройкиСохранения);
КонецПроцедуры



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьДоступность()
	Если РасположениеБазы = 0 Тогда
		НоваяСтраница = Элементы.ГруппаБазаФайловая;
	Иначе
		НоваяСтраница = Элементы.ГруппаБазаСерверная;
	КонецЕсли;
	
	Элементы.ГруппаСтраницыРаположенияБазы.ТекущаяСтраница = НоваяСтраница;
КонецПроцедуры

&НаКлиенте
Процедура ФайлЗапускаПлатформыНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Количество() = 0  Тогда
		Возврат;
	КонецЕсли;
	
	ФайлЗапускаПлатформы = Результат[0];
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОбщийКаталогСохраненияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	ОбщийКаталогСохранения = Результат[0];
	
	Для Каждого ТекСТр Из КаталогиСохранения Цикл
//		Если ЗначениеЗаполнено(ТекСТр.Каталог) Тогда
//			Продолжить;
//		КонецЕсли;
//		
		ТекСТр.Каталог = ОбщийКаталогСохранения + ПолучитьРазделительПути() + ТекСТр.Источник;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогиСохраненияКаталогНачалоВыбораЗаверешение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекДанные = КаталогиСохранения.НайтиПоИдентификатору(ДополнительныеПараметры.ТекущаяСтрока);
	ТекДанные.Каталог = Результат[0];
	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КаталогИнформационнойБазыНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Количество() = 0  Тогда
		Возврат;
	КонецЕсли;
	
	КаталогИнформационнойБазы = Результат[0];
	
КонецПроцедуры
#КонецОбласти