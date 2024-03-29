#Область ПрограммныйИнтерфейс
// Возвращает текст для включения в страницу
// 
// 
// Возвращаемое значение:
//  Строка  - текст с тегами script для включения в html страницу
Функция ТекстПодключенияВHTML() Экспорт
	ШаблонБлока =  "<script src=""file:///%1""></script>";
	Возврат СтрШаблон(ШаблонБлока, ПутьКБиблиотеке());
КонецФункции

// Проверить и установить библиотеку G6.
Процедура ПроверитьиУстановитьБиблиотеку() Экспорт
	ПутьКБиблиотеке = ПутьКБиблиотеке();
	Файл = Новый Файл(ПутьКБиблиотеке); 
    Если Файл.Существует() Тогда
    	Возврат;
    КонецЕсли;
    ТекстовыйФайл = Новый ТекстовыйДокумент;
    ТекстБиблиотеки = граф_МакетыВызовСервера.ТекстМакета("граф_БиблиотекаG6Версия4");
    ТекстовыйФайл.УстановитьТекст(ТекстБиблиотеки);
	ТекстовыйФайл.Записать(ПутьКБиблиотеке, КодировкаТекста.UTF8);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПутьКБиблиотеке()
	РазделительПути = ПолучитьРазделительПутиКлиента();
	ШаблонПути =  "%1%2g6.min.js";
	Возврат СтрШаблон(ШаблонПути, КаталогВременныхФайлов(), РазделительПути);
КонецФункции

#КонецОбласти
