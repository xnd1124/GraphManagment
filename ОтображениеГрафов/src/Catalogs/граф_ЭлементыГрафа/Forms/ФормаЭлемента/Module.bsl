#Область ОписаниеПеременных
&НаКлиенте
Перем EditorJSON;
#КонецОбласти

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	КешированныйШаблонТекстаСтраницы = ПолучитьОбщийМакет("граф_ШаблонHTML").ПолучитьТекст();
	КешированныйТекстБиблиотека = ПолучитьОбщийМакет("граф_БиблиотекаG6Версия4").ПолучитьТекст();
	КешированныйСкриптИнициализации = ПолучитьОбщийМакет("граф_СкриптИнициализацииГрафа").ПолучитьТекст();
	ЗакешироватьТекстТипаЭлемента();
	JSONHTML = УстановитьJSONEditor();
КонецПроцедуры
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СформироватьКодДляПросмотраЭлемента();
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура КодПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда
		Объект.Наименование = Объект.Код;
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура ТипЭлементаПриИзменении(Элемент)
	ЗакешироватьТекстТипаЭлемента();
	СформироватьКодДляПросмотраЭлемента();
КонецПроцедуры
&НаКлиенте
Процедура JSONHTMLДокументСформирован(Элемент)
	EditorJSON = Элементы.JSONHTML.Документ.defaultView.Init();
	EditorJSON.setText(Объект.ОписаниеЭлементаJSON);
	
	ТекущийЭлемент = Элементы.JSONHTML;

	EditorJSON.focus();
КонецПроцедуры
&НаКлиенте
Процедура JSONHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	Если НЕ ПолучитьЗначениеКоллекции(ДанныеСобытия, "Button.id")="onChange" Тогда
		Возврат;
	КонецЕсли;	
		
	Объект.ОписаниеЭлементаJSON = editorJSON.getText();
	СформироватьКодДляПросмотраЭлемента();
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Функция УстановитьJSONEditor() 
	РабочийКаталог = КаталогПрограммы(); 
	КаталогКомпоненты = "JSONEditor";
	КаталогНаДиске = Новый Файл(РабочийКаталог + КаталогКомпоненты);
	Если НЕ КаталогНаДиске.Существует() Тогда
		Чтение =  Новый ЧтениеДанных(Справочники.граф_ЭлементыГрафа.ПолучитьМакет("JSONEditor"));
		Файл = Новый ЧтениеZipФайла(Чтение.ИсходныйПоток());
		Файл.ИзвлечьВсе(РабочийКаталог + КаталогКомпоненты);
	КонецЕсли;
	Возврат РабочийКаталог + КаталогКомпоненты + "\index.html";
КонецФункции
&НаСервере
Процедура ЗакешироватьТекстТипаЭлемента()
	Если Объект.ТипЭлемента = Перечисления.граф_ТипЭлементаГрафа.Ребро Тогда
		КешированныйТекстТипаЭлемента = Справочники.граф_ЭлементыГрафа.ПолучитьМакет("ШаблонРеброПоУмолчанию").ПолучитьТекст();
	ИначеЕсли Объект.ТипЭлемента = Перечисления.граф_ТипЭлементаГрафа.Вершина Тогда
		КешированныйТекстТипаЭлемента = Справочники.граф_ЭлементыГрафа.ПолучитьМакет("ШаблонВершинаПоУмолчанию").ПолучитьТекст();
	ИначеЕсли Объект.ТипЭлемента = Перечисления.граф_ТипЭлементаГрафа.Контейнер Тогда
		КешированныйТекстТипаЭлемента = Справочники.граф_ЭлементыГрафа.ПолучитьМакет("ШаблонКонтейнерПоУмолчанию").ПолучитьТекст();	
	Иначе
		ВызватьИсключение "Некорректный тип элемента";
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура СформироватьКодДляПросмотраЭлемента()
	ШаблонТекстаСтраницы = СтрЗаменить(КешированныйШаблонТекстаСтраницы, "//содержимое библиотеки", КешированныйТекстБиблиотека);
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//инициализация графа", КешированныйСкриптИнициализации);
	СвойстваОбъекта = СвойстваИзJSON(Объект.ОписаниеЭлементаJSON);
	ОписаниеОбъекта = СтрЗаменить(КешированныйТекстТипаЭлемента,"//свойства объекта", СвойстваОбъекта);
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//данные графа", ОписаниеОбъекта);
	ВнешнийВид = ШаблонТекстаСтраницы;
