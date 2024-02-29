#Область ПрограммныйИнтерфейс
// Данные для формирования графа.
// 
// Параметры:
//  ПараметрыФормирования  - Структура -  см. функцию "ПараметрыФормированияГрафа"
// Возвращаемое значение:
//  Структура - Данные для формирования графа:
// * Узлы - ДеревоЗначений -  содержащее узлы графа, состав колонок идентичен "ОписаниеУзлов" в ПараметрыФормированияГрафа
// * Ребра - ТаблицаЗначений -  с описание всех ребер, состав колонок идентичен "ОписаниеРебер" в ПараметрыФормированияГрафа
Функция ДанныеДляФормированияГрафа(ПараметрыФормирования) Экспорт
	ПараметрыФормирования.Вставить("СхемаКомпоновкиДанных", Новый СхемаКомпоновкиДанных);
	ПараметрыФормирования.Вставить("ИдентификаторыВсехСтрок", Новый Соответствие);
	ПараметрыФормирования.Вставить("ПолныеИдентификаторы", Новый Соответствие);
	
	ОписатьПараметрыДанныхСКД(ПараметрыФормирования);
	ОписатьИсточникДанныхСКД(ПараметрыФормирования);
	ОписатьВычисляемыеПоляСКД(ПараметрыФормирования);
	ОписатьРесурсыСКД(ПараметрыФормирования);
	
	ОписатьСтруктуруСКД(ПараметрыФормирования);
	УстановитьПараметрыСКД(ПараметрыФормирования);
	ОтключитьВыводОбщихИтогов(ПараметрыФормирования);
	
	РезультатВОбщейТаблице = РезультатКомпоновкиСКД(ПараметрыФормирования);
	РезультатВРазныхТаблицах = ДанныеРезультата(ПараметрыФормирования, РезультатВОбщейТаблице);
	
	//@skip-check constructor-function-return-section
	Возврат РезультатВРазныхТаблицах;
КонецФункции

// Параметры формирования графа.
// 
// Возвращаемое значение:
//  Структура - Структура с пустыми значениями параметров:
Функция ПараметрыФормированияГрафа() Экспорт
	Результат = Новый Структура;
	Результат.Вставить("ТекстЗапроса"); //  Строка с текстом запроса 
	Результат.Вставить("ПараметрыЗапроса"); //  массив  структур: "Имя", "Значение"
	Результат.Вставить("ПоляРесурсы"); //  массив структур: "Поле", "АгрегирующаяФункция"
	Результат.Вставить("ОписаниеУзлов"); //  Дерево значений
	Результат.Вставить("ОписаниеРебер"); //  Таблица значений
	//@skip-check constructor-function-return-section
	Возврат Результат;
КонецФункции

Функция ИсходныйКодГрафаHTML(ДанныеДляГрафа, ПараметрыВыводаГрафа) Экспорт
	ШаблонТекстаСтраницы = граф_МакетыВызовСервера.ТекстМакета("граф_ШаблонHTML");
	СкриптИнициализации = граф_МакетыВызовСервера.ТекстМакета("граф_СкриптИнициализацииГрафа");
	СтрокаПодключенияБиблиотекиG6 = ПараметрыВыводаГрафа.СтрокаПодключенияБиблиотекиG6;
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы,
			"// библиотека G6",
			СтрокаПодключенияБиблиотекиG6);
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//инициализация графа", СкриптИнициализации);
	ДанныеГрафаВHTML = ДанныеГрафаВHTML(ДанныеДляГрафа);
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//данные графа", ДанныеГрафаВHTML);
	Результат = ШаблонТекстаСтраницы + УникальныйКомментарий(); // для перерисовки страницы даже если ничего не поменялось
	Возврат Результат;		
КонецФункции	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаССКД
Процедура ОписатьПараметрыДанныхСКД(ПараметрыФормирования)
	СхемаКомпоновкиДанных = ПараметрыФормирования.СхемаКомпоновкиДанных;
	ПараметрыЗапроса = ПараметрыФормирования.ПараметрыЗапроса;
	Для Каждого Параметр Из ПараметрыЗапроса Цикл
		НовыйПараметр = СхемаКомпоновкиДанных.Параметры.Добавить(); 
		НовыйПараметр.Имя = Параметр.Имя;
	КонецЦикла;
КонецПроцедуры

