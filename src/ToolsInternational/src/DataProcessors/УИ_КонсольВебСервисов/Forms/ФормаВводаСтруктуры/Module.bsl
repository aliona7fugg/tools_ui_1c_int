&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)

	Структура = Новый Структура;

	Для Каждого Строка Из VT_Structure Цикл
		Структура.Вставить(Строка.Ключ, Строка.Значение);
	КонецЦикла;

	Закрыть(Структура);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ТипЗнч(Параметры.ПрошлоеЗначение) = Тип("Структура") Тогда
		Для Каждого Строка Из Параметры.ПрошлоеЗначение Цикл
			НоваяСтрока = VT_Structure.Добавить();
			НоваяСтрока.Key = Строка.Key;
			НоваяСтрока.Value = Строка.Value;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры