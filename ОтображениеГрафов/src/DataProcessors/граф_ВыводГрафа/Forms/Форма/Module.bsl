#Область ОписаниеПеременных
&НаСервере
Перем КешОформлений; // соответствие для хранения оформлений элементов графа
#КонецОбласти

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	КешированныйШаблонТекстаСтраницы = граф_МакетыВызовСервера.ТекстМакета("граф_ШаблонHTML");
	КешированныйСкриптИнициализации = граф_МакетыВызовСервера.ТекстМакета("граф_СкриптИнициализацииГрафа");
	СохраненныйГраф = Справочники.граф_СохраненныеГрафы.ПустаяСсылка();
	Если Параметры.Свойство("Ключ", СохраненныйГраф) Тогда
		Заголовок = "Сохраненный граф: " + СохраненныйГраф;	
		Элементы.ГруппаИсточникДанных.Видимость = Ложь;
	Иначе
		Заголовок = "Формирование графа по источнику данных";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	граф_БиблиотекаG6Клиент.ПроверитьиУстановитьБиблиотеку();
	Если ЗначениеЗаполнено(СохраненныйГраф) Тогда
		ВывестиГраф(СохраненныйГраф);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Сформировать(Команда)
	Если ПроверитьЗаполнение() = Ложь Тогда
		Возврат;
	КонецЕсли;	
	СвязиУзлов.Очистить();
	СформироватьГрафНаСервере();
	ВывестиГраф();
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораЭлементаСохранения", ЭтотОбъект);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	ОткрытьФорму("Справочник.граф_СохраненныеГрафы.ФормаВыбора", ПараметрыФормы, ЭтотОбъект, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура Восстановить(Команда)
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораЭлементаЗагрузки", ЭтотОбъект);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	ОткрытьФорму("Справочник.граф_СохраненныеГрафы.ФормаВыбора", ПараметрыФормы, ЭтотОбъект, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РазборДереваДанныхИзСКД
// Функция - Назначение колонок
//
// Параметры:
//  ДеревоСКД	 - 	деревоЗначений - Дерево значений с результатами выполнения СКД 
// 
// Возвращаемое значение:
//  Структура - 
//    КолонкиИдентифкаторы - номера колонок, содежащие в своем заголовке слово "идентификатор"
//    КолонкиЗаголовки - номера колонок, содежащие в своем заголовке слово "заголовок"
//    КолонкаКодОформления - номер колонки, содежащие в своем заголовке слово "кодОформления"
//    КоличествоКолонокВсего - общее количество колонок в дереве
&НаСервере
Функция НазначениеКолонок(ДеревоСКД)
	Результат = Новый Структура;
	Результат.Вставить("КолонкиИдентификаторы", КолонкиСодержащие("идентификатор, связьисточник, связьприемник", ДеревоСКД));
	Результат.Вставить("КолонкиЗаголовки", КолонкиСодержащие("заголовок", ДеревоСКД));
	Результат.Вставить("КолонкаКодОформления", КолонкиСодержащие("кодОформления", ДеревоСКД, Истина));
	Результат.Вставить("КолонкаНаправление", КолонкиСодержащие("НаправлениеСвязи", ДеревоСКД, Истина));
	КолонкаСвязь = КолонкиСодержащие("этосвязь", ДеревоСКД);
	Для каждого Колонка Из КолонкаСвязь Цикл
		Результат.Вставить("КолонкаСвязи", Колонка.Ключ);	
	КонецЦикла;
	
	КолонкаВесСвязи = КолонкиСодержащие("ВесСвязи", ДеревоСКД);
	Для каждого Колонка Из КолонкаВесСвязи Цикл
		Результат.Вставить("КолонкаВесСвязи", Колонка.Ключ);	
	КонецЦикла;
	
	КолонкаВесСвязи = КолонкиСодержащие("ЗаголовокСвязи", ДеревоСКД);
	Для каждого Колонка Из КолонкаВесСвязи Цикл
		Результат.Вставить("КолонкаЗаголовокСвязи", Колонка.Ключ);	
	КонецЦикла;
	
	Результат.Вставить("КоличествоКолонокВсего",  ДеревоСКД.Колонки.Количество());      
	Результат.Вставить("НачальнаяКолонка",  0);
	
	Если Результат.Свойство("КолонкаСвязи") = Ложь Тогда
		ВызватьИсключение "В настройках СКД не найдена группировка с колонкой ""ЭтоСвязь""";
	КонецЕсли;
	