Процедура ОписатьИсточникДанныхСКД(ПараметрыФормирования)
	СхемаКомпоновкиДанных = ПараметрыФормирования.СхемаКомпоновкиДанных;
	ТекстЗапроса = ПараметрыФормирования.ТекстЗапроса;
	 
	ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "Local"; 
	
	ТекущийНаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	ТекущийНаборДанных.Имя                          = "ОсновнойНабор";
	ТекущийНаборДанных.Запрос                       = ТекстЗапроса;
	ТекущийНаборДанных.ИсточникДанных               = "ИсточникДанных1";
	ТекущийНаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
КонецПроцедуры

Процедура ОписатьВычисляемыеПоляСКД(ПараметрыФормирования)
	СхемаКомпоновкиДанных = ПараметрыФормирования.СхемаКомпоновкиДанных;
	ВычисляемоеПоле = СхемаКомпоновкиДанных.ВычисляемыеПоля.Добавить();
	ВычисляемоеПоле.ПутьКДанным = "ЭтоОписаниеСвязи";
	Если ПараметрыФормирования.ОписаниеРебер.Количество() > 0 Тогда
		ВычисляемоеПоле.Выражение = "Истина";
	Иначе
		ВычисляемоеПоле.Выражение = "Ложь";
	КонецЕсли;	
КонецПроцедуры

Процедура ОписатьСтруктуруСКД(ПараметрыФормирования)
	СхемаКомпоновкиДанных = ПараметрыФормирования.СхемаКомпоновкиДанных;
	НастройкиКомпоновки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	ТекущаяСтруктураСКД = НастройкиКомпоновки.Структура;
	Узлы = ПараметрыФормирования.ОписаниеУзлов;
	ДобавитьСКДТекущийУровеньДерева(ПараметрыФормирования, Узлы, ТекущаяСтруктураСКД);
	ДобавитьСвязиВСКД(ПараметрыФормирования, ТекущаяСтруктураСКД);
КонецПроцедуры

Процедура ОписатьРесурсыСКД(ПараметрыФормирования)
	СхемаКомпоновкиДанных = ПараметрыФормирования.СхемаКомпоновкиДанных;
	ПоляРесурсы = ПараметрыФормирования.ПоляРесурсы;
	Для Каждого ПолеРесурса Из ПоляРесурсы Цикл
		ПолеИтога = СхемаКомпоновкиДанных.ПоляИтога.Добавить();
		ПолеИтога.Выражение   = ПолеРесурса.АгрегирующаяФункция; 
        ПолеИтога.ПутьКДанным = ПолеРесурса.Поле; 
	КонецЦикла;
КонецПроцедуры

Процедура ОтключитьВыводОбщихИтогов(ПараметрыФормирования)
	СхемаКомпоновкиДанных = ПараметрыФормирования.СхемаКомпоновкиДанных;
	НастройкиКомпоновки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	Параметр = НастройкиКомпоновки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВертикальноеРасположениеОбщихИтогов"));
	Параметр.Значение = РасположениеИтоговКомпоновкиДанных.Нет;
    Параметр.Использование = ИСТИНА;
КонецПроцедуры

Процедура УстановитьПараметрыСКД(ПараметрыФормирования)
	СхемаКомпоновкиДанных = ПараметрыФормирования.СхемаКомпоновкиДанных;
	НастройкиКомпоновки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	ПараметрыЗапроса = ПараметрыФормирования.ПараметрыЗапроса;
	Для Каждого Параметр Из ПараметрыЗапроса Цикл
		НоваяСтрока = НастройкиКомпоновки.ПараметрыДанных.Элементы.Добавить();
		НоваяСтрока.Параметр = Новый ПараметрКомпоновкиДанных(Параметр.Имя);
		НоваяСтрока.Значение = Параметр.Значение;
		НоваяСтрока.Использование = Истина;
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиКомпоновки, Параметр.Имя, Параметр.Значение);
	КонецЦикла;
КонецПроцедуры

