#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ПрограммныйИнтерфейс
// Записывает в элемент данных графа его содержимое 
// 
// Параметры:
//  СохраненныйГраф  - СправочникСсылка.граф_СохраненныеГрафы - Записываемый элемент
//  ДанныеГрафа  - Строка - строка JSON с данными графа
Процедура ЗаписатьДанные(СохраненныйГраф, ДанныеГрафа) Экспорт
	ГрафОбъект = СохраненныйГраф.ПолучитьОбъект();
	Попытка
		ГрафОбъект.Заблокировать();
	Исключение
		ВызватьИсключение "Элемент " + СохраненныйГраф + "уже открыт для редактирования";
	КонецПопытки;

	ГрафОбъект.ДанныеГрафа = Новый ХранилищеЗначения(ДанныеГрафа, Новый СжатиеДанных(9));
	ГрафОбъект.ЕстьДанные = Истина;
	ГрафОбъект.Записать();
КонецПроцедуры


// Возвращает JSON данные сохраненного графа
// 
// Параметры:
//  СохраненныйГраф  - СправочникСсылка.граф_СохраненныеГрафы - Записываемый элемент
// 
// Возвращаемое значение:
// Строка - Данные графа в формате JSON 
Функция СохраненныеДанныеГрафа(СохраненныйГраф) Экспорт
	//@skip-check reading-attribute-from-database
	Данные = СохраненныйГраф.ДанныеГрафа.Получить();
	Возврат Данные;
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы = "ФормаОбъекта" И Параметры.Свойство("Ключ") И Параметры.Ключ.ЕстьДанные Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = Метаданные.Обработки.граф_ВыводГрафа.Формы.Форма;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли