#Область СлужебныеПроцедурыИФункции

// Возвращает новую таблицу свойств фоновых заданий.
//
// Возвращаемое значение:
//  ТаблицаЗначений.
//
Функция НовыеСвойстваФоновыхЗаданий()

	НоваяТаблица = Новый ТаблицаЗначений;
	НоваяТаблица.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Ключ", Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Начало", Новый ОписаниеТипов("Дата"));
	НоваяТаблица.Колонки.Добавить("Конец", Новый ОписаниеТипов("Дата"));
	НоваяТаблица.Колонки.Добавить("ИдентификаторРегламентногоЗадания", Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Состояние", Новый ОписаниеТипов("СостояниеФоновогоЗадания"));
	НоваяТаблица.Колонки.Добавить("ИмяМетода", Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Расположение", Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("ОписаниеИнформацииОбОшибке", Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("ПопыткаЗапуска", Новый ОписаниеТипов("Число"));
	НоваяТаблица.Колонки.Добавить("СообщенияПользователю", Новый ОписаниеТипов("Массив"));
	НоваяТаблица.Колонки.Добавить("НомерСеанса", Новый ОписаниеТипов("Число"));
	НоваяТаблица.Колонки.Добавить("НачалоСеанса", Новый ОписаниеТипов("Дата"));
	НоваяТаблица.Индексы.Добавить("Идентификатор, Начало");

	Возврат НоваяТаблица;

КонецФункции

Функция ПоследнееФоновоеЗаданиеВМассиве(МассивФоновыхЗаданий, ПоследнееФоновоеЗадание = Неопределено)

	Для Каждого ТекущееФоновоеЗадание Из МассивФоновыхЗаданий Цикл
		Если ПоследнееФоновоеЗадание = Неопределено Тогда
			ПоследнееФоновоеЗадание = ТекущееФоновоеЗадание;
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(ПоследнееФоновоеЗадание.Конец) Тогда
			Если Не ЗначениеЗаполнено(ТекущееФоновоеЗадание.Конец) Или ПоследнееФоновоеЗадание.Конец
				< ТекущееФоновоеЗадание.Конец Тогда
				ПоследнееФоновоеЗадание = ТекущееФоновоеЗадание;
			КонецЕсли;
		Иначе
			Если Не ЗначениеЗаполнено(ТекущееФоновоеЗадание.Конец) И ПоследнееФоновоеЗадание.Начало
				< ТекущееФоновоеЗадание.Начало Тогда
				ПоследнееФоновоеЗадание = ТекущееФоновоеЗадание;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат ПоследнееФоновоеЗадание;

КонецФункции

Процедура ДобавитьСвойстваФоновыхЗаданий(Знач МассивФоновыхЗаданий, Знач ТаблицаСвойствФоновыхЗаданий)

	Индекс = МассивФоновыхЗаданий.Количество() - 1;
	Пока Индекс >= 0 Цикл
		ФоновоеЗадание = МассивФоновыхЗаданий[Индекс];
		Строка = ТаблицаСвойствФоновыхЗаданий.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, ФоновоеЗадание);
		Строка.Идентификатор = ФоновоеЗадание.УникальныйИдентификатор;
		РегламентноеЗадание = ФоновоеЗадание.РегламентноеЗадание;

		Если РегламентноеЗадание = Неопределено И UT_StringFunctionsClientServer.ЭтоУникальныйИдентификатор(
			ФоновоеЗадание.Ключ) Тогда

			РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(
				Новый УникальныйИдентификатор(ФоновоеЗадание.Ключ));
		КонецЕсли;
		Строка.ИдентификаторРегламентногоЗадания = ?(
			РегламентноеЗадание = Неопределено, "", РегламентноеЗадание.УникальныйИдентификатор);

		Строка.ОписаниеИнформацииОбОшибке = ?(
			ФоновоеЗадание.ИнформацияОбОшибке = Неопределено, "", ПодробноеПредставлениеОшибки(
			ФоновоеЗадание.ИнформацияОбОшибке));

		Индекс = Индекс - 1;
	КонецЦикла;

КонецПроцедуры

// Возвращает таблицу свойств фоновых заданий.
//  Структуру таблицы смотри в функции ПустаяТаблицаСвойствФоновыхЗаданий().
// 
// Параметры:
//  Отбор        - Структура - допустимые поля:
//                 Идентификатор, Ключ, Состояние, Начало, Конец,
//                 Наименование, ИмяМетода, РегламентноеЗадание. 
//
// Возвращаемое значение:
//  ТаблицаЗначений  - возвращается таблица после отбора.
//
Функция СвойстваФоновыхЗаданий(Отбор = Неопределено) Экспорт

	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);

	Таблица = НовыеСвойстваФоновыхЗаданий();

	Если ЗначениеЗаполнено(Отбор) И Отбор.Свойство("ПолучитьПоследнееФоновоеЗаданиеРегламентногоЗадания") Тогда
		Отбор.Удалить("ПолучитьПоследнееФоновоеЗаданиеРегламентногоЗадания");
		ПолучитьПоследнее = Истина;
	Иначе
		ПолучитьПоследнее = Ложь;
	КонецЕсли;

	РегламентноеЗадание = Неопределено;
	
	// Добавление истории фоновых заданий, полученных с сервера.
	Если ЗначениеЗаполнено(Отбор) И Отбор.Свойство("ИдентификаторРегламентногоЗадания") Тогда
		Если Отбор.ИдентификаторРегламентногоЗадания <> "" Тогда
			РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(
				Новый УникальныйИдентификатор(Отбор.ИдентификаторРегламентногоЗадания));
			ТекущийОтбор = Новый Структура("Ключ", Отбор.ИдентификаторРегламентногоЗадания);
			ФоновыеЗаданияЗапущенныеВручную = ФоновыеЗадания.ПолучитьФоновыеЗадания(ТекущийОтбор);
			Если РегламентноеЗадание <> Неопределено Тогда
				ПоследнееФоновоеЗадание = РегламентноеЗадание.ПоследнееЗадание;
			КонецЕсли;
			Если Не ПолучитьПоследнее Или ПоследнееФоновоеЗадание = Неопределено Тогда
				ТекущийОтбор = Новый Структура("РегламентноеЗадание", РегламентноеЗадание);
				АвтоматическиеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(ТекущийОтбор);
			КонецЕсли;
			Если ПолучитьПоследнее Тогда
				Если ПоследнееФоновоеЗадание = Неопределено Тогда
					ПоследнееФоновоеЗадание = ПоследнееФоновоеЗаданиеВМассиве(АвтоматическиеФоновыеЗадания);
				КонецЕсли;

				ПоследнееФоновоеЗадание = ПоследнееФоновоеЗаданиеВМассиве(
					ФоновыеЗаданияЗапущенныеВручную, ПоследнееФоновоеЗадание);

				Если ПоследнееФоновоеЗадание <> Неопределено Тогда
					МассивФоновыхЗаданий = Новый Массив;
					МассивФоновыхЗаданий.Добавить(ПоследнееФоновоеЗадание);
					ДобавитьСвойстваФоновыхЗаданий(МассивФоновыхЗаданий, Таблица);
				КонецЕсли;
				Возврат Таблица;
			КонецЕсли;
			ДобавитьСвойстваФоновыхЗаданий(ФоновыеЗаданияЗапущенныеВручную, Таблица);
			ДобавитьСвойстваФоновыхЗаданий(АвтоматическиеФоновыеЗадания, Таблица);
		Иначе
			МассивФоновыхЗаданий = Новый Массив;
			ВсеИдентификаторыРегламентныхЗаданий = Новый Соответствие;
			Для Каждого ТекущееЗадание Из РегламентныеЗадания.ПолучитьРегламентныеЗадания() Цикл
				ВсеИдентификаторыРегламентныхЗаданий.Вставить(
					Строка(ТекущееЗадание.УникальныйИдентификатор), Истина);
			КонецЦикла;
			ВсеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания();
			Для Каждого ТекущееЗадание Из ВсеФоновыеЗадания Цикл
				Если ТекущееЗадание.РегламентноеЗадание = Неопределено
					И ВсеИдентификаторыРегламентныхЗаданий[ТекущееЗадание.Ключ] = Неопределено Тогда

					МассивФоновыхЗаданий.Добавить(ТекущееЗадание);
				КонецЕсли;
			КонецЦикла;
			ДобавитьСвойстваФоновыхЗаданий(МассивФоновыхЗаданий, Таблица);
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(Отбор) Тогда
			МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания();
		Иначе
			Если Отбор.Свойство("Идентификатор") Тогда
				Отбор.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор(Отбор.Идентификатор));
				Отбор.Удалить("Идентификатор");
			КонецЕсли;
			МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
			Если Отбор.Свойство("УникальныйИдентификатор") Тогда
				Отбор.Вставить("Идентификатор", Строка(Отбор.УникальныйИдентификатор));
				Отбор.Удалить("УникальныйИдентификатор");
			КонецЕсли;
		КонецЕсли;
		ДобавитьСвойстваФоновыхЗаданий(МассивФоновыхЗаданий, Таблица);
	КонецЕсли;

	Если ЗначениеЗаполнено(Отбор) И Отбор.Свойство("ИдентификаторРегламентногоЗадания") Тогда
		РегламентныеЗаданияДляОбработки = Новый Массив;
		Если Отбор.ИдентификаторРегламентногоЗадания <> "" Тогда
			Если РегламентноеЗадание = Неопределено Тогда
				РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(
					Новый УникальныйИдентификатор(Отбор.ИдентификаторРегламентногоЗадания));
			КонецЕсли;
			Если РегламентноеЗадание <> Неопределено Тогда
				РегламентныеЗаданияДляОбработки.Добавить(РегламентноеЗадание);
			КонецЕсли;
		КонецЕсли;
	Иначе
		РегламентныеЗаданияДляОбработки = РегламентныеЗадания.ПолучитьРегламентныеЗадания();
	КонецЕсли;

	Таблица.Сортировать("Начало Убыв, Конец Убыв");
	
	// Отбор фоновых заданий.
	Если ЗначениеЗаполнено(Отбор) Тогда
		Начало    = Неопределено;
		Конец     = Неопределено;
		Состояние = Неопределено;
		Если Отбор.Свойство("Начало") Тогда
			Начало = ?(ЗначениеЗаполнено(Отбор.Начало), Отбор.Начало, Неопределено);
			Отбор.Удалить("Начало");
		КонецЕсли;
		Если Отбор.Свойство("Конец") Тогда
			Конец = ?(ЗначениеЗаполнено(Отбор.Конец), Отбор.Конец, Неопределено);
			Отбор.Удалить("Конец");
		КонецЕсли;
		Если Отбор.Свойство("Состояние") Тогда
			Если ТипЗнч(Отбор.Состояние) = Тип("Массив") Тогда
				Состояние = Отбор.Состояние;
				Отбор.Удалить("Состояние");
			КонецЕсли;
		КонецЕсли;

		Если Отбор.Количество() <> 0 Тогда
			Строки = Таблица.НайтиСтроки(Отбор);
		Иначе
			Строки = Таблица;
		КонецЕсли;
		// Выполнение дополнительного отбора по периоду и состоянию (если отбор определен).
		НомерЭлемента = Строки.Количество() - 1;
		Пока НомерЭлемента >= 0 Цикл
			Если Начало <> Неопределено И Начало > Строки[НомерЭлемента].Начало Или Конец <> Неопределено И Конец < ?(
				ЗначениеЗаполнено(Строки[НомерЭлемента].Конец), Строки[НомерЭлемента].Конец, ТекущаяДатаСеанса())
				Или Состояние <> Неопределено И Состояние.Найти(Строки[НомерЭлемента].Состояние) = Неопределено Тогда
				Строки.Удалить(НомерЭлемента);
			КонецЕсли;
			НомерЭлемента = НомерЭлемента - 1;
		КонецЦикла;
		// Удаление лишних строк из таблицы.
		Если ТипЗнч(Строки) = Тип("Массив") Тогда
			НомерСтроки = Таблица.Количество() - 1;
			Пока НомерСтроки >= 0 Цикл
				Если Строки.Найти(Таблица[НомерСтроки]) = Неопределено Тогда
					Таблица.Удалить(Таблица[НомерСтроки]);
				КонецЕсли;
				НомерСтроки = НомерСтроки - 1;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	Возврат Таблица;