Функция РезультатКомпоновкиСКД(ПараметрыФормирования)
	СхемаКомпоновкиДанных = ПараметрыФормирования.СхемаКомпоновкиДанных;
	НастройкиКомпоновки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, 
						НастройкиКомпоновки, , ,
						Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = Новый ДеревоЗначений;
	ПроцессорВывода.УстановитьОбъект(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	Возврат Результат;
КонецФункции

Процедура ДобавитьСКДТекущийУровеньДерева(ПараметрыФормирования, ТекущийУровень, ТекущаяСтруктураСКД)
	СхемаКомпоновкиДанных = ПараметрыФормирования.СхемаКомпоновкиДанных;
	ИдентификаторыВсехСтрок = ПараметрыФормирования.ИдентификаторыВсехСтрок;
	СтрокиДерева = ТекущийУровень.Строки;
	Для каждого Строка Из  СтрокиДерева Цикл
		ГруппировкаКомпоновкиДанных = ТекущаяСтруктураСКД.Добавить(Тип("ГруппировкаКомпоновкиДанных"));	
		ГруппировкаКомпоновкиДанных.Использование = Истина;
		
		НовоеПолеГруппировкиСКД(ГруппировкаКомпоновкиДанных, Строка.ИдентификаторУзла);
		НовоеПолеГруппировкиСКД(ГруппировкаКомпоновкиДанных, Строка.ЗаголовокУзла);
		ИмяПоля = ИмяПоляСИдентификаторомГруппировки(Строка.ИдентификаторСтроки);
		НовоеПолеГруппировкиСКД(ГруппировкаКомпоновкиДанных, ИмяПоля);
		ДобавитьВычисляемоеПолеИдентификаторГруппировкиСКД(СхемаКомпоновкиДанных, Строка.ИдентификаторСтроки);
	
		АвтоВыбранноеПолеКомпоновкиДанных = ГруппировкаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		АвтоВыбранноеПолеКомпоновкиДанных.Использование = Истина;
		
		ИдентификаторыВсехСтрок.Вставить(Строка.ИдентификаторСтроки, Строка);
		
		Если Строка.Строки.Количество() > 0 Тогда
			ДобавитьСКДТекущийУровеньДерева(ПараметрыФормирования, Строка, ГруппировкаКомпоновкиДанных.Структура)
		КонецЕсли;
	КонецЦикла; 
КонецПроцедуры

Процедура ДобавитьСвязиВСКД(ПараметрыФормирования, ТекущаяСтруктураСКД)
	СхемаКомпоновкиДанных = ПараметрыФормирования.СхемаКомпоновкиДанных;
	ИдентификаторыВсехСтрок = ПараметрыФормирования.ИдентификаторыВсехСтрок;
	ОписаниеРебер = ПараметрыФормирования.ОписаниеРебер;
	
	Для Каждого Строка Из ОписаниеРебер Цикл
		ГруппировкаКомпоновкиДанных = ТекущаяСтруктураСКД.Добавить(Тип("ГруппировкаКомпоновкиДанных"));	
		ГруппировкаКомпоновкиДанных.Использование = Истина;
		
		НовоеПолеГруппировкиСКД(ГруппировкаКомпоновкиДанных, Строка.ИдентификаторИсточника);
		НовоеПолеГруппировкиСКД(ГруппировкаКомпоновкиДанных, Строка.ИдентификаторПриемника);
		НовоеПолеГруппировкиСКД(ГруппировкаКомпоновкиДанных, "ЭтоОписаниеСвязи");
		ИмяПоля = ИмяПоляСИдентификаторомГруппировки(Строка.ИдентификаторСтроки);
		НовоеПолеГруппировкиСКД(ГруппировкаКомпоновкиДанных, ИмяПоля);
		ДобавитьВычисляемоеПолеИдентификаторГруппировкиСКД(СхемаКомпоновкиДанных, Строка.ИдентификаторСтроки);
		Если ЗначениеЗаполнено(Строка.ЗаголовокРебра) Тогда
			ДобавитьПоляЗаголовкаВГруппировку(ПараметрыФормирования, ГруппировкаКомпоновкиДанных, Строка.ЗаголовокРебра);
		КонецЕсли;
		
		АвтоВыбранноеПолеКомпоновкиДанных = ГруппировкаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		АвтоВыбранноеПолеКомпоновкиДанных.Использование = Истина;
		
		ИдентификаторыВсехСтрок.Вставить(Строка.ИдентификаторСтроки, Строка);
	КонецЦикла;
КонецПроцедуры

Процедура ДобавитьПоляЗаголовкаВГруппировку(ПараметрыФормирования, ГруппировкаКомпоновкиДанных, Заголовок)
	СхемаКомпоновкиДанных = ПараметрыФормирования.СхемаКомпоновкиДанных;
	ПоляИтога = СхемаКомпоновкиДанных.ПоляИтога;
	ПоляВЗаголовке = ПоляВЗаголовке(Заголовок);
	Для Каждого ИмяПоля Из ПоляВЗаголовке Цикл
		БылНайденРесурс = Ложь;
		Для Каждого ПолеИтога Из ПоляИтога Цикл
			Если ПолеИтога.ПутьКДанным = ИмяПоля Тогда
				ДобавитьРесурсВГруппировку(ГруппировкаКомпоновкиДанных, ИмяПоля);
				БылНайденРесурс = Истина;
			КонецЕсли;
		КонецЦикла;
		Если БылНайденРесурс Тогда
			Продолжить;
		КонецЕсли;
		НовоеПолеГруппировкиСКД(ГруппировкаКомпоновкиДанных, ИмяПоля);
	КонецЦикла;
КонецПроцедуры

Функция ПоляВЗаголовке(Знач Заголовок)
	Заголовок = СтрЗаменить(Заголовок, ";", "");
	Разделители = " " + Символы.ПС;
	ЧастиЗаголовка = СтрРазделить(Заголовок, Разделители, Ложь);
	Возврат ЧастиЗаголовка;
КонецФункции

Процедура ДобавитьРесурсВГруппировку(ГруппировкаКомпоновкиДанных, ИмяПоля)
	ВыбранноеПоле = ГруппировкаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Использование = Истина;
	ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных(ИмяПоля);
КонецПроцедуры

Процедура ДобавитьВычисляемоеПолеИдентификаторГруппировкиСКД(СхемаКомпоновкиДанных, ИдентификаторСтроки)
	ВычисляемоеПоле = СхемаКомпоновкиДанных.ВычисляемыеПоля.Добавить();
	ВычисляемоеПоле.ПутьКДанным = ИмяПоляСИдентификаторомГруппировки(ИдентификаторСтроки);
	ВычисляемоеПоле.Выражение = "Истина";
КонецПроцедуры

Функция НовоеПолеГруппировкиСКД(ГруппировкаКомпоновкиДанных, ИмяПоля)
	ПолеГруппировкиКомпоновкиДанных = ГруппировкаКомпоновкиДанных.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировкиКомпоновкиДанных.Использование = Истина;
	ПолеГруппировкиКомпоновкиДанных.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Возврат ПолеГруппировкиКомпоновкиДанных;
КонецФункции

Функция ИмяПоляСИдентификаторомГруппировки(ИдентификаторСтроки)
	Возврат "ЭтоГруппировка" + СтрЗаменить(ИдентификаторСтроки, "-", "_");
КонецФункции

Функция ИдентификаторСтрокиИзИмениПоля(ИмяПоля)
	ТолькоГуид = СтрЗаменить(ИмяПоля, "ЭтоГруппировка", "");
	Возврат  СтрЗаменить(ТолькоГуид, "_", "-");
КонецФункции

Функция ДанныеРезультата(ПараметрыФормирования, РезультатКомпоновкиСКД)
	ДобавитьКолонкуОписаниеСвязиВСлучаеЕеОтсутствия(РезультатКомпоновкиСКД);
	Результат = Новый Структура;
	Узлы = ПараметрыФормирования.ОписаниеУзлов.Скопировать();
	Узлы.Строки.Очистить();
	Результат.Вставить("Узлы", Узлы);
	 
	Ребра = ПараметрыФормирования.ОписаниеРебер.Скопировать();
	Ребра.Очистить();
	Результат.Вставить("Ребра", Ребра);

	Результат.Вставить("ТекущийУровеньУзлов", Узлы.Строки); // служебная для отслеживания уровня вставки узлов
	УровеньСКД = РезультатКомпоновкиСКД.Строки;
	
	ЗаполнитьРекурсивноУзлыИРебра(ПараметрыФормирования, УровеньСКД, Результат);
	
	Результат.Удалить("ТекущийУровеньУзлов");
	Возврат Результат;
КонецФункции

Процедура ДобавитьКолонкуОписаниеСвязиВСлучаеЕеОтсутствия(РезультатКомпоновкиСКД)
	Если РезультатКомпоновкиСКД.Колонки.Найти("ЭтоОписаниеСвязи") = Неопределено Тогда
		РезультатКомпоновкиСКД.Колонки.Добавить("ЭтоОписаниеСвязи", Новый ОписаниеТипов("Булево"));
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьРекурсивноУзлыИРебра(ПараметрыФормирования, ТекУровеньСКД, ДанныеРезультата)
	Для Каждого Строка Из ТекУровеньСКД Цикл
		Если Строка.ЭтоОписаниеСвязи = Истина Тогда
			ДобавитьСвязь(ПараметрыФормирования, Строка, ДанныеРезультата);
		Иначе
			НовыйУзел = НовыйУзел(ПараметрыФормирования, Строка, ДанныеРезультата);
		КонецЕсли;
		Если Строка.Строки.Количество() > 0 Тогда
			НовыйУровеньУзлов = НовыйУзел.Строки;
			ПрежнийУровень = ДанныеРезультата.ТекущийУровеньУзлов;
			ДанныеРезультата.ТекущийУровеньУзлов = НовыйУровеньУзлов;
			ЗаполнитьРекурсивноУзлыИРебра(ПараметрыФормирования, Строка.Строки, ДанныеРезультата);
			ДанныеРезультата.ТекущийУровеньУзлов = ПрежнийУровень;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ДобавитьСвязь(ПараметрыФормирования, Строка, ДанныеРезультата)
	ИдентификаторыВсехСтрок = ПараметрыФормирования.ИдентификаторыВсехСтрок;
	Ребра = ДанныеРезультата.Ребра;
	НоваяСтрока = Ребра.Добавить();
	НайденныйИдентификаторГруппировки = НайденныйИдентификаторГруппировки(ПараметрыФормирования, Строка);
	СтрокаСвязи = ИдентификаторыВсехСтрок.Получить(НайденныйИдентификаторГруппировки);
	КороткийИдентификаторИсточника = Строка[СтрокаСвязи.ИдентификаторИсточника];
	КороткийИдентификаторПриемника = Строка[СтрокаСвязи.ИдентификаторПриемника];
	НоваяСтрока.ИдентификаторИсточника = ПолныйИдентификаторПоКороткому(ПараметрыФормирования, КороткийИдентификаторИсточника);
	НоваяСтрока.ИдентификаторПриемника = ПолныйИдентификаторПоКороткому(ПараметрыФормирования, КороткийИдентификаторПриемника);
	НоваяСтрока.Оформление = СтрокаСвязи.Оформление;
	Если ЗначениеЗаполнено(СтрокаСвязи.ЗаголовокРебра) Тогда
		НоваяСтрока.ЗаголовокРебра = СоставитьЗначениеСложногоЗаголовка(Строка, СтрокаСвязи.ЗаголовокРебра);
	КонецЕсли;
КонецПроцедуры

Функция СоставитьЗначениеСложногоЗаголовка(СтрокаСоЗначениями, Знач Заголовок)
	ПоляВЗаголовке = ПоляВЗаголовке(Заголовок);
	Для Каждого Поле Из ПоляВЗаголовке Цикл
		Заголовок = СтрЗаменить(Заголовок, Поле, "_служ_" + Поле);
		Заголовок = СтрЗаменить(Заголовок, "_служ_" + Поле , СтрокаСоЗначениями[Поле]);
	КонецЦикла;
	Возврат Заголовок;
КонецФункции

Функция ПолныйИдентификаторПоКороткому(ПараметрыФормирования, СтрокаИдентификатор)
	ПолныеИдентификаторы = ПараметрыФормирования.ПолныеИдентификаторы;
	Результат = ПолныеИдентификаторы.Получить(Строка(СтрокаИдентификатор));
	Возврат результат;
КонецФункции

Функция НайденныйИдентификаторГруппировки(ПараметрыФормирования, Строка)
	СхемаКомпоновкиДанных = ПараметрыФормирования.СхемаКомпоновкиДанных;
	ПолеГруппировки = Неопределено;
	Для Каждого поле из СхемаКомпоновкиДанных.ВычисляемыеПоля Цикл
		Если Поле.ПутьКДанным = "ЭтоОписаниеСвязи" Тогда
			Продолжить;
		КонецЕсли;	
		
		Если Строка[Поле.ПутьКДанным] = Истина Тогда
			ПолеГруппировки = Поле.ПутьКДанным;
		КонецЕсли;
	КонецЦикла;
	Возврат ИдентификаторСтрокиИзИмениПоля(ПолеГруппировки);
КонецФункции

Функция НовыйУзел(ПараметрыФормирования, Строка, ДанныеРезультата) 
	ИдентификаторыВсехСтрок = ПараметрыФормирования.ИдентификаторыВсехСтрок;
	ТекущийУровеньУзлов = ДанныеРезультата.ТекущийУровеньУзлов;
	НоваяСтрока = ТекущийУровеньУзлов.Добавить();
	ИдентификаторУзла = ИдентификаторыУзлаВключаяРодителей(ПараметрыФормирования, Строка);
	ЗапомнитьПолныйИдентификатор(ПараметрыФормирования, ИдентификаторУзла);
	НоваяСтрока.ИдентификаторУзла = ИдентификаторУзла;
	НайденныйИдентификаторГруппировки = НайденныйИдентификаторГруппировки(ПараметрыФормирования, Строка);
	СтрокаГруппировки = ИдентификаторыВсехСтрок.Получить(НайденныйИдентификаторГруппировки);
	Если ЗначениеЗаполнено(СтрокаГруппировки.ЗаголовокУзла) Тогда
		НоваяСтрока.ЗаголовокУзла = Строка[СтрокаГруппировки.ЗаголовокУзла];
	КонецЕсли;	
	НоваяСтрока.Оформление = СтрокаГруппировки.Оформление;
	Возврат НоваяСтрока;
КонецФункции

Процедура ЗапомнитьПолныйИдентификатор(ПараметрыФормирования, ИдентификаторУзла)
	ПолныеИдентификаторы = ПараметрыФормирования.ПолныеИдентификаторы;
	ЧастиИдентификатора = СтрРазделить(ИдентификаторУзла, "\", Ложь);
	ПолныеИдентификаторы.Вставить(ЧастиИдентификатора[0], ИдентификаторУзла);
КонецПроцедуры

Функция ИдентификаторыУзлаВключаяРодителей(ПараметрыФормирования, СтрокаУзлов)
	ИдентификаторыВсехСтрок = ПараметрыФормирования.ИдентификаторыВсехСтрок;
	НайденныйИдентификаторГруппировки = НайденныйИдентификаторГруппировки(ПараметрыФормирования, СтрокаУзлов);
	СтрокаГруппировки = ИдентификаторыВсехСтрок.Получить(НайденныйИдентификаторГруппировки);
	ИмяИдентификатора = СтрокаГруппировки.ИдентификаторУзла;
	ТекущийИдентификатор = Строка(СтрокаУзлов[ИмяИдентификатора]);
	Если ЗначениеЗаполнено(СтрокаУзлов.Родитель) Тогда
		ТекущийИдентификатор = ТекущийИдентификатор + "\"+ ИдентификаторыУзлаВключаяРодителей(ПараметрыФормирования, СтрокаУзлов.Родитель);
	КонецЕсли;
	Возврат ТекущийИдентификатор;
КонецФункции


#КонецОбласти

#Область ФормированиeHTML
Функция ДанныеГрафаВHTML(ДанныеДляГрафа)
	ШаблонТекста = "%1
					   |%2";
	ОписаниеРегистрацииНовыхТипов = ОписаниеРегистрацииНовыхТипов(ДанныеДляГрафа);
	КешОформлений =  КешОформлений();
	ОписаниеГрафаJSON = ОписаниеГрафаJSON(ДанныеДляГрафа, КешОформлений);
	Результат = СтрШаблон(ШаблонТекста, ОписаниеРегистрацииНовыхТипов, ОписаниеГрафаJSON);
	
	Возврат Результат;
КонецФункции

Функция ОписаниеГрафаJSON(ДанныеДляГрафа, КешОформлений)
	ДанныеГрафа = Новый Структура;                     
	ДанныеГрафа.Вставить("combos", ОписаниеГруппJSON(ДанныеДляГрафа, КешОформлений));
	ДанныеГрафа.Вставить("nodes", ОписаниеУзловJSON(ДанныеДляГрафа, КешОформлений));
	ДанныеГрафа.Вставить("edges", ОписаниеРеберJSON(ДанныеДляГрафа, КешОформлений)); 
	Результат = "const data = " + СериализоватьВJSON(ДанныеГрафа);
	Возврат Результат;
КонецФункции

Функция ОписаниеРеберJSON(ДанныеДляГрафа, КешОформлений) 
	Результат = Новый Массив;
	Ребра = ДанныеДляГрафа.Ребра;
	Для каждого Строка Из Ребра Цикл
		Результат.Добавить(ОписаниеРебра(Строка, КешОформлений));  
	КонецЦикла;	
	Возврат Результат;
КонецФункции

Функция ОписаниеРебра(Строка, КешОформлений) 
	Результат = Новый Структура;
	Результат.Вставить("source", Строка.ИдентификаторИсточника);
	Результат.Вставить("target", Строка.ИдентификаторПриемника);
	Результат.Вставить("label", МассивЗаголовков(Строка.ЗаголовокРебра));
	СвойстваОформления = КешОформлений.Получить(Строка.Оформление);
	Если СвойстваОформления <> Неопределено Тогда
		ДобавитьСвойстваОформления(Результат, СвойстваОформления);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция МассивЗаголовков(Строка)
	Результат = СтрРазделить(Строка, ";", Ложь);
	Возврат Результат;
КонецФункции

Функция ОписаниеУзловJSON(ДанныеДляГрафа, КешОформлений)
	Результат = Новый Массив;    
	Узлы = ДанныеДляГрафа.Узлы;
	ДобавитьВМассивРекурсивноУзлы(Результат, Узлы.Строки, КешОформлений);
	Возврат Результат;		
КонецФункции 

Процедура ДобавитьВМассивРекурсивноУзлы(Результат, Строки, КешОформлений)
	Для каждого Строка Из  Строки Цикл
		 Если Строка.Строки.Количество() = 0  Тогда
		 	 Результат.Добавить(ОписаниеУзла(Строка, КешОформлений));
		 Иначе
			ДобавитьВМассивРекурсивноУзлы(Результат, Строка.Строки, КешОформлений); 
		 КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

Функция ОписаниеУзла(Строка, КешОформлений) 
	
	Результат = Новый Структура;
	Результат.Вставить("id", Строка.ИдентификаторУзла);
	 
	Если ЗначениеЗаполнено(Строка.ЗаголовокУзла) Тогда
		Результат.Вставить("label", Строка.ЗаголовокУзла);  
	Иначе
		Результат.Вставить("label", Строка.ИдентификаторУзла);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Строка.Родитель) Тогда
		Результат.Вставить("comboId", Строка.Родитель.ИдентификаторУзла); 	
	КонецЕсли;
	
	СвойстваОформления = КешОформлений.Получить(Строка.Оформление);
	Если СвойстваОформления <> Неопределено Тогда
		ДобавитьСвойстваОформления(Результат, СвойстваОформления);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции  

Функция ОписаниеГруппJSON(ДанныеДляГрафа, КешОформлений)
	Результат = Новый Массив;    
	Узлы = ДанныеДляГрафа.Узлы.Строки;
	ДобавитьВМассивРекурсивноГруппы(Результат, Узлы, КешОформлений);
	Возврат Результат;		
КонецФункции

Процедура ДобавитьВМассивРекурсивноГруппы(Результат, Строки, КешОформлений)
	Для каждого Строка Из  Строки Цикл
		 Если Строка.Строки.Количество() > 0  Тогда
		 	 Результат.Добавить(ОписаниеГруппы(Строка, КешОформлений));
		     ДобавитьВМассивРекурсивноГруппы(Результат, Строка.Строки, КешОформлений); 
		 КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

Функция ОписаниеГруппы(Строка, КешОформлений) 
	Результат = Новый Структура;
	Результат.Вставить("id", Строка.ИдентификаторУзла);
	Если ЗначениеЗаполнено(Строка.ЗаголовокУзла) Тогда
		Результат.Вставить("label", Строка.ЗаголовокУзла);  
	Иначе
		Результат.Вставить("label", Строка.ИдентификаторУзла);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Строка.Родитель) Тогда
		Результат.Вставить("parentId", Строка.Родитель.ИдентификаторУзла); 	
	КонецЕсли;
	
	СвойстваОформления = КешОформлений.Получить(Строка.Оформление);
	Если СвойстваОформления <> Неопределено Тогда
		ДобавитьСвойстваОформления(Результат, СвойстваОформления);
	КонецЕсли;

	Возврат Результат;