//	Если Результат.КолонкиИдентификаторы.Количество() = 0 Тогда
//		ВызватьИсключение "В настройках СКД не найдено ни одной колонки, содержащей слово ""идентификатор""";
//	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаСервере
Функция КолонкиСодержащие(ИскомыеФрагменты, ДеревоСКД, ТолькоОднаКолонка = Ложь)
	ИскомыеФрагменты = НРег(ИскомыеФрагменты);
	МассивФрагментов = СтрРазделить(ИскомыеФрагменты, ",");
	Результат = Новый Соответствие;
	Счетчик = 0;
	Для Каждого Колонка Из ДеревоСКД.Колонки Цикл
		_заголовок = НРег(Колонка.Заголовок);
		_Имя = НРег(Колонка.Имя);
		Для Каждого Фрагмент Из МассивФрагментов Цикл
			Если СтрНайти(_заголовок, СокрЛП(Фрагмент)) > 0 Или СтрНайти(_Имя, СокрЛП(Фрагмент)) > 0 Тогда
				Если ТолькоОднаКолонка Тогда
					Возврат Счетчик;
				Иначе
					Результат.Вставить(Счетчик, Счетчик);
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	Возврат результат;
КонецФункции

&НаСервере
Функция НовыйПустойГрафУзлов()
	УзлыГрафа = Новый ДеревоЗначений;
	УзлыГрафа.Колонки.Добавить("Идентификатор");
	УзлыГрафа.Колонки.Добавить("Заголовок");
	УзлыГрафа.Колонки.Добавить("X");
	УзлыГрафа.Колонки.Добавить("Y");
	УзлыГрафа.Колонки.Добавить("Длина");
	УзлыГрафа.Колонки.Добавить("Высота");
	УзлыГрафа.Колонки.Добавить("КодОформленияЭлемента");
	Возврат  УзлыГрафа;
КонецФункции

&НаСервере
Процедура ЗаполнитьДанныеДляГрафа(УзлыГрафа, СтрокиДерева,
	 НазначениеКолонок, ИдентификаторРодителя = Неопределено)
	Для каждого Строка Из СтрокиДерева Цикл 
		Если Строка[НазначениеКолонок.КолонкаСвязи] = Истина Тогда
			ДобавитьСвязь(СвязиУзлов, Строка, НазначениеКолонок);
			Продолжить;
		КонецЕсли;	  
		ДобавленныеДанные = НайтиИдентификаторИДобавитьУзел(УзлыГрафа, Строка, НазначениеКолонок, ИдентификаторРодителя);
		Если Строка.Строки.Количество() > 0 Тогда      
			Если  ДобавленныеДанные <> Неопределено Тогда
				НазначенияБезТекущейКолонки = НазначенияБезТекущейКолонки(НазначениеКолонок, ДобавленныеДанные.НомерКолонки, Строка);	
				ЗаполнитьДанныеДляГрафа(УзлыГрафа, Строка.Строки, НазначенияБезТекущейКолонки, ДобавленныеДанные.Идентификатор);	
			Иначе
				ЗаполнитьДанныеДляГрафа(УзлыГрафа, Строка.Строки, НазначениеКолонок);	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры 

