#Область ОписаниеПеременных
&НаСервере
Перем КешОформлений; // соответствие для хранения оформлений элементов графа
#КонецОбласти

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	КешированныйШаблонТекстаСтраницы = ПолучитьОбщийМакет("граф_ШаблонHTML").ПолучитьТекст();
	КешированныйТекстБиблиотека = ПолучитьОбщийМакет("граф_БиблиотекаG6Версия4").ПолучитьТекст();
	КешированныйСкриптИнициализации = ПолучитьОбщийМакет("граф_СкриптИнициализацииГрафа").ПолучитьТекст();
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
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура СформироватьГрафНаСервере()
	ДеревоДанных = СКДВДеревоЗначений(ИсточникДанных);
	НазначениеКолонок = НазначениеКолонок(ДеревоДанных);   
	УзлыГрафа = НовыйПустойГрафУзлов();
	ЗаполнитьДанныеДляГрафа(УзлыГрафа, ДеревоДанных.Строки, НазначениеКолонок);
	ОписаниеГрафа = ОписаниеГрафаНаЯзыкеDOT(УзлыГрафа, СвязиУзлов);
	ОписаниеDOT.УстановитьТекст(ОписаниеГрафа);
	ОпределитьКоординатыУзлов(УзлыГрафа);
	ЗначениеВДанныеФормы(УзлыГрафа, Узлы);
КонецПроцедуры

#Область ОписаниеГрафаНаЯзыкеDot
&НаСервере
Функция ОписаниеГрафаНаЯзыкеDOT(УзлыГрафа, СвязиУзлов)
	Результат = "";  
	ДобавитьВОписаниеЗаголовокГруппы(Результат); 
	ДобавитьВОписаниеТелоГруппы(Результат, УзлыГрафа);
    ДобавитьОписаниеСвязей(Результат);
	ДобавитьВОписаниеПодвалГруппы(Результат);
	
	Возврат Результат;
КонецФункции 

&НаСервере
Процедура ДобавитьВОписаниеЗаголовокГруппы(Результат, Строка = Неопределено, ТекущийУровень = 0) 
	Если ТекущийУровень = 0 Тогда    
		Результат = "digraph G {  ";
	Иначе
		Результат = Результат + ОписаниеКластера(Строка, ТекущийУровень);	
	КонецЕсли	 
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОписаниеПодвалГруппы(Результат, ТекущийУровень = 0)   
	Результат = Результат + Символы.ПС + Отступ(ТекущийУровень) + "}"; 
КонецПроцедуры   

&НаСервере
Процедура ДобавитьВОписаниеТелоГруппы(Результат, УзлыГрафа, ТекущийУровень = 0)
	ТекущийУровень = ТекущийУровень + 1;
	Для каждого Строка Из  УзлыГрафа.Строки Цикл
		 Если Строка.Строки.Количество() > 0 Тогда
		 	ДобавитьВОписаниеЗаголовокГруппы(Результат, Строка, ТекущийУровень); 
			ДобавитьВОписаниеТелоГруппы(Результат, Строка, ТекущийУровень);
    		ДобавитьВОписаниеПодвалГруппы(Результат, ТекущийУровень); 
		Иначе
			ДобавитьОписаниеУзла(Результат, Строка, ТекущийУровень);
		 КонецЕсли;
	КонецЦикла;	
КонецПроцедуры                       