КонецФункции

Процедура ДобавитьСвойстваОформления(Результат, СвойстваОформления)
	Результат.Вставить("type", СвойстваОформления.ТипОформления); 	
	ТекстВСкобках = ТекстСоСкобками(СвойстваОформления.ОписаниеJSON);
	СвойстваОбъект = ДеСериализоватьИзJSON(ТекстВСкобках);
	Для каждого КлючИЗначение из СвойстваОбъект Цикл
		Результат.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
КонецПроцедуры

Функция СериализоватьВJSON(Значение)
	ЗаписьJSON = Новый ЗаписьJSON;
    ЗаписьJSON.УстановитьСтроку();
    ЗаписатьJSON(ЗаписьJSON, Значение);
    Возврат ЗаписьJSON.Закрыть();
КонецФункции

Функция ДеСериализоватьИзJSON(Текст)
	ЧтениеJSON = Новый ЧтениеJSON;
    ЧтениеJSON.УстановитьСтроку(Текст);
    Результат = ПрочитатьJSON(ЧтениеJSON);
    ЧтениеJSON.Закрыть();
    Возврат Результат;
КонецФункции

Функция ОписаниеРегистрацииНовыхТипов(ДанныеДляГрафа) 
	ПользовательскиеТипы = ПользовательскиеТипыВГрафе(ДанныеДляГрафа); 
	ТекстРегистрации = Справочники.граф_ТипыОформленийЭлементовГрафов.ТекстРегистрацииРасширяемыхТипов(ПользовательскиеТипы);
	Возврат ТекстРегистрации;
