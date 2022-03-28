#Использовать logos
#Использовать cli
#Использовать "."

Перем Лог;

///////////////////////////////////////////////////////////////////////////////

Процедура ВыполнитьПриложение()

    Приложение = Новый КонсольноеПриложение("cfe2cf", "Конвертор расширения .cfe в конфигурацию .cf");
    Приложение.Версия("v version", ПараметрыПриложения.Версия());

    Приложение.ДобавитьКоманду("f file", "Конвертация из файла расширения (.cfe) в файл конфигурации (.cf)", Новый КомандаИзФайлаРасширения);
	Приложение.ДобавитьКоманду("s source", "Конвертация из исходных файлов расширения (.cfe) в файл конфигурации (.cf)", Новый КомандаИзКаталогаИсходныхФайлов);
	
    Приложение.Запустить(АргументыКоманднойСтроки);

КонецПроцедуры // ВыполнениеКоманды()


///////////////////////////////////////////////////////

Лог = Логирование.ПолучитьЛог(ПараметрыПриложения.ИмяЛога());

Попытка

    ВыполнитьПриложение();

Исключение

    Сообщить(ОписаниеОшибки());

КонецПопытки;