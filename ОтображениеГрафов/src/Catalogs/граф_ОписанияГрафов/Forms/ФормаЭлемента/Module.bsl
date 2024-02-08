#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьДоступныеПоляЗапроса();
	ВосстановитьТабличныеЧасти();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.Узлы.Очистить();
	ПреобразоватьУзлыДляЗаписи(ТекущийОбъект);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыУзлы
&НаКлиенте
Процедура УзлыИдентификаторУзлаНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	НачалоВыбораПоляЗапроса(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка);
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРебра

&НаКлиенте
Процедура РебраИдентификаторИсточникаНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	НачалоВыбораПоляЗапроса(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РебраИдентификаторПриемникаНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	НачалоВыбораПоляЗапроса(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ЗаполнитьДоступныеПоляЗапроса()
	ДоступныеПоляЗапроса.Очистить();
	Если НЕ ЗначениеЗаполнено(Объект.Владелец) Тогда
		Возврат;
	КонецЕсли;	
	ТекстЗапроса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "ТекстЗапроса");
	Если НЕ ЗначениеЗаполнено(ТекстЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);   
	ПакетЗапросов = СхемаЗапроса.ПакетЗапросов[0]; 
	Колонки = пакетЗапросов.Колонки; 
	
	Для каждого Колонка Из Колонки Цикл
	 ДоступныеПоляЗапроса.Добавить(Колонка.Псевдоним, Колонка.Псевдоним);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораПоляЗапроса(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;                                                                     
	ДанныеВыбора = ДоступныеПоляЗапроса.Скопировать(); 
КонецПроцедуры

&НаСервере
Процедура ПреобразоватьУзлыДляЗаписи(ТекущийОбъект)
	ПреобразоватьУзлыТекущегоУровня(Узлы, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПреобразоватьУзлыТекущегоУровня(ТекущийУзел, ТекущийОбъект, ИдентификаторРодителя = Неопределено)
	Строки = ТекущийУзел.ПолучитьЭлементы();
	Для каждого Строка из Строки Цикл
		НоваяСтрока = ТекущийОбъект.Узлы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		НоваяСтрока.ИдентификаторСтроки = Новый УникальныйИдентификатор();
		НоваяСтрока.СтрокаРодитель = ИдентификаторРодителя;
		Если Строка.ПолучитьЭлементы().Количество() > 0 Тогда
			ПреобразоватьУзлыТекущегоУровня(Строка, ТекущийОбъект, НоваяСтрока.ИдентификаторСтроки);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ВосстановитьТабличныеЧасти()
	ВосстановитьУзлы();
КонецПроцедуры

&НаСервере
Процедура ВосстановитьУзлы()
	УзлыПоУровням = УзлыПоУровням();
	ДобавленныеСтроки = Новый Соответствие;
	Для Каждого Узел Из УзлыПоУровням Цикл
		Родитель = ДобавленныеСтроки.Получить(Узел.СтрокаРодитель);
		Если Родитель = Неопределено Тогда
			Родитель = Узлы;
		КонецЕсли;
		СтрокиУровня = Родитель.ПолучитьЭлементы();
		НоваяСтрока = СтрокиУровня.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Узел);
		ДобавленныеСтроки.Вставить(Узел.ИдентификаторСтроки, НоваяСтрока);	 
	КонецЦикла;
КонецПроцедуры	

&НаСервере
Функция УзлыПоУровням()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ссылка", Объект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	граф_ОписанияГрафовУзлы.ИдентификаторСтроки КАК Потомок,
	|	граф_ОписанияГрафовУзлы.СтрокаРодитель КАК Предок
	|ПОМЕСТИТЬ вТаблица1
	|ИЗ
	|	Справочник.граф_ОписанияГрафов.Узлы КАК граф_ОписанияГрафовУзлы
	|	ГДЕ граф_ОписанияГрафовУзлы.ССылка = &ССЫЛКА
	|	
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	граф_ОписанияГрафовУзлы.ИдентификаторСтроки,
	|	граф_ОписанияГрафовУзлы.ИдентификаторСтроки
	|ИЗ
	|	Справочник.граф_ОписанияГрафов.Узлы КАК граф_ОписанияГрафовУзлы
	|	ГДЕ граф_ОписанияГрафовУзлы.ССылка = &ССЫЛКА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Связь1.Предок КАК Предок,
	|	Связь2.Потомок КАК Потомок
	|ПОМЕСТИТЬ вТаблица2
	|ИЗ
	|	вТаблица1 КАК Связь1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ вТаблица1 КАК Связь2
	|		ПО Связь1.Потомок = Связь2.Предок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Связь1.Предок КАК Предок,
	|	Связь2.Потомок КАК Потомок
	|ПОМЕСТИТЬ вТаблица3
	|ИЗ
	|	вТаблица2 КАК Связь1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ вТаблица2 КАК Связь2
	|		ПО Связь1.Потомок = Связь2.Предок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Связь1.Предок КАК Предок,
	|	Связь2.Потомок КАК Потомок
	|ПОМЕСТИТЬ вТаблица4
	|ИЗ
	|	вТаблица3 КАК Связь1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ вТаблица3 КАК Связь2
	|		ПО Связь1.Потомок = Связь2.Предок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Связь1.Предок) КАК Уровень,
	|	Связь2.Потомок КАК Потомок
	|ПОМЕСТИТЬ втУровни
	|ИЗ
	|	вТаблица4 КАК Связь1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ вТаблица4 КАК Связь2
	|		ПО Связь1.Потомок = Связь2.Предок
	|ГДЕ
	|	Связь1.Предок <> Связь2.Потомок
	|
	|СГРУППИРОВАТЬ ПО
	|	Связь2.Потомок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	граф_ОписанияГрафовУзлы.Ссылка КАК Ссылка,
	|	граф_ОписанияГрафовУзлы.НомерСтроки КАК НомерСтроки,
	|	граф_ОписанияГрафовУзлы.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	граф_ОписанияГрафовУзлы.ИдентификаторУзла КАК ИдентификаторУзла,
	|	граф_ОписанияГрафовУзлы.Оформление КАК Оформление,
	|	граф_ОписанияГрафовУзлы.СвойстваУзла КАК СвойстваУзла,
	|	граф_ОписанияГрафовУзлы.СтрокаРодитель КАК СтрокаРодитель
	|ИЗ
	|	втУровни КАК втУровни
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.граф_ОписанияГрафов.Узлы КАК граф_ОписанияГрафовУзлы
	|		ПО втУровни.Потомок = граф_ОписанияГрафовУзлы.ИдентификаторСтроки
	|		и  граф_ОписанияГрафовУзлы.ССылка = &ССЫЛКА
	|
	|УПОРЯДОЧИТЬ ПО
	|	втУровни.Уровень";
	Результат = Запрос.Выполнить().Выгрузить();

	Возврат Результат;
КонецФункции

#КонецОбласти