&НаСервере
Процедура ДобавитьОписаниеУзла(Результат, Строка, ТекущийУровень)
	ШаблонУзла = Символы.ПС + Отступ(ТекущийУровень) + """%1"" [shape=box]";
	Результат = Результат + СтрШаблон(ШаблонУзла, Строка.Идентификатор);	
КонецПроцедуры     

&НаСервере
Функция Отступ(ТекущийУровень)
	Возврат СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(" ", ТекущийУровень);
КонецФункции

&НаСервере
Функция ОписаниеКластера(Строка, ТекущийУровень)
	ШаблонУзла = Символы.ПС + Отступ(ТекущийУровень) + "subgraph ""cluster_%1"" {";
	Возврат  СтрШаблон(ШаблонУзла, Строка.Идентификатор);	
КонецФункции

&НаСервере
Процедура ДобавитьОписаниеСвязей(Результат)
	Результат = Результат + Символы.ПС + "// связи";
	ШаблонСвязи = """%1"" -> ""%2""";
	Для каждого Строка Из СвязиУзлов Цикл
		// для более красивого расположения если связь уже есть, поменяем порядок, это позволит более рационально разместить
		Если Строка.ВесСвязи > 0 Тогда
			Результат = Результат + Символы.ПС + СтрШаблон(ШаблонСвязи, Строка.УзелНачала, Строка.УзелКонца);
		ИначеЕсли Строка.ВесСвязи < 0 Тогда
			Результат = Результат + Символы.ПС + СтрШаблон(ШаблонСвязи, Строка.УзелКонца, Строка.УзелНачала);	
		ИначеЕсли УжеЕстьСвязьОтУзла(Результат, ШаблонСвязи,Строка.УзелНачала) 
			ИЛИ  УжеЕстьСвязьКУзлу(Результат, ШаблонСвязи,Строка.УзелКонца) Тогда
			Результат = Результат + Символы.ПС + СтрШаблон(ШаблонСвязи, Строка.УзелКонца, Строка.УзелНачала);
		Иначе 
			Результат = Результат + Символы.ПС + СтрШаблон(ШаблонСвязи, Строка.УзелНачала, Строка.УзелКонца);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция УжеЕстьСвязьОтУзла(Результат, ШаблонСвязи, УзелНачала)
	ИскомыйФрагмент = СтрШаблон(ШаблонСвязи, УзелНачала, "");
    ИскомыйФрагмент = СтрЗаменить(ИскомыйФрагмент,"""""","");	
	Возврат СтрНайти(Результат, ИскомыйФрагмент) > 0;
КонецФункции

&НаСервере
Функция УжеЕстьСвязьКУзлу(Результат, ШаблонСвязи, УзелКонца)
	ИскомыйФрагмент = СтрШаблон(ШаблонСвязи, "", УзелКонца);
    ИскомыйФрагмент = СтрЗаменить(ИскомыйФрагмент,"""""","");	
	Возврат СтрНайти(Результат, ИскомыйФрагмент) > 0;
КонецФункции


&НаСервере
Процедура ЗаполнитьРекурсивноКоординатыУзлов(ТекущиеСтроки, ОписаниеГрафа, ВысотаГрафа)
	Для каждого Строка Из ТекущиеСтроки Цикл
		Если Строка.Строки.Количество() > 0 Тогда
			 ЗаполнитьРекурсивноКоординатыУзлов(Строка.Строки, ОписаниеГрафа, ВысотаГрафа);
		 КонецЕсли;   
		 ШаблонПоиска1 = "node ""%1""";
		 ШаблонПоиска2 = "node %1 ";
		 ТекстПоиска1 = СтрШаблон(ШаблонПоиска1, Строка.Идентификатор);
		 ТекстПоиска2 = СтрШаблон(ШаблонПоиска2, Строка.Идентификатор);
		 ДлинаПоиска = СтрДлина(ТекстПоиска1);
		 НайденнаяПозиция = СтрНайти(ОписаниеГрафа, ТекстПоиска1); 
		 Если НайденнаяПозиция = 0 Тогда
		 	 НайденнаяПозиция = СтрНайти(ОписаниеГрафа, ТекстПоиска2); 
			 ДлинаПоиска = СтрДлина(ТекстПоиска2);
		 КонецЕсли;
		Если  НайденнаяПозиция > 0  Тогда
			ПозицияКонцаСтроки = СтрНайти(ОписаниеГрафа, Символы.ПС, , НайденнаяПозиция);
			СтрокаСКоординатами = Сред(ОписаниеГрафа, НайденнаяПозиция + ДлинаПоиска, ПозицияКонцаСтроки - НайденнаяПозиция);
			Координаты = СтрРазделить(СтрокаСКоординатами, " ", Ложь);
			Строка.X = Координаты[0];
			Строка.Y = ВысотаГрафа - Координаты[1];
			Строка.Длина = Координаты[2];
			Строка.Высота = Координаты[3];
		КонецЕсли; 
	КонецЦикла;	
