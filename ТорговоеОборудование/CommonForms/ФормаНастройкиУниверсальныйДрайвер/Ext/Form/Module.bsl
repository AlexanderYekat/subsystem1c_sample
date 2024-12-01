﻿
&НаКлиенте
Перем ОбработкаОбслуживания;

//#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЗначениеПараметров = Параметры.ПараметрыОборудования;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(Идентификатор);

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветИнфо   = ЦветаСтиля.ЦветФонаВыделенияПоля;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;
	
	Элементы.ИнтеграционныйКомпонентУстановлен.ЦветТекста = ЦветИнфо;
	
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.Драйвер);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.Версия);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.НаименованиеДрайвера);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ОписаниеДрайвера);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТипЗнч(Идентификатор) = Тип("СправочникСсылка.ТорговоеОборудование") Тогда
		ОбработкаОбслуживания = ПолучитьСерверТО().ПолучитьОбработкуОбслуживания(Идентификатор);
	КонецЕсли;
	
	ОбновитьИнформациюОДрайвере(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если ЭтаФорма.Модифицированность Тогда
		Результат = Вопрос("Данные были модфицированы. Закрыть форму?", РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		Если Результат = КодВозвратаДиалога.Нет Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	
	ВремНастройки = ПолучитьНастройки();
	
	ЭтаФорма.Модифицированность = Ложь;
	
	Закрыть(ВремНастройки);  
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройстваЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ТолькоПросмотр = Ложь;
	КоманднаяПанель.Доступность = Истина;
	
	ДополнительноеОписание = "";
	ВыходныеПараметры = РезультатВыполнения.ВыходныеПараметры;
	
	Если ТипЗнч(ВыходныеПараметры) = Тип("Массив") Тогда
		
		Если ВыходныеПараметры.Количество() >= 2 Тогда
			ДополнительноеОписание = ВыходныеПараметры[1];
		КонецЕсли;
		
		Если ВыходныеПараметры.Количество() >= 3 И НЕ ПустаяСтрока(ВыходныеПараметры[2])  Тогда
			ДемонстрационныйРежим = ВыходныеПараметры[2];
			Элементы.ГруппаДемонстрационныйРежим.Видимость = Истина;
		КонецЕсли;
		
	КонецЕсли;
		
	ТекстСообщения = ?(РезультатВыполнения.Результат,  НСтр("ru = 'Тест успешно выполнен. %ДополнительноеОписание%'"),
	                               НСтр("ru = 'Тест не пройден. %ДополнительноеОписание%'"));
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание));
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();
	
	РезультатТеста = Неопределено;
	ДемонстрационныйРежим = "";
	
	ЭтаФорма.ТолькоПросмотр = Истина;
	ЭтаФорма.КоманднаяПанель.Доступность = Ложь;
	
	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	ПараметрыУстройства = ПолучитьНастройки().ПараметрыОборудования;
	
	Если ТипЗнч(Идентификатор) = Тип("СправочникСсылка.ТорговоеОборудование") Тогда
		ОбъектДрайвера = Неопределено;
		ОбработкаОбслуживания.СоздатьОбъектДрайвера(ОбъектДрайвера, Идентификатор, ЗначениеПараметров);
		ПараметрыПодключения = Новый Структура("ТипОборудования", "ККТ");
	
		РезультатВыполнения = ПодключаемоеОборудованиеУниверсальныйДрайверКлиент.ВыполнитьКоманду("ТестУстройства",
			ВходныеПараметры, ВыходныеПараметры, ОбъектДрайвера.Драйвер, ПараметрыУстройства, ПараметрыПодключения);		
		
		ЭтаФорма.ТолькоПросмотр = Ложь;
		ЭтаФорма.КоманднаяПанель.Доступность = Истина;
	
		ДополнительноеОписание = "";
	
		Если ТипЗнч(ВыходныеПараметры) = Тип("Массив") Тогда
		
			Если ВыходныеПараметры.Количество() >= 2 Тогда
				ДополнительноеОписание = ВыходныеПараметры[1];
			КонецЕсли;
		
			Если ВыходныеПараметры.Количество() >= 3 И НЕ ПустаяСтрока(ВыходныеПараметры[2])  Тогда
				ДемонстрационныйРежим = ВыходныеПараметры[2];
				Элементы.ГруппаДемонстрационныйРежим.Видимость = Истина;
			КонецЕсли;
		
		КонецЕсли;
		
		ТекстСообщения = ?(РезультатВыполнения,  НСтр("ru = 'Тест успешно выполнен. %ДополнительноеОписание%'"),
	                               НСтр("ru = 'Тест не пройден. %ДополнительноеОписание%'"));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		Оповещение = ОписаниеОповещенияИС("ТестУстройстваЗавершение", ЭтаФорма);
		МенеджерОборудованияКлиент.НачатьВыполнениеДополнительнойКоманды(Оповещение, "CheckHealth", ВходныеПараметры, Идентификатор, ПараметрыУстройства);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайвер(Команда)
	ЗапуститьПриложение(АдресЗагрузкиДрайвера, , Ложь);
