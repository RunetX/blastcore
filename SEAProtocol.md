# Графическое представление протокола SEA Sender #

Все длины и идентификаторы - в сетевом порядке байт (сначала старший, потом младший). Здесь и далее `#число` есть представление байта в десятичной Паскаль-нотации, а `\число` - его же в Си-нотации (то есть, `#0` == `\0` и `#49` == `\61` == `0x31` == символ `'1'`).

![http://blastcore.googlecode.com/files/incoming.png](http://blastcore.googlecode.com/files/incoming.png)

![http://blastcore.googlecode.com/files/outgoing.png](http://blastcore.googlecode.com/files/outgoing.png)

**Отличия команды #4 от показанного на схеме:**

После тела сообщения идёт еще один байт, обозначающий длину. Если он нулевой, как в подавлящем большинстве случаев, более никаких байт не идет. Если он ненулевой, то это длина следующего поля - имени пользователя, за которым идет байт длины имени компьютера, и затем собственно имя компьютера - то есть, структура такая же, как в команде #2, если из неё убрать байт #2 и ID. Эти имя пользователя и компьютера используются в том случае, если сообщение пришло из TCPSender, причем ID отправителя неизвестен (является нулевым). _Зачем это нужно и когда может случиться, никто не знает, надо спрашивать авторов оригинального Java-сервера._

Специальные значения и константы:

  * ID=0 используется как идентификатор группы всех пользователей
  * ID=65535 используется как идентификатор группы Печатников
  * Факультет с ASCII-значением `\1` означает АВТФ, `\2` - МСФ.
  * Реализация оригинального Java-сервера и штатного клиента использует номер 1000 как разделитель идентификаторов клиентов SEA Sender и TCPSender - в команде #2 не предусмотрено флага, в который из списков следует добавить пользователя, и они различаются этой константой (если идентификатор более 1000, то это пользователь TCPSender).

Замечания по схеме, вытекающие из реализации:

  * Оригинальный клиент (до версии 0.9.7.4 включительно), по-видимому, использует знаковое представление чисел - замечено на байтах длины в чате и в имени пользователя (приводит к явным ошибкам переполнения буфера и выпадению в дебаггер). По-видимому, то же применимо и к идентификаторам пользователей, хотя значение  65535 == -1 обрабатывается верно, на практике проверено не было.
    * Считаю, что это ошибка штатного клиента, и все эти числа следует трактовать как беззнаковые. -- nuclight
  * Поле isPrinter в команде #4 от сервера представляет собой два байта, каждый из которых установлен в единицу, если это сообщение для группы Печатников, и два нуля в противном случае.
    * Штатный клиент 0.9.7.4 рассматривает эти два байта как 16-битное число в сетевом порядке байт, то есть достаточно установить в единицу второй байт. Blastcore же версий до 0.4 завязался на отсылку штатным сервером обоих единичных байтов, и проверяет первый из них на строгое соответствие нулю или единице.
    * В версии 102 протокола эти 2 байта будут использованы для расширения длины, см. соответствующий раздел ниже.

**Реализация чата**

Довольно долбанутая. Такова она из-за отсутствия хранения состояния - оно полностью определяется открытыми сейчас формами. В результате используется ЧЕТЫРЕ команды-запроса `#7` для установления вместо двух, и три `#8` вместо одной. Сначала инициатор (И) посылает `#7`, у получателя (П) высвечивается окно "Хотите ответить? Да/Нет". Если да, то П отвечает пустым `#7` как подтверждением, И создает окно чата и ЕЩЕ РАЗ шлет `#7`. В ответ на получение такого `#7` П создает своё окно чата и тоже шлёт пустой `#7`.

Всё, чат установлен, теперь `#7` идет непустой, с текстом. Если текст специальный для beep, то его не показывают обе стороны, вместо этого на той стороне раздается соответствующий звук.

Закрывается чат пустыми `#8`: на команду юзера просто посылается `#8`, а на прием `#8` - закрывается окно у нас и отсылается `#8`. То есть, сначала тот, кто хочет закрыть, шлет `#8`, ему приходит ответный `#8`, который закроет ему окно; при закрытии своего окна он отправит `#8`, который та сторона уже проигнорирует. Также `#8` используется при отмене вызова (юзер не хочет отвечать).

## Версии протокола ##

Байт версии протокола изначально отражал версию штатного клиента в виде Major\*10+Minor, без учета подверсий, то есть и для 0.9.7.3 и для 0.9.7.4 это значение было 97. В конце цикла разработки Бласта это значение стало 98, дабы отличаться от штатного клиента, и 13 сентября 2009 выставлено в 100 ("1.0.0"), символически отражая полноту поддержки протокола и готовность замены штатного клиента.

После этого байт версии протокола будет меняться только с целью соответствующей обработки сервером версии именно протокола, а не различения индивидуальных клиентов. Причем есть подозрение, что штатный клиент и этот байт обрабатывает как знаковый, то есть не следует делать номера более 127. Впрочем, из этого протокола всё равно много не выжмешь, скорее всего, до этого и не дойдет.

# Расширения протокола версий более 100, применяемые в Blastcore #

Расширения ставят целью поддержку форматированного текста (RTF) и передачи файлов, которую просили пользователи. Причем не все из них, вообще говоря, требуют изменения протокола, благодаря обнаруженным особенностям реализации, которые позволяют "хакнуть" протокол без потери совместимости.

Однако следует помнить, что штатный клиент не поддерживает сообщения длиннее 32 Кб.

## Структура сообщения и двоичный ноль ##

Было обнаружено, что как штатный клиент, так и Blastcore всех версий без специальной обработки (до введения расширений) игнорирует ту часть сообщения, что идет после встречающегося в сообщении двоичного нуля '\0' - в Си это конец строки (Blastcore грузит текст как есть в написанный на Си контрол). Это позволяет передавать после двоичного нуля (называемого также ASCIIZ) расширенную информацию, которая будет проигнорирована старыми версиями. Архивер был модифицирован, чтобы вести себя аналогично старой версии.

Таким образом, сообщение может быть представлено как любое количество частей, разделенных символом ASCIIZ, каждая из которых представляет кусок информации в своем формате, и формат определяется первыми байтами после '\0' (сигнатурой), в нижеследующем порядке:

  * Plain text как в старых версиях, обязательная часть, всегда первая (нет сигнатуры);
  * Сигнатура `{\rtf` - тот же текст, что и в первой части, но с форматированием;
  * Возможно, какая-нибудь другая, еще не придуманная часть со своей сигнатурой;
  * Сигнатура `FILE` - приложенный к сообщению файл. Всегда последняя, поскольку в двоичных данных файла может встретиться символ '\0', который уже не должен интерпретироваться как разделитель (кроме того, это позволяет не указывать длину файла - он будет до конца сообщения).

В общих чертах алгоритм обработки форматированного текста такой:

  * Отправитель (версии после 0.4) из составленного ричтекста генерирует plaintext-версию и приписывает её перед RTF-версией - это то, что увидят старые версии и архивер. _Помнить об ограничении 32Кб штатного._
  * Получатель (начиная с 0.4) видит сигнатуру `#0 {\rtf` и загружает для показа пользователю в RichEdit RTF-версию, вырезая её из строки - контрол не видит символов '\0'.
    * Версия 0.4 умеет распознавать, что после RTF идет еще один '\0' и что-то еще, но игнорирует его, ограничиваясь только вырезанием и использованием RTF. _См. обрабатывающее сообщение целиком как строку функции `ExtractPlainText()` и `ExtractRTF()` в коде главной формы._
  * Для цитирования в ответном сообщении получатель использует plaintext-версию - таким образом, алгоритмы цитирования не требуют переделки.

### Формат приложенного файла ###

Ожидается поддержка к версии 0.5. Не более одного файла на сообщение. Эта часть, как уже было сказано, всегда последняя. Формат:
  * Разделяющий `#0` и сигнатура `FILE`
  * 4 байта в сетевом порядке байт - время модификации файла в формате Unix time (число секунд с полуночи 01.01.1970 по Гринвичу). _В Delphi этим числом можно оперировать с помощью функций `UnixToDateTime()/DateTimeToUnix()` и полученное `TDateTime` переводить  `DateTimeToFileDate()` для `FileSetDate()` сотоварищи._
  * 1 байт - длина имени файла
  * n байт - имя файла
  * Все остальные байты до конца - тело файла. _В Delphi, исходя из того, что сообщение будет в строке, можно использовать последовательно `TStringStream`/`TMemoryStream`/далее по вкусу._

Можно добавить, что в формате достаточно из всех свойств файла достаточно передавать только время модификации - потому что у получателя время создания будет временем создания на его машине, и время последнего доступа, естественно, тоже.

## Изменения длины ##

Здесь используется тот факт, что клиент передает серверу трехбайтное поле длины, а значит, может быть передана команда длиной до 16 мегабайт. Это нигде не используется в штатном протоколе - там ограничения до 64 Кб, так как в формате сообщения от сервера к клиенту отведено всего два байта. Из двух байт, отведенных для флага Печатников, один можно использовать для дополнительного байта длины при передаче от сервера к клиенту, но оба используются как флаг - ~~придется использовать две половинки байтов~~ формат переделан вечером 10.10.10 - добавлены флаги/приоритет, один байт чисто на длину. Кроме того, надо учесть, что новый клиент посылает длинное сообщение на группу, в которой есть и старые - что он должен указать в поле длины сообщения (полная длина - в длине команды), чтобы сервер правильно его понял, и старым клиентам сгенерировал сообщение длиной не более 32 (для <= 97) или 64 (для <= 100) килобайт.

### Отправка ###

Выполняется почти точно так же, как и ранее: SEA Packet Length выставляется в полную длину команды (до 16 мегабайт), а вот поле Message Length имеет размер 2 байта и содержит в себе ту часть сообщения, что будет отправлена сервером старым клиентам (с протоколом версий 101 и ниже). При этом применяются следующие правила, в порядке ухудшения возможностей:

  * Если вся команда укладывается в 64 Кб плюс заголовок - то в Message Length обязательно указывается полная длина, как и раньше. Здесь у сервера **более строгая** проверка - если Message Length при таких параметрах будет меньше, он посчитает, что злонамеренный пользователь хочет скрыть часть сообщения от старых (хотя они вполне могут его получить), и прибьет такого клиента.
  * Если и plain text, и RTF-часть укладываются в 64 Кб, то в Message Length надо указать их длину - лучше, чтоб клиенты версии 101 увидели форматирование, чем сидели без него (файл всё равно длиннее, лучше его не получить, чем получить обрезанный - это будет воспринято как глюк).
  * Если plain text и RTF-часть в сумме длиннее 64 Кб - следует указать длину только plain-части (даже клиенты версии 101 пусть лучше видят без форматирования, но весь текст, чем неизвестно как будет воспринят контролом обрывок RTF).
  * Отсюда вытекает, что размер plain text не может превышать 64 Кб, однако следует помнить о штатном клиенте, где ограничение в 32 Кб. Возможно, следует ввести настройки типа "в приват до 64К, на группу до 32К", или даже для приватных непосредственно проверку версии, кому мы шлём - чтоб не свалить его зазря.

### Получение ###

При получении всё сложнее, потому что отведено только два байта. Для клиентов, поддерживающих протокол версии 102 и выше, фрагмент картинки приходящей от сервера команды `#4` видоизменяется следующим образом

```
Отправление: в Message Length пишется спецзначение omsglen (for old),
и из неиспользуемых двух нулевых байтов 7 бит выделяются в поле flags/prio:

   |               |               |               |               |
..-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-...
   | flags/prio  |0|    нули       |старший omsglen|младший omsglen|
..-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-...

Получение. Если бы поле длины Message Length было 3-байтное:

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| старший байт  | средний байт  | младший байт  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

Реальное поле разворачивается в 4 байта, заимствуя из печатников - три
на поле длины (как выше) и один для флагов:

             is Printer                     Message Length
                   ^                               ^    
     _____________/ \_____________   _____________/ \______________
    /                             \ /                              \
   |               |               |               |               |
..-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-...
   | flags/prio  |P| старший байт  | средний байт  | младший байт  |
..-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-...
                  ^                
                  |                
                  `------------------ сообщение печатникам, оба 0 или 1
```

Например, полная длина сообщения должна быть 16580563 байта. Это три байта `0xFC 0xFF 0xD3`. Тогда при получении обычного сообщения 4 байта полей `isPrinter+MessageLength` будут выглядеть как `0x00 0xFC 0xFF 0xD3`. Если байт приоритетов был 0x20, то уже как `0x20 0xFC 0xFF 0xD3`. А если еще  и сообщение было адресовано группе печатников (для ранних версий стоят флаги в обоих байтах, для 102 - только в первом), то поле `is Printer` станет уже `0x21FC`, а `Message Length` останется в `0xFFD3`. _Для обработки этого надо будет поправить функцию `TMainForm.GetPrinter()`, сейчас она проверяет только первый байт на 0 или 1, закрывая соединение для других значений._

## Номера версий ##

Blastcore 0.4 сообщает версию протокола 101 - это всё еще длины в пределах 64 Кб, просто означает, что понимается разделение сообщения на части двоичными нулями, одна из которых - форматированный текст. Таким образом, в этой версии протокола полностью понимаются и файлы и прочее, просто суммарная длина у них не более 64 Кб. Возможно, что следующие версии сначала научатся посылать-принимать файлы, еще не расширяя длин. Главное здесь, что более поздний клиент может отправлять такое любому клиенту версии 101, даже если тот не поймет формат - главное, что ничего страшного не произойдет.

Протокол версии 102 уже заявляет серверу, что принимаются (и могут посылаться) сообщения длиной до 16 Мб. Это единственное отличие (102 подразумевает, что фичи 101 поддерживаются), но серьезное - оно переключает уровень проверок сервера.

На текущий момент поддержка версии 102 уже реализована в сервере, к нему приложен скрипт, умеющий отправлять из командной строки текст и файлы длиной до 16 Мб, см. его на http://code.google.com/p/seasrvkq/source/detail?r=11 и обновление на http://code.google.com/p/seasrvkq/source/detail?r=17 - скрипт может быть использован для тестирования новых версий Blastcore.

Поля флагов/приоритетов пока не определены и просто копируются сервером "как есть" (и только получателям версии 102 и выше).