КонецФункции

// Возвращает свойства ФоновогоЗадания по строке уникального идентификатора.
//
// Параметры:
//  Идентификатор - Строка - уникального идентификатора ФоновогоЗадания.
//  ИменаСвойств  - Строка, если заполнено, возвращается структура с указанными свойствами.
// 
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Структура - свойства ФоновогоЗадания.
//
Функция ПолучитьСвойстваФоновогоЗадания(Идентификатор, ИменаСвойств = "") Экспорт

	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);

	Отбор = Новый Структура("Идентификатор", Идентификатор);
	ТаблицаСвойствФоновыхЗаданий = СвойстваФоновыхЗаданий(Отбор);

	Если ТаблицаСвойствФоновыхЗаданий.Количество() > 0 Тогда
		Если ЗначениеЗаполнено(ИменаСвойств) Тогда
			Результат = Новый Структура(ИменаСвойств);
			ЗаполнитьЗначенияСвойств(Результат, ТаблицаСвойствФоновыхЗаданий[0]);
		Иначе
			Результат = ТаблицаСвойствФоновыхЗаданий[0];
		КонецЕсли;
	Иначе
		Результат = Неопределено;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Вызывает исключение, если у пользователя нет права администрирования.
Процедура ВызватьИсключениеЕслиНетПраваАдминистрирования() Экспорт

	Если UT_Common.DataSeparationEnabled() И UT_Common.SeparatedDataUsageAvailable() Тогда
		Если Не UT_Users.IsFullUser() Тогда
			ВызватьИсключение НСтр("ru = 'Нарушение прав доступа.'");
		КонецЕсли;
	Иначе
		Если Не ПривилегированныйРежим() Тогда
			ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Формирует таблицу зависимостей регламентных заданий от функциональных опций.