КонецПроцедуры

// Выполняет дополнительное действие.
// 
// Параметры:
// 	Команда - КомандаФормы - .
&НаКлиенте
Процедура ДополнительноеДействие(Команда)
	
	ОчиститьСообщения();
	
	ВыходныеПараметры = Неопределено;
	ВходныеПараметры  = Новый Массив();
	ВходныеПараметры.Добавить(Сред(Команда.Имя, 3)); 
	ВыходныеПараметры = Неопределено;
	ОбъектДрайвера = Неопределено;
	ОбработкаОбслуживания.СоздатьОбъектДрайвера(ОбъектДрайвера, Идентификатор, ЗначениеПараметров);
	ПараметрыУстройства = ПолучитьНастройки().ПараметрыОборудования;
	ПараметрыПодключения = Новый Структура("ТипОборудования", "ККТ");

	РезультатВыполнения = ПодключаемоеОборудованиеУниверсальныйДрайверКлиент.ВыполнитьКоманду("ВыполнитьДополнительноеДействие", 
		ВходныеПараметры, ВыходныеПараметры, ОбъектДрайвера.Драйвер, ПараметрыУстройства, ПараметрыПодключения);
	
	ТекстСообщения = ?(РезультатВыполнения,  НСтр("ru = 'Операция выполнена успешно.'"),
	                               НСтр("ru = 'Ошибка выполнения операции.'") + Символы.НПП + ВыходныеПараметры[1]);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	ОчиститьНастраиваемыйИнтерфейс();
	
	ОбновитьИнформациюОДрайвере(Ложь);

КонецПроцедуры

//#КонецОбласти

