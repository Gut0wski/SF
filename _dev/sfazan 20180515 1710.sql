--
-- Скрипт сгенерирован Devart dbForge Studio for MySQL, Версия 7.4.201.0
-- Домашняя страница продукта: http://www.devart.com/ru/dbforge/mysql/studio
-- Дата скрипта: 15.05.2018 17:10:54
-- Версия сервера: 5.6.38
-- Версия клиента: 4.1
--

-- 
-- Отключение внешних ключей
-- 
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 
-- Установить режим SQL (SQL mode)
-- 
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 
-- Установка кодировки, с использованием которой клиент будет посылать запросы на сервер
--
SET NAMES 'utf8';

--
-- Установка базы данных по умолчанию
--
USE sfazan;

--
-- Удалить процедуру `subject_messages`
--
DROP PROCEDURE IF EXISTS subject_messages;

--
-- Удалить таблицу `blocks_history`
--
DROP TABLE IF EXISTS blocks_history;

--
-- Удалить таблицу `contacts`
--
DROP TABLE IF EXISTS contacts;

--
-- Удалить таблицу `contacts_history`
--
DROP TABLE IF EXISTS contacts_history;

--
-- Удалить таблицу `discussions_history`
--
DROP TABLE IF EXISTS discussions_history;

--
-- Удалить таблицу `documents`
--
DROP TABLE IF EXISTS documents;

--
-- Удалить таблицу `documents_history`
--
DROP TABLE IF EXISTS documents_history;

--
-- Удалить таблицу `feedbacks_history`
--
DROP TABLE IF EXISTS feedbacks_history;

--
-- Удалить таблицу `measurements_history`
--
DROP TABLE IF EXISTS measurements_history;

--
-- Удалить таблицу `messages_history`
--
DROP TABLE IF EXISTS messages_history;

--
-- Удалить таблицу `news`
--
DROP TABLE IF EXISTS news;

--
-- Удалить таблицу `news_history`
--
DROP TABLE IF EXISTS news_history;

--
-- Удалить таблицу `payments_history`
--
DROP TABLE IF EXISTS payments_history;

--
-- Удалить таблицу `settings`
--
DROP TABLE IF EXISTS settings;

--
-- Удалить таблицу `settings_history`
--
DROP TABLE IF EXISTS settings_history;

--
-- Удалить таблицу `tariffs_history`
--
DROP TABLE IF EXISTS tariffs_history;

--
-- Удалить таблицу `tariffs_types_history`
--
DROP TABLE IF EXISTS tariffs_types_history;

--
-- Удалить таблицу `users_history`
--
DROP TABLE IF EXISTS users_history;

--
-- Удалить процедуру `active_block_user`
--
DROP PROCEDURE IF EXISTS active_block_user;

--
-- Удалить процедуру `history_blocks_user`
--
DROP PROCEDURE IF EXISTS history_blocks_user;

--
-- Удалить таблицу `blocks`
--
DROP TABLE IF EXISTS blocks;

--
-- Удалить функцию `new_assessment`
--
DROP FUNCTION IF EXISTS new_assessment;

--
-- Удалить таблицу `feedbacks`
--
DROP TABLE IF EXISTS feedbacks;

--
-- Удалить таблицу `discussions`
--
DROP TABLE IF EXISTS discussions;

--
-- Удалить представление `measurements_users`
--
DROP VIEW IF EXISTS measurements_users CASCADE;

--
-- Удалить процедуру `calculate2`
--
DROP PROCEDURE IF EXISTS calculate2;

--
-- Удалить представление `measurements_users2`
--
DROP VIEW IF EXISTS measurements_users2 CASCADE;

--
-- Удалить процедуру `calculate`
--
DROP PROCEDURE IF EXISTS calculate;

--
-- Удалить таблицу `measurements`
--
DROP TABLE IF EXISTS measurements;

--
-- Удалить таблицу `messages`
--
DROP TABLE IF EXISTS messages;

--
-- Удалить таблицу `payments`
--
DROP TABLE IF EXISTS payments;

--
-- Удалить таблицу `users`
--
DROP TABLE IF EXISTS users;

--
-- Удалить представление `tariffs_actual`
--
DROP VIEW IF EXISTS tariffs_actual CASCADE;

--
-- Удалить представление `tariffs_periods_current`
--
DROP VIEW IF EXISTS tariffs_periods_current CASCADE;

--
-- Удалить представление `tariffs_interval`
--
DROP VIEW IF EXISTS tariffs_interval CASCADE;

--
-- Удалить представление `tariffs_sort_history`
--
DROP VIEW IF EXISTS tariffs_sort_history CASCADE;

--
-- Удалить таблицу `tariffs`
--
DROP TABLE IF EXISTS tariffs;

--
-- Удалить таблицу `tariffs_types`
--
DROP TABLE IF EXISTS tariffs_types;

--
-- Установка базы данных по умолчанию
--
USE sfazan;