КонецПроцедуры

#КонецОбласти

#Область РаботаGraphVis
&НаСервере
Процедура ОпределитьКоординатыУзлов(УзлыГрафа)
	УстановитьGraphViz();                         
	ПодготовитьВходнойФайл(); 
	КаталогGraphViz = КаталогGraphViz();
	Команда = КаталогGraphViz + ПолучитьРазделительПутиСервера() + "dot -Tplain -Gcharset=""utf-8"" input.dot -o output.txt";
	ЗапуститьПриложение(Команда, КаталогGraphViz, Истина);  
	ЗаполнитьКоординатыУзлов(УзлыГрафа);
КонецПроцедуры

&НаСервере
Процедура УстановитьGraphViz()
	КаталогGraphViz = КаталогGraphViz();
	Если НЕ ФайлСуществует(КаталогGraphViz) Тогда
		НачатьТранзакцию();
		СоздатьКаталог(КаталогGraphViz); 
		РаспаковатьАрхивВМакете("граф_graphviz", КаталогGraphViz);
		ЗафиксироватьТранзакцию();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция КаталогGraphViz()
	КаталогВременныхФайлов = КаталогВременныхФайлов();    
	Результат = КаталогВременныхФайлов + ПолучитьРазделительПутиСервера() + "GraphViz";	
	Возврат  Результат;
КонецФункции  

&НаСервере
Процедура ПодготовитьВходнойФайл()
	ТекстовыйФайл = Новый ТекстовыйДокумент;                    
	ТекстовыйФайл.УстановитьТекст(ОписаниеDOT.ПолучитьТекст());	 
	ПутьКФайлу = КаталогGraphViz() + ПолучитьРазделительПутиСервера() + "input.dot"; 
	ТекстовыйФайл.Записать(ПутьКФайлу, КодировкаТекста.ANSI);
КонецПроцедуры

&НаСервере
Функция ФайлСуществует(Знач Путь)
	ПроверкаФайла = Новый Файл(Путь);
	Возврат ПроверкаФайла.Существует();
КонецФункции

&НаСервере
Процедура РаспаковатьАрхивВМакете(ИмяМакета, Каталог)
	
	ИмяФайла = Каталог + ПолучитьРазделительПутиСервера() + ИмяМакета + ".zip";
	ДвоичныеДанные = ПолучитьОбщийМакет(ИмяМакета);
	ДвоичныеДанные.Записать(ИмяФайла);      	
	
	Архив = Новый ЧтениеZipФайла(ИмяФайла);
	Архив.ИзвлечьВсе(Каталог);
	УдалитьФайлы(ИмяФайла);	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКоординатыУзлов(УзлыГрафа)
	ОписаниеГрафа = ОписаниеГрафа();
	ВысотаГрафа = ВысотаГрафа(ОписаниеГрафа);
	ЗаполнитьРекурсивноКоординатыУзлов(УзлыГрафа.Строки, ОписаниеГрафа, ВысотаГрафа);	
КонецПроцедуры

&НаСервере
Функция ВысотаГрафа(ОписаниеГрафа)
	ДлинаПервойСтроки = стрНайти(ОписаниеГрафа, Символы.ПС);
	ПерваяСтрока = Лев(ОписаниеГрафа, ДлинаПервойСтроки);
	ЧастиСтроки = СтрРазделить(ПерваяСтрока, " ");
	ПозицияВысоты = 3;
	Возврат Число(ЧастиСтроки[ПозицияВысоты]);
КонецФункции


&НаСервере
Функция ОписаниеГрафа()
	ТекстовыйФайл = Новый ТекстовыйДокумент;     
	ИмяФайла = КаталогGraphViz() + ПолучитьРазделительПутиСервера() + "output.txt";
	ТекстовыйФайл.Прочитать(ИмяФайла, КодировкаТекста.ANSI);
	Возврат ТекстовыйФайл.ПолучитьТекст();
КонецФункции

