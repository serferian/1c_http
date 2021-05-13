﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Схема = Элементы.Схема.СписокВыбора[0];
	ТипАвторизации = Элементы.ТипАвторизации.СписокВыбора[0];
	ТипТелаЗапроса = Элементы.ТипТелаЗапроса.СписокВыбора[0].Значение;
	ТипТелаЗапросаКакЕсть = Элементы.ТипТелаЗапросаКакЕсть.СписокВыбора[0];
КонецПроцедуры


&НаКлиенте
Процедура ВыполнитьЗапрос(Команда)
	ПЗ = МножествоПараметровЗапроса();
	ЗЗ = МножествоЗаголовковЗапроса();
	ДП = Новый Структура;
	
	Если ЗЗ <> Неопределено Тогда
		ДП.Вставить("Заголовки", ЗЗ);
	КонецЕсли;
	
	Если ТипАвторизации <> Элементы.ТипАвторизации.СписокВыбора[0].Значение Тогда
		ДП.Вставить(
			"Аутентификация",
			Новый Структура("Тип, Пользователь, Пароль", ТипАвторизации, ПользовательАвторизации, ПарольАвторизации)
		);
	КонецЕсли;
	
	Если Схема = Элементы.Схема.СписокВыбора[0].Значение Тогда // GET
		ОтветHTTP = РаботаСHttp.Получить(ИдентификаторРесурса, ПЗ, ДП);
	ИначеЕсли Схема = Элементы.Схема.СписокВыбора[1].Значение Тогда // POST
		//
	ИначеЕсли Схема = Элементы.Схема.СписокВыбора[2].Значение Тогда // PUT
		ВызватьИсключение "Не реализовано";
	ИначеЕсли Схема = Элементы.Схема.СписокВыбора[3].Значение Тогда // DELETE
		ВызватьИсключение "Не реализовано";
	ИначеЕсли Схема = Элементы.Схема.СписокВыбора[4].Значение Тогда // HEAD
		ВызватьИсключение "Не реализовано";
	Иначе
		ВызватьИсключение "Неизвестная схема запроса";
	КонецЕсли;
	
	КодСостояния = ОтветHTTP.КодСостояния;
	
	ЗаголовкиОтвета.Очистить();
	Для Каждого КЗ Из ОтветHTTP.Заголовки Цикл
		ЗаполнитьЗначенияСвойств(ЗаголовкиОтвета.Добавить(), КЗ);
	КонецЦикла;
	ЗаголовкиОтвета.Сортировать("Ключ");
	
	Ответ = ОтветHTTP.ПолучитьТелоКакСтроку();
	
	Элементы.ГруппаРазделы.ТекущаяСтраница = Элементы.РазделОтвет;
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовкиОтветаПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.ЗаголовкиОтвета.ТекущиеДанные;
	ЗначениеЗаголовкаОтвета = ?(ТекущиеДанные = Неопределено, "", ТекущиеДанные.Значение);
КонецПроцедуры