&НаСервере
Функция НайтиИдентификаторИДобавитьУзел(УзлыГрафа, Строка, НазначениеКолонок, ИдентификаторРодителя)
	Для Счетчик = НазначениеКолонок.НачальнаяКолонка По НазначениеКолонок.КоличествоКолонокВсего - 1 Цикл 
		ТекЗначение = Строка[Счетчик]; 
		ТекущееЗначениеЗаполнено = ЗначениеЗаполнено(ТекЗначение);
		Если  НазначениеКолонок.КолонкаКодОформления = Счетчик Тогда
			Продолжить;
		КонецЕсли;
		Если ТекущееЗначениеЗаполнено Тогда
			Результат = Новый Структура;
			Результат.Вставить("НомерКолонки", Счетчик);
			Результат.Вставить("Идентификатор", ТекЗначение);
			Если УзелУжеЕсть(УзлыГрафа, ТекЗначение) = Ложь Тогда
				ДобавитьУзел(УзлыГрафа, ТекЗначение, ИдентификаторРодителя, Строка, НазначениеКолонок);  	
			КонецЕсли;	
			Возврат Результат; 
		КонецЕсли;
	КонецЦикла; 
КонецФункции

&НаСервере
Процедура ДобавитьСвязь(СвязиУзлов, Строка, НазначениеКолонок)
	ИдентификаторНачала = Неопределено;
	ИдентификаторКонца = Неопределено;
	Для Счетчик = 0 По НазначениеКолонок.КоличествоКолонокВсего - 1 Цикл 
		Если Не ЗначениеЗаполнено(ИдентификаторНачала) и ЗначениеЗаполнено(Строка[Счетчик]) Тогда
			ИдентификаторНачала = Строка[Счетчик];
			Продолжить;
		КонецЕсли;                                
		
		Если ЗначениеЗаполнено(ИдентификаторНачала)  
			И НЕ ЗначениеЗаполнено(ИдентификаторКонца) 
			И ЗначениеЗаполнено(Строка[Счетчик]) Тогда
			ИдентификаторКонца = Строка[Счетчик];
			Прервать;
		КонецЕсли;                                
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ИдентификаторНачала) и ЗначениеЗаполнено(ИдентификаторКонца) Тогда
		 НоваяСвязь = СвязиУзлов.Добавить();
		 НоваяСвязь.УзелНачала = ИдентификаторНачала;
		 НоваяСвязь.УзелКонца = ИдентификаторКонца;
		 ЗаполнитьСвойстваСвязи(НоваяСвязь, Строка, НазначениеКолонок);
	 КонецЕсли; 
	 
КонецПроцедуры

// удаляет из назначения колонок идентификатор и заголовок текущей колонки (чтобы родитель не мешал потомкам)
&НаСервере
Функция НазначенияБезТекущейКолонки(НазначениеКолонок, НомерКолонкиКУдалению, Строка) 
	Результат = Новый Структура;
	
	КонвертацияСоответствия = Новый ФиксированноеСоответствие(НазначениеКолонок.КолонкиИдентификаторы);	
	КолонкиИдентификаторы = Новый Соответствие(КонвертацияСоответствия);
	Если НазначениеКолонок.КолонкиИдентификаторы.Получить(НомерКолонкиКУдалению) <> Неопределено Тогда
		КолонкиИдентификаторы.Удалить(НомерКолонкиКУдалению);      
	КонецЕсли;
	Результат.Вставить("КолонкиИдентификаторы", КолонкиИдентификаторы);
	
	КонвертацияСоответствия = Новый ФиксированноеСоответствие(НазначениеКолонок.КолонкиЗаголовки);	
	КолонкиЗаголовки = Новый Соответствие(КонвертацияСоответствия);
	Если НазначениеКолонок.КолонкиЗаголовки.Получить(НомерКолонкиКУдалению) <> Неопределено Тогда
		КолонкиЗаголовки.Удалить(НомерКолонкиКУдалению);      
	КонецЕсли;	
	
	ПоследнийНомерКолонки = МаксимальныйНомерЗаполненнойКолонки(НазначениеКолонок, НомерКолонкиКУдалению, Строка);
	
	Результат.Вставить("КолонкиЗаголовки", КолонкиЗаголовки);   
	Результат.Вставить("КоличествоКолонокВсего", НазначениеКолонок.КоличествоКолонокВсего); 
	Результат.Вставить("КолонкаСвязи", НазначениеКолонок.КолонкаСвязи); 
	Результат.Вставить("КолонкаКодОформления", НазначениеКолонок.КолонкаКодОформления);
	Результат.Вставить("КолонкаНаправление", НазначениеКолонок.КолонкаНаправление);
	Результат.Вставить("НачальнаяКолонка", ПоследнийНомерКолонки); 
	
	Возврат Результат;