//#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОчиститьНастраиваемыйИнтерфейс()
	
	Пока Элементы.Страницы.ПодчиненныеЭлементы.Количество() > 0 Цикл
		Элементы.Удалить(Элементы.Страницы.ПодчиненныеЭлементы.Получить(0));
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ПолучитьНастройки()
	            
	ПараметрыДрайвера = ПолучитьРеквизиты(); // Массив из РеквизитФормы - 
	
	НовыеЗначениеПараметров = Новый Структура;
	Для Каждого Параметр Из ПараметрыДрайвера Цикл
		Если Лев(Параметр.Имя, 2) = "P_" Тогда
			НовыеЗначениеПараметров.Вставить(Параметр.Имя, ЭтаФорма[Параметр.Имя]);
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьНастраиваемыйИнтерфейс(ОписаниеИнтерфейса, ДополнительныеДействия, ПервыйЗапуск)
	
	БазоваяГруппа = Неопределено;
	Элемент = Неопределено;
	ИндексГруппы = 0;
	КоличествоСтраниц = 0;
	ТекущаяСтраница = Элементы.Добавить("ОсновнаяСтраница", Тип("ГруппаФормы"), Элементы.Страницы);
	
	ЧтениеXML = Новый ЧтениеXML; 
	ЧтениеXML.УстановитьСтроку(ОписаниеИнтерфейса);
	ЧтениеXML.ПерейтиКСодержимому();
	
	Если ЧтениеXML.Имя = "Settings" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
		Пока ЧтениеXML.Прочитать() Цикл  
			
			Если ЧтениеXML.Имя = "Parameter" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
				
				ТолькоЧтение = ?(ВРег(ЧтениеXML.ЗначениеАтрибута("ReadOnly")) = "TRUE", Истина, Ложь) 
										Или ?(ВРег(ЧтениеXML.ЗначениеАтрибута("ReadOnly")) = "ИСТИНА", Истина, Ложь);
				ОригинальноеИмя   =  ЧтениеXML.ЗначениеАтрибута("Name");
				ПараметрИмя       = ?(ТолькоЧтение, "R_", "P_") + ОригинальноеИмя;
				ПараметрЗаголовок = ЧтениеXML.ЗначениеАтрибута("Caption");
				ПараметрТип       = ВРег(ЧтениеXML.ЗначениеАтрибута("TypeValue"));
				ПараметрТип       = ?(НЕ ПустаяСтрока(ПараметрТип), ПараметрТип, "STRING");
				ПараметрЗначение  = ЧтениеXML.ЗначениеАтрибута("DefaultValue");
				ПараметрОписание  = ЧтениеXML.ЗначениеАтрибута("Description");
				
				ПараметрСуществует = Ложь;
				ПараметрыДрайвера = ПолучитьРеквизиты(); // Массив из РеквизитФормы -
				Для Каждого ПараметрДрайвера Из ПараметрыДрайвера Цикл
					Если ПараметрДрайвера.Имя = ПараметрИмя Тогда
						ПараметрСуществует = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если Не ПараметрСуществует Тогда
					
					Если ПараметрТип = "NUMBER" Тогда 
						Реквизит = Новый РеквизитФормы(ПараметрИмя, Новый ОписаниеТипов("Число"), , ПараметрЗаголовок, Истина);
					ИначеЕсли ПараметрТип = "BOOLEAN" Тогда 
						Реквизит = Новый РеквизитФормы(ПараметрИмя, Новый ОписаниеТипов("Булево"), , ПараметрЗаголовок, Истина);
					Иначе
						Реквизит = Новый РеквизитФормы(ПараметрИмя, Новый ОписаниеТипов("Строка"), , ПараметрЗаголовок, Истина);
					КонецЕсли;
				
					// Добавляем новый реквизит в форму.
					ДобавляемыеРеквизиты = Новый Массив;
					ДобавляемыеРеквизиты.Добавить(Реквизит);
					ИзменитьРеквизиты(ДобавляемыеРеквизиты);
				
				КонецЕсли;
				
				Если Элементы.Найти(ПараметрИмя) = Неопределено Тогда
					// Если не было создано не одной группы.
					Если БазоваяГруппа = Неопределено Тогда
						БазоваяГруппа = Элементы.Добавить("БазоваяГруппа" + КоличествоСтраниц, Тип("ГруппаФормы"), ТекущаяСтраница);
						БазоваяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
						БазоваяГруппа.Отображение = Элементы.ДрайверИВерсия.Отображение;
						БазоваяГруппа.РастягиватьПоГоризонтали = Истина;
						БазоваяГруппа.Заголовок = НСтр("ru = 'Параметры'");
						БазоваяГруппа.Группировка = Элементы.ДрайверИВерсия.Группировка;
					КонецЕсли;
					// Добавляем новое поле ввода на форму.
					Элемент = Элементы.Добавить(ПараметрИмя, Тип("ПолеФормы"), БазоваяГруппа);
					Если ПараметрТип = "BOOLEAN" Тогда 
						Элемент.Вид = ВидПоляФормы.ПолеФлажка
					Иначе
						Элемент.Вид = ВидПоляФормы.ПолеВвода;
						Элемент.РастягиватьПоГоризонтали = Истина;
					КонецЕсли;
					Элемент.ПутьКДанным = ПараметрИмя;
					Элемент.Подсказка = ПараметрОписание;
					Элемент.ТолькоПросмотр = ТолькоЧтение; 
					МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элемент);
				КонецЕсли;
				
				ХранимоеЗначение = Неопределено;
				Если ЗначениеПараметров.Свойство(ПараметрИмя, ХранимоеЗначение) Тогда
					ПараметрЗначение = ХранимоеЗначение
				Иначе
					Если НЕ ПустаяСтрока(ПараметрЗначение) Тогда
						Если ПараметрТип = "BOOLEAN" Тогда
							ПараметрЗначение = ?(ВРег(ПараметрЗначение) = "TRUE", Истина, Ложь) Или  ?(ВРег(ПараметрЗначение) = "ИСТИНА", Истина, Ложь);
						ИначеЕсли ПараметрТип = "STRING" Тогда
							ПараметрЗначение = Строка(ПараметрЗначение);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				
				ЭтаФорма[ПараметрИмя] = ПараметрЗначение;
				МастерПараметр         = ЧтениеXML.ЗначениеАтрибута("MasterParameterName");
				МастерПараметрЗначение = ЧтениеXML.ЗначениеАтрибута("MasterParameterValue");
				МастерПараметрОперация = ЧтениеXML.ЗначениеАтрибута("MasterParameterOperation");
				
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "ChoiceList" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда 
				
				Если НЕ (Элемент = Неопределено) И НЕ (Элемент.Вид = ВидПоляФормы.ПолеФлажка) Тогда   
					Элемент.РежимВыбораИзСписка  = Истина; 
					Элемент.ВысотаСпискаВыбора   = 10;
					Элемент.РедактированиеТекста = Ложь; 
				КонецЕсли;
				
				Пока ЧтениеXML.Прочитать() И НЕ (ЧтениеXML.Имя = "ChoiceList") Цикл   
					
					Если ЧтениеXML.Имя = "Item" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
						ЗначениеАтрибута = ЧтениеXML.ЗначениеАтрибута("Value"); 
						Если ЧтениеXML.Прочитать() Тогда
							ПредставлениеАтрибута = ЧтениеXML.Значение;
						КонецЕсли;
						Если ПустаяСтрока(ЗначениеАтрибута) Тогда
							ЗначениеАтрибута = ПредставлениеАтрибута;
						КонецЕсли;
						
						Если ПараметрТип = "NUMBER" Тогда 
							Элемент.СписокВыбора.Добавить(Число(ЗначениеАтрибута), ПредставлениеАтрибута);
						Иначе
							Элемент.СписокВыбора.Добавить(ЗначениеАтрибута, ПредставлениеАтрибута)
						КонецЕсли;
					КонецЕсли;
				КонецЦикла; 
				
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "Page" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				ЗаголовокСтраницы = ЧтениеXML.ЗначениеАтрибута("Caption");
				ЗаголовокСтраницы = ?(ПустаяСтрока(ЗаголовокСтраницы), НСтр("ru = 'Параметры'"), ЗаголовокСтраницы);
				
				КоличествоСтраниц = КоличествоСтраниц + 1;
				Если КоличествоСтраниц > 1 Тогда
					Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
					ТекущаяСтраница = Элементы.Добавить("Страница" + КоличествоСтраниц, Тип("ГруппаФормы"), Элементы.Страницы);
					БазоваяГруппа = Неопределено;
				КонецЕсли;
				ТекущаяСтраница.Заголовок = ЗаголовокСтраницы;
				
			КонецЕсли;
				
			Если ЧтениеXML.Имя = "Group" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
				
				ЗаголовокГруппы = ЧтениеXML.ЗначениеАтрибута("Caption");
				ЗаголовокГруппы = ?(ПустаяСтрока(ЗаголовокГруппы), НСтр("ru = 'Параметры'"), ЗаголовокГруппы);
				
				БазоваяГруппа = Элементы.Добавить("Группа" + ИндексГруппы, Тип("ГруппаФормы"), ТекущаяСтраница);
				БазоваяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
				БазоваяГруппа.Отображение = Элементы.ДрайверИВерсия.Отображение;
				БазоваяГруппа.РастягиватьПоГоризонтали = Истина;
				БазоваяГруппа.Группировка = Элементы.ДрайверИВерсия.Группировка;
				БазоваяГруппа.Заголовок = ЗаголовокГруппы;
				ИндексГруппы = ИндексГруппы + 1;
				
			КонецЕсли;
			
		КонецЦикла;  
		
	КонецЕсли;
	
	ЧтениеXML.Закрыть(); 
	
	Если ПервыйЗапуск И НЕ ПустаяСтрока(ДополнительныеДействия) Тогда
		
		ЧтениеXML = Новый ЧтениеXML; 
		ЧтениеXML.УстановитьСтроку(ДополнительныеДействия);
		ЧтениеXML.ПерейтиКСодержимому();
		
		Если ЧтениеXML.Имя = "Actions" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
			
			Пока ЧтениеXML.Прочитать() Цикл  
				Если ЧтениеXML.Имя = "Action" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
					
					ДействиеИмя       = "M_"  + ЧтениеXML.ЗначениеАтрибута("Name");
					ДействиеЗаголовок = ЧтениеXML.ЗначениеАтрибута("Caption");
					
					Команда = ЭтаФорма.Команды.Добавить("A_" + ЧтениеXML.ЗначениеАтрибута("Name"));
					Команда.Заголовок = ДействиеЗаголовок;
					Команда.Действие = "ДополнительноеДействие";
					
					ПунктМеню = ЭтаФорма.Элементы.Добавить(ДействиеИмя, Тип("КнопкаФормы"), ЭтаФорма.Элементы.ДополнительныеДействия);
					ПунктМеню.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
					ПунктМеню.Заголовок = ДействиеЗаголовок;
					ПунктМеню.ИмяКоманды = "A_" + ЧтениеXML.ЗначениеАтрибута("Name");
					 
				КонецЕсли;
			КонецЦикла;  
			
		КонецЕсли;
		
		ЧтениеXML.Закрыть(); 
		
	КонецЕсли;
	