&НаКлиенте
Процедура ТипАвторизацииПриИзменении(Элемент)
	Отображать = (ТипАвторизации <> Элементы.ТипАвторизации.СписокВыбора[0].Значение);
	
	Элементы.ПользовательАвторизации.Видимость = Отображать;
	Элементы.ГруппаПарольАвторизации.Видимость = Отображать;
	
	ИзменитьРежимОтображенияПароля(НЕ Отображать);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПарольАвторизации(Команда)
	ИзменитьРежимОтображенияПароля(НЕ Элементы.ПоказатьПарольАвторизации.Пометка);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРежимОтображенияПароля(Знач РежимПароля)
	Элементы.ПоказатьПарольАвторизации.Пометка = РежимПароля;
	Элементы.ПарольАвторизации.РежимПароля = НЕ Элементы.ПоказатьПарольАвторизации.Пометка;
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторРесурсаПриИзменении(Элемент)
	ЗаполнитьПараметрыПоИдентификаторуРесурса();
	РассчитатьПараметрыИдентификатораРесурса();
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапросаПриИзменении(Элемент)
	РассчитатьПараметрыИдентификатораРесурса();
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапросаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		Элемент.ТекущиеДанные.Активно = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовкиЗапросаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		Элемент.ТекущиеДанные.Активно = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТипТелаЗапросаПриИзменении(Элемент)
	ТипТелаЗапросаСписокВыбора = Элементы.ТипТелаЗапроса.СписокВыбора;
	Элементы.ГруппаТипыТелаЗапроса.Видимость = (ТипТелаЗапроса <> ТипТелаЗапросаСписокВыбора[0].Значение);
	Если ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[1].Значение Тогда // form-data
		Элементы.ГруппаТипыТелаЗапроса.ТекущаяСтраница = Элементы.ТипыТелаЗапросаДанныеФормы;
	ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[2].Значение Тогда // raw
		Элементы.ГруппаТипыТелаЗапроса.ТекущаяСтраница = Элементы.ТипыТелаЗапросаКакЕсть;
	ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[3].Значение Тогда // binary
		Элементы.ГруппаТипыТелаЗапроса.ТекущаяСтраница = Элементы.ТипыТелаЗапросаДвоичныеДанные;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеФормыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ТекущиеДанные.Тип     = Элемент.ПодчиненныеЭлементы.ДанныеФормыТип.СписокВыбора[0]; // Текст
		ТекущиеДанные.Активно = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеФормыЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	ДанныеФормыТипСписокВыбора = Элемент.Родитель.ПодчиненныеЭлементы.ДанныеФормыТип.СписокВыбора;
	
	Если ТекущиеДанные.Тип = ДанныеФормыТипСписокВыбора[1].Значение Тогда // Файл
		Оповещение = Новый ОписаниеОповещения("ВыборФайлаПоляФормыЗавершение", ЭтотОбъект, ТекущиеДанные);
		
		ПоказатьДиалогВыбораФайла(Оповещение, "Выбор файла для отправки");
	Иначе
		Оповещение = Новый ОписаниеОповещения("РедакторТекстовогоПоляЗавершение", ЭтотОбъект, ТекущиеДанные);
		
		ОткрытьФорму("Обработка.КонсольРаботыСHttp.Форма.РедакторТекстовогоПоля", Новый Структура("Текст", ТекущиеДанные.Значение), ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ФайлТелаЗапросаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ВыборФайлаТелаЗапросаЗавершение", ЭтотОбъект);
	
	ПоказатьДиалогВыбораФайла(Оповещение, "Выбор файла для отправки");
КонецПроцедуры


#Область ВСПОМОГАТЕЛЬНЫЕ_ПРОЦЕДУРЫ_И_ФУНКЦИИ
&НаКлиенте
Процедура ЗаполнитьПараметрыПоИдентификаторуРесурса()
	// TODO: оформить в метод модуля
	ДлинаИдентификатораРесурса = СтрДлина(ИдентификаторРесурса);
	ПозицияНачалаПоиска = 7;
	
	Если СтрНачинаетсяС(ИдентификаторРесурса, "https://") Тогда
		ПозицияНачалаПоиска = 8;
	ИначеЕсли НЕ СтрНачинаетсяС(ИдентификаторРесурса, "http://") Тогда
		ВызватьИсключение "Не удалось разобрать URI";
	КонецЕсли;
	
	ЗначенияПараметров = Новый Соответствие;
	ЗначенияПараметровПоПорядку = Новый Массив;
	
	ПозицияНачалаСтрокиПараметров = СтрНайти(ИдентификаторРесурса, "?", , ПозицияНачалаПоиска);
	ПараметрыСтрока = ?(
		ПозицияНачалаСтрокиПараметров = 0,
		"",
		Прав(ИдентификаторРесурса, ДлинаИдентификатораРесурса - ПозицияНачалаСтрокиПараметров)
	);
	
	ПараметрыИдентификатора = СтрРазделить(ПараметрыСтрока, "&", Ложь);
	Для Каждого Параметр Из ПараметрыИдентификатора Цикл
		ПозицияРазделителя = СтрНайти(Параметр, "=");
		Если ПозицияРазделителя = 0 Тогда
			ПозицияРазделителя = СтрДлина(Параметр) + 1;
		КонецЕсли;
		
		ИмяПараметра = Лев(Параметр, ПозицияРазделителя - 1);
		Если ПустаяСтрока(ИмяПараметра) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначениеПараметра = Прав(Параметр, СтрДлина(Параметр) - ПозицияРазделителя);
		
		ЗначенияПараметра = ЗначенияПараметров.Получить(ИмяПараметра);
		Если ЗначенияПараметра = Неопределено Тогда
			ЗначенияПараметра = Новый Соответствие;
			ЗначенияПараметров.Вставить(ИмяПараметра, ЗначенияПараметра);
			Добавлять = Истина;
		Иначе
			Добавлять = (ЗначенияПараметра.Получить(ЗначениеПараметра) = Неопределено);
		КонецЕсли;
		
		Если Добавлять Тогда
			ЗначенияПараметра.Вставить(ЗначениеПараметра, Истина);
			ЗначенияПараметровПоПорядку.Добавить(Новый Структура("Ключ, Значение", ИмяПараметра, ЗначениеПараметра));
		КонецЕсли;
	КонецЦикла;
	
	СтрокиНаУдаление = Новый Массив;
	
	Для Каждого Стр Из ПараметрыЗапроса Цикл
		ЗначенияПараметра = ЗначенияПараметров.Получить(Стр.Ключ);
		Если ЗначенияПараметра = Неопределено Тогда
			Если Стр.Активно Тогда
				СтрокиНаУдаление.Добавить(Стр);
			КонецЕсли;
		Иначе
			Если ЗначенияПараметра.Получить(Стр.Значение) = Неопределено Тогда
				Если Стр.Активно Тогда
					СтрокиНаУдаление.Добавить(Стр);
				КонецЕсли;
			Иначе
				Стр.Активно = Истина;
				ЗначенияПараметра.Удалить(Стр.Значение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Стр Из СтрокиНаУдаление Цикл
		ПараметрыЗапроса.Удалить(Стр);
	КонецЦикла;
	
	Для Каждого ЗначениеПараметра Из ЗначенияПараметровПоПорядку Цикл
		ЗначенияПараметра = ЗначенияПараметров.Получить(ЗначениеПараметра.Ключ);
		Если ЗначенияПараметра = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если ЗначенияПараметра.Получить(ЗначениеПараметра.Значение) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Стр = ПараметрыЗапроса.Добавить();
		Стр.Ключ     = ЗначениеПараметра.Ключ;
		Стр.Значение = ЗначениеПараметра.Значение;
		Стр.Активно  = Истина;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьПараметрыИдентификатораРесурса()
	ДлинаИдентификатораРесурса = СтрДлина(ИдентификаторРесурса);
	ПозицияНачалаПоиска = 7;
	
	Если СтрНачинаетсяС(ИдентификаторРесурса, "https://") Тогда
		ПозицияНачалаПоиска = 8;
	ИначеЕсли НЕ СтрНачинаетсяС(ИдентификаторРесурса, "http://") Тогда
		ВызватьИсключение "Не удалось разобрать URI";
	КонецЕсли;
	
	ПозицияНачалаСтрокиПараметров = СтрНайти(ИдентификаторРесурса, "?", , ПозицияНачалаПоиска);
	
	НовыйИдентификатор = ?(
		ПозицияНачалаСтрокиПараметров = 0,
		ИдентификаторРесурса,
		Лев(ИдентификаторРесурса, ПозицияНачалаСтрокиПараметров - 1)
	);
	
	ПараметрыИдентификатора = Новый Массив;
	Для Каждого Стр Из ПараметрыЗапроса Цикл
		Если Стр.Активно И НЕ ПустаяСтрока(Стр.Ключ) Тогда
			ПараметрыИдентификатора.Добавить(Стр.Ключ + ?(ПустаяСтрока(Стр.Значение), "", "=") + Стр.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыИдентификатора.Количество() > 0 Тогда
		НовыйИдентификатор = НовыйИдентификатор + "?" + СтрСоединить(ПараметрыИдентификатора, "&");
	КонецЕсли;
	
	ИдентификаторРесурса = НовыйИдентификатор;
КонецПроцедуры

&НаКлиенте
Функция МножествоПараметровЗапроса()
	фРезультат = Новый Соответствие;
	
	Для Каждого Стр Из ПараметрыЗапроса Цикл
		Если НЕ Стр.Активно Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначенияПараметра = фРезультат.Получить(Стр.Ключ);
		Если ЗначенияПараметра = Неопределено Тогда
			ЗначенияПараметра = Новый Массив;
			фРезультат.Вставить(Стр.Ключ, ЗначенияПараметра);
		КонецЕсли;
		ЗначенияПараметра.Добавить(Стр.Значение);
	КонецЦикла;
	
	Возврат фРезультат;
КонецФункции

&НаКлиенте
Функция МножествоЗаголовковЗапроса()
	фРезультат = Новый Соответствие;
	
	Для Каждого Стр Из ЗаголовкиЗапроса Цикл
		Если НЕ Стр.Активно Тогда
			Продолжить;
		КонецЕсли;
		
		фРезультат.Вставить(Стр.Ключ, Стр.Значение);
	КонецЦикла;
	
	Возврат фРезультат;
КонецФункции

&НаКлиенте
Процедура ВыборФайлаТелаЗапросаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы <> Неопределено Тогда
		ФайлТелаЗапроса = ВыбранныеФайлы[0];
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаПоляФормыЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы <> Неопределено Тогда
		ДополнительныеПараметры.Значение = ВыбранныеФайлы[0];
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДиалогВыбораФайла(Знач Оповещение, Знач Заголовок = "Выбор файла")
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок                   = Заголовок;
	Диалог.ПредварительныйПросмотр     = Ложь;
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Диалог.МножественныйВыбор          = Ложь;
	Диалог.Показать(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура РедакторТекстовогоПоляЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ДополнительныеПараметры.Значение = Результат;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти
