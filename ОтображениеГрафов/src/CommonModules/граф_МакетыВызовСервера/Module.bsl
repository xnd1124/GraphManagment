#Область ПрограммныйИнтерфейс

// Текстовое содержимое Макета
// 
// Параметры:
//  ИмяШаблона - строка - Имя шаблона
// 
// Возвращаемое значение:
//  Строка - Текст  шаблоне
Функция ТекстМакета(ИмяШаблона) Экспорт
	Возврат ПолучитьОбщийМакет(ИмяШаблона).ПолучитьТекст();
КонецФункции
#КонецОбласти