#КонецОбласти

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
//
&НаСервере
Функция НазначениеКолонок(ДеревоСКД)
	Результат = Новый Структура;
	Результат.Вставить("КолонкиИдентификаторы", КолонкиСодержащие("идентификатор, связьисточник, связьприемник", ДеревоСКД));
	Результат.Вставить("КолонкиЗаголовки", КолонкиСодержащие("заголовок", ДеревоСКД));
	Результат.Вставить("КолонкаКодОформления", КолонкиСодержащие("кодОформления", ДеревоСКД, Истина));
	КолонкаСвязь = КолонкиСодержащие("этосвязь", ДеревоСКД);
	Для каждого Колонка Из КолонкаСвязь Цикл
		Результат.Вставить("КолонкаСвязи", Колонка.Ключ);	
	КонецЦикла;
	КолонкаВесСвязи = КолонкиСодержащие("ВесСвязи", ДеревоСКД);
	Для каждого Колонка Из КолонкаВесСвязи Цикл
		Результат.Вставить("КолонкаВесСвязи", Колонка.Ключ);	
	КонецЦикла;
	
	Результат.Вставить("КоличествоКолонокВсего",  ДеревоСКД.Колонки.Количество());      
	
	Если Результат.Свойство("КолонкаСвязи") = Ложь Тогда
		ВызватьИсключение "В настройках СКД не найдена группировка с колонкой ""ЭтоСвязь""";
	КонецЕсли;
	
	Если Результат.КолонкиИдентификаторы.Количество() = 0 Тогда
		ВызватьИсключение "В настройках СКД не найдено ни одной колонки, содержащей слово ""идентификатор""";
	КонецЕсли;
	
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
		Если Строка.Строки.Количество() > 0  Тогда      
			НазначенияБезТекущейКолонки = НазначенияБезТекущейКолонки(НазначениеКолонок, ДобавленныеДанные.НомерКолонки);
			ЗаполнитьДанныеДляГрафа(УзлыГрафа, Строка.Строки, НазначенияБезТекущейКолонки, ДобавленныеДанные.Идентификатор);	
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры 

&НаСервере
Функция НайтиИдентификаторИДобавитьУзел(УзлыГрафа, Строка, НазначениеКолонок, ИдентификаторРодителя) 
	Для Счетчик = 0 По НазначениеКолонок.КоличествоКолонокВсего - 1 Цикл 
		ТекЗначение = Строка[Счетчик]; 
		ТекущееЗначениеЗаполнено = ЗначениеЗаполнено(ТекЗначение);
		Если ТекущееЗначениеЗаполнено 
			И НазначениеКолонок.КолонкиИдентификаторы.Получить(Счетчик) <> Неопределено Тогда
			ДобавитьУзел(УзлыГрафа, ТекЗначение, ИдентификаторРодителя, Строка, НазначениеКолонок);  
			Результат = Новый Структура;
			Результат.Вставить("НомерКолонки", Счетчик);
			Результат.Вставить("Идентификатор", ТекЗначение);
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
Функция НазначенияБезТекущейКолонки(НазначениеКолонок, НомерКолонкиКУдалению) 
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
	Результат.Вставить("КолонкиЗаголовки", КолонкиЗаголовки);   
	Результат.Вставить("КоличествоКолонокВсего", НазначениеКолонок.КоличествоКолонокВсего); 
	Результат.Вставить("КолонкаСвязи", НазначениеКолонок.КолонкаСвязи); 
	Результат.Вставить("КолонкаКодОформления", НазначениеКолонок.КолонкаКодОформления); 
	Возврат Результат;
КонецФункции

&НаСервере
Процедура ДобавитьУзел(УзлыГрафа, Идентификатор, ИдентификаторРодителя, Строка, НазначенияКолонок)         
	Отбор = Новый Структура("Идентификатор", Идентификатор);
	НайденныеСтроки = УзлыГрафа.Строки.НайтиСтроки(Отбор, Истина);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат;// узел уже есть
	КонецЕсли;
	
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
	Если ЗначениеЗаполнено(НазначенияКолонок.КолонкаКодОформления) Тогда
		НоваяСтрока.КодОформленияЭлемента = Строка[НазначенияКолонок.КолонкаКодОформления];
	КонецЕсли;	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьСвойстваСвязи(НоваяСтрока, Строка, НазначенияКолонок)
	Если ЗначениеЗаполнено(НазначенияКолонок.КолонкаКодОформления) Тогда
		НоваяСтрока.КодОформленияЭлемента = Строка[НазначенияКолонок.КолонкаКодОформления];
	КонецЕсли;	
	Если НазначенияКолонок.Свойство("КолонкаВесСвязи") Тогда
		НоваяСтрока.ВесСвязи = Строка[НазначенияКолонок.КолонкаВесСвязи];
	КонецЕсли;	