//
// Возвращаемое значение:
//  Зависимости - ТаблицаЗначений - таблица значений с колонками:
//    * РегламентноеЗадание - ОбъектМетаданных:РегламентноеЗадание - регламентное задание.
//    * ФункциональнаяОпция - ОбъектМетаданных:ФункциональнаяОпция - функциональная опция,
//        от которой зависит регламентное задание.
//    * ЗависимостьПоИ      - Булево - если регламентное задание зависит более, чем
//        от одной функциональной опции и его необходимо включать только тогда,
//        когда все функциональные опции включены, то следует указывать Истина
//        для каждой зависимости.
//        По умолчанию Ложь - если хотя бы одна функциональная опция включена,
//        то регламентное задание тоже включено.
//    * ВключатьПриВключенииФункциональнойОпции - Булево, Неопределено - если Ложь, то при
//        включении функциональной опции регламентное задание не будет включаться. Значение
//        Неопределено соответствует значению Истина.
//        По умолчанию - неопределено.
//    * ДоступноВПодчиненномУзлеРИБ - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в РИБ.
//        По умолчанию - неопределено.
//    * ДоступноВМоделиСервиса      - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в модели сервиса.
//        По умолчанию - неопределено.
//    * РаботаетСВнешнимиРесурсами   - Булево - Истина, если регламентное задание работает
//        с внешними ресурсами (получение почты, синхронизация данных и т.п.).
//        По умолчанию - Ложь.
//
Функция РегламентныеЗаданияЗависимыеОтФункциональныхОпций() Экспорт

	Зависимости = Новый ТаблицаЗначений;
	Зависимости.Колонки.Добавить("РегламентноеЗадание");
	Зависимости.Колонки.Добавить("ФункциональнаяОпция");
	Зависимости.Колонки.Добавить("ЗависимостьПоИ", Новый ОписаниеТипов("Булево"));
	Зависимости.Колонки.Добавить("ДоступноВМоделиСервиса");
	Зависимости.Колонки.Добавить("ДоступноВПодчиненномУзлеРИБ");
	Зависимости.Колонки.Добавить("ВключатьПриВключенииФункциональнойОпции");
	Зависимости.Колонки.Добавить("ДоступноВАвтономномРабочемМесте");
	Зависимости.Колонки.Добавить("РаботаетСВнешнимиРесурсами", Новый ОписаниеТипов("Булево"));
	Зависимости.Колонки.Добавить("Параметризуется", Новый ОписаниеТипов("Булево"));

	//МодульИнтеграцииПодсистемБСП=УИ_ОбщегоНазначения.ОбщийМодуль("ИнтеграцияПодсистемБСП");
	//Если МодульИнтеграцииПодсистемБСП <> Неопределено Тогда
	//	МодульИнтеграцииПодсистемБСП.ПриОпределенииНастроекРегламентныхЗаданий(Зависимости);
	//КонецЕсли;
	//МодульРегламентныеЗаданияПереопределяемый=УИ_ОбщегоНазначения.ОбщийМодуль("РегламентныеЗаданияПереопределяемый");
	//Если МодульРегламентныеЗаданияПереопределяемый <> Неопределено Тогда
	//	МодульРегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий(Зависимости);
	//КонецЕсли;

	Зависимости.Сортировать("РегламентноеЗадание");

	Возврат Зависимости;