КонецФункции

Функция ПользовательскиеТипыВГрафе(ДанныеДляГрафа)
	ВсеСтрокиДерева = Новый Массив;
	Узлы = ДанныеДляГрафа.Узлы;
	Ребра = ДанныеДляГрафа.Ребра;
	СтрокиДереваРекурсивно(Узлы, ВсеСтрокиДерева);
    СтрокиТаблицы(Ребра, ВсеСтрокиДерева);	
	ВсеОформления = ОбщегоНазначения.ВыгрузитьКолонку(ВсеСтрокиДерева, "Оформление");
	ТолькоПользовательскиеТипы = ТолькоПользовательскиеТипы(ВсеОформления);
	Возврат ТолькоПользовательскиеТипы;
КонецФункции

Процедура СтрокиДереваРекурсивно(ТекущийУзел, ВсеСтрокиДерева)
	Для каждого Строка из ТекущийУзел.Строки Цикл
		ВсеСтрокиДерева.Добавить(Строка);
		СтрокиДереваРекурсивно(Строка, ВсеСтрокиДерева);
	КонецЦикла;
КонецПроцедуры

Процедура СтрокиТаблицы(Таблица, ВсеСтрокиДерева)
	Для каждого Строка из Таблица Цикл
		ВсеСтрокиДерева.Добавить(Строка);
	КонецЦикла;