КонецПроцедуры
#КонецОбласти

#Область РаботасСКД
&НаСервере
Функция СКДВДеревоЗначений(ИсточникДанных)
	ИмяМакета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсточникДанных, "ИмяШаблонаСКД");
	СхемаиНастройка = Справочники.граф_ИсточникиДанныхГрафов.ОписаниеИСхемаКомпоновкиДанныхГрафаПоИмениМакета(
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
	
	Возврат Результат
КонецФункции

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
&НаКлиенте
Процедура ВывестиГраф()
	ШаблонТекстаСтраницы = СтрЗаменить(КешированныйШаблонТекстаСтраницы,
			"//содержимое библиотеки",
			КешированныйТекстБиблиотека);
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//инициализация графа", КешированныйСкриптИнициализации);
	ШаблонТекстаСтраницы = СтрЗаменить(ШаблонТекстаСтраницы, "//данные графа", ТекстДляВыводаГрафа());
	РезультатВывода = ШаблонТекстаСтраницы;
КонецПроцедуры

&НаСервере
Функция ТекстДляВыводаГрафа()
	ШаблонТекста = "%1
	|%2";
	ОписаниеРегистрацииНовыхТипов = ОписаниеРегистрацииНовыхТипов();
	КешОформлений =  КешОформлений();
	ОписаниеГрафаJSON = ОписаниеГрафаJSON();
	Результат = СтрШаблон(ШаблонТекста, ОписаниеРегистрацииНовыхТипов, ОписаниеГрафаJSON);
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
		 Иначе
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
	масштаб = 80;
	Результат = Новый Структура;
	Результат.Вставить("id", Строка.Идентификатор);
	Результат.Вставить("x", Строка.X * масштаб);
	Результат.Вставить("y", Строка.Y * масштаб); 
	Результат.Вставить("label", Строка.Идентификатор);  
	
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
	Результат.Вставить("label", Строка.Идентификатор); 
	
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
	СвойстваОформления = КешОформлений.Получить(Строка.КодОформленияЭлемента);
	Если СвойстваОформления <> Неопределено Тогда
		ДобавитьСвойстваОформления(Результат, СвойстваОформления);
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаСервере
Функция ОписаниеРегистрацииНовыхТипов() 
	ПользовательскиеТипы = ПользовательскиеТипыВГрафе(); 
	//ТекстРегистрации = Справочники.граф_ТипыОформленийЭлементовГрафов.ТекстРегистрацииРасширяемыхТипов(ПользовательскиеТипы);
	ТекстРегистрации = "";
	Возврат ТекстРегистрации;
КонецФункции

&НаСервере
Функция ПользовательскиеТипыВГрафе()
	ВсеСтрокиДерева = Новый Массив;
	СтрокиДереваРекурсивно(Узлы, ВсеСтрокиДерева);
	ВсеКодыЭлементов = ОбщегоНазначения.ВыгрузитьКолонку(ВсеСтрокиДерева, "КодОформленияЭлемента");
	ТолькоПользовательскиеТипы = ТолькоПользовательскиеТипы(ВсеКодыЭлементов);
	Возврат ТолькоПользовательскиеТипы;
КонецФункции

&НаСервере
Функция ТолькоПользовательскиеТипы(ВсеКодыЭлементов)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	граф_ЭлементыГрафов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.граф_ОформленияЭлементовГрафа КАК граф_ЭлементыГрафов
		|ГДЕ
		|	граф_ЭлементыГрафов.Предопределенный = ЛОЖЬ
		|	И граф_ЭлементыГрафов.Код В (&Код)";
	
	Запрос.УстановитьПараметр("Код", ВсеКодыЭлементов);
	
	Результат =  Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
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

#КонецОбласти