КонецФункции

&НаСервере
Функция МаксимальныйНомерЗаполненнойКолонки(НазначениеКолонок, НомерКолонкиКУдалению, Строка)
	Результат = НомерКолонкиКУдалению;
	Для  Счетчик = НомерКолонкиКУдалению  по  НазначениеКолонок.КоличествоКолонокВсего -1  Цикл
		Если ЗначениеЗаполнено(Строка[Счетчик])  И Счетчик <> НазначениеКолонок.КолонкаКодОформления Тогда
			Результат = Счетчик;    
		КонецЕсли;
	КонецЦикла;	
	Возврат Результат + 1;
КонецФункции

&НаСервере
Функция УзелУжеЕсть(УзлыГрафа, Идентификатор)
	Отбор = Новый Структура("Идентификатор", Идентификатор);
	НайденныеСтроки = УзлыГрафа.Строки.НайтиСтроки(Отбор, Истина);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

&НаСервере
Процедура ДобавитьУзел(УзлыГрафа, Идентификатор, ИдентификаторРодителя, Строка, НазначенияКолонок)         
	
	Если ЗначениеЗаполнено(ИдентификаторРодителя) Тогда
		Отбор = Новый Структура("Идентификатор", ИдентификаторРодителя);
		НайденныеСтроки = УзлыГрафа.Строки.НайтиСтроки(Отбор, Истина);
		ТекущийУровень = НайденныеСтроки[0].Строки;
	иначе
		ТекущийУровень  = УзлыГрафа.Строки;
	КонецЕсли;                   
	
	НоваяСтрока = ТекущийУровень.Добавить();
	НоваяСтрока.Идентификатор = Идентификатор;
	ЗаполнитьСвойстваУзла(НоваяСтрока, Строка, НазначенияКолонок);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвойстваУзла(НоваяСтрока, Строка, НазначенияКолонок)
	Если ЗначениеЗаполнено(НазначенияКолонок.КолонкаКодОформления) 
		И ЗначениеЗаполнено(Строка[НазначенияКолонок.КолонкаКодОформления]) Тогда
		НоваяСтрока.КодОформленияЭлемента = Строка[НазначенияКолонок.КолонкаКодОформления];
	Иначе
		 Если Строка.Строки.Количество() > 0 Тогда
		 	НоваяСтрока.КодОформленияЭлемента = ИдентификаторОформленияГруппыПоУмолчанию;
		 Иначе
		 	НоваяСтрока.КодОформленияЭлемента = ИдентификаторОформленияУзлаПоУмолчанию;
		 КонецЕсли;
	КонецЕсли;	
	
	Для каждого Колонка из НазначенияКолонок.КолонкиЗаголовки Цикл
		Если Колонка.Значение < НазначенияКолонок.НачальнаяКолонка Тогда
			Продолжить;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(Строка[Колонка.значение]) Тогда
			НоваяСтрока.Заголовок = Строка[Колонка.Значение];
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьСвойстваСвязи(НоваяСтрока, Строка, НазначенияКолонок)
	Если ЗначениеЗаполнено(НазначенияКолонок.КолонкаКодОформления) Тогда
		НоваяСтрока.КодОформленияЭлемента = Строка[НазначенияКолонок.КолонкаКодОформления];
	КонецЕсли;	
	Если НазначенияКолонок.Свойство("КолонкаВесСвязи") Тогда
		НоваяСтрока.ВесСвязи = Строка[НазначенияКолонок.КолонкаВесСвязи];
	КонецЕсли;	
	Если НазначенияКолонок.Свойство("КолонкаЗаголовокСвязи") Тогда
		НоваяСтрока.Заголовок = Строка[НазначенияКолонок.КолонкаЗаголовокСвязи];
	КонецЕсли;	
	Если ЗначениеЗаполнено(НазначенияКолонок.КолонкаНаправление) 
		И ЗначениеЗаполнено(Строка[НазначенияКолонок.КолонкаНаправление]) Тогда
		НоваяСтрока.НаправлениеСвязи = Строка[НазначенияКолонок.КолонкаНаправление];
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