КонецФункции

// Возвращает многострочную Строку содержащую Сообщения и ОписаниеИнформацииОбОшибке,
// последнее фоновое задание найдено по идентификатору регламентного задания
// и сообщения/ошибки есть.
//
// Параметры:
//  Задание      - РегламентноеЗадание, Строка - УникальныйИдентификатор
//                 РегламентногоЗадания строкой.
//
// Возвращаемое значение:
//  Строка.
//
Функция СообщенияИОписанияОшибокРегламентногоЗадания(Знач Задание) Экспорт

	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);

	ИдентификаторРегламентногоЗадания = ?(ТипЗнч(Задание) = Тип("РегламентноеЗадание"), Строка(
		Задание.УникальныйИдентификатор), Задание);
	СвойстваПоследнегоФоновогоЗадания = ПолучитьСвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(
		ИдентификаторРегламентногоЗадания);
	Возврат ?(СвойстваПоследнегоФоновогоЗадания = Неопределено, "", СообщенияИОписанияОшибокФоновогоЗадания(
		СвойстваПоследнегоФоновогоЗадания.Идентификатор));

КонецФункции

// Возвращает свойства последнего фонового задания выполненного при выполнении регламентного задания, если оно есть.
// Процедура работает, как в файл-серверном, так и в клиент-серверном режимах.
//
// Параметры:
//  РегламентноеЗадание - РегламентноеЗадание, Строка - строка уникального идентификатора РегламентногоЗадания.
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено.
//
Функция ПолучитьСвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(РегламентноеЗадание) Экспорт

	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);

	ИдентификаторРегламентногоЗадания = ?(ТипЗнч(РегламентноеЗадание) = Тип("РегламентноеЗадание"), Строка(
		РегламентноеЗадание.УникальныйИдентификатор), РегламентноеЗадание);
	Отбор = Новый Структура;
	Отбор.Вставить("ИдентификаторРегламентногоЗадания", ИдентификаторРегламентногоЗадания);
	Отбор.Вставить("ПолучитьПоследнееФоновоеЗаданиеРегламентногоЗадания");
	ТаблицаСвойствФоновыхЗаданий = СвойстваФоновыхЗаданий(Отбор);
	ТаблицаСвойствФоновыхЗаданий.Сортировать("Конец Возр");

	Если ТаблицаСвойствФоновыхЗаданий.Количество() = 0 Тогда
		СвойстваФоновогоЗадания = Неопределено;
	ИначеЕсли Не ЗначениеЗаполнено(ТаблицаСвойствФоновыхЗаданий[0].Конец) Тогда
		СвойстваФоновогоЗадания = ТаблицаСвойствФоновыхЗаданий[0];
	Иначе
		СвойстваФоновогоЗадания = ТаблицаСвойствФоновыхЗаданий[ТаблицаСвойствФоновыхЗаданий.Количество() - 1];
	КонецЕсли;

	Возврат СвойстваФоновогоЗадания;

