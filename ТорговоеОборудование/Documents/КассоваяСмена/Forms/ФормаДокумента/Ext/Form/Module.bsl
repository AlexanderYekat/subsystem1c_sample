﻿
//#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ПолныеФискальныеДанные.Видимость = Не Объект.Статус = Перечисления.СтатусыКассовойСмены.Открыта;
	Элементы.ФормаЗакрытьСмену.Доступность = Объект.Статус = Перечисления.СтатусыКассовойСмены.Открыта;
	Элементы.ПолныеФискальныеДанные.Видимость = ДоступныВсеФискальныеДанные;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	XMLСтрока = ТекущийОбъект.ФДОЗакрытииСмены.Получить();
	Если XMLСтрока = Неопределено ИЛИ Не ТипЗнч(XMLСтрока) = Тип("Строка") ИЛИ XMLСтрока = "" Тогда
		ДоступныВсеФискальныеДанные = Ложь;
	Иначе
		ДоступныВсеФискальныеДанные = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПолучитьСерверТО().ПодключитьКлиента(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ПолучитьСерверТО().ОтключитьКлиента(ЭтаФорма);
	
КонецПроцедуры


//#КонецОбласти

//#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолныеФискальныеДанные(Команда)
	
	ПараметрыОткрытияВсехДанных = Новый Структура();
	ПараметрыОткрытияВсехДанных.Вставить("КассоваяСмена", Объект.Ссылка);
	
	ОткрытьФормуМодально("Документ.КассоваяСмена.Форма.ФормаФискальныхДанных", ПараметрыОткрытияВсехДанных);
	
КонецПроцедуры

//#КонецОбласти

//#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытьСмену(Команда)
	
	Ответ = КодВозвратаДиалога.Да;
	Если Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru = 'Перед закрытием смены документ будет записан. Продолжить?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;

	ККТ = Объект.ФискальноеУстройство;
	Если ККТ = NULL ИЛИ ККТ = Неопределено ИЛИ ПустаяСтрока(ККТ) Тогда
		Возврат;
	КонецЕсли;

	КассовыеСменыКлиент.ЗакрытьКассовуюСмену(ККТ, Объект.Ссылка);

	ЭтаФорма.Прочитать();
	ЭтаФорма.ОбновитьОтображениеДанных();
	
	Элементы.ПолныеФискальныеДанные.Видимость = Не Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыКассовойСмены.Открыта");
	Элементы.ФормаЗакрытьСмену.Доступность = Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыКассовойСмены.Открыта");
	Элементы.ПолныеФискальныеДанные.Видимость = ДоступныВсеФискальныеДанные;

КонецПроцедуры

&НаКлиенте
Функция ПоддерживаетсяВидТО(Вид) Экспорт

	Результат = Ложь;

	Если Вид = ПредопределенноеЗначение("Перечисление.ВидыТорговогоОборудования.ККТ") Тогда
		Результат = Истина;
	КонецЕсли;

	Возврат Результат;

КонецФункции // ПоддерживаетсяВидТО()


//#КонецОбласти
