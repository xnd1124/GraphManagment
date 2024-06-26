#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ВосстановитьПараметрыЗапроса();
	ЗаполнитьДоступныеПоляЗапроса();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ТекстЗапросаПриИзменении(Элемент)
	ТекстЗапросаПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПараметрыЗапроса
&НаКлиенте
Процедура ПараметрыЗапросаТипВФормеНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ЗаголовокЭлемента = НСтр("ru = 'Выбрать тип'");
	ОписаниеОповещения = Новый ОписаниеОповещения("ТипВФормеЗавершениеВыбора", ЭтотОбъект);
	СписокТипов.ПоказатьВыборЭлемента(ОписаниеОповещения, ЗаголовокЭлемента);
КонецПроцедуры

//@skip-check module-structure-form-event-regions
//@skip-check doc-comment-parameter-section
&НаКлиенте
Процедура ТипВФормеЗавершениеВыбора(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	Если ВыбранныйЭлемент <> Неопределено Тогда
		
		ТекущийПараметр = Элементы.ПараметрыЗапроса.ТекущиеДанные;
		ТекущийТип = ВыбранныйЭлемент;
		
		Если ТекущийТип.Значение = "ТаблицаЗначений"
			Или ТекущийТип.Значение = "МоментВремени" 
			Или ТекущийТип.Значение = "Граница" Тогда 
		
			ТипСтрока						= ТипСтрока(ТекущийТип.Значение);
			ТекущийПараметр.Тип 			= ТипСтрока;
			ТекущийПараметр.ТипВФорме 		= ТекущийТип.Представление;
			ТекущийПараметр.Значение 		= "";
			ТекущийПараметр.ЗначениеВФорме 	= ТекущийТип.Представление;
		Иначе
			ИнициализацияТипаИЗначенияПараметра(ТекущийПараметр, ТекущийТип);
		КонецЕсли;	
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапросаЗначениеВФормеПриИзменении(Элемент)
		ТекущийПараметр = Элементы.ПараметрыЗапроса.ТекущиеДанные;
	
	Значение		= ТекущийПараметр.ЗначениеВФорме;
	ТекущийТип		= ТекущийПараметр.Тип;
	Если ТекущийТип <> "ТаблицаЗначений" И ТекущийТип <> "МоментВремени" И ТекущийТип <> "Граница" Тогда
		ЗначВнутр					= ЗначениеВСтрокуСервер(Значение);
		ТекущийПараметр.Значение	= ЗначВнутр;
		
		Модифицированность 			= Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоляРесурсы
&НаКлиенте
Процедура ПоляРесурсыИмяПоляНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;                                                                     
	ДанныеВыбора = ДоступныеПоляЗапроса.Скопировать();
КонецПроцедуры

&НаКлиенте
Процедура ПоляРесурсыАгрегирующаяФункцияНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ПоляРесурсы.ТекущиеДанные;
	ДанныеВыбора = СписокАгрегирующихФункций(ТекущиеДанные.ИмяПоля);  
КонецПроцедуры

&НаКлиенте
Процедура ПоляРесурсыИмяПоляПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ПоляРесурсы.ТекущиеДанные;
	ТекущиеДанные.АгрегирующаяФункция = АгрегирующаяФункцияПоУмолчанию(ТекущиеДанные.ИмяПоля);	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ЗаполнитьПараметры(Команда)
	ЗаполнитьПараметрыНаСервере()
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ВосстановитьПараметрыЗапроса()
	СформироватьСписокТипов();
	Для Каждого Строка Из Объект.ПараметрыЗапроса Цикл
		Значение = ЗначениеИзСтрокиВнутр(Строка.Значение);
		Строка.ТипВФорме 				= Строка(ТипЗнч(Значение));
		Строка.ЗначениеВФорме 			= Значение;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыНаСервере()
	МассивСтруктуры = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = Объект.ТекстЗапроса;
	НайденныеПараметры = Запрос.НайтиПараметры();
	
	Для каждого НайденныйПараметр Из НайденныеПараметры Цикл 
		РезультатСтруктура = ДобавлениеНовогоПараметра(НайденныйПараметр);
		МассивСтруктуры.Добавить(РезультатСтруктура);
	КонецЦикла;
	
	Для каждого СтрПараметр Из МассивСтруктуры Цикл
		ЕстьПараметр = Ложь;
		Для каждого Стр Из Объект.ПараметрыЗапроса Цикл
			Если СтрПараметр.Имя = Стр.Имя Тогда
				ЕстьПараметр = Истина;
			КонецЕсли;
		КонецЦикла;
		Если ЕстьПараметр = Ложь Тогда 
			ДобавитьПараметрВФорму(СтрПараметр);
			Модифицированность = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДобавитьПараметрВФорму(ПараметрСтруктуры)
	Значение 	= ПараметрСтруктуры.Значение;
	Тип			= ИмяТипаИзЗначения(Значение);
	
	// Основные реквизиты.
	Элемент							= Объект.ПараметрыЗапроса.Добавить();
	Элемент.Идентификатор			= Новый УникальныйИдентификатор;
	Элемент.Имя						= ПараметрСтруктуры.Имя;
	Элемент.Тип						= Тип;
	Элемент.Значение				= Значение;
	
	Значение = ЗначениеИзСтрокиВнутр(Значение);
	
	// Форменные реквизиты.
	Элемент.ТипВФорме 				= Строка(ТипЗнч(Значение));
	Элемент.ЗначениеВФорме 			= Значение;
КонецПроцедуры

&НаСервере
Функция ИмяТипаИзЗначения(Значение) 
	Если ТипЗнч(Значение) = Тип("Строка") Тогда
		ИмяТипа = "Строка";
	ИначеЕсли ТипЗнч(Значение) = Тип("Число") Тогда
		ИмяТипа = "Число";
	ИначеЕсли ТипЗнч(Значение) = Тип("Булево") Тогда
		ИмяТипа = "Булево";
	ИначеЕсли ТипЗнч(Значение) = Тип("Дата") Тогда
		ИмяТипа = "Дата";
	ИначеЕсли ТипЗнч(Значение) = Тип("МоментВремени") Тогда
		ИмяТипа = "МоментВремени";
	ИначеЕсли ТипЗнч(Значение) = Тип("Неопределено") Тогда
		ИмяТипа = "Строка";
	ИначеЕсли ТипЗнч(Значение) = Тип("ФиксированныйМассив") Тогда
		ИмяТипа = "ФиксированныйМассив";
	Иначе	
		ИмяТипа = xmlТип(ТипЗнч(Значение)).ИмяТипа;
	КонецЕсли;
	
	Возврат ИмяТипа;
КонецФункции

&НаСервере
Функция ДобавлениеНовогоПараметра(ТекущийПрочитанныйПараметр)
	
	ЭлементПараметр = Новый Структура("Имя, Тип, Значение",
		 ТекущийПрочитанныйПараметр.Имя);
	
	// Смотрим на первый тип из списка, если есть.
	ДоступныеТипы = ТекущийПрочитанныйПараметр.ТипЗначения.Типы();
	Если ДоступныеТипы.Количество()=0 Тогда
		// Считаем строкой
		ЭлементПараметр.Тип = "Строка";
		ЭлементПараметр.Значение = ЗначениеВСтрокуВнутр("");
		Возврат ЭлементПараметр;
	КонецЕсли;
	
	// Формируем описание типа из первого доступного типа.
	Массив = Новый Массив;
	Массив.Добавить( ДоступныеТипы.Получить(0) );
	НовоеОписаниеТипов = Новый ОписаниеТипов(Массив);
	
	Значение = НовоеОписаниеТипов.ПривестиЗначение(Неопределено);
	
	СписокДобавленныхТипов = Новый СписокЗначений;
	СформироватьСписокТипов(СписокДобавленныхТипов);
	
	Флаг = Ложь;
	СтроковоеПредставлениеТипа = Строка(ТипЗнч(Значение));
	Для каждого ЭлементСписка Из СписокДобавленныхТипов Цикл
		Если ЭлементСписка.Представление = СтроковоеПредставлениеТипа Тогда
			Флаг = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ЭлементПараметр.Тип = ?(Флаг, СтроковоеПредставлениеТипа, XMLТип(ТипЗнч(Значение)).ИмяТипа);
	ЭлементПараметр.Значение = ЗначениеВСтрокуВнутр(Значение);
	
	Возврат ЭлементПараметр;
КонецФункции

&НаСервере
Функция ДоступныеТипы()
	РеквизитыФормы = ПолучитьРеквизиты();
	Для каждого Реквизит из РеквизитыФормы Цикл
		Если Реквизит.Имя = "ДоступныеТипыДанных" Тогда
			Возврат Реквизит.ТипЗначения.Типы();
		КонецЕсли;
	КонецЦикла
КонецФункции

&НаСервере
Функция СформироватьСписокТипов(СписокДобавленныхТипов = Неопределено) 
	
	МассивТипов = ДоступныеТипы();
	
	НеПримитивныеТипы = Новый СписокЗначений;
	НеПримитивныеТипы.ЗагрузитьЗначения(МассивТипов);
	НеПримитивныеТипы.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
	СписокТипов = Новый СписокЗначений;
	СписокТипов.Добавить("Строка", НСтр("ru = 'Строка'"));
	СписокТипов.Добавить("Число", НСтр("ru = 'Число'"));
	СписокТипов.Добавить("Дата", НСтр("ru = 'Дата'"));
	СписокТипов.Добавить("Булево", НСтр("ru = 'Булево'"));
	СписокТипов.Добавить("Граница", НСтр("ru = 'Граница'"));
	СписокТипов.Добавить("МоментВремени", НСтр("ru = 'Момент времени'"));
	СписокТипов.Добавить("СписокЗначений", НСтр("ru = 'Список значений'"));
	СписокТипов.Добавить("ТаблицаЗначений", НСтр("ru = 'Таблица значений'"));
	
	СписокДобавленныхТипов = Новый СписокЗначений;
	СписокДобавленныхТипов = СписокТипов.Скопировать();
	
	Для каждого Стр Из НеПримитивныеТипы Цикл
		ЗначениеТипа 		= XMLТип(Стр.Значение).ИмяТипа;
		ПредставлениеТипа 	= Строка(Стр.Значение);
		СписокТипов.Добавить(ЗначениеТипа, ПредставлениеТипа);
	КонецЦикла;
	
	Возврат СписокТипов;
КонецФункции

&НаСервере
Функция ТипСтрока(Значение)
	
	СписокДобавленныхТипов = Новый СписокЗначений;
	СформироватьСписокТипов(СписокДобавленныхТипов);
	
	ТипСтрока = Строка(Тип(Значение));
	Если Значение = "СписокЗначений" Тогда 
		Возврат "СписокЗначений";
	КонецЕсли;
		
	ТипНайден = Ложь;
	Для Каждого ЭлементСписка Из СписокДобавленныхТипов Цикл
		Если ЭлементСписка.Представление = ТипСтрока Тогда 
			ТипНайден = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ТипНайден Тогда 
		ТипСтрока	= XMLТип(Тип(Значение)).ИмяТипа;
	КонецЕсли;
	
	Возврат ТипСтрока;
	
КонецФункции

&НаКлиенте
Процедура ИнициализацияТипаИЗначенияПараметра(ТекущийПараметр, ТекущийТип)
	// Тип в табличной части.
	ТипСтрока					= ТипСтрока(ТекущийТип.Значение);
	ТекущийПараметр.Тип 		= ТипСтрока;
	
	// Тип в форме.
	Массив = Новый Массив;
	Массив.Добавить(Тип(ТекущийПараметр.Тип));
	Описание = Новый ОписаниеТипов(Массив);
	
	ТекущийПараметр.ТипВФорме 		= ТекущийТип.Представление;
	
	// Значение.
	Значение						= Описание.ПривестиЗначение(Тип(ТекущийТип.Значение));
	ТекущийПараметр.ЗначениеВФорме	= Значение;   
	
	ЗначениеВнутр					= ЗначениеВСтрокуСервер(Значение);
	ТекущийПараметр.Значение		= ЗначениеВнутр;
КонецПроцедуры	

&НаСервере
Функция ЗначениеВСтрокуСервер(Значение)
	Результат = ЗначениеВСтрокуВнутр(Значение);
	Возврат Результат;
КонецФункции

&НаСервере
Процедура ТекстЗапросаПриИзмененииНаСервере()
	ЗаполнитьДоступныеПоляЗапроса();
	ВосстановитьПараметрыЗапроса();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоступныеПоляЗапроса()
	ДоступныеПоляЗапроса.Очистить();
	
	ТекстЗапроса = Объект.ТекстЗапроса;
	Если НЕ ЗначениеЗаполнено(ТекстЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);   
	ПакетЗапросов = СхемаЗапроса.ПакетЗапросов[0]; 
	Колонки = ПакетЗапросов.Колонки; 
	
	Для каждого Колонка Из Колонки Цикл
	 ДоступныеПоляЗапроса.Добавить(Колонка.Псевдоним, Колонка.Псевдоним);
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Функция АгрегирующаяФункцияПоУмолчанию(ИмяПоля)
 ШаблонСтроки = "СУММА(%1)";
 Возврат СтрШаблон(ШаблонСтроки, ИмяПоля);
КонецФункции

&НаКлиенте
Функция СписокАгрегирующихФункций(ИмяПоля)
	Результат = Новый СписокЗначений;
	ШаблонСтроки = "%1(%2%3)";
	ВозможныеФункцииАгрегации = ВозможныеФункцииАгрегации(); 
	Для Каждого Агрегат Из ВозможныеФункцииАгрегации Цикл
		ЧастиАгрегата = СтрРазделить(Агрегат, ",", Ложь);
		Если ЧастиАгрегата.Количество() = 1 Тогда
			ТекстФункции = СтрШаблон(ШаблонСтроки,Агрегат, "", ИмяПоля);
		иначе
			ТекстФункции = СтрШаблон(ШаблонСтроки,ЧастиАгрегата[0], ЧастиАгрегата[1], ИмяПоля);
		КонецЕсли;
		Результат.Добавить(ТекстФункции);
	КонецЦикла;
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ВозможныеФункцииАгрегации()
	Результат = Новый Массив;
	Результат.Добавить("СУММА");
	Результат.Добавить("МИНИМУМ");
	Результат.Добавить("МАКСИМУМ");
	Результат.Добавить("КОЛИЧЕСТВО");
	Результат.Добавить("КОЛИЧЕСТВО,РАЗЛИЧНЫЕ ");
	Возврат Результат;
КонецФункции

#КонецОбласти