--
-- Создать таблицу `tariffs_types`
--
CREATE TABLE tariffs_types (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  title varchar(200) NOT NULL COMMENT 'заголовок тарифа',
  calculate tinyint(1) NOT NULL DEFAULT 1 COMMENT 'необходим ли съем показаний (0 - нет, 1 - да)',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 8,
AVG_ROW_LENGTH = 8192,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'типы тарифов';

--
-- Создать индекс `title` для объекта типа таблица `tariffs_types`
--
ALTER TABLE tariffs_types
ADD UNIQUE INDEX title (title);

--
-- Создать таблицу `tariffs`
--
CREATE TABLE tariffs (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  type int(11) NOT NULL COMMENT 'тип тарифа',
  period_start varchar(10) NOT NULL COMMENT 'период начала действия',
  value decimal(10, 2) NOT NULL COMMENT 'значение',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 10,
AVG_ROW_LENGTH = 2340,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'тарифы';

--
-- Создать внешний ключ
--
ALTER TABLE tariffs
ADD CONSTRAINT FK_TariffType FOREIGN KEY (type)
REFERENCES tariffs_types (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать представление `tariffs_sort_history`
--
CREATE
VIEW tariffs_sort_history
AS
SELECT
  `t`.`id` AS `id`,
  `t`.`type` AS `type`,
  `t`.`period_start` AS `period_start`,
  `t`.`value` AS `value`
FROM `tariffs` `t`
ORDER BY STR_TO_DATE(CONCAT('01.', `t`.`period_start`), '%d.%m.%Y') DESC;

--
-- Создать представление `tariffs_interval`
--
CREATE
VIEW tariffs_interval
AS
SELECT
  `t`.`type` AS `type`,
  DATE_FORMAT(STR_TO_DATE(CONCAT('01.', `t`.`period_start`), '%d.%m.%Y'), '%Y-%m-%d') AS `period_start`,
  (SELECT
      (DATE_FORMAT(STR_TO_DATE(CONCAT('01.', `t2`.`period_start`), '%d.%m.%Y'), '%Y-%m-%d') + INTERVAL -(1) DAY)
    FROM `tariffs` `t2`
    WHERE ((`t2`.`type` = `t`.`type`)
    AND (STR_TO_DATE(CONCAT('01.', `t2`.`period_start`), '%d.%m.%Y') > STR_TO_DATE(CONCAT('01.', `t`.`period_start`), '%d.%m.%Y')))
    ORDER BY STR_TO_DATE(CONCAT('01.', `t2`.`period_start`), '%d.%m.%Y') LIMIT 1) AS `period_end`,
  `t`.`value` AS `value`
FROM `tariffs` `t`;

--
-- Создать представление `tariffs_periods_current`
--
CREATE
VIEW tariffs_periods_current
AS
SELECT
  `tariffs_interval`.`type` AS `type`,
  DATE_FORMAT(MAX(`tariffs_interval`.`period_start`), '%m.%Y') AS `period_start`
FROM `tariffs_interval`
WHERE (`tariffs_interval`.`period_start` < NOW())
GROUP BY `tariffs_interval`.`type`;

--
-- Создать представление `tariffs_actual`
--
CREATE
VIEW tariffs_actual
AS
SELECT
  `tariffs`.`id` AS `id`,
  `current`.`type` AS `type`,
  `current`.`period_start` AS `period_start`,
  `tariffs`.`value` AS `value`
FROM ((`tariffs_periods_current` `current`
  JOIN `tariffs`
    ON (((`current`.`type` = `tariffs`.`type`)
    AND (`current`.`period_start` = `tariffs`.`period_start`))))
  JOIN `tariffs_types` `tt`
    ON ((`tariffs`.`type` = `tt`.`id`)))
ORDER BY `tt`.`title`;

--
-- Создать таблицу `users`
--
CREATE TABLE users (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  username varchar(100) NOT NULL COMMENT 'логин',
  password varchar(500) NOT NULL COMMENT 'хэшированный пароль',
  password_reset varchar(500) DEFAULT NULL COMMENT 'сброс пароля',
  email varchar(50) NOT NULL COMMENT 'email',
  telephone varchar(50) NOT NULL COMMENT 'телефон',
  other_contacts varchar(500) DEFAULT NULL COMMENT 'другие контактные данные',
  fio varchar(200) NOT NULL COMMENT 'Ф.И.О.',
  sector varchar(50) NOT NULL COMMENT 'номер участка',
  address varchar(500) DEFAULT NULL COMMENT 'адрес фактического проживания (если не СТ)',
  date_register timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'дата регистрации',
  date_active datetime DEFAULT NULL COMMENT 'дата последней активности',
  role varchar(50) DEFAULT NULL COMMENT 'роль',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 5,
AVG_ROW_LENGTH = 4096,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'пользователи';

--
-- Создать индекс `email` для объекта типа таблица `users`
--
ALTER TABLE users
ADD UNIQUE INDEX email (email);

--
-- Создать индекс `login` для объекта типа таблица `users`
--
ALTER TABLE users
ADD UNIQUE INDEX login (username);

--
-- Создать таблицу `payments`
--
CREATE TABLE payments (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'дата платежа',
  type int(11) NOT NULL COMMENT 'тип тарифа',
  user int(11) NOT NULL COMMENT 'код пользователя',
  sum decimal(10, 2) NOT NULL COMMENT 'сумма',
  place varchar(500) DEFAULT NULL COMMENT 'место оплаты',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 13,
AVG_ROW_LENGTH = 3276,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'платежи';

--
-- Создать внешний ключ
--
ALTER TABLE payments
ADD CONSTRAINT FK_PaymentType FOREIGN KEY (type)
REFERENCES tariffs_types (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE payments
ADD CONSTRAINT FK_PaymentUser FOREIGN KEY (user)
REFERENCES users (id) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Создать таблицу `messages`
--
CREATE TABLE messages (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'дата отправки',
  recipient int(11) NOT NULL COMMENT 'код получателя',
  sender int(11) NOT NULL COMMENT 'код отправителя',
  subject varchar(200) NOT NULL COMMENT 'тема сообщения',
  text text NOT NULL COMMENT 'текст сообщения',
  reading tinyint(1) NOT NULL DEFAULT 0 COMMENT 'сообщение прочитано (0 - нет, 1 - да)',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 14,
AVG_ROW_LENGTH = 3276,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'сообщения между пользователями';

--
-- Создать внешний ключ
--
ALTER TABLE messages
ADD CONSTRAINT FK_MessageRecipient FOREIGN KEY (recipient)
REFERENCES users (id) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE messages
ADD CONSTRAINT FK_MessageSender FOREIGN KEY (sender)
REFERENCES users (id) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Создать таблицу `measurements`
--
CREATE TABLE measurements (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'дата внесения',
  type int(11) NOT NULL COMMENT 'код тарифа',
  user int(11) NOT NULL COMMENT 'код пользователя',
  value decimal(10, 2) NOT NULL COMMENT 'показание',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 20,
AVG_ROW_LENGTH = 1489,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'контрольные показания';

--
-- Создать внешний ключ
--
ALTER TABLE measurements
ADD CONSTRAINT FK_MeasurementType FOREIGN KEY (type)
REFERENCES tariffs_types (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE measurements
ADD CONSTRAINT FK_MeasurementUser FOREIGN KEY (user)
REFERENCES users (id) ON DELETE CASCADE ON UPDATE NO ACTION;

DELIMITER $$

--
-- Создать процедуру `calculate`
--
CREATE PROCEDURE calculate (IN user_id int)
BEGIN

  SET @n := 0;

  SELECT
    @n := @n + 1 AS `num`,
    `period`,
    `type`,
    `tariff`,
    `measurement_date`,
    `measurement_value`,
    `value`,
    `to_pay`,
    `payment`
  FROM (SELECT
      p.period,
      tt.title AS type,
      ti.value AS tariff,
      DATE_FORMAT(m.date, '%d.%m.%Y %H:%i') AS measurement_date,
      m.value AS measurement_value,
      (m.value - m2.value) AS value,
      CAST(((m.value - m2.value) * ti.value) AS decimal(6, 2)) AS to_pay,
      (CASE WHEN SUM(pm.sum) IS NULL THEN 0.00 ELSE SUM(pm.sum) END) AS payment
    FROM (SELECT
        DATE_FORMAT(date, '%m.%Y') AS period
      FROM measurements
      WHERE user = user_id
      GROUP BY period) AS p
      LEFT JOIN measurements m
        ON (p.period, m.type, m.date) IN (SELECT
            mu.period,
            mu.type,
            mu.date
          FROM measurements_users mu
          WHERE mu.user = user_id)
      LEFT JOIN measurements m2
        ON (DATE_FORMAT((STR_TO_DATE(CONCAT('01.', p.period), '%d.%m.%Y') - INTERVAL 1 MONTH), '%m.%Y'), m2.type, m2.date) IN (SELECT
            mu.period,
            mu.type,
            mu.date
          FROM measurements_users mu
          WHERE mu.user = user_id)
        AND m.type = m2.type
      LEFT JOIN tariffs_types tt
        ON m.type = tt.id
      LEFT JOIN tariffs_interval ti
        ON m.type = ti.type
        AND STR_TO_DATE(CONCAT('01.', p.period), '%d.%m.%Y') BETWEEN ti.period_start AND (CASE WHEN ti.period_end IS NULL THEN '2100-01-01' ELSE ti.period_end END)
      LEFT JOIN payments pm
        ON p.period = DATE_FORMAT(pm.date, '%m.%Y')
        AND m.type = pm.type
        AND pm.user = user_id
    WHERE m2.value IS NOT NULL
    GROUP BY p.period,
             tt.title,
             ti.value,
             m.date,
             m.value

    UNION

    SELECT
      p.period,
      tt.title AS type,
      ti.value AS tariff,
      '' AS measurement_date,
      '' AS measurement_value,
      '' AS value,
      ti.value AS to_pay,
      (CASE WHEN SUM(pm.sum) IS NULL THEN 0.00 ELSE SUM(pm.sum) END) AS payment
    FROM (SELECT
        DATE_FORMAT(date, '%m.%Y') AS period
      FROM measurements
      WHERE user = user_id
      AND DATE_FORMAT(date, '%m.%Y') != (SELECT
          MIN(DATE_FORMAT(date, '%m.%Y'))
        FROM measurements
        WHERE user = user_id)
      GROUP BY period) AS p
      LEFT JOIN tariffs_interval ti
        ON STR_TO_DATE(CONCAT('01.', p.period), '%d.%m.%Y') BETWEEN ti.period_start AND (CASE WHEN ti.period_end IS NULL THEN '2100-01-01' ELSE ti.period_end END)
      LEFT JOIN tariffs_types tt
        ON ti.type = tt.id
      LEFT JOIN payments pm
        ON p.period = DATE_FORMAT(pm.date, '%m.%Y')
        AND tt.id = pm.type
        AND pm.user = user_id
    WHERE tt.calculate = 0
    GROUP BY p.period,
             tt.title,
             ti.value

    ORDER BY 1 DESC, 2 ASC) calculate;
END
$$

DELIMITER ;

--
-- Создать представление `measurements_users2`
--
CREATE
VIEW measurements_users2
AS
SELECT
  `m`.`user` AS `user`,
  DATE_FORMAT(`m`.`date`, '%m.%Y') AS `period`,
  `m`.`type` AS `type`,
  MAX(`m`.`date`) AS `cur_date`,
  (SELECT
      `m3`.`value`
    FROM `measurements` `m3`
    WHERE ((`m3`.`user` = `m`.`user`)
    AND (`m3`.`type` = `m`.`type`)
    AND (`m3`.`date` = MAX(`m`.`date`)))) AS `cur_value`,
  (SELECT
      MAX(`m2`.`date`)
    FROM `measurements` `m2`
    WHERE ((`m2`.`user` = `m`.`user`)
    AND (`m2`.`type` = `m`.`type`)
    AND (DATE_FORMAT(`m2`.`date`, '%m.%Y') < DATE_FORMAT(`m`.`date`, '%m.%Y')))
    ORDER BY `m2`.`date` DESC LIMIT 1) AS `prev_date`,
  (SELECT
      `m4`.`value`
    FROM `measurements` `m4`
    WHERE ((`m4`.`user` = `m`.`user`)
    AND (`m4`.`type` = `m`.`type`)
    AND (`m4`.`date` = `prev_date`))) AS `prev_value`
FROM `measurements` `m`
GROUP BY `m`.`user`,
         `period`,
         `m`.`type`;

DELIMITER $$

--
-- Создать процедуру `calculate2`
--
CREATE PROCEDURE calculate2 (IN user_id int)
BEGIN

  SET @n := 0;

  SELECT
    @n := @n + 1 AS `num`,
    `period`,
    `type`,
    `tariff`,
    `measurement_date`,
    `measurement_value`,
    `value`,
    `to_pay`,
    `payment`
  FROM (SELECT
      p.period,
      tt.title AS type,
      ti.value AS tariff,
      DATE_FORMAT(mu.cur_date, '%d.%m.%Y %H:%i') AS measurement_date,
      mu.cur_value AS measurement_value,
      (mu.cur_value - mu.prev_value) AS value,
      CAST(((mu.cur_value - mu.prev_value) * ti.value) AS decimal(6, 2)) AS to_pay,
      (CASE WHEN SUM(pm.sum) IS NULL THEN 0.00 ELSE SUM(pm.sum) END) AS payment
    FROM (SELECT
        DATE_FORMAT(date, '%m.%Y') AS period
      FROM measurements
      WHERE user = user_id
      GROUP BY period) AS p
      LEFT JOIN measurements_users2 mu
        ON mu.user = user_id
        AND mu.period = p.period
      LEFT JOIN tariffs_types tt
        ON mu.type = tt.id
      LEFT JOIN tariffs_interval ti
        ON mu.type = ti.type
        AND STR_TO_DATE(CONCAT('01.', p.period), '%d.%m.%Y') BETWEEN ti.period_start AND (CASE WHEN ti.period_end IS NULL THEN '2100-01-01' ELSE ti.period_end END)
      LEFT JOIN payments pm
        ON p.period = DATE_FORMAT(pm.date, '%m.%Y')
        AND mu.type = pm.type
        AND pm.user = user_id
    WHERE mu.prev_value IS NOT NULL
    GROUP BY p.period,
             tt.title,
             ti.value,
             mu.cur_date,
             mu.cur_value

    UNION

    SELECT
      p.period,
      tt.title AS type,
      ti.value AS tariff,
      '' AS measurement_date,
      '' AS measurement_value,
      '' AS value,
      ti.value AS to_pay,
      (CASE WHEN SUM(pm.sum) IS NULL THEN 0.00 ELSE SUM(pm.sum) END) AS payment
    FROM (SELECT
        DATE_FORMAT(date, '%m.%Y') AS period
      FROM measurements
      WHERE user = user_id
      AND DATE_FORMAT(date, '%m.%Y') != (SELECT
          MIN(DATE_FORMAT(date, '%m.%Y'))
        FROM measurements
        WHERE user = user_id)
      GROUP BY period) AS p
      LEFT JOIN tariffs_interval ti
        ON STR_TO_DATE(CONCAT('01.', p.period), '%d.%m.%Y') BETWEEN ti.period_start AND (CASE WHEN ti.period_end IS NULL THEN '2100-01-01' ELSE ti.period_end END)
      LEFT JOIN tariffs_types tt
        ON ti.type = tt.id
      LEFT JOIN payments pm
        ON p.period = DATE_FORMAT(pm.date, '%m.%Y')
        AND tt.id = pm.type
        AND pm.user = user_id
    WHERE tt.calculate = 0
    GROUP BY p.period,
             tt.title,
             ti.value

    ORDER BY 1 DESC, 2 ASC) calculate;

END
$$

DELIMITER ;

--
-- Создать представление `measurements_users`
--
CREATE
VIEW measurements_users
AS
SELECT
  `measurements`.`user` AS `user`,
  DATE_FORMAT(`measurements`.`date`, '%m.%Y') AS `period`,
  `measurements`.`type` AS `type`,
  MAX(`measurements`.`date`) AS `date`
FROM `measurements`
GROUP BY `measurements`.`user`,
         DATE_FORMAT(`measurements`.`date`, '%m.%Y'),
         `measurements`.`type`;

--
-- Создать таблицу `discussions`
--
CREATE TABLE discussions (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  date_create timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'дата создания',
  date_update datetime DEFAULT NULL COMMENT 'дата редактирования',
  type tinyint(1) NOT NULL COMMENT 'тип (1 - раздел, 2 - тема, 3 - сообщение)',
  parent int(11) DEFAULT NULL COMMENT 'код родителя',
  user int(11) NOT NULL COMMENT 'автор',
  title varchar(300) DEFAULT NULL COMMENT 'заголовок',
  text text DEFAULT NULL COMMENT 'текст',
  hidden tinyint(1) NOT NULL DEFAULT 0 COMMENT 'скрыто для незарегистрированных пользователей (0 - нет, 1 - да)',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 58,
AVG_ROW_LENGTH = 1365,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'обсуждения';

--
-- Создать внешний ключ
--
ALTER TABLE discussions
ADD CONSTRAINT FK_DiscussionParent FOREIGN KEY (parent)
REFERENCES discussions (id) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE discussions
ADD CONSTRAINT FK_DiscussionUser FOREIGN KEY (user)
REFERENCES users (id) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Создать таблицу `feedbacks`
--
CREATE TABLE feedbacks (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'дата создания',
  message int(11) NOT NULL COMMENT 'код сообщения',
  type tinyint(1) NOT NULL COMMENT 'тип отклика (1 - жалоба, 2 - нравится, 3 - не нравится)',
  user int(11) NOT NULL COMMENT 'код откликнувшегося',
  text varchar(500) DEFAULT NULL COMMENT 'причина жалобы',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 78,
AVG_ROW_LENGTH = 5461,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'отклики на обсуждения';

--
-- Создать внешний ключ
--
ALTER TABLE feedbacks
ADD CONSTRAINT FK_FeedbackMessage FOREIGN KEY (message)
REFERENCES discussions (id) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE feedbacks
ADD CONSTRAINT FK_FeedbackUser FOREIGN KEY (user)
REFERENCES users (id) ON DELETE CASCADE ON UPDATE NO ACTION;

DELIMITER $$

--
-- Создать функцию `new_assessment`
--
CREATE FUNCTION new_assessment (user_id int, message_id int, type_assessment int)
RETURNS int(11)
BEGIN
  SET @assessment = IF(type_assessment = 1, 2, 3);

  IF (SELECT
        COUNT(id)
      FROM feedbacks
      WHERE message = message_id
      AND user = user_id
      AND type = @assessment) > 0 THEN
    DELETE
      FROM feedbacks
    WHERE message = message_id
      AND user = user_id
      AND type = @assessment;
    RETURN FALSE;
  END IF;

  SET @not_assessment = IF(type_assessment = 1, 3, 2);

  IF (SELECT
        COUNT(id)
      FROM feedbacks
      WHERE message = message_id
      AND user = user_id
      AND type = @not_assessment) > 0 THEN
    UPDATE feedbacks
    SET type = @assessment
    WHERE message = message_id
    AND user = user_id
    AND type = @not_assessment;
    RETURN FALSE;
  END IF;

  INSERT INTO feedbacks (message, type, user)
    VALUES (message_id, @assessment, user_id);
  RETURN TRUE;
END
$$

DELIMITER ;

--
-- Создать таблицу `blocks`
--
CREATE TABLE blocks (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  date_start datetime NOT NULL COMMENT 'дата начала блокировки',
  date_end datetime NOT NULL COMMENT 'дата окончания блокировки',
  user int(11) NOT NULL COMMENT 'код заблокированного пользователя',
  moderator int(11) NOT NULL COMMENT 'кем блокирован',
  reason varchar(500) NOT NULL COMMENT 'причина блокировки',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 8,
AVG_ROW_LENGTH = 8192,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'блокировки пользователей';

--
-- Создать внешний ключ
--
ALTER TABLE blocks
ADD CONSTRAINT FK_BlockModerator FOREIGN KEY (moderator)
REFERENCES users (id) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE blocks
ADD CONSTRAINT FK_BlockUser FOREIGN KEY (user)
REFERENCES users (id) ON DELETE CASCADE ON UPDATE NO ACTION;

DELIMITER $$

--
-- Создать процедуру `history_blocks_user`
--
CREATE PROCEDURE history_blocks_user (IN user_id int)
BEGIN
  SELECT
    `b`.`date_start`,
    `b`.`date_end`,
    `u`.`username`,
    `u`.`fio`,
    `b`.`reason`
  FROM `blocks` `b`
    INNER JOIN `users` `u`
      ON `b`.`moderator` = `u`.`id`
  WHERE `b`.user = user_id
  ORDER BY `b`.`date_end` DESC;
END
$$

--
-- Создать процедуру `active_block_user`
--
CREATE PROCEDURE active_block_user (IN user_id int)
BEGIN
  SELECT
    `b`.`date_start`,
    `b`.`date_end`,
    `u`.`username`,
    `u`.`fio`,
    `b`.`reason`
  FROM `blocks` `b`
    INNER JOIN `users` `u`
      ON `b`.`moderator` = `u`.`id`
  WHERE (`b`.user = user_id)
  AND (NOW() BETWEEN `b`.`date_start` AND `b`.`date_end`)
  ORDER BY `b`.`date_end` DESC
  LIMIT 1;
END
$$

DELIMITER ;

--
-- Создать таблицу `users_history`
--
CREATE TABLE users_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  username varchar(100) DEFAULT NULL,
  password varchar(500) DEFAULT NULL,
  password_reset varchar(500) DEFAULT NULL,
  email varchar(50) DEFAULT NULL,
  telephone varchar(50) DEFAULT NULL,
  other_contacts varchar(500) DEFAULT NULL,
  fio varchar(200) DEFAULT NULL,
  sector varchar(50) DEFAULT NULL,
  address varchar(500) DEFAULT NULL,
  date_register timestamp NULL DEFAULT NULL,
  date_active datetime DEFAULT NULL,
  role varchar(50) DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 931,
AVG_ROW_LENGTH = 348,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `tariffs_types_history`
--
CREATE TABLE tariffs_types_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  title varchar(200) DEFAULT NULL,
  calculate tinyint(1) DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 4,
AVG_ROW_LENGTH = 8192,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `tariffs_history`
--
CREATE TABLE tariffs_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  type int(11) DEFAULT NULL,
  period_start varchar(10) DEFAULT NULL,
  value decimal(10, 2) DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 68,
AVG_ROW_LENGTH = 268,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `settings_history`
--
CREATE TABLE settings_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  parameter varchar(50) DEFAULT NULL,
  description varchar(300) DEFAULT NULL,
  value varchar(300) DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 23,
AVG_ROW_LENGTH = 1024,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `settings`
--
CREATE TABLE settings (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  parameter varchar(50) NOT NULL COMMENT 'наименование параметра',
  description varchar(300) NOT NULL COMMENT 'описание параметра',
  value text NOT NULL COMMENT 'значение параметра',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 4,
AVG_ROW_LENGTH = 8192,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'настройки сервиса';

--
-- Создать индекс `parameter` для объекта типа таблица `settings`
--
ALTER TABLE settings
ADD UNIQUE INDEX parameter (parameter);

--
-- Создать таблицу `payments_history`
--
CREATE TABLE payments_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  date timestamp NULL DEFAULT NULL,
  type int(11) DEFAULT NULL,
  user int(11) DEFAULT NULL,
  sum decimal(10, 2) DEFAULT NULL,
  place varchar(500) DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 22,
AVG_ROW_LENGTH = 780,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `news_history`
--
CREATE TABLE news_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  date timestamp NULL DEFAULT NULL,
  title varchar(200) DEFAULT NULL,
  preview varchar(500) DEFAULT NULL,
  text text DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 65,
AVG_ROW_LENGTH = 273,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `news`
--
CREATE TABLE news (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'дата создания',
  title varchar(200) NOT NULL COMMENT 'заголовок',
  preview varchar(500) NOT NULL COMMENT 'краткое описание',
  text text NOT NULL COMMENT 'текст',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 2,
AVG_ROW_LENGTH = 16384,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'новости';

--
-- Создать таблицу `messages_history`
--
CREATE TABLE messages_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  date timestamp NULL DEFAULT NULL,
  recipient int(11) DEFAULT NULL,
  sender int(11) DEFAULT NULL,
  subject varchar(200) DEFAULT NULL,
  text text DEFAULT NULL,
  reading tinyint(1) DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 114,
AVG_ROW_LENGTH = 799,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `measurements_history`
--
CREATE TABLE measurements_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  date timestamp NULL DEFAULT NULL,
  type int(11) DEFAULT NULL,
  user int(11) DEFAULT NULL,
  value decimal(10, 2) DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 38,
AVG_ROW_LENGTH = 481,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `feedbacks_history`
--
CREATE TABLE feedbacks_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  date timestamp NULL DEFAULT NULL,
  message int(11) DEFAULT NULL,
  type tinyint(1) DEFAULT NULL,
  user int(11) DEFAULT NULL,
  text varchar(500) DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 168,
AVG_ROW_LENGTH = 116,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `documents_history`
--
CREATE TABLE documents_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  date timestamp NULL DEFAULT NULL,
  description varchar(500) DEFAULT NULL,
  file varchar(300) DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 50,
AVG_ROW_LENGTH = 442,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `documents`
--
CREATE TABLE documents (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'дата добавления',
  description varchar(500) NOT NULL COMMENT 'описание',
  file varchar(500) NOT NULL COMMENT 'имя файла',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 15,
AVG_ROW_LENGTH = 4096,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'документы';

--
-- Создать таблицу `discussions_history`
--
CREATE TABLE discussions_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  date_create timestamp NULL DEFAULT NULL,
  date_update datetime DEFAULT NULL,
  type tinyint(1) DEFAULT NULL,
  parent int(11) DEFAULT NULL,
  user int(11) DEFAULT NULL,
  title varchar(300) DEFAULT NULL,
  text text DEFAULT NULL,
  hidden tinyint(1) DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 257,
AVG_ROW_LENGTH = 199,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `contacts_history`
--
CREATE TABLE contacts_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  fio varchar(200) DEFAULT NULL,
  telephone varchar(100) DEFAULT NULL,
  email varchar(100) DEFAULT NULL,
  address varchar(300) DEFAULT NULL,
  time varchar(300) DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 11,
AVG_ROW_LENGTH = 1820,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `contacts`
--
CREATE TABLE contacts (
  id int(11) NOT NULL AUTO_INCREMENT COMMENT 'код',
  fio varchar(200) NOT NULL COMMENT 'Ф.И.О.',
  telephone varchar(100) NOT NULL COMMENT 'телефон',
  email varchar(100) NOT NULL COMMENT 'email',
  address varchar(300) NOT NULL COMMENT 'адрес',
  time varchar(300) NOT NULL COMMENT 'часы приема',
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 2,
AVG_ROW_LENGTH = 16384,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'контакты правления';

--
-- Создать таблицу `blocks_history`
--
CREATE TABLE blocks_history (
  code int(11) NOT NULL AUTO_INCREMENT,
  id int(11) DEFAULT NULL,
  date_start datetime DEFAULT NULL,
  date_end datetime DEFAULT NULL,
  user int(11) DEFAULT NULL,
  moderator int(11) DEFAULT NULL,
  reason varchar(500) DEFAULT NULL,
  history_type tinyint(1) DEFAULT NULL,
  history_user varchar(50) DEFAULT NULL,
  history_host varchar(50) DEFAULT NULL,
  history_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code)
)
ENGINE = INNODB,
AUTO_INCREMENT = 46,
AVG_ROW_LENGTH = 481,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

DELIMITER $$

--
-- Создать процедуру `subject_messages`
--
CREATE PROCEDURE subject_messages (IN subject int)
BEGIN
  DECLARE ids text DEFAULT '';

  SET @parents = subject;
  SET ids = subject;

loop1:
  LOOP
    SET @stm = CONCAT(
    'SELECT GROUP_CONCAT(id) INTO @parents 
             FROM discussions 
             WHERE parent IN (', @parents, ') 
                AND type = 3'
    );

    PREPARE fetch_childs FROM @stm;
    EXECUTE fetch_childs;
    DROP PREPARE fetch_childs;

    IF @parents IS NULL THEN
      LEAVE loop1;
    END IF;

    SET ids = CONCAT(ids, ',', @parents);
  END LOOP;

  SET @stm = CONCAT('SELECT 
                          ds.id, 
                          ds.date_create, 
                          ds.date_update, 
                          ds.parent, 
                          ds.user as user_id,
                          us_message.username, 
                          ds.text,
                          ds_parent.text AS parent_text,
                          us_parent.username AS parent_username,
                          COUNT(fb_positive.id) AS positive,
                          COUNT(fb_negative.id) AS negative
                       FROM discussions ds 
                       INNER JOIN users us_message ON ds.user = us_message.id 
                       LEFT JOIN discussions ds_parent ON ds.parent = ds_parent.id
                       INNER JOIN users us_parent ON ds_parent.user = us_parent.id
                       LEFT JOIN feedbacks fb_positive ON fb_positive.message = ds.id AND fb_positive.type = 2
                       LEFT JOIN feedbacks fb_negative ON fb_negative.message = ds.id AND fb_negative.type = 3
                       WHERE ds.id IN (', ids, ') 
                          AND ds.type = 3
                       GROUP BY ds.id, 
                          ds.date_create, 
                          ds.date_update, 
                          ds.parent, 
                          us_message.username, 
                          ds.text,
                          ds_parent.text
                       ORDER BY date_create ASC');

  PREPARE fetch_childs FROM @stm;
  EXECUTE fetch_childs;
  DROP PREPARE fetch_childs;
END
$$

DELIMITER ;

-- 
-- Вывод данных для таблицы users
--
INSERT INTO users VALUES
(1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 17:09:59', 'ROLE_SUPER_ADMIN'),
(2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:18:43', 'ROLE_ADMIN'),
(3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-05-14 16:03:14', 'ROLE_USER'),
(4, 'Sidorov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, '11@sss.err', '11111', NULL, 'Сидоров Александр Александрович', '3', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_USER');

-- 
-- Вывод данных для таблицы tariffs_types
--
INSERT INTO tariffs_types VALUES
(5, 'вода', 1),
(6, 'земля', 0),
(7, 'свет', 1);

-- 
-- Вывод данных для таблицы discussions
--
INSERT INTO discussions VALUES
(45, '2018-04-10 09:30:37', NULL, 1, NULL, 1, 'Работа сайта', 'Технический раздел', 0),
(46, '2018-04-10 09:30:52', NULL, 1, NULL, 1, 'Основной раздел', 'Общие темы', 0),
(47, '2018-04-10 09:31:23', '2018-04-10 10:20:26', 1, NULL, 1, 'Газопровод', 'Здесь обсуждаем вопросы, связанные с проведением газопровода', 1),
(48, '2018-04-10 09:31:55', NULL, 2, 45, 1, 'Общие вопросы (FAQ)', NULL, 0),
(49, '2018-04-10 09:32:10', '2018-04-10 10:20:41', 2, 45, 1, 'Ошибки работы', NULL, 1),
(50, '2018-04-10 09:32:23', '2018-04-10 10:20:48', 2, 45, 1, 'Ваши пожелания по функционалу', NULL, 1),
(52, '2018-04-10 10:19:46', '2018-04-10 10:21:08', 2, 46, 1, 'Позвольте представиться', NULL, 1),
(53, '2018-04-10 10:20:08', NULL, 2, 47, 1, 'Участники', NULL, 0),
(54, '2018-04-10 10:40:46', NULL, 3, 48, 1, NULL, 'Сообщение 1', 0),
(55, '2018-04-10 10:57:21', '2018-04-12 15:41:47', 3, 48, 2, NULL, 'Сообщение 2', 0),
(56, '2018-04-10 11:50:43', NULL, 3, 48, 3, NULL, 'Сообщение 3', 0),
(57, '2018-04-10 12:31:18', NULL, 3, 55, 1, NULL, 'Ответ на сообщение 2', 0);

-- 
-- Вывод данных для таблицы users_history
--
INSERT INTO users_history VALUES
(1, 1, 'Gutowski', '12345', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', '', 1, 'root', 'localhost', '2018-02-20 10:57:43'),
(2, 1, 'Gutowski', '$2a$04$Bf1L2cNfJX5fpXejWSadEOWhHh6sa7GQ9z7aK3M3gxhZvGJC826mK', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', '', 2, 'root', 'localhost', '2018-02-21 10:57:09'),
(3, 1, 'Gutowski', '$2a$04$Bf1L2cNfJX5fpXejWSadEOWhHh6sa7GQ9z7aK3M3gxhZvGJC826mK', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', '', 2, 'root', 'localhost', '2018-02-21 10:57:10'),
(4, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', '', 2, 'root', 'localhost', '2018-02-21 11:06:45'),
(5, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', '', 2, 'root', 'localhost', '2018-02-21 11:06:45'),
(6, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', '', 2, 'root', 'localhost', '2018-02-21 13:29:47'),
(7, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', '', 2, 'root', 'localhost', '2018-02-21 13:30:11'),
(8, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-02-22 09:31:36'),
(9, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', '', 2, 'root', 'localhost', '2018-02-22 09:51:57'),
(10, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', '', 2, 'root', 'localhost', '2018-02-22 09:51:57'),
(11, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-02-22 09:57:12'),
(12, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-02-22 09:57:12'),
(13, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', '', 2, 'root', 'localhost', '2018-02-22 10:26:20'),
(14, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', '', 2, 'root', 'localhost', '2018-02-22 10:26:20'),
(15, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', NULL, 2, 'root', 'localhost', '2018-02-22 10:27:22'),
(16, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-02-22 11:00:04'),
(17, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', NULL, 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-02-22 11:00:05'),
(18, 2, 'test', '$2y$13$hh/U5te5k8Yh2u8ZOs5V0Oq5HdkvNV76mYck6u5H2BsJ43WOo.Vcu', NULL, 'test@test.test', 'test', NULL, 'test', 'test', NULL, '2018-02-22 14:53:56', NULL, NULL, 1, 'root', 'localhost', '2018-02-22 14:53:56'),
(19, 2, 'test', '$2y$13$hh/U5te5k8Yh2u8ZOs5V0Oq5HdkvNV76mYck6u5H2BsJ43WOo.Vcu', NULL, 'test@test.test', 'test', NULL, 'test', 'test', NULL, '2018-02-22 14:53:56', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-02-22 14:54:42'),
(20, 2, 'test', '$2y$13$hh/U5te5k8Yh2u8ZOs5V0Oq5HdkvNV76mYck6u5H2BsJ43WOo.Vcu', NULL, 'test@test.test', 'test', NULL, 'test', 'test', NULL, '2018-02-22 14:53:56', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-02-22 14:54:42'),
(21, 3, 'test2', '$2y$13$yCHsyH9OsRgDz/9M0.IJy.XgE5CwjjePGqu2kY6HBjW4K6gjnDCP2', NULL, 'test2@test2.test2', 'test2', NULL, 'test2', 'test2', NULL, '2018-02-26 14:58:09', NULL, NULL, 1, 'root', 'localhost', '2018-02-26 14:58:10'),
(22, 3, 'test2', '$2y$13$yCHsyH9OsRgDz/9M0.IJy.XgE5CwjjePGqu2kY6HBjW4K6gjnDCP2', NULL, 'test2@test2.test2', 'test2', NULL, 'test2', 'test2', NULL, '2018-02-26 14:58:09', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-02-26 14:58:36'),
(23, 4, '111111', '$2y$13$1FS5Cn4FT7x8cWDxLbz/YO5xmqUwJEerKpqjgTBZrBgpjvQYLN/oG', NULL, '11@sss.err', '11111', NULL, '1111', '11111', NULL, '2018-03-12 10:13:55', NULL, NULL, 1, 'root', 'localhost', '2018-03-12 10:13:56'),
(24, 4, '111111', '$2y$13$1FS5Cn4FT7x8cWDxLbz/YO5xmqUwJEerKpqjgTBZrBgpjvQYLN/oG', NULL, '11@sss.err', '11111', NULL, '1111', '11111', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-03-12 10:14:16'),
(25, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', '123', 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 10:34:46'),
(26, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', '123', 'Гутовская Ольга Александровна', '0', NULL, '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 10:34:46'),
(27, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', '123', 'Гутовская Ольга Александровна', '0', '1', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 10:35:03'),
(28, 1, 'Gutowski', '1234567', NULL, 'fny2004@mail.ru', '111', '123', 'Гутовская Ольга Александровна', '0', '12', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 10:38:09'),
(29, 1, 'Gutowski', '$2y$13$1FS5Cn4FT7x8cWDxLbz/YO5xmqUwJEerKpqjgTBZrBgpjvQYLN/oG', NULL, 'fny2004@mail.ru', '111', '123', 'Гутовская Ольга Александровна', '0', '12', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:09:00'),
(30, 1, 'Gutowski', '', NULL, 'fny2004@mail.ru', '111', '123', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:10:18'),
(31, 1, 'Gutowski', '', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:10:31'),
(32, 1, 'Gutowski', '1234567', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:10:43'),
(33, 1, 'Gutowski', '$2y$13$1FS5Cn4FT7x8cWDxLbz/YO5xmqUwJEerKpqjgTBZrBgpjvQYLN/oG', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:15:44'),
(34, 1, 'Gutowski', '$2y$13$1FS5Cn4FT7x8cWDxLbz/YO5xmqUwJEerKpqjgTBZrBgpjvQYLN/oG', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:15:44'),
(35, 1, 'Gutowski', '$2y$13$ltUwCjsf1xn.9aS2U3bcAO4SpJ5iG6/gXRilBghJRKIHz6bDg//v2', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:16:03'),
(36, 1, 'Gutowski', '$2y$13$p74QG3ldgvmAU/GmWg8lz.gFmihZTBfRu3p4PAr5LVaUUhhMeBlVG', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:17:36'),
(37, 1, 'Gutowski', '$2y$13$jBJ1P9FCEeI8NLRIM4FWI.efPcSsffG.Jzcjp5wz6UZE/uKplqhZq', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:17:47'),
(38, 1, 'Gutowski', '$2y$13$y9YwuvrYRsIvSbiaZhEv7O3VdbDqPcC8kNUp6ZBsBL5XvlMcZ.QBK', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:21:51'),
(39, 1, 'Gutowski', '$2y$13$.WhYA7/Gm8pdpOkJoVdUeOl1mboiWIoFcSy/GqCSvZ4Zy8HqCNd6S', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:23:24'),
(40, 1, 'Gutowski', '$2y$13$1FS5Cn4FT7x8cWDxLbz/YO5xmqUwJEerKpqjgTBZrBgpjvQYLN/oG', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:23:48'),
(41, 1, 'Gutowski', '$2y$13$U3/Qpb5we/EaSWotq3YnZeAJmQZhXO28SUe1a5FsWVK/UPlB5brw.', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:24:09'),
(42, 1, 'Gutowski', '$2y$13$cHSLC5O3CWH16qGdzouSlOKfwC1LfjhEV2IDwV2qteOj4LDyMlOaK', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:25:13'),
(43, 1, 'Gutowski', '$2y$13$DKpdAHIzRzf8jKH6wYfCRu0bILxSyQliL/OjVkVXjkhGf/Nd7cXjC', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:25:24'),
(44, 1, 'Gutowski', '$2y$13$L8VupH.fudqgsSq/LYN.0esG7/1oso.Cf3McfSom./LGYXMp50pCe', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:25:42'),
(45, 1, 'Gutowski', '$2y$13$m1xYw.j5vs6uQXghaYMJtuW5sG1kUHsHUxuAxbjc7WqgdU3UwFdKS', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:26:06'),
(46, 1, 'Gutowski', '$2y$13$Hk81boyaDb8oQZonBjJkK.Mqlp6Sv/zaBmbWa1NMXAztQAYpSVsTe', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:26:37'),
(47, 1, 'Gutowski', '1234567', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:42:44'),
(48, 1, 'Gutowski', '$2y$13$iM6i1/QmAXB/zz9FBdjQ0O/AcsJJZYSsnlUi0i8osjDkmxxPdIOiO', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 11:54:17'),
(49, 1, 'Gutowski', '$2y$13$OwFD4bWt.wqFspr.2j8fmeipPV.WggzMMkpRm59GFmSlpOyATiKW2', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:31:00'),
(50, 1, 'Gutowski', '$2y$13$EkG/AUH8wwOzZCvlKy9aK.bDvM4oQyrjZp159ob3Nu0fowq3mG6Tq', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:32:26'),
(51, 1, 'Gutowski', '$2y$13$t5WJW2T57LDGgm7aQR5NB.0Mhz6fNEa5nhFQ3gkYQfruFyDq/AAKe', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:34:49'),
(52, 1, 'Gutowski', '$2y$13$1FS5Cn4FT7x8cWDxLbz/YO5xmqUwJEerKpqjgTBZrBgpjvQYLN/oG', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:35:00'),
(53, 1, 'Gutowski', '$2y$13$GfNXviETdgh3A3MzVgoSVOVZoHPz4gDHfRUJDCkjsHEdYTgFLtNnm', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:35:09'),
(54, 1, 'Gutowski', '$2y$13$LNVAUpcp/ML1hkdI7kcaju1gIF9sWukGZx0V0Tvq1pH5yBkMykhUK', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:37:42'),
(55, 1, 'Gutowski', '$2y$13$W22toYefnJIT1ONt7HNMteno7uCHIcUa908N/9fTaBwT3iho/WH/u', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:40:55'),
(56, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:41:44'),
(57, 4, '111111', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, '11@sss.err', '11111', NULL, '1111', '11111', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-03-12 12:42:01'),
(58, 1, 'Gutowski', '$2y$13$jzZyppyi8q.6K.dgTZXUQuvOaifaqlyHDts/pnEoYY2DOSgtcX.dq', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:42:35'),
(59, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:43:41'),
(60, 1, 'Gutowski', '$2y$13$vidgusBHH1djuc/AE/jVPOL6mpsjiBo5P4znp3FsA/5gLWw4/65QK', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:44:11'),
(61, 1, 'Gutowski', '', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:44:17'),
(62, 1, 'Gutowski', '$2y$13$kBYGKxr6kTA7dpKkzyRZG.Lo2Y2LmCFvQtQ9jEokRkwYe9qJmWaLy', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:44:28'),
(63, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:45:33'),
(64, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:45:33'),
(65, 1, 'Gutowski', '$2y$13$dOn9a7./wmIUnLfX.N69l.GFttX7pNWQKhcVHyaEdMk53ZfF14j9W', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:45:49'),
(66, 1, 'Gutowski', '', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:45:54'),
(67, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:46:36'),
(68, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:46:36'),
(69, 1, 'Gutowski', '$2y$13$s1jFQrzzUDatTil7b6c2c.ww24k5KED5chv2WtEAxNF0PdyexJuP2', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:46:52'),
(70, 1, 'Gutowski', '$2y$13$UKPOCGNq8Vepdm3Xj9qKO.5ubnx2AzgGrsCcXQlsHQlj.W1FSUP7a', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:49:34'),
(71, 1, 'Gutowski', '$2y$13$6Bl0dU19IKE15qm/N33uVuUPk1hp8ZYd57ht51IiHjoz4lsyCrSEC', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:52:56'),
(72, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:53:36'),
(73, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny2004@mail.ru', '111', '12345', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:53:36'),
(74, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny2004@mail.ru', '111', '12', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:54:01'),
(75, 1, 'Gutowski', '$2y$13$W1XAjdQDr50C5BOXDFqsb.gCDDF9CeH8UahSCSyyXYAdKEXwUofCe', NULL, 'fny2004@mail.ru', '111', '12', 'Гутовская Ольга Александровна', '0', '123', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-12 12:54:20'),
(76, 1, 'Gutowski', '$2y$13$W1XAjdQDr50C5BOXDFqsb.gCDDF9CeH8UahSCSyyXYAdKEXwUofCe', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '00', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-13 12:49:37'),
(77, 1, 'Gutowski', '$2y$13$deBsWPEKUpH6NgKK4AMC2.TMCD3Yp7FD2s4cxFDp1FSXpbvtOX4rq', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '00', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-27 15:43:49'),
(78, 1, 'Gutowski', '1111111', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '00', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-27 15:55:48'),
(79, 1, 'Gutowski', '$2y$13$deBsWPEKUpH6NgKK4AMC2.TMCD3Yp7FD2s4cxFDp1FSXpbvtOX4rq', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '00', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-27 16:17:36'),
(80, 1, 'Gutowski', '$2y$13$l/bPY.hGigO/QYz6mRWkXe0.DzK18Y7RzfGUZRTMmbzT.uR4FK8A.', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '000', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-27 16:37:31'),
(81, 1, 'Gutowski', '', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '000', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 09:53:56'),
(82, 1, 'Gutowski', '1234567', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '000', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 09:55:59'),
(83, 1, 'Gutowski', '1234567', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '000', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 09:55:59'),
(84, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '000', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 09:56:15'),
(85, 1, 'Gutowski', '$2y$13$0mnTKxqW.gk1lu6wjI0Gqe/M0nYhrnqRGdpAe.uEcMUsonqNyHWyi', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '000', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:01:05'),
(86, 1, 'Gutowski', '$2y$13$erAXndr0gmlAevsADd0I/OSmPaQCi7iD.Ql67vDzMHbDOzCsMJgIm', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '000', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:01:19'),
(87, 1, 'Gutowski', '$2y$13$Yh2cMLOX.FUYcFap/ZhWU.sYgSAii7Y6K1qwGijC/WdjI.FVK48yC', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '000', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:01:28'),
(88, 1, 'Gutowski', '', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '000', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:03:42'),
(89, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '000', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:09:58'),
(90, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '000', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:09:58'),
(91, 1, 'Gutowski', '$2y$13$UAK.idReqRRNip21ytTTPeJEULmouXHvOVxAD00iE6QWN1fX6bJlu', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:11:08'),
(92, 1, 'Gutowski', '$2y$13$H83xO.hCFoJtjFYKK2PzIO.HhdBo9jUm/iDG1b4SdIfZA9CJe./Eq', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:14:01'),
(93, 1, 'Gutowski', '1234567', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:15:33'),
(94, 1, 'Gutowski', '1111111', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:20:01'),
(95, 1, 'Gutowski', '1234567', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:20:10'),
(96, 1, 'Gutowski', '1111111', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:26:25'),
(97, 1, 'Gutowski', '1234567', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:52:13'),
(98, 1, 'Gutowski', '0000', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:54:33'),
(99, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:58:13'),
(100, 1, 'Gutowski', '$2y$13$uiEjHQnbDQQYouBfTBAFp.yvqJjb/lBjGwKZNnK.gUfzBpVo4J1YW', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 10:58:13'),
(101, 1, 'Gutowski', '1234567', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 11:02:28'),
(102, 1, 'Gutowski', '$2y$15$lYTR66VLbLp9JtZxaKWqROXtNggWRyKAMQnujYNSHOzEhvaKpq9fm', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 11:15:40'),
(103, 1, 'Gutowski', '$2y$15$sQE.CaAeh27yXWhhpz7qW.Xe.BVM9.IZYykDf9/IxfUFU2egr77te', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 11:16:01'),
(104, 1, 'Gutowski', '$2y$15$8udlhE08XOIXV4XLcle63eb2aBAbv43vWPIddis9dYlLwQMtCNYOG', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 11:16:08'),
(105, 1, 'Gutowski', '1234567', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 11:16:37'),
(106, 1, 'Gutowski', '12345678', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '01', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 11:18:48'),
(107, 1, 'Gutowski', '12345678', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 11:21:18'),
(108, 1, 'Gutowski', '1234567', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 11:21:36'),
(109, 1, 'Gutowski', '12345678', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 11:22:53'),
(110, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny20040@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 11:23:46'),
(111, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 13:06:59'),
(112, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 13:06:59'),
(113, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', '_YilscCbepFaELtbOERpMpzn7303pPFJOwfC1zsyszo', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:09:13'),
(114, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:13:32'),
(115, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', 'bHyA7ndO3ljogHg4w1WWsKRkeNN_kW2G8AJKxo113q4', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:13:39'),
(116, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:14:05'),
(117, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', 'sCRminRM2L9dTNHZyBze4vYq4U1miigKBKCsVrjfn1M', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:14:34'),
(118, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:15:22'),
(119, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', 'Ef6B2zeWDpu00WjqQOyiGBqw1pr53VOtffkryQPshKc', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:15:27'),
(120, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:30:12'),
(121, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', 'X3p8Llui46aDyNX3Kf0ybyyvAx58VJLJ1jp6Mx8Y81Y', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:30:19'),
(122, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:31:18'),
(123, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', 'h_1ObJQBl9uMrGxhzzJQCXiFcY5F1rw2Syn6AGKj5FQ', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:31:26'),
(124, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:32:02'),
(125, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', 'jjBIZNV_AtmLtrsmOKpizRURWfYugNkiQRdziilzP2A', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:32:12'),
(126, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:37:07'),
(127, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', 'wPUGa244inVoBZze3RbX3IkVvac-HXz8I113sjpheuY', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:37:13'),
(128, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:43:01'),
(129, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', 'D3h-eVLV5o_auNxV_7TMZrOKTI47ygzogOfL1HkgcqU', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 14:43:06'),
(130, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 15:03:37'),
(131, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', '4OSN38TnRjyMEtYvnHbMc5pfXO1MHFFrGZjfDU5F5w4', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 15:14:29'),
(132, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 15:50:18'),
(133, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', '45tAHjNw2_vBRW5DeyYBj3lXZM7VspKVxlSF92aYo-o', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 15:55:26'),
(134, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 16:18:11'),
(135, 1, 'Gutowski', '$2y$15$HHkX2CymRrHve3PKDBuz1u2zz8GtkVLCoS67ca02vPBZmZzDPdTR6', '480tbU8xMVmfA0MqZs4KCCCIAj9wD0gzatuZTYT2d9Q', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 16:18:33'),
(136, 1, 'Gutowski', '$2y$15$9cKAAMH1fh3RsjxfO4atFevFGpJwHtB.QkW4YGuzJBiChmKrlYxIa', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 16:20:31'),
(137, 1, 'Gutowski', '$2y$15$28gCEdII32fmEem3nYU/eOz0b4UkG9IkujHOhoj7LNoFq0qTg7VNe', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-03-28 16:21:41'),
(138, 1, 'Gutowski', '$2y$15$28gCEdII32fmEem3nYU/eOz0b4UkG9IkujHOhoj7LNoFq0qTg7VNe', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '0117', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-04 11:24:24'),
(139, 1, 'Gutowski', '$2y$15$28gCEdII32fmEem3nYU/eOz0b4UkG9IkujHOhoj7LNoFq0qTg7VNe', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-04 11:25:10'),
(140, 1, 'Gutowski', '$2y$15$28gCEdII32fmEem3nYU/eOz0b4UkG9IkujHOhoj7LNoFq0qTg7VNe', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '0117', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-04 11:25:27'),
(141, 1, 'Gutowski', '$2y$15$28gCEdII32fmEem3nYU/eOz0b4UkG9IkujHOhoj7LNoFq0qTg7VNe', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-04 11:26:21'),
(142, 1, 'Gutowski', '$2y$15$28gCEdII32fmEem3nYU/eOz0b4UkG9IkujHOhoj7LNoFq0qTg7VNe', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '0118', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-04 11:26:30'),
(143, 1, 'Gutowski', '$2y$15$28gCEdII32fmEem3nYU/eOz0b4UkG9IkujHOhoj7LNoFq0qTg7VNe', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-04 16:31:17'),
(144, 1, 'Gutowski', '$2y$15$28gCEdII32fmEem3nYU/eOz0b4UkG9IkujHOhoj7LNoFq0qTg7VNe', 'EsN7bmYpEwDwBPhIf9f09femJZQ20BHI9IGJggWUjhM', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-11 12:58:25'),
(145, 1, 'Gutowski', '$2y$15$28gCEdII32fmEem3nYU/eOz0b4UkG9IkujHOhoj7LNoFq0qTg7VNe', 'oLmuzDoPC75CW0GGQcNe0I9rT7uxxhtMxPu85Wi8Zi0', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-11 12:59:06'),
(146, 1, 'Gutowski', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', 'oLmuzDoPC75CW0GGQcNe0I9rT7uxxhtMxPu85Wi8Zi0', 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-12 15:24:37'),
(147, 2, 'test', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'test@test.test', 'test', NULL, 'test', 'test', NULL, '2018-02-22 14:53:56', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-12 15:24:55'),
(148, 3, 'test2', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'test2@test2.test2', 'test2', NULL, 'test2', 'test2', NULL, '2018-02-26 14:58:09', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-12 15:24:56'),
(149, 4, '111111', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, '11@sss.err', '11111', NULL, '1111', '11111', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-12 15:24:57'),
(150, 1, 'Gutowski', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'fny2004@mail.ru', '1110', '120', 'Гутовская Ольга Александровна', '011', '1230', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-12 15:25:03'),
(151, 2, 'test', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'test@test.test', 'test', NULL, 'test', 'test', NULL, '2018-02-22 14:53:56', NULL, 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-12 15:25:35'),
(152, 2, 'test', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'test@test.test', 'test', NULL, 'test', 'test', NULL, '2018-02-22 14:53:56', NULL, 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-12 15:25:35'),
(153, 1, 'Gutowski', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'info@gutowski.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', '0', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-12 15:27:18'),
(154, 2, 'Ivanov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'test@test.test', 'test', NULL, 'test', 'test', NULL, '2018-02-22 14:53:56', NULL, 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-12 15:28:09'),
(155, 3, 'Pertov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'test2@test2.test2', 'test2', NULL, 'test2', 'test2', NULL, '2018-02-26 14:58:09', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-12 15:28:19'),
(156, 4, 'Sidorov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, '11@sss.err', '11111', NULL, '1111', '11111', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-12 15:28:23'),
(157, 2, 'Ivanov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', 'test', NULL, '2018-02-22 14:53:56', NULL, 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-12 15:28:44'),
(158, 3, 'Pertov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', 'test2', NULL, '2018-02-26 14:58:09', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-12 15:28:52'),
(159, 4, 'Sidorov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, '11@sss.err', '11111', NULL, 'Сидоров Александр Александрович', '11111', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-12 15:29:03'),
(160, 2, 'Ivanov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', NULL, 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-12 15:29:06'),
(161, 3, 'Pertov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-12 15:29:07'),
(162, 4, 'Sidorov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, '11@sss.err', '11111', NULL, 'Сидоров Александр Александрович', '3', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-12 15:29:09'),
(163, 1, 'Gutowski', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', '0', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-13 13:49:29'),
(164, 1, 'Gutowski', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', 'PnlfeWGQZKDQKBIe3AtVi5-4jfdVPTE6kb_5DkyW-jE', 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', '0', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-13 13:49:34'),
(165, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', '0', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-13 13:50:06'),
(166, 4, 'Sidorov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, '11@sss.err', '11111', NULL, 'Сидоров Александр Александрович', '3', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-19 09:31:38'),
(167, 4, 'Sidorov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, '11@sss.err', '11111', NULL, 'Сидоров Александр Александрович', '3', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-19 09:31:45'),
(168, 4, 'Sidorov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, '11@sss.err', '11111', NULL, 'Сидоров Александр Александрович', '3', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-19 09:31:49'),
(169, 4, 'Sidorov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, '11@sss.err', '11111', NULL, 'Сидоров Александр Александрович', '3', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-19 09:31:51'),
(170, 5, 'test', '777', NULL, '777@test.test', '7777', NULL, '77777', '7', NULL, '2018-04-19 09:39:30', NULL, NULL, 1, 'root', 'localhost', '2018-04-19 09:39:33'),
(171, 5, 'test', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, '777@test.test', '7777', NULL, '77777', '7', NULL, '2018-04-19 09:39:30', NULL, NULL, 2, 'root', 'localhost', '2018-04-19 09:39:50'),
(172, 5, 'test', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, '777@test.test', '7777', NULL, '77777', '7', NULL, '2018-04-19 09:39:30', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-19 09:42:06'),
(173, 5, 'test', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, '777@test.test', '7777', NULL, '77777', '7', NULL, '2018-04-19 09:39:30', NULL, 'ROLE_USER', 3, 'root', 'localhost', '2018-04-19 09:54:42'),
(174, 4, 'Sidorov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, '11@sss.err', '11111', NULL, 'Сидоров Александр Александрович', '3', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-19 14:37:13'),
(175, 4, 'Sidorov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, '11@sss.err', '11111', NULL, 'Сидоров Александр Александрович', '3', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-19 14:37:17'),
(176, 4, 'Sidorov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, '11@sss.err', '11111', NULL, 'Сидоров Александр Александрович', '3', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-19 15:17:57'),
(177, 4, 'Sidorov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, '11@sss.err', '11111', NULL, 'Сидоров Александр Александрович', '3', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-19 15:18:00'),
(178, 7, 'test', 'ddddd', NULL, 'ddas@cfdf.rte', 'd', NULL, 'd', '7', NULL, '2018-04-20 14:35:37', NULL, NULL, 1, 'root', 'localhost', '2018-04-20 14:35:38'),
(179, 7, 'test', 'ddddd', NULL, 'ddas@cfdf.rte', 'd', NULL, 'd', '7', NULL, '2018-02-25 14:35:37', NULL, NULL, 2, 'root', 'localhost', '2018-04-20 14:35:51'),
(180, 7, 'test', 'ddddd', NULL, 'ddas@cfdf.rte', 'd', NULL, 'd', '7', NULL, '2018-02-25 14:35:37', NULL, NULL, 3, 'root', 'localhost', '2018-04-20 14:36:12'),
(181, 8, 'ddd', 'ddd', NULL, 'ddd@fdsf.dfg', 's', NULL, 's', '', NULL, '2018-04-20 14:37:06', NULL, NULL, 1, 'root', 'localhost', '2018-04-20 14:37:06'),
(182, 8, 'ddd', 'ddd', NULL, 'ddd@fdsf.dfg', 's', NULL, 's', '', NULL, '2018-02-25 14:37:06', NULL, NULL, 2, 'root', 'localhost', '2018-04-20 14:37:16'),
(183, 8, 'ddd', 'ddd', NULL, 'ddd@fdsf.dfg', 's', NULL, 's', '', NULL, '2018-02-25 14:37:06', NULL, NULL, 3, 'root', 'localhost', '2018-04-20 14:37:32'),
(184, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-02-20 10:57:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 13:33:26'),
(185, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:34:36', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:34:36'),
(186, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:34:46', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:34:46'),
(187, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:34:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:34:51'),
(188, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:35:11', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:35:11'),
(189, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:35:24', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:35:24'),
(190, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:36:38', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:36:38'),
(191, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:37:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:37:32'),
(192, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:39:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:39:58'),
(193, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:40:26', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:40:26'),
(194, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:43:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:43:52'),
(195, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:46:15', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:46:15'),
(196, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:46:17', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:46:17'),
(197, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:46:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:46:21'),
(198, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:46:26', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:46:26'),
(199, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-23 15:47:26', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-23 15:47:26'),
(200, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-25 10:08:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-25 10:08:58'),
(201, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-25 10:09:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-25 10:09:03'),
(202, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-25 10:09:05', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-25 10:09:05'),
(203, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-25 10:09:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-25 10:09:07'),
(204, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-25 10:09:16', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-25 10:09:16'),
(205, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 11:59:18', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 11:59:18'),
(206, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 11:59:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 11:59:21'),
(207, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 11:59:23', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 11:59:23'),
(208, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:00:28', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:00:28'),
(209, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:02:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:02:32'),
(210, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:03:28', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:03:28'),
(211, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:03:34', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:03:34'),
(212, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:03:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:03:51'),
(213, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:03:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:03:58'),
(214, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:04:02', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:04:02'),
(215, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:04:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:04:07'),
(216, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:04:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:04:32'),
(217, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:04:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:04:37'),
(218, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:04:42', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:04:42'),
(219, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:04:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:04:49'),
(220, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:04:57', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:04:57'),
(221, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:05:01', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:05:01'),
(222, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:05:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:05:06'),
(223, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:05:09', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:05:09'),
(224, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:05:33', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:05:33'),
(225, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:05:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:05:51'),
(226, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:06:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:06:07'),
(227, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:06:11', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:06:11'),
(228, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:06:17', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:06:17'),
(229, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:06:23', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:06:23'),
(230, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:06:27', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:06:27'),
(231, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:06:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:06:29'),
(232, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:06:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:06:32'),
(233, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:06:34', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:06:34'),
(234, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:07:33', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:07:33'),
(235, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:07:47', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:07:47'),
(236, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:07:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:07:52'),
(237, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:08:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:08:00'),
(238, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:08:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:08:07'),
(239, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:12:14', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:12:14'),
(240, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:12:18', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:12:18'),
(241, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:13:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:13:30'),
(242, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:13:31', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:13:31'),
(243, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:13:33', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:13:33'),
(244, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:13:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:13:37'),
(245, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:19:05', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:19:05'),
(246, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:19:25', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:19:25'),
(247, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:19:40', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:19:40'),
(248, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:19:46', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:19:46'),
(249, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:19:54', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:19:54'),
(250, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7(985)223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:20:16', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:20:16'),
(251, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:20:16', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:20:27'),
(252, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7(978)101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:20:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:20:29'),
(253, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:20:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:20:37'),
(254, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:20:38', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:20:38'),
(255, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:20:56', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:20:56'),
(256, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:20:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:20:58'),
(257, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:21:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:21:03'),
(258, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:21:15', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:21:15'),
(259, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:21:20', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:21:20'),
(260, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:21:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:21:29'),
(261, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:21:55', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:21:55'),
(262, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:21:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:21:59'),
(263, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:22:05', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:22:05'),
(264, 3, 'Pertov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', NULL, 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:22:14'),
(265, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:22:15', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:22:15'),
(266, 3, 'Pertov', '$2y$15$qtg/o75F0B1dam0P.z.m1.Dq6/.kkC5Fh6fDUpPYSGvXWcYRlWJO6', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:22:23'),
(267, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:22:24', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:22:24'),
(268, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:22:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:22:30'),
(269, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:22:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:22:32'),
(270, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:22:36', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:22:36'),
(271, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:22:41', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:22:41'),
(272, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:22:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:22:52'),
(273, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:22:55', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:22:55'),
(274, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:00'),
(275, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:04'),
(276, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:06'),
(277, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:10', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:10'),
(278, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:13', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:13'),
(279, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:20', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:20'),
(280, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:23', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:23'),
(281, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:29'),
(282, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:34', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:34'),
(283, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:37'),
(284, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:41', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:41'),
(285, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:44', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:44'),
(286, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:49'),
(287, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:52'),
(288, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:56', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:56'),
(289, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:23:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:23:59'),
(290, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:24:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:24:21'),
(291, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:24:24', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:24:24'),
(292, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:24:28', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:24:28'),
(293, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:24:34', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:24:34'),
(294, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:24:41', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:24:41'),
(295, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:24:44', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:24:44'),
(296, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:24:46', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:24:46'),
(297, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:24:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:24:48'),
(298, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:24:53', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:24:53'),
(299, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:26:14', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:26:14'),
(300, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:26:16', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:26:16'),
(301, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:27:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:27:03'),
(302, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:27:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:27:08'),
(303, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:27:10', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:27:10'),
(304, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:27:14', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:27:14'),
(305, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:27:17', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:27:17'),
(306, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:27:22', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:27:22'),
(307, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:27:28', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:27:28'),
(308, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:27:33', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:27:33'),
(309, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:27:39', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:27:39'),
(310, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:27:46', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:27:46'),
(311, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:27:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:27:52'),
(312, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:27:55', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:27:55'),
(313, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:28:02', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:28:02'),
(314, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:28:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:28:04'),
(315, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:28:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:28:07'),
(316, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:28:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:28:08'),
(317, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:28:14', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:28:14'),
(318, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:28:17', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:28:17'),
(319, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:28:23', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:28:23'),
(320, 1, 'Gutowski', '$2y$15$ieF8WCfPljDvcBooMVrmYOOYLBS996e7XQ3QHjjkMUE.lKz4SUkXS', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:28:39', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:28:39'),
(321, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:28:39', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:28:48'),
(322, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:28:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:28:49'),
(323, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', NULL, 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:29:07'),
(324, 3, 'Pertov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:29:08'),
(325, 4, 'Sidorov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, '11@sss.err', '11111', NULL, 'Сидоров Александр Александрович', '3', NULL, '2018-03-12 10:13:55', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:29:09'),
(326, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:29:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:29:21'),
(327, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:29:40', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:29:40'),
(328, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:30:10', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:30:10'),
(329, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:31:11', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:31:11'),
(330, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:31:39'),
(331, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:31:39'),
(332, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:31:57', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:31:57'),
(333, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:32:01', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:32:01'),
(334, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 12:33:35', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:33:35'),
(335, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:36:06', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:36:06'),
(336, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:36:08', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:36:08'),
(337, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:36:10', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:36:10'),
(338, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:36:13', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:36:13'),
(339, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:36:25', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:36:25'),
(340, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:36:38', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:36:38'),
(341, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:36:47', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:36:47'),
(342, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:36:53', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:36:53'),
(343, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:36:56', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:36:56'),
(344, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:38:53', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:38:53'),
(345, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:38:57', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:38:57'),
(346, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:39:00', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:39:00'),
(347, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:39:05', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:39:05'),
(348, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:39:08', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:39:08'),
(349, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:39:25', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:39:25'),
(350, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:39:28', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:39:28'),
(351, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:39:30', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:39:30'),
(352, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:39:33', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:39:33'),
(353, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:39:36', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:39:36'),
(354, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:39:40', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:39:40'),
(355, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:39:42', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:39:42'),
(356, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:39:47', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:39:47'),
(357, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:39:49', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:39:49'),
(358, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:39:53', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:39:53'),
(359, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:39:57', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:39:57'),
(360, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:40:00', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:40:00'),
(361, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:40:03', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:40:03'),
(362, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:40:14', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:40:14'),
(363, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-04-26 12:40:20', 'ROLE_USER', 2, 'root', 'localhost', '2018-04-26 12:40:20'),
(364, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:40:28', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:40:28'),
(365, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:40:58', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:40:58'),
(366, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 12:49:14', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 12:49:14'),
(367, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:00:39', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:00:39'),
(368, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:00:56', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:00:56'),
(369, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:02:51', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:02:51'),
(370, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:03:18', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:03:18'),
(371, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:03:20', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:03:20'),
(372, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:04:01', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:04:01'),
(373, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:04:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:04:03'),
(374, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:04:34', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:04:34'),
(375, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:04:55', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:04:55'),
(376, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:05:01', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:05:01'),
(377, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:05:38', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:05:38'),
(378, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:05:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:05:52'),
(379, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:06:22', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:06:22'),
(380, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:08:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:08:00'),
(381, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:08:17', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:08:17'),
(382, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:08:20', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:08:20'),
(383, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:08:23', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:08:23'),
(384, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:08:24', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:08:24'),
(385, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:09:15', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:09:15'),
(386, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:10:05', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:10:05'),
(387, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:10:36', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:10:36'),
(388, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:11:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:11:06'),
(389, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:11:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:11:32'),
(390, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:12:17', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:12:17'),
(391, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:12:19', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:12:19'),
(392, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:12:20', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:12:20'),
(393, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:12:22', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:12:22'),
(394, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:12:24', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:12:24'),
(395, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:12:27', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:12:27'),
(396, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:12:33', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:12:33'),
(397, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:12:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:12:48'),
(398, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:12:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:12:58'),
(399, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:13:21', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:13:21'),
(400, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:13:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:13:32'),
(401, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:13:51', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:13:51'),
(402, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:13:53', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:13:53'),
(403, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:15:13', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:15:13'),
(404, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:15:17', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:15:17'),
(405, 2, 'Ivanov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test@test.test', 'test', NULL, 'Иванов Иван Иванович', '1', NULL, '2018-02-22 14:53:56', '2018-04-26 13:18:43', 'ROLE_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:18:43'),
(406, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:28:50', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:28:50'),
(407, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:28:54', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:28:54'),
(408, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:28:55', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:28:55'),
(409, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:28:57', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:28:57'),
(410, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:29:01', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:29:01'),
(411, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:29:55', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:29:55'),
(412, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:29:57', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:29:57'),
(413, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:29:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:29:58'),
(414, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:30:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:30:03'),
(415, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:30:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:30:06'),
(416, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:30:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:30:07'),
(417, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:38:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:38:29'),
(418, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:38:31', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:38:31'),
(419, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:38:34', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:38:34'),
(420, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:42:34', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:42:34'),
(421, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:42:36', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:42:36'),
(422, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:42:40', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:42:40'),
(423, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:42:43', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:42:43'),
(424, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:42:46', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:42:46'),
(425, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:43:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:43:06'),
(426, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:43:11', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:43:11'),
(427, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:43:14', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:43:14'),
(428, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:43:16', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:43:16'),
(429, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:45:36', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:45:36'),
(430, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:45:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:45:37'),
(431, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:45:42', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:45:42'),
(432, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:45:43', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:45:43'),
(433, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:45:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:45:45'),
(434, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:45:47', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:45:47'),
(435, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:46:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:46:30'),
(436, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:47:36', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:47:36'),
(437, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:47:38', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:47:38'),
(438, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:47:40', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:47:40'),
(439, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:47:54', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:47:54'),
(440, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:47:56', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:47:56'),
(441, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:49:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:49:45'),
(442, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:49:47', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:49:47'),
(443, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:49:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:49:49'),
(444, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:50:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:50:07'),
(445, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:50:09', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:50:09'),
(446, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 13:50:12', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 13:50:12'),
(447, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:03:42', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:03:42'),
(448, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:03:44', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:03:44'),
(449, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:10:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:10:00'),
(450, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:10:02', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:10:02'),
(451, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:10:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:10:04'),
(452, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:10:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:10:08'),
(453, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:10:11', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:10:11'),
(454, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:10:13', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:10:13'),
(455, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:11:17', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:11:17'),
(456, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:11:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:11:32'),
(457, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:17:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:17:48'),
(458, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:17:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:17:51'),
(459, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:33:57', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:33:57'),
(460, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:53:43', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:53:43'),
(461, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 14:55:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 14:55:58'),
(462, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:01:54', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:01:54'),
(463, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:02:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:02:00'),
(464, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:02:42', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:02:42'),
(465, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:02:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:02:45'),
(466, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:02:47', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:02:47'),
(467, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:03:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:03:29'),
(468, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:03:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:03:32'),
(469, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:04:27', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:04:27'),
(470, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:04:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:04:29'),
(471, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:04:31', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:04:31'),
(472, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:04:40', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:04:40'),
(473, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:04:42', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:04:42'),
(474, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:04:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:04:45'),
(475, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:05:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:05:29'),
(476, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:05:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:05:32'),
(477, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:06:25', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:06:25'),
(478, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:06:26', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:06:26'),
(479, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:06:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:06:29'),
(480, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:06:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:06:30'),
(481, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:08:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:08:03'),
(482, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:08:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:08:04'),
(483, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:08:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:08:06'),
(484, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:08:27', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:08:27'),
(485, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:08:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:08:30'),
(486, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:09:15', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:09:15'),
(487, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:10:35', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:10:35'),
(488, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:10:36', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:10:36'),
(489, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:30:56', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:30:56'),
(490, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:30:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:30:59'),
(491, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:31:40', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:31:40'),
(492, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:31:42', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:31:42'),
(493, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:31:47', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:31:47'),
(494, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:31:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:31:52'),
(495, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:33:23', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:33:23'),
(496, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:33:25', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:33:25'),
(497, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:36:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:36:45'),
(498, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:37:39', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:37:39'),
(499, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:37:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:37:52'),
(500, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:42:46', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:42:46'),
(501, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:45:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:45:03'),
(502, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:45:54', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:45:54'),
(503, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:45:56', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:45:56'),
(504, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:45:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:45:58'),
(505, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:46:10', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:46:10'),
(506, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:46:43', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:46:43'),
(507, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:50:01', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:50:01'),
(508, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:50:13', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:50:13'),
(509, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:51:11', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:51:11'),
(510, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:52:36', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:52:36'),
(511, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:52:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:52:37'),
(512, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:53:09', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:53:09'),
(513, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:53:18', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:53:18'),
(514, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:55:01', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:55:01'),
(515, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:55:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:55:04'),
(516, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:55:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:55:08'),
(517, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:55:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:55:48'),
(518, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:55:53', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:55:53'),
(519, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:56:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:56:08'),
(520, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:56:23', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:56:23'),
(521, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:57:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:57:04'),
(522, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:57:09', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:57:09'),
(523, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:57:10', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:57:10'),
(524, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:57:12', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:57:12'),
(525, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:57:46', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:57:46'),
(526, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:57:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:57:59'),
(527, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:58:02', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:58:02'),
(528, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:58:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:58:04'),
(529, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:58:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:58:06'),
(530, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:58:10', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:58:10'),
(531, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:58:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:58:45'),
(532, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 15:59:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 15:59:59'),
(533, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:00:01', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:00:01'),
(534, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:00:10', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:00:10'),
(535, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:00:24', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:00:24'),
(536, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:00:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:00:51'),
(537, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:00:53', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:00:53'),
(538, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:00:57', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:00:57'),
(539, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:01:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:01:29'),
(540, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:01:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:01:30'),
(541, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:01:33', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:01:33'),
(542, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:02:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:02:52'),
(543, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:03:16', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:03:16'),
(544, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:03:35', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:03:35'),
(545, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:05:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:05:53'),
(546, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:05:55', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:05:55'),
(547, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-26 16:06:41', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-26 16:06:41'),
(548, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 09:38:15', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 09:38:15'),
(549, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 09:38:18', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 09:38:18'),
(550, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 09:38:20', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 09:38:20'),
(551, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 09:44:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 09:44:00'),
(552, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 09:49:39', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 09:49:39'),
(553, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 09:49:43', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 09:49:43'),
(554, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 09:49:53', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 09:49:53'),
(555, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 09:50:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 09:50:07'),
(556, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 09:50:16', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 09:50:16'),
(557, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 09:50:24', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 09:50:24'),
(558, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 13:47:41', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 13:47:41'),
(559, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 13:47:43', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 13:47:43'),
(560, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 13:48:27', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 13:48:27'),
(561, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 13:49:02', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 13:49:02'),
(562, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 13:49:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 13:49:45'),
(563, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 13:50:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 13:50:04'),
(564, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-27 13:50:09', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-27 13:50:09'),
(565, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 11:26:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 11:26:52'),
(566, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 11:27:40', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 11:27:40'),
(567, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 11:28:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 11:28:00'),
(568, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 11:28:31', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 11:28:31'),
(569, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 11:28:41', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 11:28:41'),
(570, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 11:29:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 11:29:37'),
(571, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 11:29:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 11:29:59'),
(572, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 11:31:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 11:31:00'),
(573, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 11:44:11', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 11:44:11'),
(574, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:21:18', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:21:18'),
(575, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:21:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:21:21'),
(576, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:21:43', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:21:43'),
(577, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:21:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:21:58'),
(578, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:23:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:23:32'),
(579, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:23:53', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:23:53'),
(580, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:24:41', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:24:41'),
(581, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:25:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:25:21'),
(582, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:25:34', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:25:34'),
(583, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:25:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:25:52'),
(584, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:26:23', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:26:23'),
(585, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:26:50', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:26:50'),
(586, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:27:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:27:32'),
(587, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:29:42', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:29:42'),
(588, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:29:47', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:29:47'),
(589, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:29:53', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:29:53'),
(590, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:30:02', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:30:02'),
(591, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:30:12', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:30:12'),
(592, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:30:20', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:30:20'),
(593, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:31:11', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:31:11'),
(594, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:31:13', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:31:13'),
(595, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:33:26', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:33:26'),
(596, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 14:52:25', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 14:52:25'),
(597, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:19:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:19:49'),
(598, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:19:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:19:51'),
(599, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:20:46', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:20:46'),
(600, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:20:54', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:20:54'),
(601, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:21:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:21:21'),
(602, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:21:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:21:58'),
(603, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:22:25', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:22:25'),
(604, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:22:40', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:22:40'),
(605, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:23:53', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:23:53'),
(606, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:25:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:25:08'),
(607, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:25:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:25:32'),
(608, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:26:19', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:26:19'),
(609, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:26:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:26:45'),
(610, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:27:14', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:27:14'),
(611, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:28:05', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:28:05'),
(612, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:28:26', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:28:26'),
(613, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:30:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:30:03'),
(614, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:30:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:30:45'),
(615, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:32:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:32:52'),
(616, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:35:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:35:03'),
(617, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:35:24', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:35:24'),
(618, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:35:34', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:35:34'),
(619, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:35:57', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:35:57'),
(620, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:37:11', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:37:11'),
(621, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:37:18', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:37:18'),
(622, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:37:34', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:37:34'),
(623, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:37:39', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:37:39'),
(624, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:39:14', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:39:14'),
(625, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:39:17', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:39:17'),
(626, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:39:20', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:39:20'),
(627, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:39:36', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:39:36'),
(628, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:39:55', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:39:55'),
(629, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:51:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:51:29'),
(630, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:51:31', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:51:31'),
(631, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:51:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:51:48'),
(632, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:51:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:51:59'),
(633, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:52:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:52:03'),
(634, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:52:05', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:52:05'),
(635, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:52:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:52:45'),
(636, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:54:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:54:08'),
(637, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:56:17', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:56:17'),
(638, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:56:44', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:56:44'),
(639, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:57:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:57:03'),
(640, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:57:10', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:57:10'),
(641, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-04-28 15:57:16', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-04-28 15:57:16'),
(642, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 10:58:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 10:58:58'),
(643, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 10:59:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 10:59:00'),
(644, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 10:59:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 10:59:04'),
(645, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 10:59:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 10:59:07'),
(646, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 10:59:09', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 10:59:09'),
(647, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 10:59:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 10:59:48'),
(648, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 10:59:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 10:59:49'),
(649, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 10:59:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 10:59:51'),
(650, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 10:59:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 10:59:52'),
(651, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 10:59:54', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 10:59:54'),
(652, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 10:59:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 10:59:58'),
(653, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:04:40', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:04:40'),
(654, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:06:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:06:58'),
(655, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:08:39', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:08:39'),
(656, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:09:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:09:08'),
(657, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:12:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:12:45'),
(658, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:13:12', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:13:12'),
(659, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:13:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:13:30'),
(660, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:15:36', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:15:36'),
(661, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:15:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:15:49'),
(662, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:16:02', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:16:02'),
(663, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:16:12', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:16:12'),
(664, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:16:57', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:16:57'),
(665, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:17:13', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:17:13'),
(666, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:18:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:18:30'),
(667, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:24:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:24:59'),
(668, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:25:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:25:06'),
(669, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:25:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:25:58'),
(670, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:26:35', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:26:35'),
(671, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:26:44', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:26:44'),
(672, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:26:47', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:26:47'),
(673, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:27:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:27:32'),
(674, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 11:27:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 11:27:52'),
(675, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:25:43', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:25:43'),
(676, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:32:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:32:48'),
(677, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:33:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:33:21'),
(678, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:33:40', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:33:40'),
(679, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:34:10', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:34:10'),
(680, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:35:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:35:48'),
(681, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:36:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:36:30'),
(682, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:37:34', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:37:34'),
(683, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:37:53', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:37:53'),
(684, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:38:22', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:38:22'),
(685, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:38:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:38:58'),
(686, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:39:24', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:39:24'),
(687, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-03 12:39:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-03 12:39:30'),
(688, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:06:15', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:06:15'),
(689, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:06:20', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:06:20'),
(690, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:08:28', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:08:28'),
(691, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:08:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:08:29'),
(692, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:08:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:08:37'),
(693, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:08:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:08:58'),
(694, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:09:09', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:09:09'),
(695, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:09:11', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:09:11'),
(696, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:09:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:09:21'),
(697, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:09:34', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:09:34'),
(698, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:09:35', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:09:35'),
(699, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:09:36', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:09:36'),
(700, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:09:38', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:09:38'),
(701, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:09:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:09:51'),
(702, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:10:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:10:03'),
(703, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:10:14', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:10:14'),
(704, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:10:35', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:10:35'),
(705, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:10:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:10:51'),
(706, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:11:01', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:11:01'),
(707, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:11:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:11:37'),
(708, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:11:40', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:11:40'),
(709, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:11:42', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:11:42'),
(710, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:12:39', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:12:39'),
(711, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:12:41', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:12:41'),
(712, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:12:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:12:49'),
(713, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:16:20', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:16:20'),
(714, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:16:27', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:16:27'),
(715, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:16:31', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:16:31'),
(716, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:16:39', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:16:39'),
(717, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:17:05', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:17:05'),
(718, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:17:09', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:17:09'),
(719, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:23:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:23:06'),
(720, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:23:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:23:07'),
(721, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:23:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:23:08'),
(722, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:23:20', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:23:20'),
(723, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:23:23', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:23:23'),
(724, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:23:27', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:23:27'),
(725, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:25:28', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:25:28'),
(726, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:28:46', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:28:46'),
(727, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:28:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:28:48'),
(728, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:28:50', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:28:50'),
(729, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:28:57', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:28:57'),
(730, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:31:12', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:31:12'),
(731, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:31:13', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:31:13'),
(732, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 14:31:19', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 14:31:19'),
(733, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:14:01', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:14:01'),
(734, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:14:14', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:14:14'),
(735, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:15:55', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:15:55'),
(736, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:15:56', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:15:56'),
(737, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:17:01', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:17:01'),
(738, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:17:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:17:04'),
(739, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:17:05', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:17:05'),
(740, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:17:12', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:17:12'),
(741, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:17:13', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:17:13'),
(742, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:17:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:17:59'),
(743, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:23:23', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:23:23'),
(744, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:24:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:24:03'),
(745, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:29:47', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:29:47'),
(746, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:29:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:29:49'),
(747, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:29:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:29:51'),
(748, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:29:53', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:29:53'),
(749, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:30:11', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:30:11'),
(750, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:30:18', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:30:18'),
(751, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:30:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:30:29'),
(752, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:34:40', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:34:40'),
(753, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-11 15:34:42', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-11 15:34:42'),
(754, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 11:59:25', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 11:59:25'),
(755, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 11:59:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 11:59:32'),
(756, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 11:59:39', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 11:59:39'),
(757, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 11:59:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 11:59:49'),
(758, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 12:32:27', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 12:32:27'),
(759, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 12:32:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 12:32:30'),
(760, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 12:33:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 12:33:48'),
(761, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 12:34:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 12:34:08'),
(762, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 12:34:28', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 12:34:28'),
(763, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 12:36:13', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 12:36:13'),
(764, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 12:36:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 12:36:52'),
(765, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 12:37:02', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 12:37:02'),
(766, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 12:57:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 12:57:04'),
(767, 5, 'test', '$2y$15$KfEr22OYfCQEMPY5aE0Uzusz2spsSEqiirIYxeASv4Mb/a3as/i8C', NULL, 'test7@test7.test7', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 12:58:24', NULL, NULL, 1, 'root', 'localhost', '2018-05-14 12:58:29'),
(768, 5, 'test', '$2y$15$KfEr22OYfCQEMPY5aE0Uzusz2spsSEqiirIYxeASv4Mb/a3as/i8C', NULL, 'test7@test7.test7', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 12:58:24', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 14:37:13'),
(769, 5, 'test', '$2y$15$KfEr22OYfCQEMPY5aE0Uzusz2spsSEqiirIYxeASv4Mb/a3as/i8C', NULL, 'test7@test7.test7', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 12:58:24', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 14:37:13'),
(770, 5, 'test', '$2y$15$KfEr22OYfCQEMPY5aE0Uzusz2spsSEqiirIYxeASv4Mb/a3as/i8C', NULL, 'test7@test7.test7', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 12:58:24', '2018-05-14 14:37:17', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 14:37:17'),
(771, 5, 'test', '$2y$15$KfEr22OYfCQEMPY5aE0Uzusz2spsSEqiirIYxeASv4Mb/a3as/i8C', NULL, 'test7@test7.test7', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 12:58:24', '2018-05-14 14:37:58', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 14:37:58'),
(772, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 14:47:57', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 14:47:57'),
(773, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 14:48:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 14:48:00'),
(774, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 14:48:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 14:48:03'),
(775, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 14:50:12', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 14:50:12'),
(776, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 14:51:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 14:51:06'),
(777, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 14:51:09', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 14:51:09'),
(778, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 14:52:02', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 14:52:02'),
(779, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 14:52:56', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 14:52:56'),
(780, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 14:57:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 14:57:07'),
(781, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 14:58:22', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 14:58:22'),
(782, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:09:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:09:52'),
(783, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:11:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:11:06'),
(784, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:12:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:12:07'),
(785, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:15:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:15:00'),
(786, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:16:47', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:16:47'),
(787, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:20:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:20:29'),
(788, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:20:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:20:45'),
(789, 5, 'test', '$2y$15$KfEr22OYfCQEMPY5aE0Uzusz2spsSEqiirIYxeASv4Mb/a3as/i8C', NULL, 'test7@test7.test7', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 12:58:24', '2018-05-14 15:35:58', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 15:35:58'),
(790, 5, 'test', '$2y$15$KfEr22OYfCQEMPY5aE0Uzusz2spsSEqiirIYxeASv4Mb/a3as/i8C', NULL, 'test7@test7.test7', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 12:58:24', '2018-05-14 15:36:00', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 15:36:00'),
(791, 5, 'test', '$2y$15$KfEr22OYfCQEMPY5aE0Uzusz2spsSEqiirIYxeASv4Mb/a3as/i8C', NULL, 'test7@test7.test7', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 12:58:24', '2018-05-14 15:36:01', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 15:36:01'),
(792, 5, 'test', '$2y$15$KfEr22OYfCQEMPY5aE0Uzusz2spsSEqiirIYxeASv4Mb/a3as/i8C', NULL, 'test7@test7.test7', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 12:58:24', '2018-05-14 15:36:02', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 15:36:02'),
(793, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:37:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:37:03'),
(794, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:37:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:37:06'),
(795, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:38:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:38:08'),
(796, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:38:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:38:45'),
(797, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:39:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:39:45'),
(798, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:40:38', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:40:38'),
(799, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:40:41', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:40:41'),
(800, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:41:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:41:08'),
(801, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:42:10', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:42:10'),
(802, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:43:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:43:03'),
(803, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:43:54', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:43:54'),
(804, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:48:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:48:48'),
(805, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:48:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:48:49'),
(806, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:48:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:48:51'),
(807, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:48:54', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:48:54'),
(808, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:48:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:48:58'),
(809, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:49:53', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:49:53'),
(810, 5, 'test', '$2y$15$KfEr22OYfCQEMPY5aE0Uzusz2spsSEqiirIYxeASv4Mb/a3as/i8C', NULL, 'test7@test7.test7', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 12:58:24', '2018-05-14 15:36:02', 'ROLE_USER', 3, 'root', 'localhost', '2018-05-14 15:50:02'),
(811, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:50:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:50:03'),
(812, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:50:57', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:50:57'),
(813, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:51:13', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:51:13'),
(814, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:51:17', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:51:17'),
(815, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:54:18', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:54:18'),
(816, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:54:20', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:54:20'),
(817, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:54:58', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:54:58'),
(818, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:55:02', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:55:02'),
(819, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:55:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:55:06'),
(820, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 15:59:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 15:59:04'),
(821, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-05-14 16:00:21', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 16:00:21'),
(822, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-05-14 16:00:22', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 16:00:22'),
(823, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-05-14 16:01:03', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 16:01:03'),
(824, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-05-14 16:01:55', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 16:01:55'),
(825, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-05-14 16:03:09', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 16:03:09'),
(826, 3, 'Petrov', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'test2@test2.test2', 'test2', NULL, 'Петров Петр Петрович', '2', NULL, '2018-02-26 14:58:09', '2018-05-14 16:03:14', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 16:03:14'),
(827, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:03:23', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:03:23'),
(828, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:03:25', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:03:25'),
(829, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:04:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:04:21'),
(830, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:05:43', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:05:43'),
(831, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:05:44', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:05:44'),
(832, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:05:45', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:05:45'),
(833, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:06:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:06:49'),
(834, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:09:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:09:48'),
(835, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:09:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:39:22'),
(836, 6, 'test', '$2y$15$zxhqoDK3KJlg5KPvcKBAg.n4koQfg2kNLvhe/b1xoa/YgflSHi0P2', NULL, 'fny2004@mail.ru', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 16:39:42', NULL, NULL, 1, 'root', 'localhost', '2018-05-14 16:39:45'),
(837, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:42:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:42:21'),
(838, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:42:23', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:42:23'),
(839, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:42:24', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:42:24'),
(840, 6, 'test', '$2y$15$zxhqoDK3KJlg5KPvcKBAg.n4koQfg2kNLvhe/b1xoa/YgflSHi0P2', NULL, 'fny2004@mail.ru', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 16:39:42', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 16:42:28'),
(841, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:42:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:42:29'),
(842, 6, 'test', '$2y$15$zxhqoDK3KJlg5KPvcKBAg.n4koQfg2kNLvhe/b1xoa/YgflSHi0P2', NULL, 'fny2004@mail.ru', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 16:39:42', NULL, NULL, 2, 'root', 'localhost', '2018-05-14 16:42:56'),
(843, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:46:53', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:46:53'),
(844, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:46:54', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:46:54'),
(845, 6, 'test', '$2y$15$zxhqoDK3KJlg5KPvcKBAg.n4koQfg2kNLvhe/b1xoa/YgflSHi0P2', NULL, 'fny2004@mail.ru', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 16:39:42', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 16:46:59'),
(846, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:46:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:46:59'),
(847, 6, 'test', '$2y$15$zxhqoDK3KJlg5KPvcKBAg.n4koQfg2kNLvhe/b1xoa/YgflSHi0P2', NULL, 'fny2004@mail.ru', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 16:39:42', NULL, NULL, 2, 'root', 'localhost', '2018-05-14 16:47:24'),
(848, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:47:28', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:47:28'),
(849, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:47:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:47:30'),
(850, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:48:17', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:48:17'),
(851, 6, 'test', '$2y$15$zxhqoDK3KJlg5KPvcKBAg.n4koQfg2kNLvhe/b1xoa/YgflSHi0P2', NULL, 'fny2004@mail.ru', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 16:39:42', NULL, 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 16:48:20'),
(852, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:48:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:48:21'),
(853, 6, 'test', '$2y$15$zxhqoDK3KJlg5KPvcKBAg.n4koQfg2kNLvhe/b1xoa/YgflSHi0P2', NULL, 'fny2004@mail.ru', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 16:39:42', NULL, NULL, 2, 'root', 'localhost', '2018-05-14 16:48:52'),
(854, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:48:57', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:48:57'),
(855, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:49:46', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:49:46'),
(856, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:49:48', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:49:48'),
(857, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:50:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:50:59'),
(858, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:51:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:51:00'),
(859, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:51:01', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:51:01'),
(860, 6, 'test', '$2y$15$zxhqoDK3KJlg5KPvcKBAg.n4koQfg2kNLvhe/b1xoa/YgflSHi0P2', NULL, 'fny2004@mail.ru', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 16:39:42', '2018-05-14 16:51:05', 'ROLE_USER', 2, 'root', 'localhost', '2018-05-14 16:51:05'),
(861, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:51:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:51:06'),
(862, 6, 'test', '$2y$15$zxhqoDK3KJlg5KPvcKBAg.n4koQfg2kNLvhe/b1xoa/YgflSHi0P2', NULL, 'fny2004@mail.ru', 'test7', NULL, 'test7', 'test7', NULL, '2018-05-14 16:39:42', '2018-05-14 16:51:05', 'ROLE_USER', 3, 'root', 'localhost', '2018-05-14 16:52:07'),
(863, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:52:08', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:52:08'),
(864, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:52:33', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:52:33'),
(865, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:53:35', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:53:35'),
(866, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:53:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:53:37'),
(867, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:53:39', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:53:39'),
(868, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:54:02', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:54:02'),
(869, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:54:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:54:04'),
(870, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:54:14', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:54:14'),
(871, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:54:20', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:54:20'),
(872, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:54:22', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:54:22'),
(873, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:54:24', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:54:24'),
(874, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:54:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:54:32'),
(875, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:54:35', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:54:35'),
(876, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:54:43', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:54:43'),
(877, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:54:44', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:54:44'),
(878, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 16:54:46', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 16:54:46'),
(879, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:00:50', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:00:50'),
(880, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:00:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:00:51'),
(881, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:01:01', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:01:01'),
(882, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:01:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:01:04'),
(883, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:01:16', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:01:16'),
(884, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny20047@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:01:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:01:32'),
(885, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:01:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:01:44'),
(886, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:01:51', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:01:51'),
(887, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:01:52', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:01:52'),
(888, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:02:05', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:02:05'),
(889, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:06:50', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:06:50'),
(890, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:18:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:18:37'),
(891, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:18:41', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:18:41'),
(892, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:18:44', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:18:44'),
(893, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:18:55', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:18:55'),
(894, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:20:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:20:06'),
(895, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:24:49', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:24:49'),
(896, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:27:06', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:27:06'),
(897, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:28:27', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:28:27'),
(898, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:28:38', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:28:38'),
(899, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:29:13', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:29:13'),
(900, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-14 17:29:15', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-14 17:29:15'),
(901, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 10:33:54', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 10:33:55'),
(902, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 12:50:00', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 12:50:00'),
(903, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 12:50:03', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 12:50:03'),
(904, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 12:50:04', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 12:50:04'),
(905, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 12:56:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 12:56:21'),
(906, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 12:56:23', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 12:56:23'),
(907, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 12:56:25', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 12:56:25'),
(908, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 12:56:26', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 12:56:26'),
(909, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 14:48:09', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 14:48:09'),
(910, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 14:48:11', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 14:48:11'),
(911, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:02:11', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:02:11'),
(912, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:02:12', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:02:12'),
(913, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:02:13', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:02:13'),
(914, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:35:32', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:35:32'),
(915, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:35:37', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:35:37'),
(916, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:35:46', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:35:46'),
(917, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:35:56', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:35:56'),
(918, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:35:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:35:59'),
(919, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:36:07', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:36:07'),
(920, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:36:09', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:36:09'),
(921, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:36:13', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:36:13'),
(922, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:36:17', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:36:17');
INSERT INTO users_history VALUES
(923, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 15:36:25', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 15:36:25'),
(924, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 16:48:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 16:48:30'),
(925, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 16:48:36', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 16:48:36'),
(926, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 16:50:21', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 16:50:21'),
(927, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 16:50:22', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 16:50:22'),
(928, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 17:09:29', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 17:09:29'),
(929, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 17:09:30', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 17:09:30'),
(930, 1, 'Gutowski', '$2y$15$lELVE9ovDuheWEWyK.KFU.WC2ghgJNWbayFTszyhhx8ivqZdKQgFu', NULL, 'fny2004@mail.ru', '+7 (985) 223-25-63', '+7 (978) 101-59-86', 'Гутовская Ольга Александровна', 'нет', 'г. Москва, ул. Космонавта Волкова, 15', '2018-02-20 10:57:35', '2018-05-15 17:09:59', 'ROLE_SUPER_ADMIN', 2, 'root', 'localhost', '2018-05-15 17:09:59');

-- 
-- Вывод данных для таблицы tariffs_types_history
--
INSERT INTO tariffs_types_history VALUES
(1, 5, 'вода', 1, 1, 'root', 'localhost', '2018-02-26 13:04:13'),
(2, 6, 'земля', 0, 1, 'root', 'localhost', '2018-02-26 13:04:21'),
(3, 7, 'свет', 1, 1, 'root', 'localhost', '2018-02-26 13:04:31');

-- 
-- Вывод данных для таблицы tariffs_history
--
INSERT INTO tariffs_history VALUES
(1, 1, 5, '01.2018', 150.00, 1, 'root', 'localhost', '2018-02-26 13:05:03'),
(2, 2, 6, '01.2018', 400.00, 1, 'root', 'localhost', '2018-02-26 13:05:17'),
(3, 3, 7, '01.2018', 0.00, 1, 'root', 'localhost', '2018-02-26 13:05:33'),
(4, 3, 7, '01.2018', 0.35, 2, 'root', 'localhost', '2018-02-26 13:05:39'),
(5, 2, 6, '01.2018', 400.10, 2, 'root', 'localhost', '2018-02-26 13:05:51'),
(6, 3, 7, '02.2018', 0.35, 2, 'root', 'localhost', '2018-02-26 13:06:29'),
(7, 3, 7, '02.2018', 0.35, 2, 'root', 'localhost', '2018-02-26 13:06:29'),
(8, 4, 6, '02.2018', 400.50, 1, 'root', 'localhost', '2018-02-28 11:47:39'),
(9, 5, 5, '02.2018', 450.50, 1, 'root', 'localhost', '2018-03-14 10:28:07'),
(10, 4, 6, '02.2018', 400.50, 3, 'root', 'localhost', '2018-03-14 12:26:51'),
(11, 6, 7, '01.2018', 0.25, 1, 'root', 'localhost', '2018-03-14 15:14:10'),
(12, 1, 5, '01.2018', 15.00, 2, 'root', 'localhost', '2018-03-14 16:20:37'),
(13, 2, 6, '01.2018', 40.10, 2, 'root', 'localhost', '2018-03-14 16:20:39'),
(14, 5, 5, '02.2018', 45.50, 2, 'root', 'localhost', '2018-03-14 16:20:41'),
(15, 1, 5, '01.2017', 15.00, 2, 'root', 'localhost', '2018-04-04 09:41:02'),
(16, 2, 6, '01.2017', 40.10, 2, 'root', 'localhost', '2018-04-04 09:41:07'),
(17, 3, 7, '01.2017', 0.35, 2, 'root', 'localhost', '2018-04-04 09:41:11'),
(18, 1, 5, '01.2017', 31.60, 2, 'root', 'localhost', '2018-04-04 09:41:22'),
(19, 2, 6, '01.2017', 500.00, 2, 'root', 'localhost', '2018-04-04 09:41:32'),
(20, 3, 7, '01.2017', 2.65, 2, 'root', 'localhost', '2018-04-04 09:41:40'),
(21, 5, 5, '02.2017', 45.50, 2, 'root', 'localhost', '2018-04-04 09:41:54'),
(22, 6, 7, '02.2017', 0.25, 2, 'root', 'localhost', '2018-04-04 09:42:01'),
(23, 5, 5, '02.2017', 35.20, 2, 'root', 'localhost', '2018-04-04 09:42:16'),
(24, 6, 7, '02.2017', 3.55, 2, 'root', 'localhost', '2018-04-04 09:42:23'),
(25, 7, 5, '07.2017', 37.30, 1, 'root', 'localhost', '2018-04-04 09:42:45'),
(26, 8, 7, '07.2017', 0.00, 1, 'root', 'localhost', '2018-04-04 09:42:59'),
(27, 8, 7, '07.2017', 4.15, 2, 'root', 'localhost', '2018-04-04 09:43:03'),
(28, 9, 7, '01.2018', 700.10, 1, 'root', 'localhost', '2018-04-18 13:39:57'),
(29, 9, 7, '01.2018', 700.10, 2, 'root', 'localhost', '2018-04-18 13:42:58'),
(30, 9, 7, '01.2018', 700.10, 3, 'root', 'localhost', '2018-04-18 14:13:01'),
(31, 9, 5, '01.2018', 100.00, 1, 'root', 'localhost', '2018-04-20 13:18:13'),
(32, 9, 5, '01.2018', 170.00, 2, 'root', 'localhost', '2018-04-20 13:19:49'),
(33, 9, 5, '01.2018', 170.00, 3, 'root', 'localhost', '2018-04-20 13:20:44'),
(34, 9, 7, '04.2018', 750.00, 1, 'root', 'localhost', '2018-04-26 12:07:45'),
(35, 9, 7, '03.2018', 750.50, 2, 'root', 'localhost', '2018-04-26 12:07:58'),
(36, 9, 7, '03.2018', 750.50, 3, 'root', 'localhost', '2018-04-26 12:08:05'),
(37, 9, 5, '08.2018', 50.00, 1, 'root', 'localhost', '2018-05-14 17:01:31'),
(38, 9, 5, '07.2018', 50.00, 2, 'root', 'localhost', '2018-05-14 17:06:20'),
(39, 9, 5, '08.2018', 50.00, 2, 'root', 'localhost', '2018-05-14 17:06:46'),
(40, 9, 5, '07.2018', 50.00, 2, 'root', 'localhost', '2018-05-14 17:07:04'),
(41, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-14 17:08:08'),
(42, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-14 17:08:08'),
(43, 9, 5, '07.2018', 50.00, 2, 'root', 'localhost', '2018-05-14 17:18:50'),
(44, 9, 5, '07.2018', 50.00, 2, 'root', 'localhost', '2018-05-14 17:18:50'),
(45, 9, 5, '08.2018', 50.00, 2, 'root', 'localhost', '2018-05-14 17:28:34'),
(46, 9, 5, '08.2018', 50.00, 2, 'root', 'localhost', '2018-05-14 17:28:34'),
(47, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 09:47:44'),
(48, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 09:47:44'),
(49, 9, 5, '08.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 09:47:58'),
(50, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 09:49:13'),
(51, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 09:49:13'),
(52, 9, 5, '08.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 09:49:40'),
(53, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 10:08:33'),
(54, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 10:08:33'),
(55, 9, 5, '08.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:38:59'),
(56, 9, 5, '08.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:38:59'),
(57, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:40:02'),
(58, 9, 5, '08.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:40:15'),
(59, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:42:13'),
(60, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:42:13'),
(61, 9, 5, '08.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:42:27'),
(62, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:43:58'),
(63, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:43:58'),
(64, 9, 5, '08.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:44:11'),
(65, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:45:41'),
(66, 9, 5, '05.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:45:42'),
(67, 9, 5, '08.2018', 50.00, 2, 'root', 'localhost', '2018-05-15 12:45:53');

-- 
-- Вывод данных для таблицы tariffs
--
INSERT INTO tariffs VALUES
(1, 5, '01.2017', 31.60),
(2, 6, '01.2017', 500.00),
(3, 7, '01.2017', 2.65),
(5, 5, '02.2017', 35.20),
(6, 7, '02.2017', 3.55),
(7, 5, '07.2017', 37.30),
(8, 7, '07.2017', 4.15),
(9, 5, '08.2018', 50.00);

-- 
-- Вывод данных для таблицы settings_history
--
INSERT INTO settings_history VALUES
(1, 1, 'index', 'текст главной страницы', 'test', 1, 'root', 'localhost', '2018-02-19 14:43:41'),
(2, 1, 'index', 'текст главной страницы', '<b>Hello</b><br>World!', 2, 'root', 'localhost', '2018-02-19 14:49:16'),
(3, 1, 'index', 'текст главной страницы', '<b>Hello</b><br>World!', 2, 'root', 'localhost', '2018-02-19 14:49:16'),
(4, 2, 'api_id', 'код sms-рассылки', '9B3288EC-D599-979D-2830-33853AEDB440', 1, 'root', 'localhost', '2018-02-28 11:22:03'),
(5, 3, 'map', 'файл карты организации', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2180.044222685702!2d33.57605319699833!3d44.571689490541566!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zNDTCsDM0JzE4LjkiTiAzM8KwMzQnMzUuNSJF!5e1!3m2!1sru!2sru!4v1491368009798', 1, 'root', 'localhost', '2018-02-28 11:22:44'),
(6, 4, 'smtp_host', 'хост почтового сервера', 'mail.hostland.ru', 1, 'root', 'localhost', '2018-02-28 11:23:37'),
(7, 6, 'smtp_login', 'логин почтового сервера', '\t', 1, 'root', 'localhost', '2018-02-28 11:24:17'),
(8, 6, 'smtp_login', 'логин почтового сервера', 'info@gutowski.ru', 2, 'root', 'localhost', '2018-02-28 11:24:24'),
(9, 8, 'smtp_password', 'пароль почтового сервера', 'gutovich85', 1, 'root', 'localhost', '2018-02-28 11:24:48'),
(10, 2, 'api_id', 'код sms-рассылки', '9B3288EC-D599-979D-2830-33853AEDB440', 3, 'root', 'localhost', '2018-03-27 12:00:17'),
(11, 4, 'smtp_host', 'хост почтового сервера', 'mail.hostland.ru', 3, 'root', 'localhost', '2018-03-27 12:00:24'),
(12, 6, 'smtp_login', 'логин почтового сервера', 'info@gutowski.ru', 3, 'root', 'localhost', '2018-03-27 12:00:26'),
(13, 8, 'smtp_password', 'пароль почтового сервера', 'gutovich85', 3, 'root', 'localhost', '2018-03-27 12:00:28'),
(14, 1, 'index', 'текст главной страницы', '<h1><strong>ВНИМАНИЕ! ОБЪЯВЛЕНИЕ&nbsp;ДЛЯ ПАЙЩИКОВ по ГАЗУ!</strong></h1>\r\n\r\n<p>Галина Горлова сегодня была в горгазе, получила положительный ответ на тех. условия.<br />\r\nМожно подавать на тех. условия отдельно на каждый дом.</p>\r\n\r\n<p><strong>ПРЕДВАРИТЕЛЬНО ВОЗЬМИТЕ ПАКЕТ ДОКУМЕНТОВ У ПРЕДСЕДАТЕЛЯ', 2, 'root', 'localhost', '2018-04-04 09:26:39'),
(15, 1, 'index', 'текст главной страницы', '<h1><strong>ВНИМАНИЕ! ОБЪЯВЛЕНИЕ&nbsp;ДЛЯ ПАЙЩИКОВ по ГАЗУ!</strong></h1>\r\n\r\n<p>Галина Горлова сегодня была в горгазе, получила положительный ответ на тех. условия.<br />\r\nМожно подавать на тех. условия отдельно на каждый дом.</p>\r\n\r\n<p><strong>ПРЕДВАРИТЕЛЬНО ВОЗЬМИТЕ ПАКЕТ ДОКУМЕНТОВ У ПРЕДСЕДАТЕЛЯ', 2, 'root', 'localhost', '2018-04-04 09:27:25'),
(16, 1, 'index', 'текст главной страницы', '<h1><strong>ВНИМАНИЕ! ОБЪЯВЛЕНИЕ&nbsp;ДЛЯ ПАЙЩИКОВ по ГАЗУ!</strong></h1>\r\n\r\n<p>Галина Горлова сегодня была в горгазе, получила положительный ответ на тех. условия.<br />\r\nМожно подавать на тех. условия отдельно на каждый дом.</p>\r\n\r\n<p><strong>ПРЕДВАРИТЕЛЬНО ВОЗЬМИТЕ ПАКЕТ ДОКУМЕНТОВ У ПРЕДСЕДАТЕЛЯ', 2, 'root', 'localhost', '2018-04-04 09:27:48'),
(17, 1, 'index', 'текст главной страницы', '<h1><strong>ВНИМАНИЕ! ОБЪЯВЛЕНИЕ&nbsp;ДЛЯ ПАЙЩИКОВ по ГАЗУ!</strong></h1>\r\n\r\n<p>Галина Горлова сегодня была в горгазе, получила положительный ответ на тех. условия.<br />\r\nМожно подавать на тех. условия отдельно на каждый дом.</p>\r\n\r\n<p><strong>ПРЕДВАРИТЕЛЬНО ВОЗЬМИТЕ ПАКЕТ ДОКУМЕНТОВ У ПРЕДСЕДАТЕЛЯ', 2, 'root', 'localhost', '2018-04-04 09:28:08'),
(18, 1, 'index', 'текст главной страницы', '<h1><strong>ВНИМАНИЕ! ОБЪЯВЛЕНИЕ&nbsp;ДЛЯ ПАЙЩИКОВ ПО ГАЗУ!</strong></h1>\r\n\r\n<p>Галина Горлова сегодня была в горгазе, получила положительный ответ на тех. условия.<br />\r\nМожно подавать на тех. условия отдельно на каждый дом.</p>\r\n\r\n<p><strong>ПРЕДВАРИТЕЛЬНО ВОЗЬМИТЕ ПАКЕТ ДОКУМЕНТОВ У ПРЕДСЕДАТЕЛЯ', 2, 'root', 'localhost', '2018-04-18 09:11:35'),
(19, 1, 'index', 'текст главной страницы', '<h1><strong>ВНИМАНИЕ! ОБЪЯВЛЕНИЕ&nbsp;ДЛЯ ПАЙЩИКОВ ПО ГАЗУ!</strong></h1>\r\n\r\n<p>Галина Горлова сегодня была в горгазе, получила положительный ответ на тех. условия.<br />\r\nМожно подавать на тех. условия отдельно на каждый дом.</p>\r\n\r\n<p><strong>ПРЕДВАРИТЕЛЬНО ВОЗЬМИТЕ ПАКЕТ ДОКУМЕНТОВ У ПРЕДСЕДАТЕЛЯ', 2, 'root', 'localhost', '2018-04-18 09:47:06'),
(20, 1, 'index', 'текст главной страницы', '<h1><strong>ВНИМАНИЕ! ОБЪЯВЛЕНИЕ&nbsp;ДЛЯ ПАЙЩИКОВ ПО ГАЗУ!</strong></h1>\r\n\r\n<p>Галина Горлова сегодня была в горгазе, получила положительный ответ на тех. условия.<br />\r\nМожно подавать на тех. условия отдельно на каждый дом.</p>\r\n\r\n<p><strong>ПРЕДВАРИТЕЛЬНО ВОЗЬМИТЕ ПАКЕТ ДОКУМЕНТОВ У ПРЕДСЕДАТЕЛЯ', 2, 'root', 'localhost', '2018-04-26 12:03:26'),
(21, 1, 'index', 'текст главной страницы', '<h1><strong>ВНИМАНИЕ! ОБЪЯВЛЕНИЕ&nbsp;ДЛЯ ПАЙЩИКОВ ПО ГАЗУ!</strong></h1>\r\n\r\n<p>Галина Горлова сегодня была в горгазе, получила положительный ответ на тех. условия.<br />\r\nМожно подавать на тех. условия отдельно на каждый дом..</p>\r\n\r\n<p><strong>ПРЕДВАРИТЕЛЬНО ВОЗЬМИТЕ ПАКЕТ ДОКУМЕНТОВ У ПРЕДСЕДАТЕЛ', 2, 'root', 'localhost', '2018-05-11 14:23:18'),
(22, 1, 'index', 'текст главной страницы', '<h1><strong>ВНИМАНИЕ! ОБЪЯВЛЕНИЕ&nbsp;ДЛЯ ПАЙЩИКОВ ПО ГАЗУ!</strong></h1>\r\n\r\n<p>Галина Горлова сегодня была в горгазе, получила положительный ответ на тех. условия.<br />\r\nМожно подавать на тех. условия отдельно на каждый дом.</p>\r\n\r\n<p><strong>ПРЕДВАРИТЕЛЬНО ВОЗЬМИТЕ ПАКЕТ ДОКУМЕНТОВ У ПРЕДСЕДАТЕЛЯ', 2, 'root', 'localhost', '2018-05-11 14:23:26');

-- 
-- Вывод данных для таблицы settings
--
INSERT INTO settings VALUES
(1, 'index', 'текст главной страницы', '<h1><strong>ВНИМАНИЕ! ОБЪЯВЛЕНИЕ&nbsp;ДЛЯ ПАЙЩИКОВ ПО ГАЗУ!</strong></h1>\r\n\r\n<p>Галина Горлова сегодня была в горгазе, получила положительный ответ на тех. условия.<br />\r\nМожно подавать на тех. условия отдельно на каждый дом.</p>\r\n\r\n<p><strong>ПРЕДВАРИТЕЛЬНО ВОЗЬМИТЕ ПАКЕТ ДОКУМЕНТОВ У ПРЕДСЕДАТЕЛЯ ПРАВЛЕНИЯ КАЙДАНОВСКОЙ НАТАЛИИ!<br />\r\nПозвоните&nbsp; +7 978 72 777 04, продиктуйте полностью ФИО и номер участка, если присвоен адрес, то его тоже.</strong></p>\r\n\r\n<p><br />\r\n-------------------------------------------------------------------------------------------------------</p>\r\n\r\n<p><strong>Перечень документов: </strong><br />\r\n1. Схема кооператива с указанием расположения участка; (у председателя).<br />\r\n2. Копия и оригинал правоустанавливающих документов на дом и на участок (самостоятельно).<br />\r\n3. Копия и оригинал паспорта собственника (самостоятельно).<br />\r\n4. Заявление (готовит председатель).</p>\r\n\r\n<p>Документы подает собственник. СДАТЬ В ГОРГАЗ В ЕДИНОЕ ОКНО.</p>\r\n\r\n<p><strong>Выдача ТУ физлицам бесплатно!!!</strong></p>\r\n\r\n<p>--------------------------------------------------------<br />\r\nНЮАНСЫ:&nbsp;Каждый обращается сам за проектом, кроме тех, кто планирует быть на одной ветке.<br />\r\nИм рекомендуем вместе заказывать проект.<br />\r\n<br />\r\nАЛГОРИТМ ДЕЙСТВИЙ<br />\r\n1. Ждем ТУ.<br />\r\n2. Заказываем проект (кто где захочет).<br />\r\n3. Приступаем к работам по строительству личной веточки.<br />\r\n-------------------------------------------------------------------------------------------------------<br />\r\nВАМ ПОНАДОБИТСЯ<br />\r\n1.<strong>&nbsp;Проектировщик</strong> &lrm;8 (978) 864-17-12 Миропольцева Татьяна Петровна.<br />\r\n2.&nbsp;<strong>За выполнением работ </strong>можете обратиться к нашему <strong>подрядчику</strong> Прудникову Виталию Михайловичу.<br />\r\n&nbsp; &nbsp;&nbsp;Он строил нашу основную ветку, человек знает наш кооператив, адекватные цены. &lrm;+7 978 739-71-40</p>\r\n\r\n<p>Удачи!</p>\r\n\r\n<p>Председатель правления СНТ &quot;Степной Фазан&quot; Кайдановская Наталия.</p>'),
(3, 'map', 'файл карты организации', 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2180.044222685702!2d33.57605319699833!3d44.571689490541566!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zNDTCsDM0JzE4LjkiTiAzM8KwMzQnMzUuNSJF!5e1!3m2!1sru!2sru!4v1491368009798');

-- 
-- Вывод данных для таблицы payments_history
--
INSERT INTO payments_history VALUES
(1, 5, '2018-01-05 15:59:28', 5, 1, 50.00, NULL, 1, 'root', 'localhost', '2018-03-14 15:59:49'),
(2, 7, '2018-01-07 16:00:47', 5, 1, 20.70, NULL, 1, 'root', 'localhost', '2018-03-14 16:01:13'),
(3, 9, '2018-02-10 16:02:26', 7, 1, 100.00, NULL, 1, 'root', 'localhost', '2018-03-14 16:02:51'),
(4, 10, '2018-02-10 16:03:04', 6, 1, 100.00, NULL, 1, 'root', 'localhost', '2018-03-14 16:03:29'),
(5, 10, '2018-02-10 16:03:04', 6, 1, 100.10, NULL, 2, 'root', 'localhost', '2018-03-14 16:03:35'),
(6, 12, '2018-03-14 16:04:13', 5, 1, 80.00, NULL, 1, 'root', 'localhost', '2018-03-14 16:04:21'),
(7, 13, '2018-04-19 09:43:04', 5, 5, 10.00, NULL, 1, 'root', 'localhost', '2018-04-19 09:43:11'),
(8, 5, '2018-01-05 15:59:28', 5, 1, 50.00, 'Сбербанк', 2, 'root', 'localhost', '2018-04-20 09:26:52'),
(9, 9, '2018-02-10 16:02:26', 7, 1, 100.00, 'Касса', 2, 'root', 'localhost', '2018-04-20 09:26:54'),
(10, 9, '2018-02-10 16:02:26', 7, 1, 100.00, 'Севэнергосбыт', 2, 'root', 'localhost', '2018-04-20 09:27:10'),
(11, 13, '2018-04-20 09:20:00', 7, 4, 100.50, '1111', 1, 'root', 'localhost', '2018-04-20 09:41:37'),
(12, 13, '2018-04-20 09:20:00', 7, 4, 100.57, '11117', 2, 'root', 'localhost', '2018-04-20 09:43:40'),
(13, 13, '2018-04-20 09:20:00', 7, 4, 100.57, '11117', 3, 'root', 'localhost', '2018-04-20 09:44:36'),
(14, 13, '2018-02-01 14:30:00', 5, 1, 1111.00, 'swasdwaf', 1, 'root', 'localhost', '2018-04-20 14:30:21'),
(15, 13, '2018-02-01 14:30:00', 5, 1, 1111.50, 'swasdwaf', 2, 'root', 'localhost', '2018-04-20 14:30:31'),
(16, 13, '2018-02-01 14:30:00', 5, 1, 1111.50, 'swasdwaf', 3, 'root', 'localhost', '2018-04-20 14:31:36'),
(17, 14, '2018-02-01 14:32:00', 5, 1, 5.00, NULL, 1, 'root', 'localhost', '2018-04-20 14:32:13'),
(18, 14, '2018-02-01 14:32:00', 5, 1, 5.00, NULL, 3, 'root', 'localhost', '2018-04-20 14:32:18'),
(19, 13, '2018-04-26 12:23:00', 7, 1, 100.00, NULL, 1, 'root', 'localhost', '2018-04-26 12:23:19'),
(20, 13, '2018-04-26 12:04:00', 7, 1, 100.00, NULL, 2, 'root', 'localhost', '2018-04-26 12:23:28'),
(21, 13, '2018-04-26 12:04:00', 7, 1, 100.00, NULL, 3, 'root', 'localhost', '2018-04-26 12:23:33');

-- 
-- Вывод данных для таблицы payments
--
INSERT INTO payments VALUES
(5, '2018-01-05 15:59:28', 5, 1, 50.00, 'Сбербанк'),
(7, '2018-01-07 16:00:47', 5, 1, 20.70, NULL),
(9, '2018-02-10 16:02:26', 7, 1, 100.00, 'Севэнергосбыт'),
(10, '2018-02-10 16:03:04', 6, 1, 100.10, NULL),
(12, '2018-03-14 16:04:13', 5, 1, 80.00, NULL);

-- 
-- Вывод данных для таблицы news_history
--
INSERT INTO news_history VALUES
(1, 1, '2018-02-26 09:26:39', 'заголовок1', 'Это статья', 'Текст новости', 1, 'root', 'localhost', '2018-02-26 09:27:07'),
(2, 2, '2018-02-26 09:26:39', 'заголовок1', 'Это статья', 'Текст новости', 1, 'root', 'localhost', '2018-02-26 09:27:07'),
(3, 2, '2018-02-26 09:26:39', 'заголовок1', 'Это статья', 'Текст новости', 3, 'root', 'localhost', '2018-02-26 09:27:10'),
(4, 1, '2018-02-26 09:26:39', 'заголовок1', 'Это новость', 'Текст новости', 2, 'root', 'localhost', '2018-02-26 09:27:26'),
(5, 3, '2018-02-26 09:28:39', 'заголовок2', 'Это новость', 'Текст новости 2', 1, 'root', 'localhost', '2018-02-26 09:50:14'),
(6, 4, '2018-02-26 09:28:39', 'заголовок2', 'Это новость', 'Текст новости 2', 1, 'root', 'localhost', '2018-02-26 09:50:14'),
(7, 4, '2018-02-26 09:28:39', 'заголовок2', 'Это новость', 'Текст новости 2', 3, 'root', 'localhost', '2018-02-26 09:50:17'),
(8, 1, '2018-02-26 09:26:39', 'заголовок1', 'Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости ', 'Текст новости', 2, 'root', 'localhost', '2018-02-26 12:01:20'),
(9, 1, '2018-02-26 09:26:39', 'заголовок1', 'Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости ', 'Текст новости', 2, 'root', 'localhost', '2018-02-26 12:01:21'),
(10, 3, '2018-02-26 09:28:39', 'заголовок2', 'Это новость', 'Текст новости 2', 3, 'root', 'localhost', '2018-04-04 09:29:18'),
(11, 1, '2018-02-26 09:26:39', 'заголовок1', 'Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости Это текст новости ', '<p>ПАЙЩИКАМ ГАЗОПРОВОДА СНТ &quot;СТЕПНОЙ ФАЗАН&quot;<br />\r\nЗавтра 4 марта<br />\r\nв течении дня приходите получать пакет документов для ГОРГАЗА<br />\r\nк Кайдановской Наталии, ул. Тюменская, 44<br />\r\n+7 978 77 777 04</p>', 2, 'root', 'localhost', '2018-04-04 09:29:36'),
(12, 1, '2018-02-26 09:26:39', 'заголовок1', 'Получение пакета документов для горгаза', '<p>ПАЙЩИКАМ ГАЗОПРОВОДА СНТ &quot;СТЕПНОЙ ФАЗАН&quot;<br />\r\nЗавтра 4 марта<br />\r\nв течении дня приходите получать пакет документов для ГОРГАЗА<br />\r\nк Кайдановской Наталии, ул. Тюменская, 44<br />\r\n+7 978 77 777 04</p>', 2, 'root', 'localhost', '2018-04-04 09:30:23'),
(13, 1, '2018-02-26 09:26:39', 'заголовок1', 'Получение пакета документов для горгаза', '<p>ПАЙЩИКАМ ГАЗОПРОВОДА СНТ &quot;СТЕПНОЙ ФАЗАН&quot;<br />\r\nЗавтра 4 марта<br />\r\nв течении дня приходите получать пакет документов для ГОРГАЗА<br />\r\nк Кайдановской Наталии, ул. Тюменская, 44<br />\r\n+7 978 77 777 04</p>', 2, 'root', 'localhost', '2018-04-04 09:30:23'),
(14, 1, '2018-02-26 09:26:39', 'Газопровод', 'Получение пакета документов для горгаза', '<p>ПАЙЩИКАМ ГАЗОПРОВОДА СНТ &quot;СТЕПНОЙ ФАЗАН&quot;<br />\r\nЗавтра 4 марта<br />\r\nв течении дня приходите получать пакет документов для ГОРГАЗА<br />\r\nк Кайдановской Наталии, ул. Тюменская, 44<br />\r\n+7 978 77 777 04</p>', 2, 'root', 'localhost', '2018-04-04 09:30:31'),
(15, 1, '2018-03-03 17:46:00', 'Газопровод', 'Получение пакета документов для горгаза', '<p>ПАЙЩИКАМ ГАЗОПРОВОДА СНТ &quot;СТЕПНОЙ ФАЗАН&quot;<br />\r\nЗавтра 4 марта<br />\r\nв течении дня приходите получать пакет документов для ГОРГАЗА<br />\r\nк Кайдановской Наталии, ул. Тюменская, 44<br />\r\n+7 978 77 777 04</p>', 2, 'root', 'localhost', '2018-04-04 09:32:14'),
(16, 1, '2018-03-03 17:46:00', 'Газопровод', 'Получение пакета документов для горгаза', '<p>ПАЙЩИКАМ ГАЗОПРОВОДА СНТ &quot;СТЕПНОЙ ФАЗАН&quot;<br />\r\nЗавтра 4 марта<br />\r\nв течении дня приходите получать пакет документов для ГОРГАЗА<br />\r\nк Кайдановской Наталии, ул. Тюменская, 44<br />\r\n+7 978 77 777 04</p>', 2, 'root', 'localhost', '2018-04-04 09:32:14'),
(17, 1, '2018-03-03 17:46:00', 'Газопровод kdjlsjdflsj  dkl jsflkjsl', 'Получение пакета документов для горгаза', '<p>ПАЙЩИКАМ ГАЗОПРОВОДА СНТ &quot;СТЕПНОЙ ФАЗАН&quot;<br />\r\nЗавтра 4 марта<br />\r\nв течении дня приходите получать пакет документов для ГОРГАЗА<br />\r\nк Кайдановской Наталии, ул. Тюменская, 44<br />\r\n+7 978 77 777 04</p>', 2, 'root', 'localhost', '2018-04-18 10:21:22'),
(18, 1, '2018-03-03 17:46:00', 'Газопровод kdjlsjdflsj  dkl jsflkjslds ddf', 'Получение пакета документов для горгаза', '<p>ПАЙЩИКАМ ГАЗОПРОВОДА СНТ &quot;СТЕПНОЙ ФАЗАН&quot;<br />\r\nЗавтра 4 марта<br />\r\nв течении дня приходите получать пакет документов для ГОРГАЗА<br />\r\nк Кайдановской Наталии, ул. Тюменская, 44<br />\r\n+7 978 77 777 04</p>', 2, 'root', 'localhost', '2018-04-18 10:21:35'),
(19, 1, '2018-03-03 17:46:00', 'Газопровод', 'Получение пакета документов для горгаза', '<p>ПАЙЩИКАМ ГАЗОПРОВОДА СНТ &quot;СТЕПНОЙ ФАЗАН&quot;<br />\r\nЗавтра 4 марта<br />\r\nв течении дня приходите получать пакет документов для ГОРГАЗА<br />\r\nк Кайдановской Наталии, ул. Тюменская, 44<br />\r\n+7 978 77 777 04</p>', 2, 'root', 'localhost', '2018-04-18 10:22:13'),
(20, 2, '2018-04-18 10:35:54', 'test1', 'test2', '<p>test<u><strong>3</strong></u></p>', 1, 'root', 'localhost', '2018-04-18 10:35:55'),
(21, 2, '2018-04-18 10:35:54', 'test1', 'test2', '<p>test<u><strong>3</strong></u></p>', 3, 'root', 'localhost', '2018-04-18 10:36:06'),
(22, 2, '2018-04-20 10:46:55', 'test1', 'test2', '<p>test3</p>', 1, 'root', 'localhost', '2018-04-20 10:46:56'),
(23, 3, '2018-04-20 10:50:48', '2', '2', '<p>2</p>', 1, 'root', 'localhost', '2018-04-20 10:50:49'),
(24, 4, '2018-04-20 10:51:06', '4', '4', '<p>4</p>', 1, 'root', 'localhost', '2018-04-20 10:51:06'),
(25, 5, '2018-04-20 10:53:17', '5', '5', '<p>5</p>', 1, 'root', 'localhost', '2018-04-20 10:53:17'),
(26, 6, '2018-04-20 10:53:51', '7', '7', '<p>7</p>', 1, 'root', 'localhost', '2018-04-20 10:53:51'),
(27, 7, '2018-04-20 11:02:37', '8', '8', '<p>8</p>', 1, 'root', 'localhost', '2018-04-20 11:02:38'),
(28, 8, '2018-04-20 11:07:16', '8', '8', '<p>8</p>', 1, 'root', 'localhost', '2018-04-20 11:07:17'),
(29, 9, '2018-04-20 11:08:18', '9', '9', '<p>9</p>', 1, 'root', 'localhost', '2018-04-20 11:08:19'),
(30, 10, '2018-04-20 11:14:24', '10', '10', '<p>10</p>', 1, 'root', 'localhost', '2018-04-20 11:14:24'),
(31, 6, '2018-04-20 10:53:51', '77', '7', '<p>7</p>', 2, 'root', 'localhost', '2018-04-20 11:16:07'),
(32, 6, '2018-04-20 10:53:51', '777', '7', '<p>7</p>', 2, 'root', 'localhost', '2018-04-20 11:17:39'),
(33, 6, '2018-04-20 10:53:51', '7777', '7', '<p>7</p>', 2, 'root', 'localhost', '2018-04-20 11:18:08'),
(34, 6, '2018-04-20 10:53:51', '77777', '7', '<p>7</p>', 2, 'root', 'localhost', '2018-04-20 11:18:45'),
(35, 6, '2018-04-20 10:53:51', '7', '7', '<p>7</p>', 2, 'root', 'localhost', '2018-04-20 11:19:09'),
(36, 6, '2018-04-20 10:53:51', '70', '7', '<p>7</p>', 2, 'root', 'localhost', '2018-04-20 11:37:31'),
(37, 7, '2018-04-20 11:02:37', '8', '8', '<p>8</p>', 3, 'root', 'localhost', '2018-04-20 11:40:19'),
(38, 6, '2018-04-20 10:53:51', '70', '7', '<p>7</p>', 3, 'root', 'localhost', '2018-04-20 11:56:20'),
(39, 8, '2018-04-20 11:07:16', '8', '8', '<p>8</p>', 3, 'root', 'localhost', '2018-04-20 12:05:55'),
(40, 4, '2018-04-20 10:51:06', '4', '4', '<p>4</p>', 3, 'root', 'localhost', '2018-04-20 12:31:32'),
(41, 3, '2018-04-20 10:50:48', '2', '2', '<p>2</p>', 3, 'root', 'localhost', '2018-04-20 12:31:57'),
(42, 10, '2018-04-20 11:14:24', '10', '10', '<p>10</p>', 3, 'root', 'localhost', '2018-04-20 12:38:51'),
(43, 5, '2018-04-20 10:53:17', '5', '5', '<p>5</p>', 3, 'root', 'localhost', '2018-04-20 12:42:20'),
(44, 2, '2018-04-20 10:46:55', 'test1', 'test2', '<p>test3</p>', 3, 'root', 'localhost', '2018-04-20 12:44:36'),
(45, 11, '2018-04-20 12:46:06', '1', '1', '<p>1</p>', 1, 'root', 'localhost', '2018-04-20 12:46:06'),
(46, 12, '2018-04-20 12:46:13', '5', '5', '<p>5</p>', 1, 'root', 'localhost', '2018-04-20 12:46:14'),
(47, 11, '2018-04-20 12:46:06', '11', '1', '<p>1</p>', 2, 'root', 'localhost', '2018-04-20 12:46:22'),
(48, 9, '2018-04-20 11:08:18', '9', '9', '<p>9</p>', 3, 'root', 'localhost', '2018-04-20 12:46:30'),
(49, 12, '2018-04-20 12:46:13', '5', '5', '<p>5</p>', 3, 'root', 'localhost', '2018-04-20 12:46:44'),
(50, 11, '2018-04-20 12:46:06', '11', '1', '<p>1</p>', 3, 'root', 'localhost', '2018-04-20 12:46:52'),
(51, 2, '2018-04-23 09:25:16', '1', '1', '<p>1</p>', 1, 'root', 'localhost', '2018-04-23 09:25:16'),
(52, 2, '2018-04-23 09:25:16', '1', '1вывалываолп а вы лдп п жлвпжд п плвпжд лплы ж пылп лжд лпыждп жпжд пждвлждл жд ыжвл п\\ылпвылплпждл пжд лжп п жл', '<p>1</p>', 2, 'root', 'localhost', '2018-04-23 09:26:18'),
(53, 2, '2018-04-23 09:25:16', '1', '1вывалываолп а вы лдп п жлвпжд п плвпжд лплы ж пылп лжд лпыждп жпжд пждвлждл жд ыжвл п\\ылпвылплпждл пжд лжп п жл', '<p>1</p>', 3, 'root', 'localhost', '2018-04-23 09:55:17'),
(54, 2, '2018-04-26 12:03:57', 't', 't', '<p><strong>t</strong></p>', 1, 'root', 'localhost', '2018-04-26 12:03:57'),
(55, 2, '2018-04-26 12:03:57', 't7', 't', '<p><strong>t</strong></p>', 2, 'root', 'localhost', '2018-04-26 12:04:59'),
(56, 2, '2018-04-26 12:03:57', 't7', 't', '<p><strong>t</strong></p>', 3, 'root', 'localhost', '2018-04-26 12:05:05'),
(57, 3, '2018-04-26 13:42:39', '1', '1', '<p>1</p>', 1, 'root', 'localhost', '2018-04-26 13:42:39'),
(58, 3, '2018-04-26 13:42:39', '1', '1', '<p>1</p>', 3, 'root', 'localhost', '2018-04-26 13:42:44'),
(59, 4, '2018-04-26 13:43:10', '1', '1', '<p>1</p>', 1, 'root', 'localhost', '2018-04-26 13:43:10'),
(60, 4, '2018-04-26 13:43:10', '1', '1', '<p>1</p>', 3, 'root', 'localhost', '2018-04-26 13:43:15'),
(61, 5, '2018-04-26 13:45:40', '1', '1', '<p>1</p>', 1, 'root', 'localhost', '2018-04-26 13:45:40'),
(62, 5, '2018-04-26 13:45:40', '1', '1', '<p>1</p>', 3, 'root', 'localhost', '2018-04-26 15:53:17'),
(63, 2, '2018-05-11 14:28:56', 'test1', 'wew2qe', '<p>eeeee</p>', 1, 'root', 'localhost', '2018-05-11 14:28:56'),
(64, 2, '2018-05-11 14:28:56', 'test1', 'wew2qe', '<p>eeeee</p>', 3, 'root', 'localhost', '2018-05-11 14:31:18');

-- 
-- Вывод данных для таблицы news
--
INSERT INTO news VALUES
(1, '2018-03-03 17:46:00', 'Газопровод', 'Получение пакета документов для горгаза', '<p>ПАЙЩИКАМ ГАЗОПРОВОДА СНТ &quot;СТЕПНОЙ ФАЗАН&quot;<br />\r\nЗавтра 4 марта<br />\r\nв течении дня приходите получать пакет документов для ГОРГАЗА<br />\r\nк Кайдановской Наталии, ул. Тюменская, 44<br />\r\n+7 978 77 777 04</p>');

-- 
-- Вывод данных для таблицы messages_history
--
INSERT INTO messages_history VALUES
(1, 1, '2018-03-13 10:54:29', 2, 1, '1', '2', 0, 1, 'root', 'localhost', '2018-03-13 10:54:42'),
(2, 1, '2018-03-13 10:54:29', 1, 2, '1', '2', 0, 2, 'root', 'localhost', '2018-03-13 10:56:57'),
(3, 3, '2018-03-13 11:22:42', 2, 1, '11', '22', 0, 1, 'root', 'localhost', '2018-03-13 11:22:57'),
(4, 3, '2018-03-13 11:22:42', 2, 1, '11', '22', 1, 2, 'root', 'localhost', '2018-03-13 11:23:00'),
(5, 4, '2018-03-13 12:31:39', 1, 1, 'ttttt', 't', 0, 1, 'root', 'localhost', '2018-03-13 12:41:14'),
(6, 4, '2018-03-13 12:31:39', 1, 1, 'ttttt', 't', 0, 3, 'root', 'localhost', '2018-03-13 12:41:22'),
(7, 4, '2018-03-27 14:27:05', 1, 1, '1', '2', 0, 1, 'root', 'localhost', '2018-03-27 14:27:05'),
(8, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 0, 1, 'root', 'localhost', '2018-03-27 14:27:44'),
(9, 6, '2018-03-27 14:30:33', 2, 1, '11111111111', '222222222222222', 0, 1, 'root', 'localhost', '2018-03-27 14:30:34'),
(10, 8, '2018-03-27 14:34:05', 4, 1, '0', '00', 0, 1, 'root', 'localhost', '2018-03-27 14:34:06'),
(11, 9, '2018-03-27 14:37:02', 3, 1, '7', '77', 0, 1, 'root', 'localhost', '2018-03-27 14:37:02'),
(12, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-03-27 15:17:02'),
(13, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-03-27 15:17:02'),
(14, 10, '2018-03-28 11:52:55', 3, 1, 'test555', 'safsgfsdgasghaewhewhw', 0, 1, 'root', 'localhost', '2018-03-28 11:52:56'),
(15, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-04 15:38:45'),
(16, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-04 15:39:20'),
(17, 4, '2018-03-27 14:27:05', 1, 1, '1', '2', 1, 2, 'root', 'localhost', '2018-04-04 15:39:24'),
(18, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-04 15:39:28'),
(19, 4, '2018-03-27 14:27:05', 1, 1, '1', '2', 0, 2, 'root', 'localhost', '2018-04-04 15:39:42'),
(20, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 0, 2, 'root', 'localhost', '2018-04-04 15:40:54'),
(21, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 2, 'root', 'localhost', '2018-04-04 15:41:08'),
(22, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 0, 2, 'root', 'localhost', '2018-04-04 15:41:13'),
(23, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 2, 'root', 'localhost', '2018-04-04 15:41:54'),
(24, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 0, 2, 'root', 'localhost', '2018-04-04 15:41:58'),
(25, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 2, 'root', 'localhost', '2018-04-04 15:44:29'),
(26, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 0, 2, 'root', 'localhost', '2018-04-04 15:44:35'),
(27, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 2, 'root', 'localhost', '2018-04-04 15:48:39'),
(28, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 0, 2, 'root', 'localhost', '2018-04-04 15:48:44'),
(29, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 2, 'root', 'localhost', '2018-04-04 15:48:54'),
(30, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 0, 2, 'root', 'localhost', '2018-04-04 15:49:01'),
(31, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 2, 'root', 'localhost', '2018-04-04 15:49:34'),
(32, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 0, 2, 'root', 'localhost', '2018-04-04 15:49:41'),
(33, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 2, 'root', 'localhost', '2018-04-04 15:50:33'),
(34, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 0, 2, 'root', 'localhost', '2018-04-04 15:50:39'),
(35, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 2, 'root', 'localhost', '2018-04-04 15:50:44'),
(36, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 0, 2, 'root', 'localhost', '2018-04-04 15:50:48'),
(37, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-04 15:53:46'),
(38, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 2, 'root', 'localhost', '2018-04-04 15:53:47'),
(39, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 0, 2, 'root', 'localhost', '2018-04-04 15:53:53'),
(40, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-04 15:56:04'),
(41, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-04 16:43:57'),
(42, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-05 11:15:28'),
(43, 11, '2018-04-12 14:21:17', 3, 1, '7', '1234567', 0, 1, 'root', 'localhost', '2018-04-12 14:21:18'),
(44, 12, '2018-04-12 14:22:27', 3, 1, '12', '21', 0, 1, 'root', 'localhost', '2018-04-12 14:22:27'),
(45, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-12 14:49:21'),
(46, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-12 14:55:45'),
(47, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-12 14:55:59'),
(48, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 2, 'root', 'localhost', '2018-04-12 14:56:02'),
(49, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-12 14:56:05'),
(50, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 2, 'root', 'localhost', '2018-04-12 14:56:07'),
(51, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-12 15:01:05'),
(52, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-12 15:01:24'),
(53, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-12 15:01:37'),
(54, 13, '2018-04-12 15:01:58', 2, 1, 'test', '1\r\n2\r\n3', 0, 1, 'root', 'localhost', '2018-04-12 15:01:58'),
(55, 13, '2018-04-12 15:01:58', 2, 1, 'test', 'Устанавливает интерлиньяж (межстрочный интервал) текста, отсчет ведется от базовой линии шрифта. При обычных обстоятельствах расстояние между строками зависит от вида и размера шрифта и определяется браузером автоматически. Отрицательное значение межстрочного расстояния не допускается.\r\nЛюбое число больше нуля воспринимается как множитель от размера шрифта текущего текста. Например, значение 1.5 устанавливает полуторный межстрочный интервал. В качестве значений принимаются также любые единицы длины, принятые в CSS — пикселы (px), дюймы (in), пункты (pt) и др. Разрешается использовать процентную запись, в этом случае за 100% берется высота шрифта.', 0, 2, 'root', 'localhost', '2018-04-12 15:05:43'),
(56, 13, '2018-04-12 15:01:58', 2, 1, 'test', 'Устанавливает интерлиньяж (межстрочный интервал) текста, отсчет ведется от базовой линии шрифта. При обычных обстоятельствах расстояние между строками зависит от вида и размера шрифта и определяется браузером автоматически. Отрицательное значение межстрочного расстояния не допускается.\r\nЛюбое число больше нуля воспринимается как множитель от размера шрифта текущего текста. Например, значение 1.5 устанавливает полуторный межстрочный интервал. В качестве значений принимаются также любые единицы длины, принятые в CSS — пикселы (px), дюймы (in), пункты (pt) и др. Разрешается использовать процентную запись, в этом случае за 100% берется высота шрифта.', 0, 2, 'root', 'localhost', '2018-04-12 15:05:43'),
(57, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-12 15:33:23'),
(58, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 2, 'root', 'localhost', '2018-04-12 15:33:27'),
(59, 5, '2018-03-27 14:27:44', 1, 1, '11111', '22222', 1, 2, 'root', 'localhost', '2018-04-12 15:33:28'),
(60, 5, '2018-03-27 14:27:44', 1, 1, 'Тестовое входящее сообщение № 1', '22222', 1, 2, 'root', 'localhost', '2018-04-12 15:34:12'),
(61, 5, '2018-03-27 14:27:44', 1, 1, 'Тестовое входящее сообщение № 1', 'авыа', 1, 2, 'root', 'localhost', '2018-04-12 15:34:19'),
(62, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'авыа', 1, 2, 'root', 'localhost', '2018-04-12 15:34:35'),
(63, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'авыа', 1, 2, 'root', 'localhost', '2018-04-12 15:34:40'),
(64, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1, 2, 'root', 'localhost', '2018-04-12 15:35:03'),
(65, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1, 2, 'root', 'localhost', '2018-04-12 15:35:08'),
(66, 4, '2018-03-27 14:27:05', 1, 1, '10', '2', 1, 3, 'root', 'localhost', '2018-04-12 15:35:31'),
(67, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', '2', 0, 2, 'root', 'localhost', '2018-04-12 15:35:59'),
(68, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).', 0, 2, 'root', 'localhost', '2018-04-12 15:36:22'),
(69, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).', 1, 2, 'root', 'localhost', '2018-04-12 15:36:34'),
(70, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).', 0, 2, 'root', 'localhost', '2018-04-12 15:36:44'),
(71, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).', 1, 2, 'root', 'localhost', '2018-04-12 15:36:47'),
(72, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 0, 2, 'root', 'localhost', '2018-04-12 15:36:48'),
(73, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).', 1, 2, 'root', 'localhost', '2018-04-12 15:36:54'),
(74, 8, '2018-03-27 14:34:05', 4, 1, '0', '00', 0, 3, 'root', 'localhost', '2018-04-12 15:37:45'),
(75, 9, '2018-03-27 14:37:02', 3, 1, '7', '77', 0, 3, 'root', 'localhost', '2018-04-12 15:37:45'),
(76, 10, '2018-03-28 11:52:55', 3, 1, 'test555', 'safsgfsdgasghaewhewhw', 0, 3, 'root', 'localhost', '2018-04-12 15:37:45'),
(77, 11, '2018-04-12 14:21:17', 3, 1, '7', '1234567', 0, 3, 'root', 'localhost', '2018-04-12 15:37:45'),
(78, 12, '2018-04-12 14:22:27', 3, 1, '12', '21', 0, 3, 'root', 'localhost', '2018-04-12 15:37:45'),
(79, 3, '2018-03-13 11:22:42', 4, 1, '11', '22', 1, 2, 'root', 'localhost', '2018-04-12 15:37:57'),
(80, 3, '2018-03-13 11:22:42', 4, 1, 'Тема исходящего', '22', 1, 2, 'root', 'localhost', '2018-04-12 15:38:20'),
(81, 6, '2018-03-27 14:30:33', 2, 1, 'Второе исходящее', '222222222222222', 0, 2, 'root', 'localhost', '2018-04-12 15:38:27'),
(82, 13, '2018-04-12 15:01:58', 2, 1, 'Новое исходящее', 'Устанавливает интерлиньяж (межстрочный интервал) текста, отсчет ведется от базовой линии шрифта. При обычных обстоятельствах расстояние между строками зависит от вида и размера шрифта и определяется браузером автоматически. Отрицательное значение межстрочного расстояния не допускается.\r\nЛюбое число больше нуля воспринимается как множитель от размера шрифта текущего текста. Например, значение 1.5 устанавливает полуторный межстрочный интервал. В качестве значений принимаются также любые единицы длины, принятые в CSS — пикселы (px), дюймы (in), пункты (pt) и др. Разрешается использовать процентную запись, в этом случае за 100% берется высота шрифта.', 0, 2, 'root', 'localhost', '2018-04-12 15:38:37'),
(83, 3, '2018-03-13 11:22:42', 4, 1, 'Тема исходящего', 'Основным объектом манипуляции в HTTP является ресурс, на который указывает URI (Uniform Resource Identifier) в запросе клиента. Обычно такими ресурсами являются хранящиеся на сервере файлы, но ими могут быть логические объекты или что-то абстрактное. Особенностью протокола HTTP является возможность указать в запросе и ответе способ представления одного и того же ресурса по различным параметрам: формату, кодировке, языку и т. д. (в частности, для этого используется HTTP-заголовок). Именно благодаря возможности указания способа кодирования сообщения, клиент и сервер могут обмениваться двоичными данными, хотя данный протокол является текстовым.', 1, 2, 'root', 'localhost', '2018-04-12 15:38:58'),
(84, 6, '2018-03-27 14:30:33', 2, 1, 'Второе исходящее', 'Основным объектом манипуляции в HTTP является ресурс, на который указывает URI (Uniform Resource Identifier) в запросе клиента. Обычно такими ресурсами являются хранящиеся на сервере файлы, но ими могут быть логические объекты или что-то абстрактное. Особенностью протокола HTTP является возможность указать в запросе и ответе способ представления одного и того же ресурса по различным параметрам: формату, кодировке, языку и т. д. (в частности, для этого используется HTTP-заголовок). Именно благодаря возможности указания способа кодирования сообщения, клиент и сервер могут обмениваться двоичными данными, хотя данный протокол является текстовым.\r\n\r\nHTTP — протокол прикладного уровня; аналогичными ему являются FTP и SMTP. Обмен сообщениями идёт по обыкновенной схеме «запрос-ответ». Для идентификации ресурсов HTTP использует глобальные URI. В отличие от многих других протоколов, HTTP не сохраняет своего состояния. Это означает отсутствие сохранения промежуточного состояния между парами «запрос-ответ». Компоненты, использующие HTTP, могут самостоятельно осуществлять сохранение информации о состоянии, связанной с последними запросами и ответами (например, «куки» на стороне клиента, «сессии» на стороне сервера). Браузер, посылающий запросы, может отслеживать задержки ответов. Сервер может хранить IP-адреса и заголовки запросов последних клиентов. Однако сам протокол не осведомлён о предыдущих запросах и ответах, в нём не предусмотрена внутренняя поддержка состояния, к нему не предъявляются такие требования.', 0, 2, 'root', 'localhost', '2018-04-12 15:39:10'),
(85, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).', 1, 2, 'root', 'localhost', '2018-04-12 15:39:29'),
(86, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).\r\nИзначально язык HTML был задуман и создан как средство структурирования и форматирования документов без их привязки к средствам воспроизведения (отображения). В идеале, текст с разметкой HTML должен был без стилистических и структурных искажений воспроизводиться на оборудовании с различной технической оснащённостью (цветной экран современного компьютера, монохромный экран органайзера, ограниченный по размерам экран мобильного телефона или устройства и программы голосового воспроизведения текстов). Однако современное применение HTML очень далеко от его изначальной задачи. Например, тег <table> предназначен для создания в документах таблиц, но иногда используется и для оформления размещения элементов на странице. С течением времени основная идея платформонезависимости языка HTML была принесена в жертву современным потребностям в мультимедийном и графическом оформлении.', 1, 2, 'root', 'localhost', '2018-04-12 15:39:53'),
(87, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).\r\nИзначально язык HTML был задуман и создан как средство структурирования и форматирования документов без их привязки к средствам воспроизведения (отображения). В идеале, текст с разметкой HTML должен был без стилистических и структурных искажений воспроизводиться на оборудовании с различной технической оснащённостью (цветной экран современного компьютера, монохромный экран органайзера, ограниченный по размерам экран мобильного телефона или устройства и программы голосового воспроизведения текстов). Однако современное применение HTML очень далеко от его изначальной задачи. Например, тег <table> предназначен для создания в документах таблиц, но иногда используется и для оформления размещения элементов на странице. С течением времени основная идея платформонезависимости языка HTML была принесена в жертву современным потребностям в мультимедийном и графическом оформлении.', 1, 2, 'root', 'localhost', '2018-04-12 15:39:58'),
(88, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).\r\nИзначально язык HTML был задуман и создан как средство структурирования и форматирования документов без их привязки к средствам воспроизведения (отображения). В идеале, текст с разметкой HTML должен был без стилистических и структурных искажений воспроизводиться на оборудовании с различной технической оснащённостью (цветной экран современного компьютера, монохромный экран органайзера, ограниченный по размерам экран мобильного телефона или устройства и программы голосового воспроизведения текстов). Однако современное применение HTML очень далеко от его изначальной задачи. Например, тег <table> предназначен для создания в документах таблиц, но иногда используется и для оформления размещения элементов на странице. С течением времени основная идея платформонезависимости языка HTML была принесена в жертву современным потребностям в мультимедийном и графическом оформлении.', 1, 2, 'root', 'localhost', '2018-04-12 15:40:16'),
(89, 14, '2018-04-13 14:16:22', 2, 1, '777', '888', 0, 1, 'root', 'localhost', '2018-04-13 14:16:23'),
(90, 14, '2018-04-13 14:16:22', 2, 1, '777', '888', 0, 3, 'root', 'localhost', '2018-04-13 14:16:47'),
(91, 15, '2018-04-13 14:50:02', 4, 1, '11111111111', '222222222222', 0, 1, 'root', 'localhost', '2018-04-13 14:50:03'),
(92, 15, '2018-04-13 14:50:02', 4, 1, '11111111111', '222222222222', 0, 3, 'root', 'localhost', '2018-04-13 14:50:18'),
(93, 14, '2018-04-19 09:44:30', 5, 1, 'ееее', 'ееее', 0, 1, 'root', 'localhost', '2018-04-19 09:44:39'),
(94, 15, '2018-04-19 09:44:42', 1, 5, 'ааааа', 'аааа', 0, 1, 'root', 'localhost', '2018-04-19 09:44:50'),
(95, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1, 2, 'root', 'localhost', '2018-04-23 09:23:58'),
(96, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).\r\nИзначально язык HTML был задуман и создан как средство структурирования и форматирования документов без их привязки к средствам воспроизведения (отображения). В идеале, текст с разметкой HTML должен был без стилистических и структурных искажений воспроизводиться на оборудовании с различной технической оснащённостью (цветной экран современного компьютера, монохромный экран органайзера, ограниченный по размерам экран мобильного телефона или устройства и программы голосового воспроизведения текстов). Однако современное применение HTML очень далеко от его изначальной задачи. Например, тег <table> предназначен для создания в документах таблиц, но иногда используется и для оформления размещения элементов на странице. С течением времени основная идея платформонезависимости языка HTML была принесена в жертву современным потребностям в мультимедийном и графическом оформлении.', 1, 2, 'root', 'localhost', '2018-04-23 09:24:06'),
(97, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1, 2, 'root', 'localhost', '2018-04-23 09:24:11'),
(98, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1, 2, 'root', 'localhost', '2018-04-23 10:00:54'),
(99, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).\r\nИзначально язык HTML был задуман и создан как средство структурирования и форматирования документов без их привязки к средствам воспроизведения (отображения). В идеале, текст с разметкой HTML должен был без стилистических и структурных искажений воспроизводиться на оборудовании с различной технической оснащённостью (цветной экран современного компьютера, монохромный экран органайзера, ограниченный по размерам экран мобильного телефона или устройства и программы голосового воспроизведения текстов). Однако современное применение HTML очень далеко от его изначальной задачи. Например, тег <table> предназначен для создания в документах таблиц, но иногда используется и для оформления размещения элементов на странице. С течением времени основная идея платформонезависимости языка HTML была принесена в жертву современным потребностям в мультимедийном и графическом оформлении.', 1, 2, 'root', 'localhost', '2018-04-23 10:00:56'),
(100, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1, 2, 'root', 'localhost', '2018-04-23 15:04:43'),
(101, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).\r\nИзначально язык HTML был задуман и создан как средство структурирования и форматирования документов без их привязки к средствам воспроизведения (отображения). В идеале, текст с разметкой HTML должен был без стилистических и структурных искажений воспроизводиться на оборудовании с различной технической оснащённостью (цветной экран современного компьютера, монохромный экран органайзера, ограниченный по размерам экран мобильного телефона или устройства и программы голосового воспроизведения текстов). Однако современное применение HTML очень далеко от его изначальной задачи. Например, тег <table> предназначен для создания в документах таблиц, но иногда используется и для оформления размещения элементов на странице. С течением времени основная идея платформонезависимости языка HTML была принесена в жертву современным потребностям в мультимедийном и графическом оформлении.', 1, 2, 'root', 'localhost', '2018-04-23 15:04:44'),
(102, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1, 2, 'root', 'localhost', '2018-04-26 12:21:11'),
(103, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).\r\nИзначально язык HTML был задуман и создан как средство структурирования и форматирования документов без их привязки к средствам воспроизведения (отображения). В идеале, текст с разметкой HTML должен был без стилистических и структурных искажений воспроизводиться на оборудовании с различной технической оснащённостью (цветной экран современного компьютера, монохромный экран органайзера, ограниченный по размерам экран мобильного телефона или устройства и программы голосового воспроизведения текстов). Однако современное применение HTML очень далеко от его изначальной задачи. Например, тег <table> предназначен для создания в документах таблиц, но иногда используется и для оформления размещения элементов на странице. С течением времени основная идея платформонезависимости языка HTML была принесена в жертву современным потребностям в мультимедийном и графическом оформлении.', 1, 2, 'root', 'localhost', '2018-04-26 12:21:13'),
(104, 14, '2018-04-26 12:21:27', 3, 1, '1', '01', 0, 1, 'root', 'localhost', '2018-04-26 12:21:27'),
(105, 14, '2018-04-26 12:21:27', 3, 1, '1', '01', 0, 3, 'root', 'localhost', '2018-04-26 12:21:52'),
(106, 6, '2018-03-27 14:30:33', 2, 1, 'Второе исходящее', 'Основным объектом манипуляции в HTTP является ресурс, на который указывает URI (Uniform Resource Identifier) в запросе клиента. Обычно такими ресурсами являются хранящиеся на сервере файлы, но ими могут быть логические объекты или что-то абстрактное. Особенностью протокола HTTP является возможность указать в запросе и ответе способ представления одного и того же ресурса по различным параметрам: формату, кодировке, языку и т. д. (в частности, для этого используется HTTP-заголовок). Именно благодаря возможности указания способа кодирования сообщения, клиент и сервер могут обмениваться двоичными данными, хотя данный протокол является текстовым.\r\n\r\nHTTP — протокол прикладного уровня; аналогичными ему являются FTP и SMTP. Обмен сообщениями идёт по обыкновенной схеме «запрос-ответ». Для идентификации ресурсов HTTP использует глобальные URI. В отличие от многих других протоколов, HTTP не сохраняет своего состояния. Это означает отсутствие сохранения промежуточного состояния между парами «запрос-ответ». Компоненты, использующие HTTP, могут самостоятельно осуществлять сохранение информации о состоянии, связанной с последними запросами и ответами (например, «куки» на стороне клиента, «сессии» на стороне сервера). Браузер, посылающий запросы, может отслеживать задержки ответов. Сервер может хранить IP-адреса и заголовки запросов последних клиентов. Однако сам протокол не осведомлён о предыдущих запросах и ответах, в нём не предусмотрена внутренняя поддержка состояния, к нему не предъявляются такие требования.', 1, 2, 'root', 'localhost', '2018-04-26 12:36:50'),
(107, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1, 2, 'root', 'localhost', '2018-04-26 13:29:59'),
(108, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1, 2, 'root', 'localhost', '2018-05-11 15:17:06'),
(109, 1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).\r\nИзначально язык HTML был задуман и создан как средство структурирования и форматирования документов без их привязки к средствам воспроизведения (отображения). В идеале, текст с разметкой HTML должен был без стилистических и структурных искажений воспроизводиться на оборудовании с различной технической оснащённостью (цветной экран современного компьютера, монохромный экран органайзера, ограниченный по размерам экран мобильного телефона или устройства и программы голосового воспроизведения текстов). Однако современное применение HTML очень далеко от его изначальной задачи. Например, тег <table> предназначен для создания в документах таблиц, но иногда используется и для оформления размещения элементов на странице. С течением времени основная идея платформонезависимости языка HTML была принесена в жертву современным потребностям в мультимедийном и графическом оформлении.', 1, 2, 'root', 'localhost', '2018-05-11 15:17:08'),
(110, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 0, 2, 'root', 'localhost', '2018-05-11 15:17:56'),
(111, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1, 2, 'root', 'localhost', '2018-05-11 15:18:00'),
(112, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1, 2, 'root', 'localhost', '2018-05-14 15:38:09'),
(113, 5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1, 2, 'root', 'localhost', '2018-05-14 16:04:23');

-- 
-- Вывод данных для таблицы messages
--
INSERT INTO messages VALUES
(1, '2018-03-13 10:54:29', 1, 2, 'Еще одно тестовое сообщение', 'Текстовые документы, содержащие разметку на языке HTML (такие документы традиционно имеют расширение .html или .htm), обрабатываются специальными приложениями, которые отображают документ в его форматированном виде. Такие приложения, называемые «браузерами» или «интернет-обозревателями», обычно предоставляют пользователю удобный интерфейс для запроса веб-страниц, их просмотра (и вывода на иные внешние устройства) и, при необходимости, отправки введённых пользователем данных на сервер. Наиболее популярными на сегодняшний день браузерами являются Google Chrome, Mozilla Firefox, Opera, Internet Explorer и Safari (см.: Браузер#Рыночные доли).\r\nИзначально язык HTML был задуман и создан как средство структурирования и форматирования документов без их привязки к средствам воспроизведения (отображения). В идеале, текст с разметкой HTML должен был без стилистических и структурных искажений воспроизводиться на оборудовании с различной технической оснащённостью (цветной экран современного компьютера, монохромный экран органайзера, ограниченный по размерам экран мобильного телефона или устройства и программы голосового воспроизведения текстов). Однако современное применение HTML очень далеко от его изначальной задачи. Например, тег <table> предназначен для создания в документах таблиц, но иногда используется и для оформления размещения элементов на странице. С течением времени основная идея платформонезависимости языка HTML была принесена в жертву современным потребностям в мультимедийном и графическом оформлении.', 1),
(3, '2018-03-13 11:22:42', 4, 1, 'Тема исходящего', 'Основным объектом манипуляции в HTTP является ресурс, на который указывает URI (Uniform Resource Identifier) в запросе клиента. Обычно такими ресурсами являются хранящиеся на сервере файлы, но ими могут быть логические объекты или что-то абстрактное. Особенностью протокола HTTP является возможность указать в запросе и ответе способ представления одного и того же ресурса по различным параметрам: формату, кодировке, языку и т. д. (в частности, для этого используется HTTP-заголовок). Именно благодаря возможности указания способа кодирования сообщения, клиент и сервер могут обмениваться двоичными данными, хотя данный протокол является текстовым.', 1),
(5, '2018-03-27 14:27:44', 1, 3, 'Тестовое входящее сообщение № 1', 'Язык HTML был разработан британским учёным Тимом Бернерсом-Ли приблизительно в 1986—1991 годах в стенах ЦЕРНа в Женеве в Швейцарии. HTML создавался как язык для обмена научной и технической документацией, пригодный для использования людьми, не являющимися специалистами в области вёрстки. HTML успешно справлялся с проблемой сложности SGML путём определения небольшого набора структурных и семантических элементов — дескрипторов. Дескрипторы также часто называют «тегами». С помощью HTML можно легко создать относительно простой, но красиво оформленный документ. Помимо упрощения структуры документа, в HTML внесена поддержка гипертекста. Мультимедийные возможности были добавлены позже.', 1),
(6, '2018-03-27 14:30:33', 2, 1, 'Второе исходящее', 'Основным объектом манипуляции в HTTP является ресурс, на который указывает URI (Uniform Resource Identifier) в запросе клиента. Обычно такими ресурсами являются хранящиеся на сервере файлы, но ими могут быть логические объекты или что-то абстрактное. Особенностью протокола HTTP является возможность указать в запросе и ответе способ представления одного и того же ресурса по различным параметрам: формату, кодировке, языку и т. д. (в частности, для этого используется HTTP-заголовок). Именно благодаря возможности указания способа кодирования сообщения, клиент и сервер могут обмениваться двоичными данными, хотя данный протокол является текстовым.\r\n\r\nHTTP — протокол прикладного уровня; аналогичными ему являются FTP и SMTP. Обмен сообщениями идёт по обыкновенной схеме «запрос-ответ». Для идентификации ресурсов HTTP использует глобальные URI. В отличие от многих других протоколов, HTTP не сохраняет своего состояния. Это означает отсутствие сохранения промежуточного состояния между парами «запрос-ответ». Компоненты, использующие HTTP, могут самостоятельно осуществлять сохранение информации о состоянии, связанной с последними запросами и ответами (например, «куки» на стороне клиента, «сессии» на стороне сервера). Браузер, посылающий запросы, может отслеживать задержки ответов. Сервер может хранить IP-адреса и заголовки запросов последних клиентов. Однако сам протокол не осведомлён о предыдущих запросах и ответах, в нём не предусмотрена внутренняя поддержка состояния, к нему не предъявляются такие требования.', 1),
(13, '2018-04-12 15:01:58', 2, 1, 'Новое исходящее', 'Устанавливает интерлиньяж (межстрочный интервал) текста, отсчет ведется от базовой линии шрифта. При обычных обстоятельствах расстояние между строками зависит от вида и размера шрифта и определяется браузером автоматически. Отрицательное значение межстрочного расстояния не допускается.\r\nЛюбое число больше нуля воспринимается как множитель от размера шрифта текущего текста. Например, значение 1.5 устанавливает полуторный межстрочный интервал. В качестве значений принимаются также любые единицы длины, принятые в CSS — пикселы (px), дюймы (in), пункты (pt) и др. Разрешается использовать процентную запись, в этом случае за 100% берется высота шрифта.', 0);

-- 
-- Вывод данных для таблицы measurements_history
--
INSERT INTO measurements_history VALUES
(1, 2, '2018-03-12 10:08:58', 5, 1, 100.00, 1, 'root', 'localhost', '2018-03-14 10:09:34'),
(2, 3, '2018-03-12 10:09:42', 7, 1, 200.00, 1, 'root', 'localhost', '2018-03-14 10:10:06'),
(3, 4, '2018-03-14 10:10:25', 5, 1, 150.00, 1, 'root', 'localhost', '2018-03-14 10:10:34'),
(4, 5, '2018-02-10 10:57:47', 5, 1, 80.50, 1, 'root', 'localhost', '2018-03-14 10:58:04'),
(5, 7, '2018-03-10 10:58:39', 7, 1, 180.00, 1, 'root', 'localhost', '2018-03-14 10:58:54'),
(6, 7, '2018-03-10 08:58:39', 7, 1, 180.00, 2, 'root', 'localhost', '2018-03-14 11:55:05'),
(7, 5, '2018-02-10 09:57:47', 5, 1, 80.50, 2, 'root', 'localhost', '2018-03-14 11:55:07'),
(8, 3, '2018-03-12 11:09:42', 7, 1, 200.00, 2, 'root', 'localhost', '2018-03-14 11:55:09'),
(9, 2, '2018-03-12 12:08:58', 5, 1, 100.00, 2, 'root', 'localhost', '2018-03-14 11:55:11'),
(10, 7, '2018-02-10 08:58:39', 7, 1, 180.00, 2, 'root', 'localhost', '2018-03-14 11:58:56'),
(11, 7, '2018-02-10 08:58:39', 7, 1, 180.00, 2, 'root', 'localhost', '2018-03-14 11:58:56'),
(12, 8, '2018-01-01 15:11:40', 5, 1, 77.00, 1, 'root', 'localhost', '2018-03-14 15:11:57'),
(13, 10, '2018-01-01 14:12:37', 7, 1, 177.00, 1, 'root', 'localhost', '2018-03-14 15:12:53'),
(14, 11, '2018-04-19 09:45:29', 5, 5, 100.00, 1, 'root', 'localhost', '2018-04-19 09:45:36'),
(15, 12, '2018-04-19 15:41:13', 7, 4, 500.10, 1, 'root', 'localhost', '2018-04-19 15:41:13'),
(16, 12, '2018-04-19 15:41:13', 7, 4, 500.10, 3, 'root', 'localhost', '2018-04-19 15:41:32'),
(17, 13, '2018-04-19 15:44:02', 7, 4, 70.50, 1, 'root', 'localhost', '2018-04-19 15:44:03'),
(18, 13, '2018-04-19 15:44:02', 7, 4, 70.50, 3, 'root', 'localhost', '2018-04-19 15:45:06'),
(19, 14, '2018-04-19 15:54:18', 7, 4, 1.20, 1, 'root', 'localhost', '2018-04-19 15:54:19'),
(20, 14, '2018-04-19 15:54:18', 7, 4, 1.25, 2, 'root', 'localhost', '2018-04-19 16:02:39'),
(21, 14, '2018-04-19 15:54:18', 7, 4, 1.25, 3, 'root', 'localhost', '2018-04-19 16:05:37'),
(22, 15, '2018-04-19 19:13:00', 7, 4, 1.50, 1, 'root', 'localhost', '2018-04-19 16:13:32'),
(23, 15, '2018-04-19 07:00:00', 7, 4, 1.57, 2, 'root', 'localhost', '2018-04-19 16:14:42'),
(24, 15, '2018-04-19 07:00:00', 7, 4, 100.50, 2, 'root', 'localhost', '2018-04-19 16:18:30'),
(25, 16, '2018-04-01 16:18:00', 7, 4, 10.00, 1, 'root', 'localhost', '2018-04-19 16:18:41'),
(26, 16, '2018-03-01 16:18:00', 7, 4, 10.00, 2, 'root', 'localhost', '2018-04-19 16:19:30'),
(27, 15, '2018-04-19 07:00:00', 7, 4, 100.50, 3, 'root', 'localhost', '2018-04-20 09:12:57'),
(28, 17, '2018-03-10 14:18:00', 5, 1, 111111.00, 1, 'root', 'localhost', '2018-04-20 14:19:06'),
(29, 17, '2018-03-10 14:18:00', 5, 1, 111111.50, 2, 'root', 'localhost', '2018-04-20 14:20:46'),
(30, 17, '2018-03-10 14:18:00', 5, 1, 111111.57, 2, 'root', 'localhost', '2018-04-20 14:22:17'),
(31, 17, '2018-03-10 14:18:00', 5, 1, 111111.57, 3, 'root', 'localhost', '2018-04-20 14:25:05'),
(32, 17, '2018-04-26 12:00:00', 7, 1, 900.00, 1, 'root', 'localhost', '2018-04-26 12:22:50'),
(33, 17, '2018-04-26 12:00:00', 7, 1, 900.10, 2, 'root', 'localhost', '2018-04-26 12:22:58'),
(34, 17, '2018-04-26 12:00:00', 7, 1, 900.10, 3, 'root', 'localhost', '2018-04-26 12:23:03'),
(35, 17, '2018-04-03 15:35:00', 5, 1, 170.00, 1, 'root', 'localhost', '2018-05-15 15:35:55'),
(36, 18, '2018-04-05 15:35:00', 5, 1, 190.00, 1, 'root', 'localhost', '2018-05-15 15:36:06'),
(37, 19, '2018-04-15 15:36:00', 7, 1, 300.00, 1, 'root', 'localhost', '2018-05-15 15:36:24');

-- 
-- Вывод данных для таблицы measurements
--
INSERT INTO measurements VALUES
(2, '2018-03-12 12:08:58', 5, 1, 100.00),
(3, '2018-03-12 11:09:42', 7, 1, 200.00),
(4, '2018-03-14 10:10:25', 5, 1, 150.00),
(5, '2018-02-10 09:57:47', 5, 1, 80.50),
(7, '2018-02-10 08:58:39', 7, 1, 180.00),
(8, '2018-01-01 15:11:40', 5, 1, 77.00),
(10, '2018-01-01 14:12:37', 7, 1, 177.00),
(16, '2018-03-01 16:18:00', 7, 4, 10.00),
(17, '2018-04-03 15:35:00', 5, 1, 170.00),
(18, '2018-04-05 15:35:00', 5, 1, 190.00),
(19, '2018-04-15 15:36:00', 7, 1, 300.00);

-- 
-- Вывод данных для таблицы feedbacks_history
--
INSERT INTO feedbacks_history VALUES
(1, 1, '2018-03-05 15:54:51', 8, 1, 1, NULL, 1, 'root', 'localhost', '2018-03-05 15:55:10'),
(2, 2, '2018-03-30 13:12:42', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:12:42'),
(3, 2, '2018-03-30 13:12:42', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:12:53'),
(4, 3, '2018-03-30 13:13:18', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:13:18'),
(5, 3, '2018-03-30 13:13:18', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:13:23'),
(6, 4, '2018-03-30 13:13:48', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:13:48'),
(7, 4, '2018-03-30 13:13:48', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:14:07'),
(8, 5, '2018-03-30 13:22:49', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:22:49'),
(9, 5, '2018-03-30 13:22:49', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:22:55'),
(10, 6, '2018-03-30 13:25:40', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:25:40'),
(11, 6, '2018-03-30 13:25:40', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:25:45'),
(12, 7, '2018-03-30 13:25:50', 1, 3, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:25:50'),
(13, 7, '2018-03-30 13:25:50', 1, 3, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:25:55'),
(14, 8, '2018-03-30 13:29:58', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:29:58'),
(15, 8, '2018-03-30 13:29:58', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:30:03'),
(16, 9, '2018-03-30 13:31:21', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:31:21'),
(17, 9, '2018-03-30 13:31:21', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:31:25'),
(18, 10, '2018-03-30 13:34:41', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:34:41'),
(19, 10, '2018-03-30 13:34:41', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:34:46'),
(20, 11, '2018-03-30 13:36:40', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:36:40'),
(21, 12, '2018-03-30 13:36:51', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:36:51'),
(22, 13, '2018-03-30 13:36:52', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:36:52'),
(23, 14, '2018-03-30 13:36:53', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:36:53'),
(24, 11, '2018-03-30 13:36:40', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:37:00'),
(25, 12, '2018-03-30 13:36:51', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:37:00'),
(26, 13, '2018-03-30 13:36:52', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:37:00'),
(27, 14, '2018-03-30 13:36:53', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:37:00'),
(28, 15, '2018-03-30 13:38:05', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:38:05'),
(29, 16, '2018-03-30 13:46:22', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:46:22'),
(30, 16, '2018-03-30 13:46:22', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:46:30'),
(31, 17, '2018-03-30 13:47:01', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:47:01'),
(32, 18, '2018-03-30 13:47:02', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:47:02'),
(33, 17, '2018-03-30 13:47:01', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:47:08'),
(34, 18, '2018-03-30 13:47:02', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:47:08'),
(35, 15, '2018-03-30 13:38:05', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:47:33'),
(36, 19, '2018-03-30 13:50:12', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:50:12'),
(37, 20, '2018-03-30 13:50:16', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:50:16'),
(38, 21, '2018-03-30 13:50:17', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 13:50:17'),
(39, 20, '2018-03-30 13:50:16', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:50:23'),
(40, 21, '2018-03-30 13:50:17', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 13:50:23'),
(41, 19, '2018-03-30 13:50:12', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:02:21'),
(42, 22, '2018-03-30 14:02:25', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:02:25'),
(43, 22, '2018-03-30 14:02:25', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:09:33'),
(44, 23, '2018-03-30 14:09:36', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:09:36'),
(45, 23, '2018-03-30 14:09:36', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:09:57'),
(46, 24, '2018-03-30 14:10:01', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:10:01'),
(47, 24, '2018-03-30 14:10:01', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:10:04'),
(48, 25, '2018-03-30 14:12:14', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:12:14'),
(49, 25, '2018-03-30 14:12:14', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:12:18'),
(50, 26, '2018-03-30 14:12:21', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:12:21'),
(51, 26, '2018-03-30 14:12:21', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:12:31'),
(52, 27, '2018-03-30 14:12:31', 1, 3, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:12:31'),
(53, 27, '2018-03-30 14:12:31', 1, 3, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:12:40'),
(54, 28, '2018-03-30 14:12:40', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:12:40'),
(55, 28, '2018-03-30 14:12:40', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:14:29'),
(56, 29, '2018-03-30 14:14:33', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:14:33'),
(57, 29, '2018-03-30 14:14:33', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:14:38'),
(58, 30, '2018-03-30 14:14:41', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:14:41'),
(59, 30, '2018-03-30 14:14:41', 1, 3, 1, NULL, 2, 'root', 'localhost', '2018-03-30 14:14:48'),
(60, 30, '2018-03-30 14:14:41', 1, 2, 1, NULL, 2, 'root', 'localhost', '2018-03-30 14:14:55'),
(61, 30, '2018-03-30 14:14:41', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:18:36'),
(62, 31, '2018-03-30 14:18:40', 1, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:18:40'),
(63, 32, '2018-03-30 14:31:25', 8, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:31:25'),
(64, 33, '2018-03-30 14:34:14', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:34:14'),
(65, 32, '2018-03-30 14:31:25', 8, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:34:33'),
(66, 33, '2018-03-30 14:34:14', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:35:29'),
(67, 34, '2018-03-30 14:35:56', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:35:56'),
(68, 34, '2018-03-30 14:35:56', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:25'),
(69, 35, '2018-03-30 14:37:26', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:26'),
(70, 35, '2018-03-30 14:37:26', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:26'),
(71, 36, '2018-03-30 14:37:27', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:27'),
(72, 36, '2018-03-30 14:37:27', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:28'),
(73, 37, '2018-03-30 14:37:28', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:28'),
(74, 37, '2018-03-30 14:37:28', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:29'),
(75, 38, '2018-03-30 14:37:29', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:29'),
(76, 38, '2018-03-30 14:37:29', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:30'),
(77, 39, '2018-03-30 14:37:30', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:30'),
(78, 39, '2018-03-30 14:37:30', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:31'),
(79, 40, '2018-03-30 14:37:31', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:31'),
(80, 40, '2018-03-30 14:37:31', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:32'),
(81, 41, '2018-03-30 14:37:33', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:33'),
(82, 41, '2018-03-30 14:37:33', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:33'),
(83, 42, '2018-03-30 14:37:34', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:34'),
(84, 42, '2018-03-30 14:37:34', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:34'),
(85, 43, '2018-03-30 14:37:35', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:35'),
(86, 43, '2018-03-30 14:37:35', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:35'),
(87, 44, '2018-03-30 14:37:36', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:36'),
(88, 44, '2018-03-30 14:37:36', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:37'),
(89, 45, '2018-03-30 14:37:37', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:37'),
(90, 45, '2018-03-30 14:37:37', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:38'),
(91, 46, '2018-03-30 14:37:38', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:38'),
(92, 46, '2018-03-30 14:37:38', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:39'),
(93, 47, '2018-03-30 14:37:40', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:40'),
(94, 47, '2018-03-30 14:37:40', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:40'),
(95, 48, '2018-03-30 14:37:41', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:41'),
(96, 48, '2018-03-30 14:37:41', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:41'),
(97, 49, '2018-03-30 14:37:42', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:42'),
(98, 49, '2018-03-30 14:37:42', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:37:42'),
(99, 50, '2018-03-30 14:37:43', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:37:43'),
(100, 50, '2018-03-30 14:37:43', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:39:19'),
(101, 51, '2018-03-30 14:39:28', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:39:28'),
(102, 51, '2018-03-30 14:39:28', 5, 3, 1, NULL, 2, 'root', 'localhost', '2018-03-30 14:39:34'),
(103, 51, '2018-03-30 14:39:28', 5, 3, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:55:03'),
(104, 31, '2018-03-30 14:18:40', 1, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:55:05'),
(105, 52, '2018-03-30 14:55:10', 6, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:55:10'),
(106, 53, '2018-03-30 14:56:13', 5, 3, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:56:13'),
(107, 53, '2018-03-30 14:56:13', 5, 3, 1, NULL, 3, 'root@localhost', 'localhost', '2018-03-30 14:56:16'),
(108, 54, '2018-03-30 14:56:19', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-03-30 14:56:19'),
(109, 54, '2018-03-30 14:56:19', 5, 3, 1, NULL, 2, 'root', 'localhost', '2018-03-30 14:56:21'),
(110, 1, '2018-03-05 15:54:51', 8, 1, 1, NULL, 2, 'root', 'localhost', '2018-03-30 16:08:42'),
(111, 54, '2018-03-30 14:56:19', 5, 2, 1, NULL, 2, 'root', 'localhost', '2018-03-30 16:12:29'),
(112, 55, '2018-04-02 10:30:56', 5, 1, 1, '12345', 1, 'root', 'localhost', '2018-04-02 10:30:57'),
(113, 56, '2018-04-02 10:33:18', 5, 1, 1, '12345', 1, 'root', 'localhost', '2018-04-02 10:33:18'),
(114, 56, '2018-04-02 10:33:18', 5, 1, 1, '12345', 3, 'root@localhost', 'localhost', '2018-04-02 10:33:28'),
(115, 55, '2018-04-02 10:30:56', 5, 1, 1, '12345', 3, 'root@localhost', 'localhost', '2018-04-02 10:33:30'),
(116, 57, '2018-04-02 11:29:22', 5, 1, 1, '12345', 1, 'root', 'localhost', '2018-04-02 11:29:22'),
(117, 58, '2018-04-02 11:30:04', 5, 1, 1, '12345', 1, 'root', 'localhost', '2018-04-02 11:30:04'),
(118, 54, '2018-03-30 14:56:19', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-04-02 11:30:54'),
(119, 59, '2018-04-02 11:30:58', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-02 11:30:58'),
(120, 60, '2018-04-02 11:31:02', 5, 1, 1, '12345', 1, 'root', 'localhost', '2018-04-02 11:31:03'),
(121, 57, '2018-04-02 11:29:22', 5, 1, 1, '12345', 3, 'root@localhost', 'localhost', '2018-04-02 11:31:17'),
(122, 58, '2018-04-02 11:30:04', 5, 1, 1, '12345', 3, 'root@localhost', 'localhost', '2018-04-02 11:31:17'),
(123, 59, '2018-04-02 11:30:58', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-04-02 11:31:17'),
(124, 60, '2018-04-02 11:31:02', 5, 1, 1, '12345', 3, 'root@localhost', 'localhost', '2018-04-02 11:31:17'),
(125, 61, '2018-04-02 11:31:29', 5, 1, 1, '12345', 1, 'root', 'localhost', '2018-04-02 11:31:29'),
(126, 62, '2018-04-02 11:31:47', 44, 1, 1, '12345', 1, 'root', 'localhost', '2018-04-02 11:31:47'),
(127, 61, '2018-04-02 11:31:29', 5, 1, 1, '12345', 3, 'root@localhost', 'localhost', '2018-04-02 11:31:58'),
(128, 62, '2018-04-02 11:31:47', 44, 1, 1, '12345', 3, 'root@localhost', 'localhost', '2018-04-02 11:31:58'),
(129, 63, '2018-04-02 11:36:57', 5, 1, 1, '12345', 1, 'root', 'localhost', '2018-04-02 11:36:57'),
(130, 63, '2018-04-02 11:36:57', 5, 1, 1, '12345', 3, 'root@localhost', 'localhost', '2018-04-02 11:37:04'),
(131, 64, '2018-04-02 11:41:49', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-02 11:41:49'),
(132, 64, '2018-04-02 11:41:49', 5, 3, 1, NULL, 2, 'root', 'localhost', '2018-04-02 11:41:52'),
(133, 64, '2018-04-02 11:41:49', 5, 2, 1, NULL, 2, 'root', 'localhost', '2018-04-02 11:41:54'),
(134, 64, '2018-04-02 11:41:49', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-04-02 11:41:56'),
(135, 65, '2018-04-02 11:41:59', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-02 11:41:59'),
(136, 65, '2018-04-02 11:41:59', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-04-02 12:26:15'),
(137, 66, '2018-04-02 12:26:17', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-02 12:26:17'),
(138, 67, '2018-04-02 14:46:15', 45, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-02 14:46:26'),
(139, 67, '2018-04-02 14:46:15', 45, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-04-02 14:46:50'),
(140, 68, '2018-04-02 14:51:48', 49, 1, 1, NULL, 1, 'root', 'localhost', '2018-04-02 14:51:58'),
(141, 69, '2018-04-02 16:20:08', 52, 2, 4, NULL, 1, 'root', 'localhost', '2018-04-02 16:20:17'),
(142, 66, '2018-04-02 12:26:17', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-04-06 11:35:55'),
(143, 67, '2018-04-06 11:36:03', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-06 11:36:03'),
(144, 67, '2018-04-06 11:36:03', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-04-06 11:36:06'),
(145, 68, '2018-04-06 11:36:11', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-06 11:36:11'),
(146, 68, '2018-04-06 11:36:11', 5, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-04-10 09:28:00'),
(147, 69, '2018-04-10 09:28:03', 5, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-10 09:28:03'),
(148, 70, '2018-04-10 10:57:34', 54, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-10 10:57:34'),
(149, 71, '2018-04-10 10:57:42', 55, 3, 1, NULL, 1, 'root', 'localhost', '2018-04-10 10:57:42'),
(150, 71, '2018-04-10 10:57:42', 55, 3, 1, NULL, 3, 'root@localhost', 'localhost', '2018-04-10 11:50:54'),
(151, 70, '2018-04-10 10:57:34', 54, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-04-10 15:13:41'),
(152, 71, '2018-04-10 15:13:43', 54, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-10 15:13:43'),
(153, 71, '2018-04-10 15:13:43', 54, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-04-10 15:17:15'),
(154, 72, '2018-04-10 15:17:17', 54, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-10 15:17:17'),
(155, 73, '2018-04-10 15:32:04', 55, 3, 1, NULL, 1, 'root', 'localhost', '2018-04-10 15:32:04'),
(156, 74, '2018-04-10 15:17:17', 54, 2, 4, NULL, 1, 'root', 'localhost', '2018-04-10 15:32:32'),
(157, 72, '2018-04-10 15:17:17', 54, 3, 1, NULL, 2, 'root', 'localhost', '2018-04-10 15:40:26'),
(158, 72, '2018-04-10 15:17:17', 54, 2, 1, NULL, 2, 'root', 'localhost', '2018-04-10 15:40:30'),
(159, 75, '2018-04-10 15:48:56', 54, 1, 1, 'test', 1, 'root', 'localhost', '2018-04-10 15:48:56'),
(160, 75, '2018-04-10 15:48:56', 54, 1, 1, 'test', 3, 'root@localhost', 'localhost', '2018-04-10 15:49:21'),
(161, 75, '2018-04-11 16:15:46', 70, 1, 1, 'ыфыфы', 1, 'root', 'localhost', '2018-04-11 16:15:47'),
(162, 76, '2018-04-11 16:16:03', 70, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-11 16:16:03'),
(163, 72, '2018-04-10 15:17:17', 54, 2, 1, NULL, 3, 'root@localhost', 'localhost', '2018-04-13 15:20:07'),
(164, 75, '2018-04-13 15:20:10', 54, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-13 15:20:10'),
(165, 76, '2018-04-19 09:46:11', 50, 2, 5, NULL, 1, 'root', 'localhost', '2018-04-19 09:46:19'),
(166, 76, '2018-04-26 12:27:26', 60, 2, 1, NULL, 1, 'root', 'localhost', '2018-04-26 12:27:26'),
(167, 77, '2018-04-26 12:40:18', 55, 1, 3, 'test', 1, 'root', 'localhost', '2018-04-26 12:40:18');

-- 
-- Вывод данных для таблицы feedbacks
--
INSERT INTO feedbacks VALUES
(73, '2018-04-10 15:32:04', 55, 3, 1, NULL),
(74, '2018-04-10 15:17:17', 54, 2, 4, NULL),
(75, '2018-04-13 15:20:10', 54, 2, 1, NULL),
(77, '2018-04-26 12:40:18', 55, 1, 3, 'test');

-- 
-- Вывод данных для таблицы documents_history
--
INSERT INTO documents_history VALUES
(1, 11, '2018-02-26 12:37:20', 'лаоыдаоц', '1.txt', 1, 'root', 'localhost', '2018-02-26 12:42:48'),
(2, 12, '2018-02-26 13:37:20', 'папавпвпа', '5.txt', 1, 'root', 'localhost', '2018-02-26 12:43:05'),
(3, 12, '2018-02-26 13:37:20', 'папавпвпа', '5.docx', 2, 'root', 'localhost', '2018-02-27 15:12:27'),
(4, 12, '2018-02-26 13:30:00', 'папавпвпа', '5.docx', 2, 'root', 'localhost', '2018-02-27 15:14:06'),
(5, 11, '2018-02-26 12:37:20', 'Протокол собрания по газу 14.05.2017', '1.txt', 2, 'root', 'localhost', '2018-04-04 09:33:08'),
(6, 12, '2017-06-11 22:05:00', 'папавпвпа', '5.docx', 2, 'root', 'localhost', '2018-04-04 09:33:31'),
(7, 12, '2017-06-11 22:05:00', 'папавпвпа', 'Протокол собрания по газу 14.05.2017.docx', 2, 'root', 'localhost', '2018-04-04 09:33:48'),
(8, 12, '2017-06-11 22:05:00', 'Протокол собрания по газу 14.05.2017', 'Протокол собрания по газу 14.05.2017.docx', 2, 'root', 'localhost', '2018-04-04 09:34:03'),
(9, 11, '2018-02-26 12:37:20', 'вфыаывп', '1.txt', 2, 'root', 'localhost', '2018-04-04 09:34:05'),
(10, 11, '2018-02-26 12:37:20', 'Баланс платежей СНТ в 2017 году', '1.txt', 2, 'root', 'localhost', '2018-04-04 09:35:34'),
(11, 11, '2018-02-26 12:37:20', 'Баланс платежей СНТ в 2017 году', '1.txt', 2, 'root', 'localhost', '2018-04-04 09:35:34'),
(12, 11, '2018-02-26 12:37:20', 'Баланс платежей СНТ в 2017 году', 'на сайт Балансовая ведомость платежей 2017 год.xlsx', 2, 'root', 'localhost', '2018-04-04 09:35:43'),
(13, 11, '2017-06-13 21:06:00', 'Баланс платежей СНТ в 2017 году', 'на сайт Балансовая ведомость платежей 2017 год.xlsx', 2, 'root', 'localhost', '2018-04-04 09:36:20'),
(14, 13, '2018-04-04 09:36:24', 'Показания ВОДОМЕРОВ на 1 июля', '', 1, 'root', 'localhost', '2018-04-04 09:36:32'),
(15, 13, '2018-04-04 09:36:24', 'Показания ВОДОМЕРОВ на 1 июля', 'Показания показаний водомеров- 2017 в сайт.xlsx', 2, 'root', 'localhost', '2018-04-04 09:36:40'),
(16, 13, '2017-07-07 20:15:00', 'Показания ВОДОМЕРОВ на 1 июля', 'Показания показаний водомеров- 2017 в сайт.xlsx', 2, 'root', 'localhost', '2018-04-04 09:37:04'),
(17, 14, '2018-04-04 09:37:06', 'Показания ВОДОМЕРОВ на 14.12.2017', '', 1, 'root', 'localhost', '2018-04-04 09:37:14'),
(18, 14, '2018-04-04 09:37:06', 'Показания ВОДОМЕРОВ на 14.12.2017', 'voda 2017.xlsx', 2, 'root', 'localhost', '2018-04-04 09:37:20'),
(19, 14, '2018-01-21 21:18:00', 'Показания ВОДОМЕРОВ на 14.12.2017', 'voda 2017.xlsx', 2, 'root', 'localhost', '2018-04-04 09:37:34'),
(20, 15, '2018-04-18 11:16:00', 'test1', 'test', 1, 'root', 'localhost', '2018-04-18 11:16:00'),
(21, 15, '2018-04-18 11:16:00', 'test11', 'test', 2, 'root', 'localhost', '2018-04-18 11:18:09'),
(22, 16, '2018-04-18 11:34:12', '111111', '2a9bbfb99647e65044c765234d9c8017.png', 1, 'root', 'localhost', '2018-04-18 11:34:12'),
(23, 15, '2018-04-18 11:16:00', 'test11', 'test', 3, 'root', 'localhost', '2018-04-18 11:35:03'),
(24, 16, '2018-04-18 11:34:12', '111111', '2a9bbfb99647e65044c765234d9c8017.png', 3, 'root', 'localhost', '2018-04-18 11:55:18'),
(25, 17, '2018-04-18 11:56:05', 'vfdggeygryryry', '9eac5ff0f91d12c0636a51a4486dd1f9.png', 1, 'root', 'localhost', '2018-04-18 11:56:05'),
(26, 17, '2018-04-18 11:56:05', 'vfdggeygryryry', '9eac5ff0f91d12c0636a51a4486dd1f9.png', 3, 'root', 'localhost', '2018-04-18 11:56:17'),
(27, 18, '2018-04-18 11:57:53', '11111111111', '31bcb854f4fb646e1cf9ea5d90422451.png', 1, 'root', 'localhost', '2018-04-18 11:57:53'),
(28, 18, '2018-04-18 11:57:53', '1111111111170', '', 2, 'root', 'localhost', '2018-04-18 12:23:54'),
(29, 18, '2018-04-18 11:57:53', '1111111111170', '17ab44607d5c574ef20bbf6a3cb250e3.png', 2, 'root', 'localhost', '2018-04-18 12:33:03'),
(30, 18, '2018-04-18 11:57:53', '111111111117', '', 2, 'root', 'localhost', '2018-04-18 12:33:17'),
(31, 18, '2018-04-18 11:57:53', '111111111117', 'cb3868275002cc21bae1683a332dafba.png', 2, 'root', 'localhost', '2018-04-18 12:33:48'),
(32, 18, '2018-04-18 11:57:53', '1111111111178', '37509143307c46ced5a1cfea4d39af84.png', 2, 'root', 'localhost', '2018-04-18 12:36:48'),
(33, 18, '2018-04-18 11:57:53', '11111111111787', '37509143307c46ced5a1cfea4d39af84.png', 2, 'root', 'localhost', '2018-04-18 12:37:01'),
(34, 18, '2018-04-18 11:57:53', '111111111117878', '169c680aaa973ee1156b2e9c26bb2690.png', 2, 'root', 'localhost', '2018-04-18 12:37:13'),
(35, 18, '2018-04-18 11:57:53', '11111111111787', '169c680aaa973ee1156b2e9c26bb2690.png', 2, 'root', 'localhost', '2018-04-18 12:39:23'),
(36, 18, '2018-04-18 11:57:53', '111111111117', 'cd34ca6b0024765107b3943ed3b23ce9.png', 2, 'root', 'localhost', '2018-04-18 12:39:40'),
(37, 18, '2018-04-18 11:57:53', '111111111117', 'cd34ca6b0024765107b3943ed3b23ce9.png', 3, 'root', 'localhost', '2018-04-18 12:39:50'),
(38, 19, '2018-04-18 12:43:44', '1', '2ec08b99f3fb8011e0061180212cbda4.png', 1, 'root', 'localhost', '2018-04-18 12:43:44'),
(39, 19, '2018-04-18 12:43:44', '17', '2ec08b99f3fb8011e0061180212cbda4.png', 2, 'root', 'localhost', '2018-04-18 12:43:52'),
(40, 19, '2018-04-18 12:43:44', '17', '0eefa3e0b492022e86edb164c22acb5f.png', 2, 'root', 'localhost', '2018-04-18 12:44:01'),
(41, 19, '2018-04-18 12:43:44', '17', '0eefa3e0b492022e86edb164c22acb5f.png', 3, 'root', 'localhost', '2018-04-18 12:44:06'),
(42, 15, '2018-04-20 13:04:17', '111', '6f45b7b93347c469d8f00fecfbbba1e9.png', 1, 'root', 'localhost', '2018-04-20 13:04:17'),
(43, 13, '2017-07-07 20:15:00', 'Показания ВОДОМЕРОВ на 1 июля1', 'Показания показаний водомеров- 2017 в сайт.xlsx', 2, 'root', 'localhost', '2018-04-20 13:06:07'),
(44, 13, '2017-07-07 20:15:00', 'Показания ВОДОМЕРОВ на 1 июля', 'Показания показаний водомеров- 2017 в сайт.xlsx', 2, 'root', 'localhost', '2018-04-20 13:06:14'),
(45, 15, '2018-04-20 13:04:17', '111', '6f45b7b93347c469d8f00fecfbbba1e9.png', 3, 'root', 'localhost', '2018-04-20 13:07:29'),
(46, 15, '2018-04-26 12:05:50', 't', '614224987b639f4ab794d76eaa2d7306.docx', 1, 'root', 'localhost', '2018-04-26 12:05:50'),
(47, 15, '2018-04-26 12:05:50', 't7', '614224987b639f4ab794d76eaa2d7306.docx', 2, 'root', 'localhost', '2018-04-26 12:06:10'),
(48, 15, '2018-04-26 12:05:50', 't7', '424431a1300256ec6728147308402481.pdf', 2, 'root', 'localhost', '2018-04-26 12:06:22'),
(49, 15, '2018-04-26 12:05:50', 't7', '424431a1300256ec6728147308402481.pdf', 3, 'root', 'localhost', '2018-04-26 12:06:31');

-- 
-- Вывод данных для таблицы documents
--
INSERT INTO documents VALUES
(11, '2017-06-13 21:06:00', 'Баланс платежей СНТ в 2017 году', 'на сайт Балансовая ведомость платежей 2017 год.xlsx'),
(12, '2017-06-11 22:05:00', 'Протокол собрания по газу 14.05.2017', 'Протокол собрания по газу 14.05.2017.docx'),
(13, '2017-07-07 20:15:00', 'Показания ВОДОМЕРОВ на 1 июля', 'Показания показаний водомеров- 2017 в сайт.xlsx'),
(14, '2018-01-21 21:18:00', 'Показания ВОДОМЕРОВ на 14.12.2017', 'voda 2017.xlsx');

-- 
-- Вывод данных для таблицы discussions_history
--
INSERT INTO discussions_history VALUES
(1, 1, '2018-03-02 11:35:11', NULL, 1, NULL, 1, '11', '111', 0, 1, 'root', 'localhost', '2018-03-02 11:35:24'),
(2, 3, '2018-03-02 11:36:04', '2018-03-02 11:50:05', 1, NULL, 1, '22', '222', 1, 1, 'root', 'localhost', '2018-03-02 11:36:23'),
(3, 4, '2018-03-02 11:36:46', NULL, 2, 1, 1, '1', '1', 0, 1, 'root', 'localhost', '2018-03-02 11:37:00'),
(4, 5, '2018-03-02 11:37:07', NULL, 3, 4, 1, '1', '1', 0, 1, 'root', 'localhost', '2018-03-02 11:37:19'),
(5, 6, '2018-03-02 11:37:22', NULL, 3, 5, 1, '2', '2', 1, 1, 'root', 'localhost', '2018-03-02 11:37:36'),
(6, 6, '2018-03-02 11:37:22', NULL, 3, 5, 1, '2', '2', 0, 1, 'root@localhost', 'localhost', '2018-03-02 11:37:44'),
(7, 8, '2018-03-02 11:53:36', NULL, 3, 4, 1, '3', '3', 0, 1, 'root', 'localhost', '2018-03-02 11:53:53'),
(8, 8, '2018-03-02 11:53:36', NULL, 3, 4, 1, '3', '333', 0, 1, 'root@localhost', 'localhost', '2018-03-05 16:09:21'),
(9, 9, '2018-03-29 13:28:12', NULL, 1, NULL, 1, 'test3', '33333', 1, 1, 'root', 'localhost', '2018-03-29 13:28:14'),
(10, 9, '2018-03-29 13:28:12', NULL, 1, NULL, 1, 'test3', '33333', 1, 3, 'root', 'localhost', '2018-03-29 13:28:37'),
(11, 10, '2018-03-29 13:31:26', NULL, 1, NULL, 1, 'test3', '33333', 1, 1, 'root', 'localhost', '2018-03-29 13:31:26'),
(12, 10, '2018-03-29 13:31:26', NULL, 1, NULL, 1, 'test3', '33333', 1, 3, 'root', 'localhost', '2018-03-29 13:31:44'),
(13, 11, '2018-03-29 13:32:34', NULL, 1, NULL, 1, 'test3', '33333', 1, 1, 'root', 'localhost', '2018-03-29 13:32:34'),
(14, 11, '2018-03-29 13:32:34', NULL, 1, NULL, 1, 'test3', '33333', 1, 3, 'root', 'localhost', '2018-03-29 13:32:46'),
(15, 12, '2018-03-29 13:34:05', NULL, 1, NULL, 1, 'test3', '33333', 1, 1, 'root', 'localhost', '2018-03-29 13:34:05'),
(16, 12, '2018-03-29 13:34:05', NULL, 1, NULL, 1, 'test3', '33333', 1, 3, 'root', 'localhost', '2018-03-29 13:34:45'),
(17, 13, '2018-03-29 13:34:53', NULL, 1, NULL, 1, 'test3', '33333', 1, 1, 'root', 'localhost', '2018-03-29 13:34:54'),
(18, 13, '2018-03-29 13:34:53', NULL, 1, NULL, 1, 'test3', '33333', 1, 3, 'root', 'localhost', '2018-03-29 13:35:11'),
(19, 14, '2018-03-29 13:36:46', NULL, 1, NULL, 1, 'test3', '33333', 1, 1, 'root', 'localhost', '2018-03-29 13:36:46'),
(20, 14, '2018-03-29 13:36:46', NULL, 1, NULL, 1, 'test3', '33333', 1, 3, 'root', 'localhost', '2018-03-29 13:36:53'),
(21, 15, '2018-03-29 13:37:00', NULL, 1, NULL, 1, 'test3', '33333', 0, 1, 'root', 'localhost', '2018-03-29 13:37:00'),
(22, 15, '2018-03-29 13:37:00', NULL, 1, NULL, 1, 'test3', '33333', 1, 1, 'root@localhost', 'localhost', '2018-03-29 13:53:45'),
(23, 15, '2018-03-29 13:37:00', NULL, 1, NULL, 1, 'test3', '33333', 1, 1, 'root@localhost', 'localhost', '2018-03-29 13:53:45'),
(24, 15, '2018-03-29 13:37:00', NULL, 1, NULL, 1, 'test3', '33333', 0, 1, 'root@localhost', 'localhost', '2018-03-29 14:02:47'),
(25, 15, '2018-03-29 13:37:00', NULL, 1, NULL, 1, 'test3', '33333', 0, 1, 'root@localhost', 'localhost', '2018-03-29 14:02:47'),
(26, 15, '2018-03-29 13:37:00', NULL, 1, NULL, 1, 'test3', '33333', 1, 1, 'root@localhost', 'localhost', '2018-03-29 14:02:53'),
(27, 15, '2018-03-29 13:37:00', NULL, 1, NULL, 1, 'test33', '33333', 1, 1, 'root@localhost', 'localhost', '2018-03-29 14:04:10'),
(28, 15, '2018-03-29 13:37:00', NULL, 1, NULL, 1, 'test33', '33333', 0, 1, 'root@localhost', 'localhost', '2018-03-29 14:04:21'),
(29, 15, '2018-03-29 13:37:00', '2018-03-29 14:07:11', 1, NULL, 1, 'test330', '33333', 0, 1, 'root@localhost', 'localhost', '2018-03-29 14:07:11'),
(30, 15, '2018-03-29 13:37:00', '2018-03-29 14:07:11', 1, NULL, 1, 'test330', '33333', 0, 3, 'root', 'localhost', '2018-03-29 14:18:23'),
(31, 18, '2018-03-29 14:45:16', NULL, 2, 1, 1, '2', '2', 0, 1, 'root', 'localhost', '2018-03-29 14:45:17'),
(32, 18, '2018-03-29 14:45:16', NULL, 2, 1, 1, '2', '2', 0, 3, 'root', 'localhost', '2018-03-29 14:46:35'),
(33, 19, '2018-03-29 14:52:22', NULL, 2, 1, 1, '20000', '2000000', 0, 1, 'root', 'localhost', '2018-03-29 14:52:23'),
(34, 19, '2018-03-29 14:52:22', NULL, 2, 1, 1, '20000', '2000000', 0, 3, 'root', 'localhost', '2018-03-29 14:52:49'),
(35, 20, '2018-03-29 14:57:14', NULL, 2, 1, 1, '00000', '0000000000', 0, 1, 'root', 'localhost', '2018-03-29 14:57:15'),
(36, 20, '2018-03-29 14:57:14', NULL, 2, 1, 1, '00000', '0000000000', 0, 3, 'root', 'localhost', '2018-03-29 14:57:37'),
(37, 21, '2018-03-29 14:57:45', NULL, 2, 1, 1, '00000', 'test2222222', 0, 1, 'root', 'localhost', '2018-03-29 14:57:45'),
(38, 21, '2018-03-29 14:57:45', NULL, 2, 1, 1, '00000', 'test2222222', 0, 3, 'root', 'localhost', '2018-03-29 14:58:14'),
(39, 22, '2018-03-29 14:58:29', NULL, 2, 3, 1, '2', 'test2222222', 0, 1, 'root', 'localhost', '2018-03-29 14:58:29'),
(40, 22, '2018-03-29 14:58:29', NULL, 2, 3, 1, '2', 'test2222222', 0, 3, 'root', 'localhost', '2018-03-29 14:58:43'),
(41, 23, '2018-03-29 14:59:15', NULL, 2, 1, 1, '333', '3333', 0, 1, 'root', 'localhost', '2018-03-29 14:59:15'),
(42, 8, '2018-03-02 11:53:36', '2018-03-29 14:59:48', 3, 4, 1, '3', '333', 0, 1, 'root@localhost', 'localhost', '2018-03-29 14:59:48'),
(43, 23, '2018-03-29 14:59:15', NULL, 2, 1, 1, '333', '3333', 0, 3, 'root', 'localhost', '2018-03-29 14:59:50'),
(44, 24, '2018-03-29 15:00:00', NULL, 2, 1, 1, 'wqw', 'qe', 0, 1, 'root', 'localhost', '2018-03-29 15:00:01'),
(45, 24, '2018-03-29 15:00:00', NULL, 2, 1, 1, 'wqw', 'qe', 0, 3, 'root', 'localhost', '2018-03-29 15:00:38'),
(46, 25, '2018-03-29 15:13:04', NULL, 2, 1, 1, 'swddqw', 'qwrfqrqrt', 0, 1, 'root', 'localhost', '2018-03-29 15:13:05'),
(47, 25, '2018-03-29 15:13:04', NULL, 2, 1, 1, 'swddqw', 'qwrfqrqrt', 0, 3, 'root', 'localhost', '2018-03-29 15:13:28'),
(48, 26, '2018-03-29 15:13:42', NULL, 2, 1, 1, '00000', '0000', 0, 1, 'root', 'localhost', '2018-03-29 15:13:43'),
(49, 26, '2018-03-29 15:13:42', NULL, 2, 1, 1, '00000', '0000', 0, 3, 'root', 'localhost', '2018-03-29 15:13:48'),
(50, 27, '2018-03-29 15:14:00', NULL, 2, 3, 1, 'wqw', 'q', 0, 1, 'root', 'localhost', '2018-03-29 15:14:01'),
(51, 27, '2018-03-29 15:14:00', NULL, 2, 3, 1, 'wqw', 'q', 0, 3, 'root', 'localhost', '2018-03-29 15:14:09'),
(52, 28, '2018-03-29 15:14:23', NULL, 2, 1, 1, '20000', '2000000', 0, 1, 'root', 'localhost', '2018-03-29 15:14:23'),
(53, 28, '2018-03-29 15:14:23', '2018-03-29 15:18:28', 2, 1, 1, '200001', '2000000', 0, 1, 'root@localhost', 'localhost', '2018-03-29 15:18:28'),
(54, 28, '2018-03-29 15:14:23', '2018-03-29 15:18:36', 2, 3, 1, '200001', '2000000', 0, 1, 'root@localhost', 'localhost', '2018-03-29 15:18:36'),
(55, 28, '2018-03-29 15:14:23', '2018-03-29 15:18:51', 2, 1, 1, '200001', '2000000', 1, 1, 'root@localhost', 'localhost', '2018-03-29 15:18:51'),
(56, 29, '2018-03-29 15:41:00', NULL, 3, 4, 1, NULL, '777', 0, 1, 'root', 'localhost', '2018-03-29 15:41:01'),
(57, 29, '2018-03-29 15:41:00', NULL, 3, 4, 1, NULL, '777', 0, 3, 'root', 'localhost', '2018-03-29 15:43:21'),
(58, 30, '2018-03-29 15:43:33', NULL, 3, 4, 1, NULL, '777', 0, 1, 'root', 'localhost', '2018-03-29 15:43:33'),
(59, 32, '2018-03-30 09:44:13', NULL, 1, NULL, 1, '3', '3', 0, 1, 'root', 'localhost', '2018-03-30 09:44:14'),
(60, 32, '2018-03-30 09:44:13', NULL, 1, NULL, 1, '3', '3', 0, 3, 'root', 'localhost', '2018-03-30 09:44:36'),
(61, 33, '2018-03-30 09:44:48', NULL, 2, 1, 1, '333', '33333', 0, 1, 'root', 'localhost', '2018-03-30 09:44:49'),
(62, 33, '2018-03-30 09:44:48', NULL, 2, 1, 1, '333', '33333', 0, 3, 'root', 'localhost', '2018-03-30 09:44:55'),
(63, 34, '2018-03-30 09:45:54', NULL, 1, NULL, 1, '3', '3', 0, 1, 'root', 'localhost', '2018-03-30 09:45:54'),
(64, 34, '2018-03-30 09:45:54', NULL, 1, NULL, 1, '3', '3', 0, 3, 'root', 'localhost', '2018-03-30 09:46:08'),
(65, 35, '2018-03-30 09:46:18', NULL, 2, 1, 1, '3', '3', 0, 1, 'root', 'localhost', '2018-03-30 09:46:19'),
(66, 35, '2018-03-30 09:46:18', NULL, 2, 1, 1, '3', '3', 0, 3, 'root', 'localhost', '2018-03-30 09:46:24'),
(67, 36, '2018-03-30 09:46:38', NULL, 3, 4, 1, NULL, '3', 0, 1, 'root', 'localhost', '2018-03-30 09:46:38'),
(68, 36, '2018-03-30 09:46:38', NULL, 3, 4, 1, NULL, '3', 0, 3, 'root', 'localhost', '2018-03-30 09:47:03'),
(69, 37, '2018-03-30 09:49:32', NULL, 1, NULL, 1, '3', '3', 0, 1, 'root', 'localhost', '2018-03-30 09:49:32'),
(70, 37, '2018-03-30 09:49:32', NULL, 1, NULL, 1, '3', '3', 0, 3, 'root', 'localhost', '2018-03-30 09:49:45'),
(71, 38, '2018-03-30 09:50:55', NULL, 1, NULL, 1, '3', '3', 0, 1, 'root', 'localhost', '2018-03-30 09:50:55'),
(72, 38, '2018-03-30 09:50:55', NULL, 1, NULL, 1, '3', '3', 0, 3, 'root', 'localhost', '2018-03-30 09:51:00'),
(73, 39, '2018-03-30 09:51:14', NULL, 2, 1, 1, '3', '3', 0, 1, 'root', 'localhost', '2018-03-30 09:51:14'),
(74, 39, '2018-03-30 09:51:14', NULL, 2, 1, 1, '3', '3', 0, 3, 'root', 'localhost', '2018-03-30 09:51:20'),
(75, 28, '2018-03-29 15:14:23', '2018-03-30 09:54:04', 2, 1, 1, '2000012', '2000000', 1, 1, 'root@localhost', 'localhost', '2018-03-30 09:54:04'),
(76, 3, '2018-03-02 11:36:04', '2018-03-30 09:54:29', 1, NULL, 1, '22', '2222', 1, 1, 'root@localhost', 'localhost', '2018-03-30 09:54:29'),
(77, 40, '2018-03-30 10:05:30', NULL, 3, 30, 4, NULL, '888', 0, 1, 'root', 'localhost', '2018-03-30 10:05:47'),
(78, 5, '2018-03-02 11:37:07', NULL, 3, NULL, 1, '1', '1', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:11:10'),
(79, 8, '2018-03-02 11:53:36', '2018-03-29 14:59:48', 3, NULL, 1, '3', '333', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:11:22'),
(80, 6, '2018-03-02 11:37:22', NULL, 3, NULL, 1, '2', '2', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:11:25'),
(81, 5, '2018-03-02 11:37:07', NULL, 3, 4, 1, '1', '1', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:12:25'),
(82, 6, '2018-03-02 11:37:22', NULL, 3, 5, 1, '2', '2', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:12:32'),
(83, 8, '2018-03-02 11:53:36', '2018-03-29 14:59:48', 3, 4, 1, '3', '333', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:12:36'),
(84, 5, '2018-03-02 11:37:07', NULL, 3, 4, 1, NULL, '1', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:12:54'),
(85, 6, '2018-03-02 11:37:22', NULL, 3, 5, 1, NULL, '2', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:12:57'),
(86, 8, '2018-03-02 11:53:36', '2018-03-29 14:59:48', 3, 4, 1, NULL, '333', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:13:01'),
(87, 5, '2018-03-02 11:37:07', NULL, 3, 4, 1, NULL, 'Пункт 1', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:13:43'),
(88, 5, '2018-03-02 11:37:07', NULL, 3, 4, 1, NULL, 'Пункт 1', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:13:43'),
(89, 8, '2018-03-02 11:53:36', '2018-03-29 14:59:48', 3, 4, 1, NULL, 'Пункт 2', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:13:53'),
(90, 30, '2018-03-29 15:43:33', NULL, 3, 4, 1, NULL, 'Пункт 3', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:13:57'),
(91, 6, '2018-03-02 11:37:22', NULL, 3, 5, 1, NULL, 'Подпункт 1.1', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:14:22'),
(92, 40, '2018-03-30 10:05:30', NULL, 3, 30, 4, NULL, 'Подпункт 3.1', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:14:40'),
(93, 42, '2018-03-30 12:16:51', NULL, 3, 5, 2, NULL, 'Подпункт 3.2', 0, 1, 'root', 'localhost', '2018-03-30 12:17:20'),
(94, 44, '2018-03-30 12:17:59', NULL, 3, 42, 4, NULL, 'Подпункт 3.2.1', 0, 1, 'root', 'localhost', '2018-03-30 12:18:17'),
(95, 42, '2018-03-30 12:16:51', NULL, 3, 5, 2, NULL, 'Подпункт 1.2', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:43:52'),
(96, 44, '2018-03-30 12:17:59', NULL, 3, 42, 4, NULL, 'Подпункт 1.2.1', 0, 1, 'root@localhost', 'localhost', '2018-03-30 12:43:55'),
(97, 45, '2018-03-30 15:50:55', NULL, 3, 4, 1, NULL, '5', 0, 1, 'root', 'localhost', '2018-03-30 15:50:55'),
(98, 45, '2018-03-30 15:50:55', NULL, 3, 4, 1, NULL, '5', 0, 3, 'root', 'localhost', '2018-03-30 15:51:02'),
(99, 46, '2018-03-30 15:52:22', NULL, 3, 4, 1, NULL, '5', 0, 1, 'root', 'localhost', '2018-03-30 15:52:23'),
(100, 46, '2018-03-30 15:52:22', NULL, 3, 4, 1, NULL, '5', 0, 3, 'root', 'localhost', '2018-03-30 15:52:31'),
(101, 47, '2018-03-30 15:52:38', NULL, 3, 5, 1, NULL, '5', 0, 1, 'root', 'localhost', '2018-03-30 15:52:38'),
(102, 47, '2018-03-30 15:52:38', NULL, 3, 5, 1, NULL, '5', 0, 3, 'root', 'localhost', '2018-03-30 15:52:45'),
(103, 48, '2018-03-30 15:57:00', NULL, 3, 4, 1, NULL, '5', 0, 1, 'root', 'localhost', '2018-03-30 15:57:00'),
(104, 48, '2018-03-30 15:57:00', NULL, 3, 4, 1, NULL, '5', 0, 3, 'root', 'localhost', '2018-03-30 15:57:06'),
(105, 49, '2018-03-30 15:57:17', NULL, 3, 5, 1, NULL, '5', 0, 1, 'root', 'localhost', '2018-03-30 15:57:17'),
(106, 49, '2018-03-30 15:57:17', NULL, 3, 5, 1, NULL, '5', 0, 3, 'root', 'localhost', '2018-03-30 15:57:23'),
(107, 45, '2018-04-02 14:45:45', NULL, 3, 44, 1, NULL, '888', 0, 1, 'root', 'localhost', '2018-04-02 14:46:07'),
(108, 45, '2018-04-02 14:45:45', NULL, 3, 44, 1, NULL, '888', 0, 3, 'root', 'localhost', '2018-04-02 14:46:50'),
(109, 48, '2018-04-02 14:50:55', NULL, 2, 1, 1, NULL, '0', 0, 1, 'root', 'localhost', '2018-04-02 14:51:17'),
(110, 49, '2018-04-02 14:51:24', NULL, 3, 48, 1, NULL, '00', 0, 1, 'root', 'localhost', '2018-04-02 14:51:37'),
(111, 48, '2018-04-02 14:50:55', NULL, 2, 1, 1, NULL, '0', 0, 3, 'root', 'localhost', '2018-04-02 15:57:50'),
(112, 50, '2018-04-02 16:18:35', NULL, 2, 1, 1, 'ццц', 'ццц', 0, 1, 'root', 'localhost', '2018-04-02 16:18:49'),
(113, 52, '2018-04-02 16:19:38', NULL, 3, 50, 1, 'у', 'уу', 0, 1, 'root', 'localhost', '2018-04-02 16:19:51'),
(114, 50, '2018-04-02 16:18:35', NULL, 2, 1, 1, 'ццц', 'ццц', 0, 3, 'root', 'localhost', '2018-04-02 16:21:07'),
(115, 53, '2018-04-02 16:27:43', NULL, 1, NULL, 1, 'н', 'н', 0, 1, 'root', 'localhost', '2018-04-02 16:27:43'),
(116, 53, '2018-04-02 16:27:43', NULL, 1, NULL, 1, 'н', 'н', 0, 3, 'root', 'localhost', '2018-04-02 16:27:46'),
(117, 54, '2018-04-02 16:29:46', NULL, 2, 1, 1, 'y', 'y', 0, 1, 'root', 'localhost', '2018-04-02 16:29:46'),
(118, 54, '2018-04-02 16:29:46', NULL, 2, 1, 1, 'y', 'y', 0, 3, 'root', 'localhost', '2018-04-02 16:29:49'),
(119, 55, '2018-04-02 16:32:58', NULL, 3, 4, 1, NULL, 'y', 0, 1, 'root', 'localhost', '2018-04-02 16:32:59'),
(120, 55, '2018-04-02 16:32:58', NULL, 3, 4, 1, NULL, 'y', 0, 3, 'root', 'localhost', '2018-04-02 16:33:06'),
(121, 1, '2018-03-02 11:35:11', NULL, 1, NULL, 1, 'Раздел 1', '111', 0, 1, 'root@localhost', 'localhost', '2018-04-05 11:50:10'),
(122, 1, '2018-03-02 11:35:11', NULL, 1, NULL, 1, 'Раздел 1', '111', 0, 1, 'root@localhost', 'localhost', '2018-04-05 11:50:10'),
(123, 3, '2018-03-02 11:36:04', '2018-03-30 09:54:29', 1, NULL, 1, 'Раздел 2', '2222', 1, 1, 'root@localhost', 'localhost', '2018-04-05 11:50:17'),
(124, 1, '2018-03-02 11:35:11', NULL, 1, NULL, 1, 'Раздел 1', 'Описание раздела 1', 0, 1, 'root@localhost', 'localhost', '2018-04-05 11:50:31'),
(125, 3, '2018-03-02 11:36:04', '2018-03-30 09:54:29', 1, NULL, 1, 'Раздел 2', 'Описание раздела 2', 1, 1, 'root@localhost', 'localhost', '2018-04-05 11:50:36'),
(126, 4, '2018-03-02 11:36:46', NULL, 2, 1, 1, 'Тема 1', '1', 0, 1, 'root@localhost', 'localhost', '2018-04-05 11:54:01'),
(127, 4, '2018-03-02 11:36:46', NULL, 2, 1, 1, 'Тема 1', 'Описание темы 1', 0, 1, 'root@localhost', 'localhost', '2018-04-05 12:03:02'),
(128, 4, '2018-03-02 11:36:46', NULL, 2, 1, 1, 'Тема 1', 'Описание темы 1', 0, 1, 'root@localhost', 'localhost', '2018-04-05 12:03:02'),
(129, 28, '2018-03-29 15:14:23', '2018-03-30 09:54:04', 2, 1, 1, 'Тема 2', 'Описание темы 2', 1, 1, 'root@localhost', 'localhost', '2018-04-05 12:03:36'),
(130, 28, '2018-03-29 15:14:23', '2018-03-30 09:54:04', 2, 1, 1, 'Тема 2', 'Описание темы 2', 1, 1, 'root@localhost', 'localhost', '2018-04-05 12:03:36'),
(131, 4, '2018-03-02 11:36:46', NULL, 2, 1, 1, 'Тема 1', '', 0, 1, 'root@localhost', 'localhost', '2018-04-05 12:40:49'),
(132, 28, '2018-03-29 15:14:23', '2018-03-30 09:54:04', 2, 1, 1, 'Тема 2', '', 1, 1, 'root@localhost', 'localhost', '2018-04-05 12:40:54'),
(133, 1, '2018-03-02 11:35:11', '2018-04-05 13:13:20', 1, NULL, 1, 'Раздел 1', 'Описание раздела 1', 1, 1, 'root@localhost', 'localhost', '2018-04-05 13:13:20'),
(134, 1, '2018-03-02 11:35:11', '2018-04-05 13:13:31', 1, NULL, 1, 'Раздел 1', 'Описание раздела 1', 0, 1, 'root@localhost', 'localhost', '2018-04-05 13:13:31'),
(135, 45, '2018-04-05 13:14:23', NULL, 1, NULL, 1, '11111111уцауцпцп', 'ауывпукыркурокуркуро', 1, 1, 'root', 'localhost', '2018-04-05 13:14:23'),
(136, 45, '2018-04-05 13:14:23', NULL, 1, NULL, 1, '11111111уцауцпцп', 'ауывпукыркурокуркуро', 1, 3, 'root', 'localhost', '2018-04-05 13:14:28'),
(137, 4, '2018-03-02 11:36:46', NULL, 2, 1, 1, 'Тема 1', NULL, 0, 1, 'root@localhost', 'localhost', '2018-04-05 13:20:43'),
(138, 28, '2018-03-29 15:14:23', '2018-03-30 09:54:04', 2, 1, 1, 'Тема 2', NULL, 1, 1, 'root@localhost', 'localhost', '2018-04-05 13:20:45'),
(139, 46, '2018-04-05 13:20:57', NULL, 2, 1, 1, 'qswqwrrqrwrqrw', NULL, 1, 1, 'root', 'localhost', '2018-04-05 13:20:57'),
(140, 46, '2018-04-05 13:20:57', NULL, 2, 1, 1, 'qswqwrrqrwrqrw', NULL, 1, 3, 'root', 'localhost', '2018-04-05 13:21:05'),
(141, 47, '2018-04-05 15:10:16', NULL, 2, 1, 1, 'gdgfggfdgfgdgfs', NULL, 1, 1, 'root', 'localhost', '2018-04-05 15:10:17'),
(142, 47, '2018-04-05 15:10:16', NULL, 2, 1, 1, 'gdgfggfdgfgdgfs', NULL, 1, 3, 'root', 'localhost', '2018-04-05 15:10:24'),
(143, 48, '2018-04-05 15:10:38', NULL, 1, NULL, 1, 'qerrrwrewtewtewtewtewtttewtewtew', 'eeq', 1, 1, 'root', 'localhost', '2018-04-05 15:10:38'),
(144, 48, '2018-04-05 15:10:38', NULL, 1, NULL, 1, 'qerrrwrewtewtewtewtewtttewtewtew', 'eeq', 1, 3, 'root', 'localhost', '2018-04-05 15:10:41'),
(145, 5, '2018-03-02 11:37:07', NULL, 3, 4, 1, NULL, 'Пункт 1', 0, 3, 'root', 'localhost', '2018-04-10 09:28:17'),
(146, 3, '2018-03-02 11:36:04', '2018-03-30 09:54:29', 1, NULL, 1, 'Раздел 2', 'Описание раздела 2', 1, 3, 'root', 'localhost', '2018-04-10 09:28:56'),
(147, 1, '2018-03-02 11:35:11', '2018-04-05 13:13:31', 1, NULL, 1, 'Раздел 1', 'Описание раздела 1', 0, 3, 'root', 'localhost', '2018-04-10 09:28:59'),
(148, 45, '2018-04-10 09:30:37', NULL, 1, NULL, 1, 'Работа сайта', 'Технический раздел', 0, 1, 'root', 'localhost', '2018-04-10 09:30:38'),
(149, 46, '2018-04-10 09:30:52', NULL, 1, NULL, 1, 'Основной раздел', 'Общие темы', 0, 1, 'root', 'localhost', '2018-04-10 09:30:52'),
(150, 47, '2018-04-10 09:31:23', NULL, 1, NULL, 1, 'Газопровод', 'Здесь обсуждаем вопросы, связанные с проведением газопровода', 0, 1, 'root', 'localhost', '2018-04-10 09:31:23'),
(151, 48, '2018-04-10 09:31:55', NULL, 2, 45, 1, 'Общие вопросы (FAQ)', NULL, 0, 1, 'root', 'localhost', '2018-04-10 09:31:55'),
(152, 49, '2018-04-10 09:32:10', NULL, 2, 45, 1, 'Ошибки работы', NULL, 0, 1, 'root', 'localhost', '2018-04-10 09:32:10'),
(153, 50, '2018-04-10 09:32:23', NULL, 2, 45, 1, 'Ваши пожелания по функционалу', NULL, 0, 1, 'root', 'localhost', '2018-04-10 09:32:23'),
(154, 51, '2018-04-10 09:32:51', NULL, 2, 45, 1, 'Позвольте представиться', NULL, 0, 1, 'root', 'localhost', '2018-04-10 09:32:52'),
(155, 51, '2018-04-10 09:32:51', NULL, 2, 45, 1, 'Позвольте представиться', NULL, 0, 3, 'root', 'localhost', '2018-04-10 09:32:57'),
(156, 52, '2018-04-10 10:19:46', NULL, 2, 46, 1, 'Позвольте представиться', NULL, 0, 1, 'root', 'localhost', '2018-04-10 10:19:46'),
(157, 53, '2018-04-10 10:20:08', NULL, 2, 47, 1, 'Участники', NULL, 0, 1, 'root', 'localhost', '2018-04-10 10:20:08'),
(158, 47, '2018-04-10 09:31:23', '2018-04-10 10:20:26', 1, NULL, 1, 'Газопровод', 'Здесь обсуждаем вопросы, связанные с проведением газопровода', 1, 1, 'root@localhost', 'localhost', '2018-04-10 10:20:26'),
(159, 49, '2018-04-10 09:32:10', '2018-04-10 10:20:41', 2, 45, 1, 'Ошибки работы', NULL, 1, 1, 'root@localhost', 'localhost', '2018-04-10 10:20:41'),
(160, 50, '2018-04-10 09:32:23', '2018-04-10 10:20:48', 2, 45, 1, 'Ваши пожелания по функционалу', NULL, 1, 1, 'root@localhost', 'localhost', '2018-04-10 10:20:48'),
(161, 52, '2018-04-10 10:19:46', '2018-04-10 10:21:08', 2, 46, 1, 'Позвольте представиться', NULL, 1, 1, 'root@localhost', 'localhost', '2018-04-10 10:21:08'),
(162, 54, '2018-04-10 10:40:46', NULL, 3, 48, 1, NULL, 'Сообщение 1', 0, 1, 'root', 'localhost', '2018-04-10 10:40:46'),
(163, 55, '2018-04-10 10:57:21', NULL, 3, 48, 1, NULL, 'Сообщение 2', 0, 1, 'root', 'localhost', '2018-04-10 10:57:22'),
(164, 56, '2018-04-10 11:50:43', NULL, 3, 48, 1, NULL, 'Сообщение 3', 0, 1, 'root', 'localhost', '2018-04-10 11:50:43'),
(165, 57, '2018-04-10 12:31:18', NULL, 3, 55, 1, NULL, 'Ответ на сообщение 2', 0, 1, 'root', 'localhost', '2018-04-10 12:31:18'),
(166, 58, '2018-04-10 14:35:36', NULL, 3, 48, 1, NULL, 'Сообщение 4', 0, 1, 'root', 'localhost', '2018-04-10 14:35:36'),
(167, 59, '2018-04-10 14:35:54', NULL, 3, 58, 1, NULL, 'Сообщение 5', 0, 1, 'root', 'localhost', '2018-04-10 14:35:54'),
(168, 60, '2018-04-10 14:39:46', NULL, 1, NULL, 1, 'test1', '1', 0, 1, 'root', 'localhost', '2018-04-10 14:39:46'),
(169, 61, '2018-04-10 14:39:54', NULL, 1, NULL, 1, 'test2', '2', 0, 1, 'root', 'localhost', '2018-04-10 14:39:55'),
(170, 62, '2018-04-10 14:40:03', NULL, 1, NULL, 1, 'test3', '3', 0, 1, 'root', 'localhost', '2018-04-10 14:40:03'),
(171, 61, '2018-04-10 14:39:54', NULL, 1, NULL, 1, 'test2', '2', 0, 3, 'root', 'localhost', '2018-04-10 14:46:22'),
(172, 62, '2018-04-10 14:40:03', NULL, 1, NULL, 1, 'test3', '3', 0, 3, 'root', 'localhost', '2018-04-10 14:46:25'),
(173, 60, '2018-04-10 14:39:46', NULL, 1, NULL, 1, 'test1', '1', 0, 3, 'root', 'localhost', '2018-04-10 14:46:27'),
(174, 58, '2018-04-10 14:35:36', NULL, 3, 48, 1, NULL, 'Сообщение 4', 0, 3, 'root', 'localhost', '2018-04-10 14:58:51'),
(175, 63, '2018-04-10 14:59:14', NULL, 3, 48, 1, NULL, '111', 0, 1, 'root', 'localhost', '2018-04-10 14:59:15'),
(176, 64, '2018-04-10 14:59:19', NULL, 3, 48, 1, NULL, '111', 0, 1, 'root', 'localhost', '2018-04-10 14:59:19'),
(177, 64, '2018-04-10 14:59:19', NULL, 3, 48, 1, NULL, '111', 0, 3, 'root', 'localhost', '2018-04-10 15:00:00'),
(178, 63, '2018-04-10 14:59:14', NULL, 3, 48, 1, NULL, '111', 0, 3, 'root', 'localhost', '2018-04-10 15:00:20'),
(179, 65, '2018-04-10 15:01:12', NULL, 3, 48, 1, NULL, '1111', 0, 1, 'root', 'localhost', '2018-04-10 15:01:12'),
(180, 66, '2018-04-10 15:01:17', NULL, 3, 48, 1, NULL, '1111111111', 0, 1, 'root', 'localhost', '2018-04-10 15:01:18'),
(181, 66, '2018-04-10 15:01:17', NULL, 3, 48, 1, NULL, '1111111111', 0, 3, 'root', 'localhost', '2018-04-10 15:01:43'),
(182, 67, '2018-04-10 15:02:25', NULL, 3, 48, 1, NULL, '8888', 0, 1, 'root', 'localhost', '2018-04-10 15:02:25'),
(183, 68, '2018-04-11 15:08:47', NULL, 3, 48, 1, NULL, '1234567', 0, 1, 'root', 'localhost', '2018-04-11 15:08:47'),
(184, 69, '2018-04-11 15:09:04', NULL, 3, 68, 1, NULL, '11111111777777', 0, 1, 'root', 'localhost', '2018-04-11 15:09:05'),
(185, 68, '2018-04-11 15:08:47', NULL, 3, 48, 1, NULL, '12345670', 0, 1, 'root@localhost', 'localhost', '2018-04-11 15:09:18'),
(186, 70, '2018-04-11 15:10:15', NULL, 3, 48, 1, NULL, '\\adfasgfawgagsw', 0, 1, 'root', 'localhost', '2018-04-11 15:10:16'),
(187, 70, '2018-04-11 15:10:15', '2018-04-11 15:41:15', 3, 48, 1, NULL, 'ddddd', 0, 1, 'root@localhost', 'localhost', '2018-04-11 15:41:15'),
(188, 55, '2018-04-10 10:57:21', '2018-04-11 15:44:53', 3, 48, 1, NULL, 'Сообщение 22', 0, 1, 'root@localhost', 'localhost', '2018-04-11 15:44:53'),
(189, 71, '2018-04-11 15:46:28', NULL, 1, NULL, 1, 'q', 'q', 0, 1, 'root', 'localhost', '2018-04-11 15:46:28'),
(190, 71, '2018-04-11 15:46:28', NULL, 1, NULL, 1, 'q', 'q', 0, 3, 'root', 'localhost', '2018-04-11 15:46:51'),
(191, 72, '2018-04-11 15:48:48', NULL, 2, 45, 1, 'sssss', NULL, 0, 1, 'root', 'localhost', '2018-04-11 15:48:48'),
(192, 72, '2018-04-11 15:48:48', NULL, 2, 45, 1, 'sssss', NULL, 0, 3, 'root', 'localhost', '2018-04-11 15:48:52'),
(193, 73, '2018-04-11 15:49:31', NULL, 2, 45, 1, 'ewqeqwe', NULL, 0, 1, 'root', 'localhost', '2018-04-11 15:49:32'),
(194, 73, '2018-04-11 15:49:31', NULL, 2, 45, 1, 'ewqeqwe', NULL, 0, 3, 'root', 'localhost', '2018-04-11 15:49:36'),
(195, 74, '2018-04-11 15:50:18', NULL, 2, 45, 1, 'dsfa', NULL, 0, 1, 'root', 'localhost', '2018-04-11 15:50:18'),
(196, 74, '2018-04-11 15:50:18', NULL, 2, 45, 1, 'dsfa', NULL, 0, 3, 'root', 'localhost', '2018-04-11 15:50:22'),
(197, 75, '2018-04-11 15:50:39', NULL, 2, 45, 1, 'asddad', NULL, 0, 1, 'root', 'localhost', '2018-04-11 15:50:39'),
(198, 75, '2018-04-11 15:50:39', NULL, 2, 45, 1, 'asddad', NULL, 0, 3, 'root', 'localhost', '2018-04-11 15:51:30'),
(199, 76, '2018-04-11 15:51:59', NULL, 2, 45, 1, 'fdsfdssg', NULL, 0, 1, 'root', 'localhost', '2018-04-11 15:51:59'),
(200, 76, '2018-04-11 15:51:59', NULL, 2, 45, 1, 'fdsfdssg', NULL, 0, 3, 'root', 'localhost', '2018-04-11 15:52:07'),
(201, 77, '2018-04-11 16:03:19', NULL, 1, NULL, 1, '111', 'qw', 0, 1, 'root', 'localhost', '2018-04-11 16:03:19'),
(202, 77, '2018-04-11 16:03:19', '2018-04-11 16:03:25', 1, NULL, 1, '111', 'qwzzzz', 0, 1, 'root@localhost', 'localhost', '2018-04-11 16:03:25'),
(203, 77, '2018-04-11 16:03:19', '2018-04-11 16:04:22', 1, NULL, 1, '111sdsd', 'qwzzzz', 0, 1, 'root@localhost', 'localhost', '2018-04-11 16:04:22'),
(204, 77, '2018-04-11 16:03:19', '2018-04-11 16:04:22', 1, NULL, 1, '111sdsd', 'qwzzzz', 0, 3, 'root', 'localhost', '2018-04-11 16:05:30'),
(205, 78, '2018-04-11 16:05:40', NULL, 2, 45, 1, 'xdasdsddas', NULL, 0, 1, 'root', 'localhost', '2018-04-11 16:05:41'),
(206, 78, '2018-04-11 16:05:40', NULL, 2, 45, 1, 'xdasdsddas', NULL, 0, 3, 'root', 'localhost', '2018-04-11 16:05:44'),
(207, 69, '2018-04-11 15:09:04', NULL, 3, 68, 1, NULL, '11111111777777', 0, 3, 'root', 'localhost', '2018-04-11 16:16:27'),
(208, 70, '2018-04-11 15:10:15', '2018-04-11 15:41:15', 3, 48, 1, NULL, 'ddddd', 0, 3, 'root', 'localhost', '2018-04-11 16:18:01'),
(209, 69, '2018-04-12 14:25:50', NULL, 1, NULL, 1, '1', '2', 0, 1, 'root', 'localhost', '2018-04-12 14:25:50'),
(210, 69, '2018-04-12 14:25:50', '2018-04-12 14:26:22', 1, NULL, 1, '11', '2', 0, 1, 'root@localhost', 'localhost', '2018-04-12 14:26:22'),
(211, 69, '2018-04-12 14:25:50', '2018-04-12 14:26:22', 1, NULL, 1, '11', '2', 0, 3, 'root', 'localhost', '2018-04-12 14:26:40'),
(212, 68, '2018-04-11 15:08:47', NULL, 3, 48, 1, NULL, '12345670', 0, 3, 'root', 'localhost', '2018-04-12 14:33:18'),
(213, 67, '2018-04-10 15:02:25', NULL, 3, 48, 1, NULL, '8888', 0, 3, 'root', 'localhost', '2018-04-12 15:41:25'),
(214, 65, '2018-04-10 15:01:12', NULL, 3, 48, 1, NULL, '1111', 0, 3, 'root', 'localhost', '2018-04-12 15:41:29'),
(215, 55, '2018-04-10 10:57:21', '2018-04-12 15:41:47', 3, 48, 1, NULL, 'Сообщение 2', 0, 1, 'root@localhost', 'localhost', '2018-04-12 15:41:47'),
(216, 55, '2018-04-10 10:57:21', '2018-04-12 15:41:47', 3, 48, 2, NULL, 'Сообщение 2', 0, 1, 'root@localhost', 'localhost', '2018-04-13 14:25:27'),
(217, 56, '2018-04-10 11:50:43', NULL, 3, 48, 3, NULL, 'Сообщение 3', 0, 1, 'root@localhost', 'localhost', '2018-04-13 14:25:31'),
(218, 58, '2018-04-19 09:46:45', NULL, 1, NULL, 5, 'вввв', 'ввв', 0, 1, 'root', 'localhost', '2018-04-19 09:46:58'),
(219, 60, '2018-04-19 09:47:37', NULL, 2, 58, 5, 'сссс', 'ссс', 0, 1, 'root', 'localhost', '2018-04-19 09:47:50'),
(220, 61, '2018-04-19 09:47:54', NULL, 3, 60, 5, 'кккккк', 'кккк', 0, 1, 'root', 'localhost', '2018-04-19 09:48:11'),
(221, 62, '2018-04-19 09:48:16', NULL, 3, 61, 1, 'куеук', 'ееуеуеу', 0, 1, 'root', 'localhost', '2018-04-19 09:48:34'),
(222, 58, '2018-04-20 13:25:35', NULL, 1, NULL, 1, '1', '22', 0, 1, 'root', 'localhost', '2018-04-20 13:25:36'),
(223, 58, '2018-04-20 13:25:35', '2018-04-20 13:27:20', 1, NULL, 1, '11', '22', 0, 1, 'root@localhost', 'localhost', '2018-04-20 13:27:20'),
(224, 58, '2018-04-20 13:25:35', '2018-04-20 13:27:20', 1, NULL, 1, '11', '22', 0, 3, 'root', 'localhost', '2018-04-20 13:36:14'),
(225, 59, '2018-04-20 13:40:28', NULL, 2, 45, 1, '1111111', NULL, 0, 1, 'root', 'localhost', '2018-04-20 13:40:28'),
(226, 60, '2018-04-20 13:40:54', NULL, 2, 46, 1, '1', NULL, 0, 1, 'root', 'localhost', '2018-04-20 13:40:54'),
(227, 60, '2018-04-20 13:40:54', NULL, 2, 46, 1, '1', NULL, 0, 3, 'root', 'localhost', '2018-04-20 13:40:59'),
(228, 59, '2018-04-20 13:40:28', '2018-04-20 13:44:12', 2, 45, 1, '11111117', NULL, 0, 1, 'root@localhost', 'localhost', '2018-04-20 13:44:12'),
(229, 59, '2018-04-20 13:40:28', '2018-04-20 13:44:57', 2, 46, 1, '111111178', NULL, 0, 1, 'root@localhost', 'localhost', '2018-04-20 13:44:57'),
(230, 59, '2018-04-20 13:40:28', '2018-04-20 13:45:07', 2, 45, 1, '111111178', NULL, 0, 1, 'root@localhost', 'localhost', '2018-04-20 13:45:07'),
(231, 59, '2018-04-20 13:40:28', '2018-04-20 13:45:07', 2, 45, 1, '111111178', NULL, 0, 3, 'root', 'localhost', '2018-04-20 13:46:40'),
(232, 61, '2018-04-20 13:52:22', NULL, 3, 48, 1, NULL, '11111111', 0, 1, 'root', 'localhost', '2018-04-20 13:52:22'),
(233, 61, '2018-04-20 13:52:22', NULL, 3, 48, 1, NULL, '11111111', 0, 3, 'root', 'localhost', '2018-04-20 13:52:38'),
(234, 62, '2018-04-20 13:54:54', NULL, 3, 48, 1, NULL, '1', 0, 1, 'root', 'localhost', '2018-04-20 13:54:54'),
(235, 63, '2018-04-20 14:01:41', NULL, 3, 48, 1, NULL, '222', 0, 1, 'root', 'localhost', '2018-04-20 14:01:41'),
(236, 64, '2018-04-20 14:03:44', NULL, 3, 48, 1, NULL, '333', 0, 1, 'root', 'localhost', '2018-04-20 14:03:44'),
(237, 63, '2018-04-20 14:01:41', '2018-04-20 14:04:09', 3, 48, 1, NULL, '2', 0, 1, 'root@localhost', 'localhost', '2018-04-20 14:04:09'),
(238, 64, '2018-04-20 14:03:44', NULL, 3, 48, 1, NULL, '333', 0, 3, 'root', 'localhost', '2018-04-20 14:05:43'),
(239, 63, '2018-04-20 14:01:41', '2018-04-20 14:04:09', 3, 48, 1, NULL, '2', 0, 3, 'root', 'localhost', '2018-04-20 14:07:13'),
(240, 62, '2018-04-20 13:54:54', NULL, 3, 48, 1, NULL, '1', 0, 3, 'root', 'localhost', '2018-04-20 14:08:01'),
(241, 65, '2018-04-20 14:09:38', NULL, 3, 48, 1, NULL, '111', 0, 1, 'root', 'localhost', '2018-04-20 14:09:38'),
(242, 66, '2018-04-20 14:09:42', NULL, 3, 48, 1, NULL, '222', 0, 1, 'root', 'localhost', '2018-04-20 14:09:43'),
(243, 66, '2018-04-20 14:09:42', NULL, 3, 48, 1, NULL, '222', 0, 3, 'root', 'localhost', '2018-04-20 14:09:47'),
(244, 67, '2018-04-20 14:10:22', NULL, 3, 48, 1, NULL, '222', 0, 1, 'root', 'localhost', '2018-04-20 14:10:22'),
(245, 67, '2018-04-20 14:10:22', NULL, 3, 48, 1, NULL, '222', 0, 3, 'root', 'localhost', '2018-04-20 14:10:26'),
(246, 65, '2018-04-20 14:09:38', NULL, 3, 48, 1, NULL, '111', 0, 3, 'root', 'localhost', '2018-04-20 14:10:30'),
(247, 58, '2018-04-26 12:24:19', NULL, 1, NULL, 1, '1', '1', 0, 1, 'root', 'localhost', '2018-04-26 12:24:20'),
(248, 58, '2018-04-26 12:24:19', '2018-04-26 12:24:26', 1, NULL, 1, '10', '1', 0, 1, 'root@localhost', 'localhost', '2018-04-26 12:24:26'),
(249, 59, '2018-04-26 12:27:06', NULL, 2, 58, 1, '1', NULL, 0, 1, 'root', 'localhost', '2018-04-26 12:27:06'),
(250, 59, '2018-04-26 12:27:06', '2018-04-26 12:27:13', 2, 58, 1, '10', NULL, 0, 1, 'root@localhost', 'localhost', '2018-04-26 12:27:13'),
(251, 60, '2018-04-26 12:27:20', NULL, 3, 59, 1, NULL, '1', 0, 1, 'root', 'localhost', '2018-04-26 12:27:20'),
(252, 60, '2018-04-26 12:27:20', '2018-04-26 12:27:32', 3, 59, 1, NULL, '11111', 0, 1, 'root@localhost', 'localhost', '2018-04-26 12:27:32'),
(253, 61, '2018-04-26 12:27:37', NULL, 3, 60, 1, NULL, 'iyui', 0, 1, 'root', 'localhost', '2018-04-26 12:27:38'),
(254, 62, '2018-04-26 12:27:44', NULL, 3, 61, 1, NULL, 'aaaa', 0, 1, 'root', 'localhost', '2018-04-26 12:27:45'),
(255, 61, '2018-04-26 12:27:37', NULL, 3, 60, 1, NULL, 'iyui', 0, 3, 'root', 'localhost', '2018-04-26 12:27:50'),
(256, 58, '2018-04-26 12:24:19', '2018-04-26 12:24:26', 1, NULL, 1, '10', '1', 0, 3, 'root', 'localhost', '2018-04-26 12:28:16');

-- 
-- Вывод данных для таблицы contacts_history
--
INSERT INTO contacts_history VALUES
(1, 0, 'test1', 'test2', 'test3@test.test', 'test4', 'test5', 1, 'root', 'localhost', '2018-03-01 10:02:40'),
(2, 1, 'Кайдановская Наталия Ивановна', 'test2', 'test3@test.test', 'test4', 'test5', 2, 'root', 'localhost', '2018-04-04 09:44:01'),
(3, 1, 'Кайдановская Наталия Ивановна', '+ 7 (978) 727-77-04', 'test3@test.test', 'test4', 'test5', 2, 'root', 'localhost', '2018-04-04 09:44:09'),
(4, 1, 'Кайдановская Наталия Ивановна', '+ 7 (978) 727-77-04', 'kaidanovska@gmail.com', 'test4', 'test5', 2, 'root', 'localhost', '2018-04-04 09:44:20'),
(5, 1, 'Кайдановская Наталия Ивановна', '+ 7 (978) 727-77-04', 'kaidanovska@gmail.com', 'не назначен', 'test5', 2, 'root', 'localhost', '2018-04-04 09:44:30'),
(6, 1, 'Кайдановская Наталия Ивановна', '+ 7 (978) 727-77-04', 'kaidanovska@gmail.com', 'не назначен', 'звонить 10-15', 2, 'root', 'localhost', '2018-04-04 09:44:40'),
(7, 1, 'Кайдановская Наталия Ивановна', '+ 7 (978) 727-77-04', 'kaidanovska@gmail.com', 'не назначен', 'звонить 10-15', 2, 'root', 'localhost', '2018-04-04 09:45:03'),
(8, 1, 'Кайдановская Наталия Ивановна', '+ 7 (978) 727-77-04', 'kaidanovska@gmail.com', 'не назначен1', 'звонить 10-15', 2, 'root', 'localhost', '2018-04-18 14:45:44'),
(9, 1, 'Кайдановская Наталия Ивановна', '+ 7 (978) 727-77-04', 'kaidanovska@gmail.com', 'не назначен', 'звонить 10-15', 2, 'root', 'localhost', '2018-04-18 14:46:00'),
(10, 1, 'Кайдановская Наталия Ивановна', '+ 7 (978) 727-77-04', 'kaidanovska@gmail.com', 'не назначен', 'звонить c 10 до 15 часов', 2, 'root', 'localhost', '2018-04-26 12:19:39');

-- 
-- Вывод данных для таблицы contacts
--
INSERT INTO contacts VALUES
(1, 'Кайдановская Наталия Ивановна', '+ 7 (978) 727-77-04', 'kaidanovska@gmail.com', 'не назначен', 'звонить c 10 до 15 часов');

-- 
-- Вывод данных для таблицы blocks_history
--
INSERT INTO blocks_history VALUES
(1, 6, '2018-03-05 16:34:25', '2018-04-05 16:34:25', 2, 1, '555', 1, 'root', 'localhost', '2018-03-05 16:34:34'),
(2, 6, '2018-03-05 16:34:25', '2018-04-05 16:34:25', 1, 1, '555', 2, 'root', 'localhost', '2018-03-12 13:12:42'),
(3, 6, '2018-03-05 16:34:25', '2018-04-05 16:34:25', 2, 1, '555', 2, 'root', 'localhost', '2018-03-12 15:55:43'),
(4, 6, '2018-03-05 16:34:25', '2018-04-05 16:34:25', 1, 1, '555', 2, 'root', 'localhost', '2018-03-12 15:59:00'),
(5, 7, '2017-01-01 00:00:00', '2018-01-01 00:00:00', 1, 1, '12345', 1, 'root', 'localhost', '2018-04-02 12:03:27'),
(6, 7, '2017-01-01 00:00:00', '2018-01-01 00:00:00', 1, 1, '12345', 3, 'root', 'localhost', '2018-04-02 12:03:43'),
(7, 6, '2018-03-05 16:34:25', '2018-04-05 16:34:25', 4, 1, '555', 2, 'root', 'localhost', '2018-04-02 12:03:46'),
(8, 8, '2018-04-02 12:10:00', '2018-04-02 16:10:00', 1, 1, '1', 1, 'root', 'localhost', '2018-04-02 12:10:43'),
(9, 8, '2018-04-02 12:10:00', '2018-04-02 16:10:00', 1, 1, '1', 3, 'root', 'localhost', '2018-04-02 12:11:12'),
(10, 6, '2018-03-05 16:34:25', '2018-05-05 16:34:25', 4, 1, '555', 2, 'root', 'localhost', '2018-04-02 12:11:20'),
(11, 6, '2018-03-05 16:34:25', '2018-05-05 16:34:25', 1, 1, '555', 2, 'root', 'localhost', '2018-04-02 12:21:17'),
(12, 6, '2018-03-05 16:34:25', '2018-03-05 16:34:25', 1, 1, '555', 2, 'root', 'localhost', '2018-04-02 12:21:49'),
(13, 6, '2018-03-05 16:34:25', '2018-03-05 16:34:25', 1, 1, '555', 2, 'root', 'localhost', '2018-04-02 12:21:49'),
(14, 6, '2018-03-05 16:34:25', '2018-05-05 16:34:25', 1, 1, '555', 2, 'root', 'localhost', '2018-04-02 12:22:04'),
(15, 6, '2018-03-05 16:34:25', '2018-05-05 16:34:25', 4, 1, '555', 2, 'root', 'localhost', '2018-04-02 12:34:24'),
(16, 6, '2018-03-05 16:34:25', '2018-05-05 16:34:25', 1, 1, '555', 2, 'root', 'localhost', '2018-04-02 12:34:31'),
(17, 6, '2018-03-05 16:34:25', '2018-05-05 16:34:25', 4, 1, '555', 2, 'root', 'localhost', '2018-04-02 16:32:50'),
(18, 6, '2018-03-05 16:34:25', '2018-05-05 16:34:25', 1, 1, '555', 2, 'root', 'localhost', '2018-04-04 10:33:48'),
(19, 7, '2018-04-04 10:33:59', '2018-04-04 10:34:01', 1, 1, '777', 1, 'root', 'localhost', '2018-04-04 10:34:09'),
(20, 7, '2017-04-04 10:33:59', '2017-09-04 10:34:01', 1, 1, '777', 2, 'root', 'localhost', '2018-04-04 10:34:18'),
(21, 7, '2017-04-04 10:33:59', '2017-09-04 10:34:01', 4, 1, '777', 2, 'root', 'localhost', '2018-04-04 11:14:42'),
(22, 7, '2017-04-04 10:33:59', '2017-09-04 10:34:01', 1, 1, '777', 2, 'root', 'localhost', '2018-04-04 11:14:52'),
(23, 6, '2018-03-05 16:34:25', '2018-05-05 16:34:25', 4, 1, '555', 2, 'root', 'localhost', '2018-04-04 11:15:37'),
(24, 7, '2017-04-04 10:33:59', '2017-09-04 10:34:01', 4, 1, '777', 2, 'root', 'localhost', '2018-04-04 11:15:39'),
(25, 6, '2018-03-05 16:34:25', '2018-05-05 16:34:25', 1, 1, '555', 2, 'root', 'localhost', '2018-04-04 11:15:45'),
(26, 7, '2017-04-04 10:33:59', '2017-09-04 10:34:01', 1, 1, '777', 2, 'root', 'localhost', '2018-04-04 11:15:47'),
(27, 6, '2018-03-05 16:34:25', '2018-04-05 16:34:25', 1, 1, '555', 2, 'root', 'localhost', '2018-04-05 15:51:22'),
(28, 6, '2018-03-05 16:34:25', '2018-04-05 12:34:25', 1, 1, '555', 2, 'root', 'localhost', '2018-04-05 15:51:37'),
(29, 8, '2018-04-01 12:00:00', '2018-04-17 17:00:00', 1, 1, 'wqrqwr', 1, 'root', 'localhost', '2018-04-11 14:06:41'),
(30, 8, '2018-04-01 12:00:00', '2018-04-17 17:00:00', 1, 1, 'wqrqwr', 3, 'root', 'localhost', '2018-04-11 14:12:04'),
(31, 6, '2018-03-05 16:34:25', '2018-04-05 12:34:25', 1, 2, '555', 2, 'root', 'localhost', '2018-04-12 15:29:44'),
(32, 7, '2017-04-04 10:33:59', '2017-09-04 10:34:01', 1, 2, '777', 2, 'root', 'localhost', '2018-04-12 15:29:47'),
(33, 6, '2018-03-05 16:34:25', '2018-04-05 12:34:25', 1, 2, 'Тестовая блокировка', 2, 'root', 'localhost', '2018-04-12 15:29:55'),
(34, 7, '2017-04-04 10:33:59', '2017-09-04 10:34:01', 1, 2, 'Просто так =)', 2, 'root', 'localhost', '2018-04-12 15:30:00'),
(35, 8, '2018-04-13 12:28:00', '2018-04-13 18:28:00', 2, 1, '33333333', 1, 'root', 'localhost', '2018-04-13 14:28:34'),
(36, 8, '2018-04-13 12:28:00', '2018-04-13 18:28:00', 2, 1, '33333333', 3, 'root', 'localhost', '2018-04-13 14:28:53'),
(37, 9, '2018-04-13 08:43:00', '2018-04-13 19:43:00', 2, 1, '7788', 1, 'root', 'localhost', '2018-04-13 14:44:06'),
(38, 9, '2018-04-13 08:43:00', '2018-04-13 19:43:00', 2, 1, '7788', 3, 'root', 'localhost', '2018-04-13 14:44:21'),
(39, 6, '2018-03-05 16:34:25', '2018-04-24 12:34:25', 1, 2, 'Тестовая блокировка', 2, 'root', 'localhost', '2018-04-18 14:59:16'),
(40, 6, '2018-03-05 16:34:25', '2018-04-18 15:11:56', 1, 2, 'Тестовая блокировка', 2, 'root', 'localhost', '2018-04-18 15:11:56'),
(41, 8, '2018-04-19 09:49:05', '2018-04-19 09:49:06', 5, 1, 'сссс', 1, 'root', 'localhost', '2018-04-19 09:49:13'),
(42, 8, '2018-05-11 15:30:00', '2018-05-11 19:30:00', 2, 1, 'aaaaa', 1, 'root', 'localhost', '2018-05-11 15:30:17'),
(43, 8, '2018-05-11 15:30:00', '2018-05-11 19:30:00', 2, 1, 'aaaaa', 3, 'root', 'localhost', '2018-05-11 15:30:26'),
(44, 6, '2018-03-05 16:34:25', '2018-05-18 15:11:56', 1, 2, 'Тестовая блокировка', 2, 'root', 'localhost', '2018-05-14 12:36:50'),
(45, 6, '2018-03-05 16:34:25', '2018-04-18 15:11:56', 1, 2, 'Тестовая блокировка', 2, 'root', 'localhost', '2018-05-14 12:36:59');

-- 
-- Вывод данных для таблицы blocks
--
INSERT INTO blocks VALUES
(6, '2018-03-05 16:34:25', '2018-04-18 15:11:56', 1, 2, 'Тестовая блокировка'),
(7, '2017-04-04 10:33:59', '2017-09-04 10:34:01', 1, 2, 'Просто так =)');

--
-- Установка базы данных по умолчанию
--
USE sfazan;

--
-- Удалить триггер `users_after_delete`
--
DROP TRIGGER IF EXISTS users_after_delete;

--
-- Удалить триггер `users_after_insert`
--
DROP TRIGGER IF EXISTS users_after_insert;

--
-- Удалить триггер `users_after_update`
--
DROP TRIGGER IF EXISTS users_after_update;

--
-- Удалить триггер `tariffs_types_after_delete`
--
DROP TRIGGER IF EXISTS tariffs_types_after_delete;

--
-- Удалить триггер `tariffs_types_after_insert`
--
DROP TRIGGER IF EXISTS tariffs_types_after_insert;

--
-- Удалить триггер `tariffs_types_after_update`
--
DROP TRIGGER IF EXISTS tariffs_types_after_update;

--
-- Удалить триггер `tariffs_after_delete`
--
DROP TRIGGER IF EXISTS tariffs_after_delete;

--
-- Удалить триггер `tariffs_after_insert`
--
DROP TRIGGER IF EXISTS tariffs_after_insert;

--
-- Удалить триггер `tariffs_after_update`
--
DROP TRIGGER IF EXISTS tariffs_after_update;

--
-- Удалить триггер `settings_after_delete`
--
DROP TRIGGER IF EXISTS settings_after_delete;

--
-- Удалить триггер `settings_after_insert`
--
DROP TRIGGER IF EXISTS settings_after_insert;

--
-- Удалить триггер `settings_after_update`
--
DROP TRIGGER IF EXISTS settings_after_update;

--
-- Удалить триггер `payments_after_delete`
--
DROP TRIGGER IF EXISTS payments_after_delete;

--
-- Удалить триггер `payments_after_insert`
--
DROP TRIGGER IF EXISTS payments_after_insert;

--
-- Удалить триггер `payments_after_update`
--
DROP TRIGGER IF EXISTS payments_after_update;

--
-- Удалить триггер `news_after_delete`
--
DROP TRIGGER IF EXISTS news_after_delete;

--
-- Удалить триггер `news_after_insert`
--
DROP TRIGGER IF EXISTS news_after_insert;

--
-- Удалить триггер `news_after_update`
--
DROP TRIGGER IF EXISTS news_after_update;

--
-- Удалить триггер `messages_after_delete`
--
DROP TRIGGER IF EXISTS messages_after_delete;

--
-- Удалить триггер `messages_after_insert`
--
DROP TRIGGER IF EXISTS messages_after_insert;

--
-- Удалить триггер `messages_after_update`
--
DROP TRIGGER IF EXISTS messages_after_update;

--
-- Удалить триггер `measurements_after_delete`
--
DROP TRIGGER IF EXISTS measurements_after_delete;

--
-- Удалить триггер `measurements_after_insert`
--
DROP TRIGGER IF EXISTS measurements_after_insert;

--
-- Удалить триггер `measurements_after_update`
--
DROP TRIGGER IF EXISTS measurements_after_update;

--
-- Удалить триггер `feedbacks_after_delete`
--
DROP TRIGGER IF EXISTS feedbacks_after_delete;

--
-- Удалить триггер `feedbacks_after_insert`
--
DROP TRIGGER IF EXISTS feedbacks_after_insert;

--
-- Удалить триггер `feedbacks_after_update`
--
DROP TRIGGER IF EXISTS feedbacks_after_update;

--
-- Удалить триггер `documents_after_delete`
--
DROP TRIGGER IF EXISTS documents_after_delete;

--
-- Удалить триггер `documents_after_insert`
--
DROP TRIGGER IF EXISTS documents_after_insert;

--
-- Удалить триггер `documents_after_update`
--
DROP TRIGGER IF EXISTS documents_after_update;

--
-- Удалить триггер `discussions_after_delete`
--
DROP TRIGGER IF EXISTS discussions_after_delete;

--
-- Удалить триггер `discussions_after_insert`
--
DROP TRIGGER IF EXISTS discussions_after_insert;

--
-- Удалить триггер `discussions_after_update`
--
DROP TRIGGER IF EXISTS discussions_after_update;

--
-- Удалить триггер `contacts_after_delete`
--
DROP TRIGGER IF EXISTS contacts_after_delete;

--
-- Удалить триггер `contacts_after_insert`
--
DROP TRIGGER IF EXISTS contacts_after_insert;

--
-- Удалить триггер `contacts_after_update`
--
DROP TRIGGER IF EXISTS contacts_after_update;

--
-- Удалить триггер `blocks_after_delete`
--
DROP TRIGGER IF EXISTS blocks_after_delete;

--
-- Удалить триггер `blocks_after_insert`
--
DROP TRIGGER IF EXISTS blocks_after_insert;

--
-- Удалить триггер `blocks_after_update`
--
DROP TRIGGER IF EXISTS blocks_after_update;

--
-- Установка базы данных по умолчанию
--
USE sfazan;

DELIMITER $$

--
-- Создать триггер `users_after_delete`
--
CREATE TRIGGER users_after_delete
AFTER DELETE
ON users
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO users_history (id, username, password, password_reset, email, telephone, other_contacts, fio, sector, address, date_register, date_active, role, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.username, OLD.password, OLD.password_reset, OLD.email, OLD.telephone, OLD.other_contacts, OLD.fio, OLD.sector, OLD.address, OLD.date_register, OLD.date_active, OLD.role, 3, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `users_after_insert`
--
CREATE TRIGGER users_after_insert
AFTER INSERT
ON users
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO users_history (id, username, password, password_reset, email, telephone, other_contacts, fio, sector, address, date_register, date_active, role, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.username, NEW.password, NEW.password_reset, NEW.email, NEW.telephone, NEW.other_contacts, NEW.fio, NEW.sector, NEW.address, NEW.date_register, NEW.date_active, NEW.role, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `users_after_update`
--
CREATE TRIGGER users_after_update
AFTER UPDATE
ON users
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO users_history (id, username, password, password_reset, email, telephone, other_contacts, fio, sector, address, date_register, date_active, role, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.username, NEW.password, NEW.password_reset, NEW.email, NEW.telephone, NEW.other_contacts, NEW.fio, NEW.sector, NEW.address, NEW.date_register, NEW.date_active, NEW.role, 2, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `tariffs_types_after_delete`
--
CREATE TRIGGER tariffs_types_after_delete
AFTER DELETE
ON tariffs_types
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO tariffs_types_history (id, title, calculate, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.title, OLD.calculate, 3, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `tariffs_types_after_insert`
--
CREATE TRIGGER tariffs_types_after_insert
AFTER INSERT
ON tariffs_types
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO tariffs_types_history (id, title, calculate, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.title, NEW.calculate, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `tariffs_types_after_update`
--
CREATE TRIGGER tariffs_types_after_update
AFTER UPDATE
ON tariffs_types
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO tariffs_types_history (id, title, calculate, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.title, NEW.calculate, 2, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `tariffs_after_delete`
--
CREATE TRIGGER tariffs_after_delete
AFTER DELETE
ON tariffs
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO tariffs_history (id, type, period_start, value, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.type, OLD.period_start, OLD.value, 3, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `tariffs_after_insert`
--
CREATE TRIGGER tariffs_after_insert
AFTER INSERT
ON tariffs
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO tariffs_history (id, type, period_start, value, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.type, NEW.period_start, NEW.value, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `tariffs_after_update`
--
CREATE TRIGGER tariffs_after_update
AFTER UPDATE
ON tariffs
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO tariffs_history (id, type, period_start, value, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.type, NEW.period_start, NEW.value, 2, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `settings_after_delete`
--
CREATE TRIGGER settings_after_delete
AFTER DELETE
ON settings
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO settings_history (id, parameter, description, value, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.parameter, OLD.description, OLD.value, 3, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `settings_after_insert`
--
CREATE TRIGGER settings_after_insert
AFTER INSERT
ON settings
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO settings_history (id, parameter, description, value, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.parameter, NEW.description, NEW.value, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `settings_after_update`
--
CREATE TRIGGER settings_after_update
AFTER UPDATE
ON settings
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO settings_history (id, parameter, description, value, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.parameter, NEW.description, NEW.value, 2, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `payments_after_delete`
--
CREATE TRIGGER payments_after_delete
AFTER DELETE
ON payments
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO payments_history (id, date, type, user, sum, place, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.date, OLD.type, OLD.user, OLD.sum, OLD.place, 3, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `payments_after_insert`
--
CREATE TRIGGER payments_after_insert
AFTER INSERT
ON payments
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO payments_history (id, date, type, user, sum, place, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date, NEW.type, NEW.user, NEW.sum, NEW.place, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `payments_after_update`
--
CREATE TRIGGER payments_after_update
AFTER UPDATE
ON payments
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO payments_history (id, date, type, user, sum, place, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date, NEW.type, NEW.user, NEW.sum, NEW.place, 2, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `news_after_delete`
--
CREATE TRIGGER news_after_delete
AFTER DELETE
ON news
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO news_history (id, date, title, preview, text, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.date, OLD.title, OLD.preview, OLD.text, 3, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `news_after_insert`
--
CREATE TRIGGER news_after_insert
AFTER INSERT
ON news
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO news_history (id, date, title, preview, text, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date, NEW.title, NEW.preview, NEW.text, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `news_after_update`
--
CREATE TRIGGER news_after_update
AFTER UPDATE
ON news
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO news_history (id, date, title, preview, text, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date, NEW.title, NEW.preview, NEW.text, 2, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `messages_after_delete`
--
CREATE TRIGGER messages_after_delete
AFTER DELETE
ON messages
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO messages_history (id, date, recipient, sender, subject, text, reading, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.date, OLD.recipient, OLD.sender, OLD.subject, OLD.text, OLD.reading, 3, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `messages_after_insert`
--
CREATE TRIGGER messages_after_insert
AFTER INSERT
ON messages
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO messages_history (id, date, recipient, sender, subject, text, reading, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date, NEW.recipient, NEW.sender, NEW.subject, NEW.text, NEW.reading, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `messages_after_update`
--
CREATE TRIGGER messages_after_update
AFTER UPDATE
ON messages
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO messages_history (id, date, recipient, sender, subject, text, reading, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date, NEW.recipient, NEW.sender, NEW.subject, NEW.text, NEW.reading, 2, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `measurements_after_delete`
--
CREATE TRIGGER measurements_after_delete
AFTER DELETE
ON measurements
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO measurements_history (id, date, type, user, value, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.date, OLD.type, OLD.user, OLD.value, 3, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `measurements_after_insert`
--
CREATE TRIGGER measurements_after_insert
AFTER INSERT
ON measurements
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO measurements_history (id, date, type, user, value, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date, NEW.type, NEW.user, NEW.value, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `measurements_after_update`
--
CREATE TRIGGER measurements_after_update
AFTER UPDATE
ON measurements
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO measurements_history (id, date, type, user, value, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date, NEW.type, NEW.user, NEW.value, 2, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `feedbacks_after_delete`
--
CREATE TRIGGER feedbacks_after_delete
AFTER DELETE
ON feedbacks
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO feedbacks_history (id, date, message, type, user, text, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.date, OLD.message, OLD.type, OLD.user, OLD.text, 3, SUBSTRING_INDEX(@user, @delimiter, 3), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `feedbacks_after_insert`
--
CREATE TRIGGER feedbacks_after_insert
AFTER INSERT
ON feedbacks
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO feedbacks_history (id, date, message, type, user, text, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date, NEW.message, NEW.type, NEW.user, NEW.text, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `feedbacks_after_update`
--
CREATE TRIGGER feedbacks_after_update
AFTER UPDATE
ON feedbacks
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO feedbacks_history (id, date, message, type, user, text, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date, NEW.message, NEW.type, NEW.user, NEW.text, 2, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `documents_after_delete`
--
CREATE TRIGGER documents_after_delete
AFTER DELETE
ON documents
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO documents_history (id, date, description, file, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.date, OLD.description, OLD.file, 3, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `documents_after_insert`
--
CREATE TRIGGER documents_after_insert
AFTER INSERT
ON documents
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO documents_history (id, date, description, file, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date, NEW.description, NEW.file, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `documents_after_update`
--
CREATE TRIGGER documents_after_update
AFTER UPDATE
ON documents
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO documents_history (id, date, description, file, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date, NEW.description, NEW.file, 2, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `discussions_after_delete`
--
CREATE TRIGGER discussions_after_delete
AFTER DELETE
ON discussions
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO discussions_history (id, date_create, date_update, type, parent, user, title, text, hidden, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.date_create, OLD.date_update, OLD.type, OLD.parent, OLD.user, OLD.title, OLD.text, OLD.hidden, 3, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `discussions_after_insert`
--
CREATE TRIGGER discussions_after_insert
AFTER INSERT
ON discussions
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO discussions_history (id, date_create, date_update, type, parent, user, title, text, hidden, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date_create, NEW.date_update, NEW.type, NEW.parent, NEW.user, NEW.title, NEW.text, NEW.hidden, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `discussions_after_update`
--
CREATE TRIGGER discussions_after_update
AFTER UPDATE
ON discussions
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO discussions_history (id, date_create, date_update, type, parent, user, title, text, hidden, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date_create, NEW.date_update, NEW.type, NEW.parent, NEW.user, NEW.title, NEW.text, NEW.hidden, 1, SUBSTRING_INDEX(@user, @delimiter, 2), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `contacts_after_delete`
--
CREATE TRIGGER contacts_after_delete
AFTER DELETE
ON contacts
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO contacts_history (id, fio, telephone, email, address, time, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.fio, OLD.telephone, OLD.email, OLD.address, OLD.time, 3, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `contacts_after_insert`
--
CREATE TRIGGER contacts_after_insert
AFTER INSERT
ON contacts
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO contacts_history (id, fio, telephone, email, address, time, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.fio, NEW.telephone, NEW.email, NEW.address, NEW.time, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `contacts_after_update`
--
CREATE TRIGGER contacts_after_update
AFTER UPDATE
ON contacts
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO contacts_history (id, fio, telephone, email, address, time, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.fio, NEW.telephone, NEW.email, NEW.address, NEW.time, 2, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `blocks_after_delete`
--
CREATE TRIGGER blocks_after_delete
AFTER DELETE
ON blocks
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO blocks_history (id, date_start, date_end, user, moderator, reason, history_type, history_user, history_host)
    VALUES (OLD.id, OLD.date_start, OLD.date_end, OLD.user, OLD.moderator, OLD.reason, 3, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `blocks_after_insert`
--
CREATE TRIGGER blocks_after_insert
AFTER INSERT
ON blocks
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO blocks_history (id, date_start, date_end, user, moderator, reason, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date_start, NEW.date_end, NEW.user, NEW.moderator, NEW.reason, 1, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

--
-- Создать триггер `blocks_after_update`
--
CREATE TRIGGER blocks_after_update
AFTER UPDATE
ON blocks
FOR EACH ROW
BEGIN
  SET @user = USER();
  SET @delimiter = '@';
  SET @start = LOCATE(@delimiter, @user);
  SET @length = LENGTH(@user) - @start;

  INSERT HIGH_PRIORITY INTO blocks_history (id, date_start, date_end, user, moderator, reason, history_type, history_user, history_host)
    VALUES (NEW.id, NEW.date_start, NEW.date_end, NEW.user, NEW.moderator, NEW.reason, 2, SUBSTRING_INDEX(@user, @delimiter, 1), SUBSTRING(@user, @start + 1, @length));
END
$$

DELIMITER ;

-- 
-- Восстановить предыдущий режим SQL (SQL mode)
-- 
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Включение внешних ключей
-- 
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;