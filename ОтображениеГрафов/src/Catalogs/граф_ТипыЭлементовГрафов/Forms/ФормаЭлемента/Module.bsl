
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
Процедура ОписаниеЭлементаJSПриИзменении(Элемент)
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
КонецПроцедуры

&НаСервере
Процедура НастроитьВнешнийВидФормы()
	Если Объект.Предопределенный Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры

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

&НаКлиенте
Процедура СформироватьКодДляПросмотраЭлемента()
		
	ШаблонТекстаСтраницы = СтрЗаменить(КешированныйШаблонТекстаСтраницы, "//инициализация графа", КешированныйСкриптИнициализации);
	
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//данные графа", КешированныйТекстТипаЭлемента);
	
	Если ЗначениеЗаполнено(Объект.ОписаниеЭлементаJS) Тогда
		ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "// регистрация типа элемента", Объект.ОписаниеЭлементаJS);
	КонецЕсли;
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//тип объекта", Объект.Код);
	
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//содержимое библиотеки",
		КешированныйТекстБиблиотека);
		
	ВнешнийВид = ШаблонТекстаСтраницы;
	
КонецПроцедуры

&НаСервере
Процедура ТипЭлементаПриИзмененииНаСервере()
	ЗакешироватьТекстТипаЭлемента();
КонецПроцедуры



#КонецОбласти

