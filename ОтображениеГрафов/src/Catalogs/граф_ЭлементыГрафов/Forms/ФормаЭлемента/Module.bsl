#Область ОписаниеПеременных
&НаКлиенте
Перем EditorJSON;
#КонецОбласти

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗакешироватьДанныеССервера();
	НастроитьВнешнийВидФормы();
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
	ТипЭлементаПриИзмененииНаСервере();
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
	Если Не ПолучитьЗначениеКоллекции(ДанныеСобытия, "Button.id") = "onChange" Тогда
		Возврат;
	КонецЕсли;

	Объект.ОписаниеЭлементаJS = editorJSON.getText();
	СформироватьКодДляПросмотраЭлемента();
КонецПроцедуры

&НаКлиенте
Процедура РасширяемыйЭлементПриИзменении(Элемент)
	ЗакешироватьРасширяемыйТип();
	СформироватьКодДляПросмотраЭлемента();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ЗакешироватьДанныеССервера()
	КешированныйШаблонТекстаСтраницы = ПолучитьОбщийМакет("граф_ШаблонHTML").ПолучитьТекст();
	КешированныйТекстБиблиотека = ПолучитьОбщийМакет("граф_БиблиотекаG6Версия4").ПолучитьТекст();
	КешированныйСкриптИнициализации = ПолучитьОбщийМакет("граф_СкриптИнициализацииГрафа").ПолучитьТекст();
	ЗакешироватьТекстТипаЭлемента();
	ЗакешироватьРасширяемыйТип();
КонецПроцедуры

&НаСервере
Процедура НастроитьВнешнийВидФормы()
	Если Объект.Предопределенный Тогда
		ТолькоПросмотр = Истина;
		Элементы.JSONHTML.ТолькоПросмотр = Истина;
		Элементы.РасширяемыйЭлемент.АвтоОтметкаНезаполненного = Ложь;	
	иначе
		JSONHTML = УстановитьJSONEditor();	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция УстановитьJSONEditor()
	РабочийКаталог = КаталогПрограммы();
	КаталогКомпоненты = "JSONEditor";
	КаталогНаДиске = Новый Файл(РабочийКаталог + КаталогКомпоненты);
	Если Не КаталогНаДиске.Существует() Тогда
		Чтение = Новый ЧтениеДанных(Справочники.граф_ТипыЭлементовГрафов.ПолучитьМакет("JSONEditor"));
		Файл = Новый ЧтениеZipФайла(Чтение.ИсходныйПоток());
		Файл.ИзвлечьВсе(РабочийКаталог + КаталогКомпоненты);
	КонецЕсли;
	Возврат РабочийКаталог + КаталогКомпоненты + "\index.html";
КонецФункции

&НаСервере
Процедура ЗакешироватьТекстТипаЭлемента()
	МестоМакетов = Справочники.граф_ТипыЭлементовГрафов;
	Если Объект.ТипЭлемента = Перечисления.граф_СоставляющиеГрафа.Ребро Тогда
		КешированныйТекстТипаЭлемента = МестоМакетов.ПолучитьМакет("ШаблонРеброПоУмолчанию").ПолучитьТекст();
	ИначеЕсли Объект.ТипЭлемента = Перечисления.граф_СоставляющиеГрафа.Вершина Тогда
		КешированныйТекстТипаЭлемента = МестоМакетов.ПолучитьМакет("ШаблонВершинаПоУмолчанию").ПолучитьТекст();
	ИначеЕсли Объект.ТипЭлемента = Перечисления.граф_СоставляющиеГрафа.Контейнер Тогда
		КешированныйТекстТипаЭлемента = МестоМакетов.ПолучитьМакет("ШаблонКонтейнерПоУмолчанию").ПолучитьТекст();
	Иначе
		ВызватьИсключение "Некорректный тип элемента";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗакешироватьРасширяемыйТип()
	Если ЗначениеЗаполнено(Объект.РасширяемыйЭлемент) Тогда
		КешированныйТипОбъекта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РасширяемыйЭлемент, "Код");
	иначе
		КешированныйТипОбъекта = Объект.Код;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьКодДляПросмотраЭлемента()
	ШаблонТекстаСтраницы = СтрЗаменить(КешированныйШаблонТекстаСтраницы, "//содержимое библиотеки",
		КешированныйТекстБиблиотека);
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//инициализация графа", КешированныйСкриптИнициализации);
	СвойстваОбъекта = СвойстваИзJSON(Объект.ОписаниеЭлементаJSON);
	РегистрацияВложенныхТипов = РегистрацияВложенныхТипов();
	ОписаниеОбъекта = СтрЗаменить(КешированныйТекстТипаЭлемента, "//свойства объекта", СвойстваОбъекта);
	
	Если ЗначениеЗаполнено(РегистрацияВложенныхТипов) Тогда
		ОписаниеОбъекта = РегистрацияВложенныхТипов + Символы.ПС + ОписаниеОбъекта;
	КонецЕсли;
	
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//данные графа", ОписаниеОбъекта);
	ВнешнийВид = ШаблонТекстаСтраницы;
КонецПроцедуры

&НаСервере
Функция РегистрацияВложенныхТипов()
	РасширяемыеТипы = Новый Массив;
	РасширяемыеТипы.Добавить(Объект.РасширяемыйЭлемент);
	Возврат Справочники.граф_ТипыЭлементовГрафов.ТекстРегистрацииРасширяемыхТипов(РасширяемыеТипы);