КонецПроцедуры                   

&НаКлиенте
Процедура НачатьВыполнениеДополнительнойКомандыЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если Не ТипЗнч(РезультатВыполнения) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ПервыйЗапуск = ?(Параметры.Свойство("ПервыйЗапуск"), Параметры.ПервыйЗапуск, Истина);
	ВыходныеПараметры = РезультатВыполнения.ВыходныеПараметры;
	Элементы.СтатусДрайвера.Видимость = Истина;
	
	Если РезультатВыполнения.Результат Тогда
		ДрайверУстановлен         = ВыходныеПараметры[0];
		ВерсияДрайвера            = ВыходныеПараметры[1];
		НаименованиеДрайвера      = ВыходныеПараметры[2];
		ОписаниеДрайвера          = ВыходныеПараметры[3];
		ТипОборудования           = ВыходныеПараметры[4];
		РевизияИнтерфейса         = ВыходныеПараметры[5];
		ИнтеграционныйКомпонент   = ВыходныеПараметры[6];
		ОсновнойДрайверУстановлен = ВыходныеПараметры[7];
		АдресЗагрузкиДрайвера     = ВыходныеПараметры[8];
		ПараметрыДрайвера         = ВыходныеПараметры[9];
		ДополнительныеДействия    = ВыходныеПараметры[10];
		
		Если (ИнтеграционныйКомпонент И ОсновнойДрайверУстановлен) Или (НЕ ИнтеграционныйКомпонент) Тогда
			Если НЕ ПустаяСтрока(ПараметрыДрайвера) Тогда
				ОбновитьНастраиваемыйИнтерфейс(ПараметрыДрайвера, ДополнительныеДействия, ПервыйЗапуск);
			КонецЕсли;
		КонецЕсли;
		
		Если ИнтеграционныйКомпонент И НЕ ОсновнойДрайверУстановлен Тогда
			ДрайверУстановлен = НСтр("ru='Установлен интеграционный компонент'");
			ВерсияДрайвера = НСтр("ru='Не определена'");
			Элементы.ДрайверНаименования.Видимость = НЕ ПустаяСтрока(НаименованиеДрайвера); 
			Элементы.ДрайверНаименования.Заголовок = СтрЗаменить(Элементы.ДрайверНаименования.Заголовок, "%Наименование%", НаименованиеДрайвера);
			Элементы.СтатусДрайвера.ТекущаяСтраница = Элементы.ДрайверИнтеграционныйКомпонент;
			Элементы.ПерейтиНаСайтПроизводителя.Видимость = НЕ ПустаяСтрока(АдресЗагрузкиДрайвера);
		Иначе
			Элементы.СтатусДрайвера.ТекущаяСтраница = Элементы.ДрайверУстановлен;
			Элементы.ДрайверИВерсия.Доступность = Истина;
		КонецЕсли;
		
		Элементы.Драйвер.ЦветТекста = ?(ВерсияДрайвера = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);
		Элементы.Версия.ЦветТекста  = Элементы.Драйвер.ЦветТекста ;
		Элементы.НаименованиеДрайвера.ЦветТекста = ?(НаименованиеДрайвера = НСтр("ru='Не определено'"), ЦветОшибки, ЦветТекста);
		Элементы.ОписаниеДрайвера.ЦветТекста     = ?(ОписаниеДрайвера     = НСтр("ru='Не определено'"), ЦветОшибки, ЦветТекста);
		Элементы.ОписаниеДрайвера.Видимость = НЕ ПустаяСтрока(ОписаниеДрайвера);
		
		ОбновитьСтатусПереустановкиДрайвера();
	Иначе
		ДрайверСообщение  = РезультатВыполнения.ОписаниеОшибки;
		ДрайверУстановлен = ВыходныеПараметры[2];
		ВерсияДрайвера  = НСтр("ru='Не определена'");
		Если НЕ ПустаяСтрока(ДрайверСообщение) И ДрайверУстановлен = НСтр("ru='Установлен'") Тогда
			Элементы.УстройствоПодключено.Видимость = Истина;
			Элементы.УстройствоПодключено.Заголовок = ДрайверСообщение;
			Элементы.ТестУстройства.Видимость = Ложь;
			Элементы.ЗаписатьИЗакрыть.Видимость = Ложь;
			Элементы.ДрайверИВерсия.Видимость   = Ложь;
			Элементы.ПрефиксыИСуффиксыДорожек.Видимость = Ложь;
			Элементы.Функции.Видимость = Ложь;
			Элементы.Закрыть.Видимость = Истина;
			Элементы.СтатусДрайвера.Видимость = Ложь;
		Иначе
			Элементы.СтатусДрайвера.ТекущаяСтраница = Элементы.ДрайверНеУстановлен;
		КонецЕсли;
	КонецЕсли;
	
	Если Не Элементы.УстройствоПодключено.Видимость Тогда
		Элементы.УстановитьДрайвер.Видимость = Не (ДрайверУстановлен = НСтр("ru='Установлен'"));
		Элементы.ТестУстройства.Видимость = (НЕ ДрайверУстановлен = НСтр("ru='Не установлен'")) 
	                                      И (НЕ ИнтеграционныйКомпонент Или (ИнтеграционныйКомпонент И ОсновнойДрайверУстановлен));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере(ПервыйЗапуск)

	ВходныеПараметры = Неопределено;
	
	Если ТипЗнч(Идентификатор) = Тип("СправочникСсылка.ТорговоеОборудование") Тогда
		ВыходныеПараметры = Неопределено;
		ОбъектДрайвера = Неопределено;
	
		Результат = ОбработкаОбслуживания.СоздатьОбъектДрайвера(ОбъектДрайвера, Идентификатор, ЗначениеПараметров);
		
		Если ЗначениеЗаполнено(Результат) Тогда
			// ошибка
			ТекстОшибки = ПолучитьСерверТО().ПолучитьТекстОшибкиТО(Результат);
			Элементы.ДекорацияОшибкаЗагрузки.Заголовок = ТекстОшибки;
			Элементы.СтатусДрайвера.ТекущаяСтраница = Элементы.ОшибкаЗагрузки;
			Возврат;
		КонецЕсли;
	
		ДополнительныеПараметры = Неопределено;
		ПараметрыПодключения = Новый Структура("ТипОборудования", "ККТ");
	
		РезультатВыполнения = ПодключаемоеОборудованиеУниверсальныйДрайверКлиент.ВыполнитьКоманду("ПолучитьОписаниеДрайвера", 
			ВходныеПараметры, ВыходныеПараметры, ОбъектДрайвера.Драйвер, ДополнительныеПараметры, ПараметрыПодключения);
		
		Элементы.СтатусДрайвера.Видимость = Истина;
	
		Если РезультатВыполнения Тогда
			ДрайверУстановлен         = ВыходныеПараметры[0];
			ВерсияДрайвера            = ВыходныеПараметры[1];
			НаименованиеДрайвера      = ВыходныеПараметры[2];
			ОписаниеДрайвера          = ВыходныеПараметры[3];
			ТипОборудования           = ВыходныеПараметры[4];
			РевизияИнтерфейса         = ВыходныеПараметры[5];
			ИнтеграционныйКомпонент   = ВыходныеПараметры[6];
			ОсновнойДрайверУстановлен = ВыходныеПараметры[7];
			АдресЗагрузкиДрайвера     = ВыходныеПараметры[8];
			ПараметрыДрайвера         = ВыходныеПараметры[9];
			ДополнительныеДействия    = ВыходныеПараметры[10];
		
			Если (ИнтеграционныйКомпонент И ОсновнойДрайверУстановлен) ИЛИ (НЕ ИнтеграционныйКомпонент) Тогда
				Если НЕ ПустаяСтрока(ПараметрыДрайвера) Тогда
					ОбновитьНастраиваемыйИнтерфейс(ПараметрыДрайвера, ДополнительныеДействия, ПервыйЗапуск);
				КонецЕсли;
			КонецЕсли;
		
			Если ИнтеграционныйКомпонент И НЕ ОсновнойДрайверУстановлен Тогда
				ДрайверУстановлен = НСтр("ru='Установлен интеграционный компонент'");
				ВерсияДрайвера = НСтр("ru='Не определена'");
				Элементы.ДрайверНаименования.Видимость = НЕ ПустаяСтрока(НаименованиеДрайвера); 
				Элементы.ДрайверНаименования.Заголовок = СтрЗаменить(Элементы.ДрайверНаименования.Заголовок, "%Наименование%", НаименованиеДрайвера);
				Элементы.СтатусДрайвера.ТекущаяСтраница = Элементы.ДрайверИнтеграционныйКомпонент;
				Элементы.ПерейтиНаСайтПроизводителя.Видимость = НЕ ПустаяСтрока(АдресЗагрузкиДрайвера);
			Иначе
				Элементы.СтатусДрайвера.ТекущаяСтраница = Элементы.ДрайверУстановлен;
				Элементы.ДрайверИВерсия.Доступность = Истина;
			КонецЕсли;
		
			Элементы.Драйвер.ЦветТекста = ?(ВерсияДрайвера = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);
			Элементы.Версия.ЦветТекста  = Элементы.Драйвер.ЦветТекста ;
			Элементы.НаименованиеДрайвера.ЦветТекста = ?(НаименованиеДрайвера = НСтр("ru='Не определено'"), ЦветОшибки, ЦветТекста);
			Элементы.ОписаниеДрайвера.ЦветТекста     = ?(ОписаниеДрайвера     = НСтр("ru='Не определено'"), ЦветОшибки, ЦветТекста);
			Элементы.ОписаниеДрайвера.Видимость = НЕ ПустаяСтрока(ОписаниеДрайвера);
		
		Иначе
			ДрайверСообщение  = ОбъектДрайвера.ОписаниеОшибки;
			ДрайверУстановлен = ВыходныеПараметры[2];
			ВерсияДрайвера  = НСтр("ru='Не определена'");
			Если НЕ ПустаяСтрока(ДрайверСообщение) И ДрайверУстановлен = НСтр("ru='Установлен'") Тогда
				Элементы.УстройствоПодключено.Видимость = Истина;
				Элементы.УстройствоПодключено.Заголовок = ДрайверСообщение;
				Элементы.ТестУстройства.Видимость = Ложь;
				Элементы.ЗаписатьИЗакрыть.Видимость = Ложь;
				Элементы.ДрайверИВерсия.Видимость   = Ложь;
				Элементы.Функции.Видимость = Ложь;
				Элементы.Закрыть.Видимость = Истина;
				Элементы.СтатусДрайвера.Видимость = Ложь;
			Иначе
				Элементы.СтатусДрайвера.ТекущаяСтраница = Элементы.ДрайверНеУстановлен;
			КонецЕсли;
		КонецЕсли;
	
		Если Не Элементы.УстройствоПодключено.Видимость Тогда
			Элементы.ТестУстройства.Видимость = (НЕ ДрайверУстановлен = НСтр("ru='Не установлен'")) 
	                                      И (НЕ ИнтеграционныйКомпонент Или (ИнтеграционныйКомпонент И ОсновнойДрайверУстановлен));
		КонецЕсли;
	Иначе
		ПараметрыУстройства = Неопределено;
		ПараметрыКоманды = Новый Структура("ПервыйЗапуск", ПервыйЗапуск);
		Оповещение = ОписаниеОповещенияИС("НачатьВыполнениеДополнительнойКомандыЗавершение", ЭтаФорма, ПараметрыКоманды);
		МенеджерОборудованияКлиент.НачатьВыполнениеДополнительнойКоманды(Оповещение, "ПолучитьОписаниеДрайвера", ВходныеПараметры, Идентификатор, ПараметрыУстройства);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусПереустановкиДрайвера()
	
	Если Не ТекущееРабочееМесто Тогда
		Возврат;
	КонецЕсли;
	