#Область РаботасСКД
&НаСервере
Функция СКДВДеревоЗначений(ИсточникДанных)
	ИмяМакета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсточникДанных, "ИмяШаблонаСКД");
	СхемаиНастройка = Справочники.граф_УдалитьИсточникиДанныхГрафов.ОписаниеИСхемаКомпоновкиДанныхГрафаПоИмениМакета(
		ИсточникДанных, ИмяМакета);
	
	СхемаКомпоновкиДанных = СхемаиНастройка.СхемаКомпоновкиДанных;
	НастройкаКомпоновки = СхемаиНастройка.НастройкиКомпоновкиДанных;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	Если НастройкаКомпоновки = Неопределено Тогда
		ТекущиеНастройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	Иначе
		ТекущиеНастройки = НастройкаКомпоновки;
	КонецЕсли;
	
	УстановитьПараметрыСКД(ТекущиеНастройки);
	КомпоновщикНастроек.ЗагрузитьНастройки(ТекущиеНастройки);
	
	ЗаполнитьОформлениеПоУмолчанию(ТекущиеНастройки);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, 
						КомпоновщикНастроек.Настройки,,,
						Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = Новый ДеревоЗначений;
	ПроцессорВывода.УстановитьОбъект(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат Результат;
КонецФункции

&НаСервере
Процедура ЗаполнитьОформлениеПоУмолчанию(ТекущиеНастройки)
	ОформлениеГруппыПоУмолчанию = Новый ПараметрКомпоновкиДанных("ОформлениеГруппыПоУмолчанию");
	Значение = ТекущиеНастройки.ПараметрыДанных.НайтиЗначениеПараметра(ОформлениеГруппыПоУмолчанию);
	Если Значение = Неопределено Тогда
		ИдентификаторОформленияГруппыПоУмолчанию = "";
	Иначе
		Если ТипЗнч(Значение.Значение) = Тип("СправочникСсылка.граф_ОформленияЭлементовГрафа") Тогда
			ИдентификаторОформленияГруппыПоУмолчанию = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Значение.Значение, "Код");
		Иначе
			ИдентификаторОформленияГруппыПоУмолчанию = "";
		КонецЕсли;	
	КонецЕсли;
	
	ОформлениеУзлаПоУмолчанию = Новый ПараметрКомпоновкиДанных("ОформлениеУзлаПоУмолчанию");
	Значение = ТекущиеНастройки.ПараметрыДанных.НайтиЗначениеПараметра(ОформлениеУзлаПоУмолчанию);
	Если Значение = Неопределено Тогда
		ИдентификаторОформленияУзлаПоУмолчанию = "";
	Иначе
		Если ТипЗнч(Значение.Значение) = Тип("СправочникСсылка.граф_ОформленияЭлементовГрафа") Тогда
			ИдентификаторОформленияУзлаПоУмолчанию = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Значение.Значение, "Код");
		Иначе
			ИдентификаторОформленияУзлаПоУмолчанию = "";
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура УстановитьПараметрыСКД(Настройка)
	
	Если ТипЗнч(ПараметрыИсточникаДанных) <> Тип("ФиксированнаяСтруктура") Тогда
		Возврат;
	КонецЕсли;	
	ПараметрыДанныхСКД = Настройка.ПараметрыДанных.Элементы;
	
	Для каждого ПараметрСКД Из ПараметрыИсточникаДанных Цикл
		ПараметрРегистраторы = ПараметрыДанныхСКД.Найти(ПараметрСКД.НаименованиеПараметра);
		ПараметрРегистраторы.Значение = ПараметрСКД.ЗначениеПараметра;
	КонецЦикла;	
		
КонецПроцедуры


#КонецОбласти