КонецФункции

// Возвращает многострочную Строку содержащую Сообщения и ОписаниеИнформацииОбОшибке,
// если фоновое задание найдено по идентификатору и сообщения/ошибки есть.
//
// Параметры:
//  Задание      - Строка - УникальныйИдентификатор ФоновогоЗадания строкой.
//
// Возвращаемое значение:
//  Строка.
//
Функция СообщенияИОписанияОшибокФоновогоЗадания(Идентификатор, СвойстваФоновогоЗадания = Неопределено) Экспорт

	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);

	Если СвойстваФоновогоЗадания = Неопределено Тогда
		СвойстваФоновогоЗадания = ПолучитьСвойстваФоновогоЗадания(Идентификатор);
	КонецЕсли;

	Строка = "";
	Если СвойстваФоновогоЗадания <> Неопределено Тогда
		Для Каждого Сообщение Из СвойстваФоновогоЗадания.СообщенияПользователю Цикл
			Строка = Строка + ?(Строка = "", "", "
												 |
												 |") + Сообщение.Текст;
		КонецЦикла;
		Если ЗначениеЗаполнено(СвойстваФоновогоЗадания.ОписаниеИнформацииОбОшибке) Тогда
			Строка = Строка + ?(Строка = "", СвойстваФоновогоЗадания.ОписаниеИнформацииОбОшибке, "
																								 |
																								 |"
				+ СвойстваФоновогоЗадания.ОписаниеИнформацииОбОшибке);
		КонецЕсли;
	КонецЕсли;

	Возврат Строка;

КонецФункции

// Возвращает представление регламентного задания,
// это по порядку исключения незаполненных реквизитов:
// Наименование, Метаданные.Синоним, Метаданные.Имя.
//
// Параметры:
//  Задание      - РегламентноеЗадание, Строка - если строка, тогда УникальныйИдентификатор строкой.
//
// Возвращаемое значение:
//  Строка.
//
Функция ПредставлениеРегламентногоЗадания(Знач Задание) Экспорт

	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);

	Если ТипЗнч(Задание) = Тип("РегламентноеЗадание") Тогда
		РегламентноеЗадание = Задание;
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(
			Новый УникальныйИдентификатор(Задание));
	КонецЕсли;

	Если РегламентноеЗадание <> Неопределено Тогда
		Представление = РегламентноеЗадание.Наименование;

		Если ПустаяСтрока(РегламентноеЗадание.Наименование) Тогда
			Представление = РегламентноеЗадание.Метаданные.Синоним;

			Если ПустаяСтрока(Представление) Тогда
				Представление = РегламентноеЗадание.Метаданные.Имя;
			КонецЕсли;
		КонецЕсли
		;
	Иначе
		Представление = ТекстНеОпределено();
	КонецЕсли;

	Возврат Представление;

КонецФункции

// Возвращает текст "<не определено>".
Функция ТекстНеОпределено() Экспорт

	Возврат НСтр("ru = '<не определено>'");

КонецФункции

// Отменяет фоновое задание, если это возможно, а именно, если оно выполняется на сервере, и активно.
//
// Параметры:
//  Идентификатор  - Строка уникального идентификатора ФоновогоЗадания.
// 
Процедура ОтменитьФоновоеЗадание(Идентификатор) Экспорт

	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);

	НовыйУникальныйИдентификатор = Новый УникальныйИдентификатор(Идентификатор);
	Отбор = Новый Структура;
	Отбор.Вставить("УникальныйИдентификатор", НовыйУникальныйИдентификатор);
	МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если МассивФоновыхЗаданий.Количество() = 1 Тогда
		ФоновоеЗадание = МассивФоновыхЗаданий[0];
	Иначе
		ВызватьИсключение НСтр("ru = 'Фоновое задание не найдено на сервере.'");
	КонецЕсли;

	Если ФоновоеЗадание.Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		ВызватьИсключение НСтр("ru = 'Задание не выполняется, его нельзя отменить.'");
	КонецЕсли;

	ФоновоеЗадание.Отменить();