#Если Не ВебКлиент Тогда  
	Если ТребуетсяПереустановка Тогда
		Элементы.Переустановка.Видимость = Истина;
		Элементы.ДекорацияПереустановитьДрайвер.Заголовок = НСтр("ru = 'Драйвер будет переустановлен после перезагрузки ""1С:Предприятие"".'");
		Элементы.ПереустановитьДрайверКнопка.Видимость = Ложь;
		Элементы.ПерезапуститьПрограмму.Видимость = Истина;
	ИначеЕсли Не ПустаяСтрока(ВерсияДрайвераВМакете) И Не ПустаяСтрока(ВерсияДрайвера) 
		И Не ВерсияДрайвераВМакете = ВерсияДрайвера И ДрайверУстановлен = НСтр("ru='Установлен'")
		И Не Элементы.УстройствоПодключено.Видимость Тогда
		Элементы.Переустановка.Видимость = Истина;
		ТекстСообщения = НСтр("ru = 'Версия драйвера в конфигурации (%ВКонфигурации%) отличается от установленного.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВКонфигурации%", ВерсияДрайвераВМакете);
		Элементы.ДекорацияПереустановитьДрайвер.Заголовок = ТекстСообщения;
		Элементы.ПерезапуститьПрограмму.Видимость = Ложь;
	Иначе
	   Элементы.Переустановка.Видимость = Ложь;
	КонецЕсли;
#КонецЕсли    
	
КонецПроцедуры

//#КонецОбласти