#Область ВыводГрафа
&НаСервере
Процедура СформироватьГрафНаСервере()
	ДеревоДанных = СКДВДеревоЗначений(ИсточникДанных);
	НазначениеКолонок = НазначениеКолонок(ДеревоДанных);   
	УзлыГрафа = НовыйПустойГрафУзлов();
	ЗаполнитьДанныеДляГрафа(УзлыГрафа, ДеревоДанных.Строки, НазначениеКолонок);
	//ОписаниеГрафа = ОписаниеГрафаНаЯзыкеDOT(УзлыГрафа, СвязиУзлов);
	//ОписаниеDOT.УстановитьТекст(ОписаниеГрафа);
	//ОпределитьКоординатыУзлов(УзлыГрафа);
	ЗначениеВДанныеФормы(УзлыГрафа, Узлы);
КонецПроцедуры

&НаКлиенте
Процедура ВывестиГраф(СохраненныйГраф = Неопределено)
	БиблиотекаG6 = граф_БиблиотекаG6Клиент.ТекстПодключенияВHTML();
	ШаблонТекстаСтраницы = СтрЗаменить(КешированныйШаблонТекстаСтраницы,
			"// библиотека G6",
			БиблиотекаG6);
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//инициализация графа", КешированныйСкриптИнициализации);
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//данные графа", ТекстДляВыводаГрафа(СохраненныйГраф));
	
	
	РезультатВывода = ШаблонТекстаСтраницы + УникальныйКомментарий(); // для перерисовки страницы даже если ничего не поменялось
КонецПроцедуры


&НаКлиенте
Функция УникальныйКомментарий()
	Шаблон = "<!-- %1 -->";
	Возврат СтрШаблон(Шаблон, ТекущаяУниверсальнаяДатаВМиллисекундах());
КонецФункции

&НаСервере
Функция ТекстДляВыводаГрафа(СохраненныйГраф)
	Если ЗначениеЗаполнено(СохраненныйГраф) Тогда
		ДанныеГрафа = Справочники.граф_СохраненныеГрафы.СохраненныеДанныеГрафа(СохраненныйГраф);
		Результат = "const data = " + ДанныеГрафа;
	Иначе
		ШаблонТекста = "%1
					   |%2";
		ОписаниеРегистрацииНовыхТипов = ОписаниеРегистрацииНовыхТипов();
		КешОформлений =  КешОформлений();
		ОписаниеГрафаJSON = ОписаниеГрафаJSON();
		Результат = СтрШаблон(ШаблонТекста, ОписаниеРегистрацииНовыхТипов, ОписаниеГрафаJSON);
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаСервере
Функция ОписаниеГрафаJSON()
	ДанныеГрафа = Новый Структура;                     
	ДанныеГрафа.Вставить("combos", ОписаниеГруппJSON());
	ДанныеГрафа.Вставить("nodes", ОписаниеУзловJSON());
	ДанныеГрафа.Вставить("edges", ОписаниеРеберJSON()); 
	Результат = "const data = " + СериализоватьВJSON(ДанныеГрафа);
	Возврат Результат;
КонецФункции

&НаСервере
Функция ОписаниеУзловJSON()
	Результат = Новый Массив;    
	УзлыГрафа = РеквизитФормыВЗначение("Узлы");
	ДобавитьВМассивРекурсивноУзлы(Результат, УзлыГрафа.Строки);
	Возврат Результат;		
КонецФункции   
 
&НаСервере
Функция ОписаниеГруппJSON()
	Результат = Новый Массив;    
	УзлыГрафа = РеквизитФормыВЗначение("Узлы");
	ДобавитьВМассивРекурсивноГруппы(Результат, УзлыГрафа.Строки);
	Возврат Результат;		
КонецФункции

&НаСервере
Процедура ДобавитьВМассивРекурсивноУзлы(Результат, Строки)
	Для каждого Строка Из  Строки Цикл
		 Если Строка.Строки.Количество() = 0  Тогда
		 	 Результат.Добавить(ОписаниеУзла(Строка));
		 Иначе
			ДобавитьВМассивРекурсивноУзлы(Результат, Строка.Строки); 
		 КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВМассивРекурсивноГруппы(Результат, Строки)
	Для каждого Строка Из  Строки Цикл
		 Если Строка.Строки.Количество() > 0  Тогда
		 	 Результат.Добавить(ОписаниеГруппы(Строка));
		     ДобавитьВМассивРекурсивноГруппы(Результат, Строка.Строки); 
		 КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Функция СериализоватьВJSON(Значение)
	ЗаписьJSON = Новый ЗаписьJSON;
    ЗаписьJSON.УстановитьСтроку();
    ЗаписатьJSON(ЗаписьJSON, Значение);
    Возврат ЗаписьJSON.Закрыть();