КонецПроцедуры

// Предназначена для "ручного" немедленного выполнения процедуры регламентного задания
// либо в сеансе клиента (в файловой ИБ), либо в фоновом задании на сервере (в серверной ИБ).
// Применяется в любом режиме соединения.
// Ручной режим запуска не влияет на выполнение регламентного задания по аварийному
// и основному расписаниям, т.к. не указывается ссылка на регламентное задание у фонового задания.
// Тип ФоновоеЗадание не допускает установки такой ссылки, поэтому для файлового режима применяется
// тоже правило.
// 
// Параметры:
//  Задание             - РегламентноеЗадание, Строка - уникального идентификатора РегламентногоЗадания.
//
// Возвращаемое значение:
//  Структура - со свойствами
//    * МоментЗапуска -   Неопределено, Дата - для файловой ИБ устанавливает переданный момент, как момент запуска
//                        метода регламентного задания.
//                        Для серверной ИБ - возвращает момент запуска фонового задания по факту.
//    * ИдентификаторФоновогоЗадания - Строка - для серверной ИБ возвращает идентификатор запущенного фонового задания.
//
Функция ВыполнитьРегламентноеЗаданиеВручную(Знач Задание) Экспорт

	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);

	ПараметрыВыполнения = ПараметрыВыполненияРегламентногоЗадания();
	ПараметрыВыполнения.ПроцедураУжеВыполняется = Ложь;
	Задание = UT_ScheduledJobsServer.ПолучитьРегламентноеЗадание(Задание);

	ПараметрыВыполнения.ЗапускВыполнен = Ложь;
	СвойстваПоследнегоФоновогоЗадания = ПолучитьСвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(Задание);

	Если СвойстваПоследнегоФоновогоЗадания <> Неопределено И СвойстваПоследнегоФоновогоЗадания.Состояние
		= СостояниеФоновогоЗадания.Активно Тогда

		ПараметрыВыполнения.МоментЗапуска  = СвойстваПоследнегоФоновогоЗадания.Начало;
		Если ЗначениеЗаполнено(СвойстваПоследнегоФоновогоЗадания.Наименование) Тогда
			ПараметрыВыполнения.ПредставлениеФоновогоЗадания = СвойстваПоследнегоФоновогоЗадания.Наименование;
		Иначе
			ПараметрыВыполнения.ПредставлениеФоновогоЗадания = ПредставлениеРегламентногоЗадания(Задание);
		КонецЕсли;
	Иначе
		НаименованиеФоновогоЗадания = СтрШаблон(НСтр("ru = 'Запуск вручную: %1'"), ПредставлениеРегламентногоЗадания(
			Задание));
		// Не используются длительные операции, т.к. делается вызов метода регламентного задания.
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(Задание.Метаданные.ИмяМетода, Задание.Параметры, Строка(
			Задание.УникальныйИдентификатор), НаименованиеФоновогоЗадания);
		ПараметрыВыполнения.ИдентификаторФоновогоЗадания = Строка(ФоновоеЗадание.УникальныйИдентификатор);
		ПараметрыВыполнения.МоментЗапуска = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(
			ФоновоеЗадание.УникальныйИдентификатор).Начало;
		ПараметрыВыполнения.ЗапускВыполнен = Истина;
	КонецЕсли;

	ПараметрыВыполнения.ПроцедураУжеВыполняется = Не ПараметрыВыполнения.ЗапускВыполнен;
	Возврат ПараметрыВыполнения;

КонецФункции

Функция ПараметрыВыполненияРегламентногоЗадания()

	Результат = Новый Структура;
	Результат.Вставить("МоментЗапуска");
	Результат.Вставить("ИдентификаторФоновогоЗадания");
	Результат.Вставить("ПредставлениеФоновогоЗадания");
	Результат.Вставить("ПроцедураУжеВыполняется");
	Результат.Вставить("ЗапускВыполнен");
	Возврат Результат;

КонецФункции