КонецПроцедуры

Функция ТолькоПользовательскиеТипы(Оформления)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	граф_ЭлементыГрафов.ТипОформления как ТипОформления
		|ИЗ
		|	Справочник.граф_ОформленияЭлементовГрафа КАК граф_ЭлементыГрафов
		|ГДЕ
		|	граф_ЭлементыГрафов.Предопределенный = ЛОЖЬ
		|	И граф_ЭлементыГрафов.Ссылка В (&Оформления)";
	
	Запрос.УстановитьПараметр("Оформления", Оформления);
	
	Результат =  Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ТипОформления");
	Возврат Результат;
			
КонецФункции

Функция КешОформлений()
	Результат = Новый Соответствие;
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	граф_ОформленияЭлементовГрафа.Ссылка,
		|	граф_ОформленияЭлементовГрафа.ОписаниеJSON,
		|	граф_ОформленияЭлементовГрафа.ТипОформления.Код КАК ТипОформления
		|ИЗ
		|	Справочник.граф_ОформленияЭлементовГрафа КАК граф_ОформленияЭлементовГрафа
		|ГДЕ
		|	граф_ОформленияЭлементовГрафа.ПометкаУдаления = ЛОЖЬ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СвойстваОформления = Новый Структура;
		СвойстваОформления.Вставить("ОписаниеJSON", ВыборкаДетальныеЗаписи.ОписаниеJSON);
		СвойстваОформления.Вставить("ТипОформления", ВыборкаДетальныеЗаписи.ТипОформления);
		Результат.Вставить(ВыборкаДетальныеЗаписи.Ссылка, СвойстваОформления);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ТекстСоСкобками(Текст) Экспорт
	ШаблонТекста = "{
	|%1
	|}";
	Возврат СтрШаблон(ШаблонТекста, Текст);
КонецФункции

Функция УникальныйКомментарий()
	Шаблон = "<!-- %1 -->";
	Возврат СтрШаблон(Шаблон, ТекущаяУниверсальнаяДатаВМиллисекундах());
КонецФункции

#КонецОбласти

#КонецОбласти