КонецФункции

&НаСервере
Функция ДеСериализоватьИзJSON(Текст)
	ЧтениеJSON = Новый ЧтениеJSON;
    ЧтениеJSON.УстановитьСтроку(Текст);
    Результат = ПрочитатьJSON(ЧтениеJSON);
    ЧтениеJSON.Закрыть();
    Возврат Результат;
КонецФункции

&НаСервере
Функция ОписаниеУзла(Строка) 
	масштаб = 100;
	Результат = Новый Структура;
	Результат.Вставить("id", Строка.Идентификатор);
	Результат.Вставить("x", Строка.X * масштаб);
	Результат.Вставить("y", Строка.Y * масштаб); 
	Если ЗначениеЗаполнено(Строка.Заголовок) Тогда
		Результат.Вставить("label", Строка.Заголовок);  
	Иначе
		Результат.Вставить("label", Строка.Идентификатор);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Строка.Родитель) Тогда
		Результат.Вставить("comboId", Строка.Родитель.Идентификатор); 	
	КонецЕсли;
	
	СвойстваОформления = КешОформлений.Получить(Строка.КодОформленияЭлемента);
	Если СвойстваОформления <> Неопределено Тогда
		ДобавитьСвойстваОформления(Результат, СвойстваОформления);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции  

&НаСервере
Функция ОписаниеГруппы(Строка) 
	Результат = Новый Структура;
	Результат.Вставить("id", Строка.Идентификатор);
	Если ЗначениеЗаполнено(Строка.Заголовок) Тогда
		Результат.Вставить("label", Строка.Заголовок);  
	Иначе
		Результат.Вставить("label", Строка.Идентификатор);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Строка.Родитель) Тогда
		Результат.Вставить("parentId", Строка.Родитель.Идентификатор); 	
	КонецЕсли;
	
	СвойстваОформления = КешОформлений.Получить(Строка.КодОформленияЭлемента);
	Если СвойстваОформления <> Неопределено Тогда
		ДобавитьСвойстваОформления(Результат, СвойстваОформления);
	КонецЕсли;

	Возврат Результат;
КонецФункции

&НаСервере
Процедура ДобавитьСвойстваОформления(Результат, СвойстваОформления)
	Результат.Вставить("type", СвойстваОформления.ТипОформления); 	
	ТекстВСкобках = граф_РаботаСТекстомКлиентСервер.ТекстСоСкобками(СвойстваОформления.ОписаниеJSON);
	СвойстваОбъект = ДеСериализоватьИзJSON(ТекстВСкобках);
	Для каждого КлючИЗначение из СвойстваОбъект Цикл
		Результат.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ОписаниеРеберJSON() 
	Результат = Новый Массив;
	Для каждого Строка Из СвязиУзлов Цикл
		Результат.Добавить(ОписаниеРебра(Строка));  
	КонецЦикла;	
	Возврат Результат;
КонецФункции

&НаСервере
Функция ОписаниеРебра(Строка) 
	Результат = Новый Структура;
	Результат.Вставить("source", Строка.УзелНачала);
	Результат.Вставить("target", Строка.УзелКонца);
	Результат.Вставить("label", МассивЗаголовков(Строка.Заголовок));
	СвойстваОформления = КешОформлений.Получить(Строка.КодОформленияЭлемента);
	Если СвойстваОформления <> Неопределено Тогда
		ДобавитьСвойстваОформления(Результат, СвойстваОформления);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаСервере
Функция МассивЗаголовков(Строка)
	Результат = СтрРазделить(Строка, ";", Ложь);
	Возврат Результат;