Процедура ОбновленнаяТаблицаРегламентныхЗаданий(Параметры, АдресХранилища) Экспорт

	ИдентификаторРегламентногоЗадания = Параметры.ИдентификаторРегламентногоЗадания;
	Таблица                           = Параметры.Таблица;
	ОтключенныеЗадания                = Параметры.ОтключенныеЗадания;
	
	// Обновление таблицы РегламентныеЗадания и списка СписокВыбора регламентного задания для отбора.
	ТекущиеЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания();
	ОтключенныеЗадания.Очистить();

	ПараметрыРегламентныхЗаданий = РегламентныеЗаданияЗависимыеОтФункциональныхОпций();
	ПараметрыОтбора        = Новый Структура;
	ПараметризуемыеЗадания = Новый Массив;
	ПараметрыОтбора.Вставить("Параметризуется", Истина);
	РезультатПоиска = ПараметрыРегламентныхЗаданий.НайтиСтроки(ПараметрыОтбора);
	Для Каждого СтрокаРезультата Из РезультатПоиска Цикл
		ПараметризуемыеЗадания.Добавить(СтрокаРезультата.РегламентноеЗадание);
	КонецЦикла;

	ЗаданияВМоделиСервиса = Новый Соответствие;
	ПодсистемаРаботаВМоделиСервисаСуществует = UT_Common.SubsystemExists(
		"СтандартныеПодсистемы.РаботаВМоделиСервиса");
	ПодсистемаРаботаВМоделиСервиса=Неопределено;
	Если ПодсистемаРаботаВМоделиСервисаСуществует Тогда
		//@skip-warning
		ПодсистемаРаботаВМоделиСервиса=Метаданные.Подсистемы.СтандартныеПодсистемы.Подсистемы.РаботаВМоделиСервиса;
	КонецЕсли;
	Для Каждого ОбъектМетаданных Из Метаданные.РегламентныеЗадания Цикл
		Если Не РегламентноеЗаданиеДоступноПоФункциональнымОпциям(ОбъектМетаданных, ПараметрыРегламентныхЗаданий) Тогда
			ОтключенныеЗадания.Добавить(ОбъектМетаданных.Имя);
			Продолжить;
		КонецЕсли;
		Если Не UT_Common.DataSeparationEnabled() И ПодсистемаРаботаВМоделиСервисаСуществует Тогда
			Если ПодсистемаРаботаВМоделиСервиса.Состав.Содержит(ОбъектМетаданных) Тогда
				ЗаданияВМоделиСервиса.Вставить(ОбъектМетаданных.Имя, Истина);
				Продолжить;
			КонецЕсли;
			Для Каждого Подсистема Из ПодсистемаРаботаВМоделиСервиса.Подсистемы Цикл
				Если Подсистема.Состав.Содержит(ОбъектМетаданных) Тогда
					ЗаданияВМоделиСервиса.Вставить(ОбъектМетаданных.Имя, Истина);
					Продолжить;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;

	Если ИдентификаторРегламентногоЗадания = Неопределено Тогда

		Индекс = 0;
		Для Каждого Задание Из ТекущиеЗадания Цикл
			Если Не UT_Common.DataSeparationEnabled() И ЗаданияВМоделиСервиса[Задание.Метаданные.Имя]
				<> Неопределено Тогда

				Продолжить;
			КонецЕсли;

			Идентификатор = Строка(Задание.УникальныйИдентификатор);

			Если Индекс >= Таблица.Количество() Или Таблица[Индекс].Идентификатор <> Идентификатор Тогда
				
				// Вставка нового задания.
				Обновляемое = Таблица.Вставить(Индекс);
				
				// Установка уникального идентификатора.
				Обновляемое.Идентификатор = Идентификатор;
			Иначе
				Обновляемое = Таблица[Индекс];
			КонецЕсли;

			Если ПараметризуемыеЗадания.Найти(Задание.Метаданные) <> Неопределено Тогда
				Обновляемое.Параметризуемое = Истина;
			КонецЕсли;

			ОбновитьСтрокуТаблицыРегламентныхЗаданий(Обновляемое, Задание);
			Индекс = Индекс + 1;
		КонецЦикла;
	
		// Удаление лишних строк.
		Пока Индекс < Таблица.Количество() Цикл
			Таблица.Удалить(Индекс);
		КонецЦикла;
	Иначе
		Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(
			Новый УникальныйИдентификатор(ИдентификаторРегламентногоЗадания));

		Строки = Таблица.НайтиСтроки(
			Новый Структура("Идентификатор", ИдентификаторРегламентногоЗадания));

		Если Задание <> Неопределено И Строки.Количество() > 0 Тогда

			СтрокаЗадание = Строки[0];
			Если ПараметризуемыеЗадания.Найти(Задание.Метаданные) <> Неопределено Тогда
				СтрокаЗадание.Параметризуемое = Истина;
			КонецЕсли;
			ОбновитьСтрокуТаблицыРегламентныхЗаданий(СтрокаЗадание, Задание);
		КонецЕсли;
	КонецЕсли;

	Результат = Новый Структура;
	Результат.Вставить("Таблица", Таблица);
	Результат.Вставить("ОтключенныеЗадания", ОтключенныеЗадания);

	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

