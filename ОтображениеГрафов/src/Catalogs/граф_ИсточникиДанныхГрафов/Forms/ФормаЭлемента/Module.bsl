#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НастроитьСКД();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Не ЗначениеЗаполнено(ТекущийОбъект.ИмяШаблонаСКД) Тогда

		Если Не ПустаяСтрока(АдресСхемыКомпоновкиДанных) Тогда
			ТекущийОбъект.ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(
				АдресСхемыКомпоновкиДанных));
		КонецЕсли;
	Иначе
		ТекущийОбъект.ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;

	Если Не ПустаяСтрока(АдресНастроекКомпоновкиДанных) Тогда
		ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(
			АдресНастроекКомпоновкиДанных));
	Иначе
		ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ИмяШаблонаСКДПриИзменении(Элемент)
	ИмяШаблонаСКДПриИзмененииНаСервере();
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Редактировать(Команда)
	ЗаголовокФормы = "Настройка компоновки данных источника графов";
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НеПомещатьНастройкиВСхемуКомпоновкиДанных", Истина);
	ПараметрыФормы.Вставить("НеРедактироватьСхемуКомпоновкиДанных", Ложь);
	ПараметрыФормы.Вставить("НеНастраиватьУсловноеОформление", Истина);
	ПараметрыФормы.Вставить("НеНастраиватьВыбор", Истина);
	ПараметрыФормы.Вставить("НеНастраиватьПорядок", Ложь);
	ПараметрыФормы.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыФормы.Вставить("АдресСхемыКомпоновкиДанных", АдресСхемыКомпоновкиДанных);
	ПараметрыФормы.Вставить("АдресНастроекКомпоновкиДанных", АдресНастроекКомпоновкиДанных);
	ПараметрыФормы.Вставить("Заголовок", ЗаголовокФормы);
	ПараметрыФормы.Вставить("ИсточникШаблонов", Объект.Ссылка);
	ПараметрыФормы.Вставить("ИмяШаблонаСКД", Объект.ИмяШаблонаСКД);
	ПараметрыФормы.Вставить("ВозвращатьИмяТекущегоШаблонаСКД", Истина);
	
	ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных",
		ПараметрыФормы, , , , , 
		Новый ОписаниеОповещения("РедактироватьСхемуКомпоновкиДанныхЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура НастроитьСКД()
	Для Каждого Макет Из Метаданные.Справочники.граф_ИсточникиДанныхГрафов.Макеты Цикл
		Если Макет.ТипМакета <> Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			Продолжить;
		КонецЕсли;
		Элементы.ИмяШаблонаСКД.СписокВыбора.Добавить(Макет.Имя, Макет.Синоним);
	КонецЦикла;
	ПредставлениеСхемы = "Произвольная";
	Элементы.ИмяШаблонаСКД.СписокВыбора.Добавить("", ПредставлениеСхемы);
	
	Если Параметры.ЗначениеКопирования.Пустая() Тогда
		СхемаИНастройки = Справочники.граф_ИсточникиДанныхГрафов.ОписаниеИСхемаКомпоновкиДанныхГрафаПоИмениМакета(Объект.Ссылка,
			Объект.ИмяШаблонаСКД);
	Иначе
		СхемаИНастройки = Справочники.граф_ИсточникиДанныхГрафов.ОписаниеИСхемаКомпоновкиДанныхГрафаПоИмениМакета(Параметры.ЗначениеКопирования, 
			Параметры.ЗначениеКопирования.ИмяШаблонаСКД);
	КонецЕсли;
	
	Если ПустаяСтрока(СхемаИНастройки.Описание) Тогда
		Объект.ИмяШаблонаСКД = "";
	КонецЕсли;
	
	Адреса = АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище();
	
	АдресСхемыКомпоновкиДанных = Адреса.СхемаКомпоновкиДанных;
	АдресНастроекКомпоновкиДанных = Адреса.НастройкиКомпоновкиДанных;
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСхемуКомпоновкиДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	АдресаНастроек = Результат;
	
	Если ЗначениеЗаполнено(АдресаНастроек) Тогда
		Если ПустаяСтрока(АдресаНастроек.ИмяТекущегоШаблонаСКД)
			И Элементы.ИмяШаблонаСКД.СписокВыбора.НайтиПоЗначению("") = Неопределено Тогда
			ПредставлениеШаблонаСКД = "Произвольная";
			Элементы.ИмяШаблонаСКД.СписокВыбора.Добавить("", ПредставлениеШаблонаСКД);
		КонецЕсли;
		
		Объект.ИмяШаблонаСКД = АдресаНастроек.ИмяТекущегоШаблонаСКД;
		
		Если АдресаНастроек.Свойство("АдресХранилищаНастройкиКомпоновщика") Тогда
			АдресНастроекКомпоновкиДанных = АдресаНастроек.АдресХранилищаНастройкиКомпоновщика;
		КонецЕсли;
	
	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура ИмяШаблонаСКДПриИзмененииНаСервере()
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(
		Справочники.граф_ИсточникиДанныхГрафов.ПолучитьМакет(Объект.ИмяШаблонаСКД), Новый УникальныйИдентификатор());
	АдресНастроекКомпоновкиДанных = "";
КонецПроцедуры


&НаСервере 
Функция АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище()
	
	Возврат Справочники.граф_ИсточникиДанныхГрафов.АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище(Объект);
	
КонецФункции

#КонецОбласти
	