КонецФункции

&НаСервере
Функция ОписаниеРегистрацииНовыхТипов() 
	ПользовательскиеТипы = ПользовательскиеТипыВГрафе(); 
	ТекстРегистрации = Справочники.граф_ТипыОформленийЭлементовГрафов.ТекстРегистрацииРасширяемыхТипов(ПользовательскиеТипы);
	Возврат ТекстРегистрации;
КонецФункции

&НаСервере
Функция ПользовательскиеТипыВГрафе()
	ВсеСтрокиДерева = Новый Массив;
	СтрокиДереваРекурсивно(Узлы, ВсеСтрокиДерева);
    СтрокиТаблицы(СвязиУзлов, ВсеСтрокиДерева);	
	ВсеКодыЭлементов = ОбщегоНазначения.ВыгрузитьКолонку(ВсеСтрокиДерева, "КодОформленияЭлемента");
	ТолькоПользовательскиеТипы = ТолькоПользовательскиеТипы(ВсеКодыЭлементов);
	Возврат ТолькоПользовательскиеТипы;
КонецФункции

&НаСервере
Функция ТолькоПользовательскиеТипы(ВсеКодыЭлементов)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	граф_ЭлементыГрафов.ТипОформления как ТипОформления
		|ИЗ
		|	Справочник.граф_ОформленияЭлементовГрафа КАК граф_ЭлементыГрафов
		|ГДЕ
		|	граф_ЭлементыГрафов.Предопределенный = ЛОЖЬ
		|	И граф_ЭлементыГрафов.Код В (&Код)";
	
	Запрос.УстановитьПараметр("Код", ВсеКодыЭлементов);
	
	Результат =  Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ТипОформления");
	Возврат Результат;
			
КонецФункции

&НаСервере
Процедура СтрокиДереваРекурсивно(ТекущийУзел, ВсеСтрокиДерева)
	Для каждого Строка из ТекущийУзел.ПолучитьЭлементы() Цикл
		ВсеСтрокиДерева.Добавить(Строка);
		СтрокиДереваРекурсивно(Строка, ВсеСтрокиДерева);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СтрокиТаблицы(Таблица, ВсеСтрокиДерева)
	Для каждого Строка из Таблица Цикл
		ВсеСтрокиДерева.Добавить(Строка);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция КешОформлений()
	Результат = Новый Соответствие;
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	граф_ОформленияЭлементовГрафа.Код,
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
		Результат.Вставить(ВыборкаДетальныеЗаписи.Код, СвойстваОформления);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область ЗагрузкаВыгрузкаДанныхГрафа
&НаКлиенте
Процедура ПослеВыбораЭлементаСохранения(ВыбранныйЭлемент, Параметры) Экспорт
    Если ВыбранныйЭлемент = Неопределено Тогда
        Возврат;
    КонецЕсли;
    ОбъектHTML = Элементы.РезультатВывода.Document.DefaultView;
    ДанныеГрафа = ОбъектHTML.SavedGraph();
    ЗаписатьДанныеГрафа(ВыбранныйЭлемент, ДанныеГрафа);
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеГрафа(ВыбранныйЭлемент, ДанныеГрафа)
	Справочники.граф_СохраненныеГрафы.ЗаписатьДанные(ВыбранныйЭлемент, ДанныеГрафа);
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораЭлементаЗагрузки(ВыбранныйЭлемент, Параметры) Экспорт
    Если ВыбранныйЭлемент = Неопределено Тогда
        Возврат;
    КонецЕсли;
    ОбъектHTML = Элементы.РезультатВывода.Document.DefaultView;
    ДанныеГрафа = СохраненныеДанныеГрафа(ВыбранныйЭлемент); 
    ОбъектHTML.GraphFromJSON(ДанныеГрафа);
КонецПроцедуры

&НаСервере
Функция СохраненныеДанныеГрафа(ВыбранныйЭлемент)
	Возврат Справочники.граф_СохраненныеГрафы.СохраненныеДанныеГрафа(ВыбранныйЭлемент);
КонецФункции


#КонецОбласти

#КонецОбласти