КонецПроцедуры
&НаКлиенте
Функция СвойстваИзJSON(Текст)
	ПозицияПервойСкобки = СтрНайти(Текст, "{", , ,1);
	ПозицияПоследнейСкобки = СтрНайти(Текст, "}", НаправлениеПоиска.СКонца, ,1);
	Если ПозицияПервойСкобки = 0 ИЛИ ПозицияПоследнейСкобки =0 Тогда
		Возврат Текст;
	КонецЕслИ;
	Результат = Сред(Текст, ПозицияПервойСкобки + 1, ПозицияПоследнейСкобки - ПозицияПервойСкобки - 1);
	Возврат Результат;
КонецФункции


&НаКлиенте
Функция ПолучитьЗначениеКоллекции(Знач Коллекция, Знач ИмяСвойства, ЗначениеПоУмолчанию=Неопределено, МягкийРежим=Истина)
	
	Если (ТипЗнч(Коллекция)=Тип("Число") ИЛИ ТипЗнч(Коллекция)=Тип("Строка") ИЛИ ТипЗнч(Коллекция)=Тип("Булево") ИЛИ ТипЗнч(Коллекция)=Тип("Дата")) Тогда
		
		Если МягкийРежим И ЗначениеЗаполнено(Коллекция) Тогда
			Возврат Коллекция;	
		Иначе
			Возврат ЗначениеПоУмолчанию;
		КонецЕсли;	
		
	КонецЕсли;
	
	Результат = ПолучитьКоллекциюПоСвойству(Коллекция, ИмяСвойства, ЗначениеПоУмолчанию);
	
	Возврат ПолучитьЗначениеКоллекцииБезВложенности(Результат.Коллекция, Результат.ИмяСвойства, ЗначениеПоУмолчанию);
		
КонецФункции
&НаКлиенте
Функция ПолучитьЗначениеКоллекцииБезВложенности(Знач Коллекция, ИмяСвойства, ЗначениеПоУмолчанию=Неопределено) экспорт
	
	Если (ТипЗнч(Коллекция)=Тип("Структура") ИЛИ ТипЗнч(Коллекция)=Тип("ФиксированнаяСтруктура")) И НЕ ПустаяСтрока(ИмяСвойства) Тогда
		
		Попытка
			Если Коллекция.Свойство(ИмяСвойства)  И ( ЗначениеЗаполнено(Коллекция[ИмяСвойства]) ИЛИ ЗначениеПоУмолчанию=Неопределено)  Тогда			
				Возврат Коллекция[ИмяСвойства];
			КонецЕсли;
		Исключение
			Возврат  ЗначениеПоУмолчанию;
		КонецПопытки;
		
	ИначеЕсли ТипЗнч(Коллекция)=Тип("ВнешнийОбъект") Тогда
		
		Попытка
			Возврат Коллекция[ИмяСвойства];
		Исключение
			Возврат ЗначениеПоУмолчанию; 
		КонецПопытки;	
				
	ИначеЕсли ТипЗнч(Коллекция)=Тип("ДанныеФормыЭлементДерева") И НЕ ПустаяСтрока(ИмяСвойства) Тогда
		
		Если Коллекция.Свойство(ИмяСвойства)  И (ЗначениеЗаполнено(Коллекция[ИмяСвойства]) ИЛИ ЗначениеПоУмолчанию=Неопределено)  Тогда			
			Возврат Коллекция[ИмяСвойства];
		КонецЕсли;
	ИначеЕсли ТипЗнч(Коллекция)=Тип("Соответствие") И (ЗначениеЗаполнено(Коллекция.Получить(ИмяСвойства)) ИЛИ ЗначениеПоУмолчанию=Неопределено)   Тогда
		Возврат Коллекция.Получить(ИмяСвойства);
	КонецЕсли;
	
	Возврат ЗначениеПоУмолчанию;
КонецФункции
&НаКлиенте
Функция ПолучитьКоллекциюПоСвойству(Коллекция, Знач ИмяСвойства, ЗначениеПоУмолчанию=Неопределено) экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Коллекция",		Коллекция);
	Результат.Вставить("ИмяСвойства",	ИмяСвойства);
	
	Если НЕ ТипЗнч(ИмяСвойства)=Тип("Строка") Тогда
		Возврат Результат;
	КонецЕсли;
			
	МассивСвойств = СтрРазделить(ИмяСвойства, ".");	
	
	Если МассивСвойств.Количество()=1 Тогда		
		Возврат Результат;
	КонецЕсли;
	
	
	Для Ном=0 По МассивСвойств.Количество()-2 Цикл				
		Результат.Вставить("Коллекция",	ПолучитьЗначениеКоллекцииБезВложенности(Результат.Коллекция, СокрЛП(МассивСвойств[Ном]), ЗначениеПоУмолчанию));
	КонецЦикла;		
	
	Результат.Вставить("ИмяСвойства",	СокрЛП(МассивСвойств[Ном])); 
		
	Возврат Результат;

КонецФункции	
#КонецОбласти