КонецФункции

&НаКлиенте
Функция СвойстваБезТипа(Текст)
	ПозицияПервойСкобки = СтрНайти(Текст, "{", , , 1);
	ПозицияПоследнейСкобки = СтрНайти(Текст, "}", НаправлениеПоиска.СКонца, , 1);
	Если ПозицияПервойСкобки = 0 Или ПозицияПоследнейСкобки = 0 Тогда
		Результат = "";
	Иначе
		Результат = Сред(Текст, ПозицияПервойСкобки + 1, ПозицияПоследнейСкобки - ПозицияПервойСкобки - 1);	
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция СвойствоТип()
	ШабонРезультата = "type: ""%1"",";
	Возврат СтрШаблон(ШабонРезультата, КешированныйТипОбъекта);
КонецФункции

&НаКлиенте
Функция СвойстваИзJSON(Текст)
	СвойстваБезТипа = СвойстваБезТипа(Текст);
	СвойствоТип = СвойствоТип(); 
	ШабонРезультата = "%1
		|%2";
	Возврат СтрШаблон(ШабонРезультата, СвойствоТип, СвойстваБезТипа);
КонецФункции

&НаКлиенте
Функция ПолучитьЗначениеКоллекции(Знач Коллекция, Знач ИмяСвойства, ЗначениеПоУмолчанию = Неопределено,
	МягкийРежим = Истина)

	ЭтоПримитивныеТипы = (ТипЗнч(Коллекция) = Тип("Число") Или ТипЗнч(Коллекция) = Тип("Строка") Или ТипЗнч(Коллекция)
		= Тип("Булево") Или ТипЗнч(Коллекция) = Тип("Дата"));
	Если ЭтоПримитивныеТипы Тогда
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
Функция ПолучитьЗначениеКоллекцииБезВложенности(Знач Коллекция, ИмяСвойства, ЗначениеПоУмолчанию = Неопределено)
	ТипКоллекции = ТипЗнч(Коллекция);
	ЭтоСтруктурныйТипСоСвойством = (ТипКоллекции = Тип("Структура") Или ТипКоллекции = Тип("ФиксированнаяСтруктура")
		Или ТипКоллекции = Тип("ДанныеФормыЭлементДерева")) И ЗначениеЗаполнено(ИмяСвойства) И Коллекция.Свойство(
		ИмяСвойства);
	Если ЭтоСтруктурныйТипСоСвойством Тогда
		Возврат Коллекция[ИмяСвойства];
	ИначеЕсли ТипЗнч(Коллекция) = Тип("ВнешнийОбъект") Тогда
		Попытка
			Возврат Коллекция[ИмяСвойства];
		Исключение
			Возврат ЗначениеПоУмолчанию;
		КонецПопытки;
	ИначеЕсли ТипЗнч(Коллекция) = Тип("Соответствие") Тогда
		Возврат Коллекция.Получить(ИмяСвойства);
	Иначе
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция ПолучитьКоллекциюПоСвойству(Коллекция, Знач ИмяСвойства, ЗначениеПоУмолчанию = Неопределено) Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Коллекция", Коллекция);
	Результат.Вставить("ИмяСвойства", ИмяСвойства);

	Если Не ТипЗнч(ИмяСвойства) = Тип("Строка") Тогда
		Возврат Результат;
	КонецЕсли;

	МассивСвойств = СтрРазделить(ИмяСвойства, ".");

	Если МассивСвойств.Количество() = 1 Тогда
		Возврат Результат;
	КонецЕсли;

	Для Ном = 0 По МассивСвойств.Количество() - 2 Цикл
		Результат.Вставить("Коллекция", ПолучитьЗначениеКоллекцииБезВложенности(Результат.Коллекция, СокрЛП(
			МассивСвойств[Ном]), ЗначениеПоУмолчанию));
	КонецЦикла;

	Результат.Вставить("ИмяСвойства", СокрЛП(МассивСвойств[Ном]));

	Возврат Результат;

КонецФункции

&НаСервере
Процедура ТипЭлементаПриИзмененииНаСервере()
	УстановитьРасширяемыйЭлемент();
	ЗакешироватьТекстТипаЭлемента();
КонецПроцедуры

&НаСервере
Процедура УстановитьРасширяемыйЭлемент()
	Если ЗначениеЗаполнено(Объект.РасширяемыйЭлемент) 
		ИЛИ Объект.Предопределенный Тогда
		Возврат;
	КонецЕсли;
	Если Объект.ТипЭлемента = Перечисления.граф_СоставляющиеГрафа.Вершина Тогда
		Объект.РасширяемыйЭлемент = Справочники.граф_ТипыЭлементовГрафов.rect;
	ИначеЕсли Объект.ТипЭлемента = Перечисления.граф_СоставляющиеГрафа.Ребро Тогда
		Объект.РасширяемыйЭлемент = Справочники.граф_ТипыЭлементовГрафов.line;
	ИначеЕсли Объект.ТипЭлемента = Перечисления.граф_СоставляющиеГрафа.Контейнер Тогда
		Объект.РасширяемыйЭлемент = Справочники.граф_ТипыЭлементовГрафов.сombo_rect;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