// Проверяет, включено ли регламентное задание по функциональным опциям.
//
// Параметры:
//  Задание - ОбъектМетаданных: РегламентноеЗадание - регламентное задание.
//  ЗависимостиЗаданий - ТаблицаЗначений - таблица зависимостей регламентных
//    заданий, полученная методом РегламентныеЗаданияСлужебный.РегламентныеЗаданияЗависимыеОтФункциональныхОпций.
//    Если не указано, получается автоматически.
//
// Возвращаемое значение:
//  Использование - Булево - Истина, если регламентное задание используется.
//
Функция РегламентноеЗаданиеДоступноПоФункциональнымОпциям(Задание, ЗависимостиЗаданий = Неопределено) Экспорт

	Если ЗависимостиЗаданий = Неопределено Тогда
		ЗависимостиЗаданий = РегламентныеЗаданияЗависимыеОтФункциональныхОпций();
	КонецЕсли;

	ОтключитьВПодчиненномУзлеРИБ = Ложь;
	ОтключитьВАвтономномРабочемМесте = Ложь;
	Использование                = Неопределено;
	IsSubordinateDIBNode        = UT_Common.IsSubordinateDIBNode();
	ЭтоРазделенныйРежим          = UT_Common.DataSeparationEnabled();
	ЭтоАвтономноеРабочееМесто 	 = UT_Common.IsStandaloneWorkplace();

	НайденныеСтроки = ЗависимостиЗаданий.НайтиСтроки(Новый Структура("РегламентноеЗадание", Задание));

	Для Каждого СтрокаЗависимости Из НайденныеСтроки Цикл
		Если ЭтоРазделенныйРежим И СтрокаЗависимости.ДоступноВМоделиСервиса = Ложь Тогда
			Возврат Ложь;
		КонецЕсли;

		ОтключитьВПодчиненномУзлеРИБ = (СтрокаЗависимости.ДоступноВПодчиненномУзлеРИБ = Ложь) И IsSubordinateDIBNode;
		ОтключитьВАвтономномРабочемМесте = (СтрокаЗависимости.ДоступноВАвтономномРабочемМесте = Ложь)
			И ЭтоАвтономноеРабочееМесто;

		Если ОтключитьВПодчиненномУзлеРИБ Или ОтключитьВАвтономномРабочемМесте Тогда
			Возврат Ложь;
		КонецЕсли;

		Если СтрокаЗависимости.ФункциональнаяОпция = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		ЗначениеФО = ПолучитьФункциональнуюОпцию(СтрокаЗависимости.ФункциональнаяОпция.Имя);

		Если Использование = Неопределено Тогда
			Использование = ЗначениеФО;
		ИначеЕсли СтрокаЗависимости.ЗависимостьПоИ Тогда
			Использование = Использование И ЗначениеФО;
		Иначе
			Использование = Использование Или ЗначениеФО;
		КонецЕсли;
	КонецЦикла;

	Если Использование = Неопределено Тогда
		Возврат Истина;
	Иначе
		Возврат Использование;
	КонецЕсли;

КонецФункции
Процедура ОбновитьСтрокуТаблицыРегламентныхЗаданий(Строка, Задание)

	ЗаполнитьЗначенияСвойств(Строка, Задание);
	
	// Уточнение наименования
	Строка.Наименование = ПредставлениеРегламентногоЗадания(Задание);
	
	// Установка Даты завершения и Состояния завершения по последней фоновой процедуре.
	СвойстваПоследнегоФоновогоЗадания = UT_ScheduledJobsInternal.ПолучитьСвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(
		Задание);

	Строка.ИмяЗадания = Задание.Метаданные.Имя;
	Если СвойстваПоследнегоФоновогоЗадания = Неопределено Тогда
		Строка.ДатаНачала          = ТекстНеОпределено();
		Строка.ДатаОкончания       = ТекстНеОпределено();
		Строка.СостояниеВыполнения = ТекстНеОпределено();
	Иначе
		Строка.ДатаНачала          = ?(ЗначениеЗаполнено(СвойстваПоследнегоФоновогоЗадания.Начало),
			СвойстваПоследнегоФоновогоЗадания.Начало, "<>");
		Строка.ДатаОкончания       = ?(ЗначениеЗаполнено(СвойстваПоследнегоФоновогоЗадания.Конец),
			СвойстваПоследнегоФоновогоЗадания.Конец, "<>");
		Строка.СостояниеВыполнения = СвойстваПоследнегоФоновогоЗадания.Состояние;
	КонецЕсли;

КонецПроцедуры

// Только для внутреннего использования.
//
Процедура ТаблицаСвойствФоновыхЗаданийВФоне(Параметры, АдресХранилища) Экспорт

	ТаблицаСвойств = СвойстваФоновыхЗаданий(Параметры.Отбор);

	Результат = Новый Структура;
	Результат.Вставить("ТаблицаСвойств", ТаблицаСвойств);

	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

#КонецОбласти