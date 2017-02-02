DROP SCHEMA IF EXISTS PUBLIC CASCADE;
CREATE SCHEMA PUBLIC;

CREATE DATABASE messenger_db;

-- START CONSTRUCT DATABASE

CREATE TABLE IF NOT EXISTS locations (
	loc_id SERIAL PRIMARY KEY,
	loc_country varchar(100) NOT NULL,
	loc_region varchar(100),
	loc_city varchar(100)
);


CREATE TABLE IF NOT EXISTS settings (
	s_id SERIAL PRIMARY KEY,
	s_notifications boolean NOT NULL,
	s_mes_preview boolean NOT NULL,
	s_sound boolean NOT NULL,
	s_language int NOT NULL
--	u_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS devices (
	dev_id SERIAL PRIMARY KEY,
	dev_type int NOT NULL,
	dev_number varchar(500) NOT NULL,
	u_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
	user_id SERIAL PRIMARY KEY,
	user_name varchar(100) NOT NULL,
	user_gender int,
	user_icon varchar(500),
	user_phone varchar(50) NOT NULL,
	user_email varchar(100),
	user_last_visit timestamp NOT NULL,
	user_password varchar(500) NOT NULL,
	setting_id int REFERENCES settings (s_id) ON DELETE CASCADE ON UPDATE CASCADE,
	loc_id int REFERENCES locations (loc_id) ON DELETE CASCADE ON UPDATE CASCADE,
	dev_id int REFERENCES devices (dev_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ALTER TABLE settings ADD FOREIGN KEY (u_id) REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE IF NOT EXISTS contacts (
	c_id SERIAL PRIMARY KEY,
	c_user_id int NOT NULL,
	u_id int REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
	in_black_list boolean NOT NULL
);


CREATE TABLE IF NOT EXISTS conversations (
	con_id SERIAL PRIMARY KEY,
	con_name varchar(100),
	con_icon varchar(500)
--	u_id int NOT NULL REFERENCES user_connects (u_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS messages (
	m_id SERIAL PRIMARY KEY,
	m_text varchar(10000) NOT NULL,
	m_time timestamp NOT NULL,
	m_is_read boolean NOT NULL,
	m_is_deleted boolean NOT NULL,
	u_from int NOT NULL,
	con_id int REFERENCES conversations (con_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS user_connects (
	u_id int NOT NULL REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
	c_id int NOT NULL REFERENCES conversations (con_id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (u_id, c_id)
);


CREATE TABLE IF NOT EXISTS attachments (
	at_id SERIAL PRIMARY KEY,
	at_link varchar(500) NOT NULL,
	at_date timestamp NOT NULL,
	at_type int NOT NULL, -- 0 image, 1 audio, 2 video, 3 doc
	CHECK (at_type BETWEEN 0 AND 3),
	m_id int REFERENCES messages (m_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS smiles (
	s_id SERIAL PRIMARY KEY,
	s_link varchar(500),
	s_type int,
	m_id int REFERENCES messages (m_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- START CONSTRUCT DATABASE
-- START INSERT VALUES

INSERT INTO locations (loc_country, loc_region, loc_city)
	VALUES ('Russia', 'Spb', 'Saint-Petersburg'),
		   ('Russia', 'Bashkortostan', 'Ufa'),
		   ('Ukraine', 'Lion', 'Lion'),
		   ('Ukraine', 'Kiev', 'Kiev'),
		   ('Russia', 'Udmurtia', 'Ishevsk'),
		   ('Russia', 'Moscow', 'Moscow'),
		   ('Germany', 'Munich', 'Munich');

INSERT INTO settings (s_notifications, s_mes_preview, s_sound, s_language)
	VALUES (TRUE, TRUE, TRUE, 1),
		   (TRUE, FALSE, TRUE, 2),
		   (TRUE, FALSE, TRUE, 4),
		   (TRUE, FALSE, TRUE, 4),
		   (TRUE, FALSE, TRUE, 2),
		   (TRUE, TRUE, FALSE, 3);

INSERT INTO devices (dev_type, dev_number, u_id)
	VALUES (0, 'iMac', 1),
		   (1, 'iPhone', 2),
		   (1, 'Android', 1),
		   (1, 'Nexus', 2),
		   (1, 'iPhone', 3),
		   (2, 'iWatch', 3);

INSERT INTO users (user_name, user_gender, user_icon, user_phone, user_email, user_last_visit, 
	user_password, setting_id, loc_id, dev_id)
	VALUES ('Daria', 1, 'daria.jpg', '79110343466', 'dd@d.ru', timestamp '2016-11-28 13:38:10', '12345', 1, 1, 1),
		   ('Sasha Startseva', 1, 'daria.jpg', '79990377656', 'ss@d.ru', timestamp '2016-11-28 13:38:10', '3456', 1, 2, 2),
		   ('Dima', 0, 'dima.jpg', '79129962465', 'dima@gmail.com', timestamp '2014-11-28 13:38:10', '235422', 2, 3, 2),
		   ('Andrew', 0, 'andrew.jpg', '78122324543', 'andrew@mail.ru', timestamp '2015-11-28 13:38:10', '2343543', 2, 4, 3),		   
		   ('Maria', 1, 'maria.jpg', '71234567890', 'masha23@mail.ifmo.ru', timestamp '2012-12-28 13:38:10', 'dfjsdkfs', 2, 3, 1);

INSERT INTO contacts (c_user_id, u_id, in_black_list)
	VALUES (1, 2, FALSE),
		   (2, 1, FALSE),
		   (1, 3, FALSE),
		   (3, 1, FALSE),
		   (4, 5, FALSE),
		   (5, 4, FALSE),
		   (3, 4, FALSE);

INSERT INTO conversations (con_name, con_icon)
	VALUES ('Dialog1', 'dial.jpg'),
		   ('Conv1', 'conv1.jpg'),
		   ('Conv2', 'conv2.jpg'),
		   ('Conv3', 'conv3.jpg'),
		   ('Conv4', 'conv4.jpg'),
		   ('Conv5', 'conv5.jpg');

INSERT INTO user_connects (u_id, c_id)
	VALUES (1, 1),
		   (2, 1),
		   (3, 2),
		   (4, 2),
		   (5, 2);

INSERT INTO messages (m_text, m_time, m_is_read, m_is_deleted, u_from, con_id)	
	VALUES ('hi, Maria!', timestamp '2016-11-28 13:38:10', TRUE, FALSE, 1, 1),
		   ('Mua', timestamp '2016-12-28 13:38:10', TRUE, FALSE, 2, 1),
		   ('like', timestamp '2016-12-29 13:38:10', TRUE, FALSE, 3, 2),
		   ('love love', timestamp '2016-10-28 13:38:10', TRUE, FALSE, 4, 2),
		   ('ping ping', timestamp '2016-10-28 13:38:10', TRUE, FALSE, 5, 3),
		   ('pong pong', timestamp '2016-10-28 13:38:10', TRUE, FALSE, 2, 3),
		   ('hello, Daria!', timestamp '2017-01-02 13:38:10', TRUE, FALSE, 2, 1);

INSERT INTO attachments (at_link, at_date, at_type, m_id)
	VALUES ('att.doc', timestamp '2016-11-28 13:38:10', 2, 1),
		   ('im.jpg', timestamp '2016-12-28 13:38:10', 1, 2),
		   ('vi.wmv', timestamp '2016-12-28 13:38:10', 3, 3),
		   ('dd.doc', timestamp '2016-12-28 13:38:10', 2, 4),
		   ('att2.doc', timestamp '2016-11-28 13:38:10', 2, 2);


INSERT INTO smiles (s_link, s_type, m_id)
	VALUES ('smile1.jpg', 0, 1),
		   ('smile2.jpg', 1, 2),
		   ('smile3.jpg', 1, 3),
		   ('smile4.jpg', 0, 2);


ALTER TABLE devices ADD FOREIGN KEY (u_id) REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE user_connects ADD FOREIGN KEY (c_id) REFERENCES conversations (con_id) ON DELETE CASCADE ON UPDATE CASCADE;

-- END INSERT VALUES

-- START INDEXES

CREATE INDEX user_name_idx ON users (user_name);-- INCLUDING (director, rating);
CREATE  INDEX conv_name_idx ON conversations (con_name);
CREATE UNIQUE INDEX contacts_idx ON contacts (c_user_id, u_id);
CREATE INDEX cities_idx ON locations (loc_city);
CREATE INDEX mes_date_idx ON messages (m_time);
CREATE INDEX mes_con_idx ON messages (con_id, u_from);


-- END INDEXES

-- START QUERIES

SELECT * FROM smiles;
SELECT * FROM attachments;
SELECT * FROM messages;
SELECT * FROM contacts;
SELECT * FROM user_connects;
SELECT * FROM conversations;
SELECT * FROM settings;
SELECT * FROM devices;
SELECT * FROM users;
SELECT * FROM locations;

-- 4.1 Вывести все сообщения пользователя X с указанием даты

SELECT m_time, m_text
FROM messages
WHERE u_from IN (
	SELECT user_id 
	FROM users 
	WHERE user_name = 'Daria'
);

-- 4.2 Вывести сообщения в конференции X с указанием отправителя и времени

SELECT m_time, user_name, m_text
FROM messages, users
WHERE user_id = u_from AND con_id IN (
	SELECT con_id 
	FROM conversations
	WHERE con_name = 'Dialog1'
);	

-- 4.3 Вывести контакты пользователя с ID = X, с которыми он переписывался

SELECT contacts.c_user_id
FROM contacts
WHERE contacts.u_id = 1 AND contacts.c_user_id IN (
	SELECT u_id 
	FROM user_connects
	WHERE c_id IN (
		SELECT c_id
		FROM user_connects
		WHERE u_id = contacts.u_id
	) 
);
	
-- 4.4 Вывести контакты пользователя X и количество сообщений с каждым их них в порядке убывания

SELECT contacts.c_user_id, COUNT(messages.m_id)
FROM contacts, messages
WHERE contacts.u_id = 1 AND messages.con_id IN (
	SELECT c_id 
	FROM user_connects 
	WHERE u_id = contacts.u_id AND c_id IN (
		SELECT c_id
		FROM user_connects
		WHERE u_id = contacts.c_user_id
	)
)
GROUP BY contacts.c_user_id 
ORDER BY COUNT(messages.m_id);

-- 4.5 Вывести всех пользователей из России

SELECT users.user_name 
FROM users
WHERE users.loc_id IN (
	SELECT loc_id
	FROM locations
	WHERE loc_country = 'Russia'
);

-- 4.6 Для каждого пользователя вывести, включен ли у него звук в приложении

SELECT users.user_name, s_sound 
FROM users, settings
WHERE users.setting_id = settings.s_id;

-- 4.7 Для всех сообщений вывести список прикрепленных файлов

SELECT m_id, at_link, at_type, at_date
FROM messages
NATURAL JOIN attachments;

-- 4.8 Вывести всех пользователей, количество сообщений которых больше X

SELECT contacts.c_user_id, COUNT(messages.m_id)
FROM contacts, messages
WHERE contacts.u_id = 1 AND messages.con_id IN (
	SELECT c_id 
	FROM user_connects 
	WHERE u_id = contacts.u_id AND c_id IN (
		SELECT c_id
		FROM user_connects
		WHERE u_id = contacts.c_user_id
	)
)
GROUP BY contacts.c_user_id 
HAVING COUNT(messages.m_id) > 2;


-- 4.9 Вывести пользователей, которые общались со всеми своими контактами.

SELECT users.user_name 
FROM users 
WHERE users.user_id IN (
	SELECT contacts.u_id
	FROM contacts
	WHERE contacts.c_user_id IN (
		SELECT u_id 
		FROM user_connects
		WHERE c_id IN (
			SELECT c_id
			FROM user_connects
			WHERE u_id = contacts.u_id	
		)
	) 
) AND users.user_id NOT IN (
	SELECT contacts.u_id
	FROM contacts
	WHERE contacts.c_user_id NOT IN (
		SELECT u_id 
		FROM user_connects
		WHERE c_id IN (
			SELECT c_id
			FROM user_connects
			WHERE u_id = contacts.u_id	
		)
	) 
);

-- 4.10 Среднее количество сообщений в день для пользователя X

SELECT AVG(TT.CNT)
FROM (
	SELECT EXTRACT (DAY FROM messages.m_time) AS TMN, COUNT(m_id) AS CNT
	FROM users 
	INNER JOIN messages ON users.user_id = messages.u_from
	WHERE users.user_name = 'Maria'
	GROUP BY EXTRACT (DAY FROM messages.m_time)
) AS TT
GROUP BY TT.TMN;


-- 4.11 Вывести всех пользователей, которые были активны в течение последних пяти дней

SELECT users.user_name
FROM users
WHERE (SELECT EXTRACT (DAY FROM now() - users.user_last_visit)) < 5;

-- 4.12 Для пользователя Х количество контактов из каждой страны

SELECT users.user_name, COUNT(contacts.c_user_id)
FROM users
INNER JOIN contacts ON users.user_id = contacts.u_id
WHERE contacts.c_user_id IN (
	SELECT users.user_id
	FROM users
	WHERE users.loc_id IN (
		SELECT loc_id
		FROM locations
		WHERE locations.loc_country = 'Russia'
	)
) 
GROUP BY users.user_name;


-- END QUERIES

CREATE VIEW Convers AS
SELECT user_connects.c_id AS ccon, user_connects.u_id AS u1, users.user_id AS u2
FROM user_connects, users
WHERE users.user_id IN (
	SELECT u_id 
	FROM user_connects
	WHERE c_id IN (
		SELECT c_id
		FROM user_connects
		WHERE u_id = users.user_id
	) 
);

-- CREATE UNIQUE INDEX conv_users_idx ON Convers (Convers.u1) INCLUDING (Convers.u2); ???


SELECT * FROM Convers;


-- BEGIN TRIGGERS

-- 5.1 При отправке сообщения смотрит, если пользователь-отправитель не в черном списке, 
-- то не отправляет сообщение.

CREATE OR REPLACE FUNCTION message_check() RETURNS TRIGGER AS $MTrig$
    BEGIN
    	IF (NEW.u_from NOT IN (
    		SELECT contacts.c_user_id 
    		FROM contacts
    		WHERE contacts.in_black_list = TRUE AND contacts.u_id IN (
    			SELECT u2 
    			FROM Convers
    			WHERE ccon = NEW.con_id AND u1 = NEW.u_from
    	    )
    	)) THEN
    		BEGIN    			
    			RETURN NEW;
    		END;
		END IF;    				
    	RETURN NULL;
    END;
$MTrig$ LANGUAGE plpgsql;

CREATE TRIGGER message_check
BEFORE INSERT OR UPDATE ON messages
FOR EACH ROW EXECUTE PROCEDURE message_check();


-- 5.2 При запросе создания нового пользователя или изменения профиля проверяет то, 
-- что такого пользователя нет в системе по номеру телефона.

CREATE OR REPLACE FUNCTION user_check() RETURNS TRIGGER AS $UTrig$
    BEGIN
    	IF (NEW.user_phone NOT IN (
    		SELECT users.user_phone
    		FROM users
    	)) THEN
    		BEGIN    			
    			RETURN NEW;
    		END;
		END IF;    				
    	RETURN NULL;
    END;
$UTrig$ LANGUAGE plpgsql;

CREATE TRIGGER user_check
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW EXECUTE PROCEDURE user_check();


-- 5.3 Триггер, не позволяющий удалять из базы сообщения, которые не были удалены пользователем.

CREATE OR REPLACE FUNCTION m_del() RETURNS TRIGGER AS $MDTrig$
    BEGIN
    	IF (NEW.m_is_deleted = TRUE) THEN
    		BEGIN    			
    			RETURN NEW;
    		END;
		END IF;    				
    	RETURN NULL;
    END;
$MDTrig$ LANGUAGE plpgsql;

CREATE TRIGGER m_del
BEFORE DELETE ON messages
FOR EACH ROW EXECUTE PROCEDURE m_del();


-- END TRIGGERS

-- START PROCEDURES

-- 6.1 send_message(u_id1, u_id2, mbody) -- пытается отправить пользователю сообщение, 
-- возвращает TRUE, если сообщение отправлено.

CREATE OR REPLACE FUNCTION send_message(u_id1 int, u_id2 int, mbody varchar(10000)) RETURNS BOOLEAN AS $$
	DECLARE
		con_num int;
	BEGIN
    	con_num := (SELECT ccon FROM Convers WHERE u1 = u_id1 AND u2 = u_id2);

		INSERT INTO messages (m_text, m_time, m_is_read, m_is_deleted, u_from, con_id)	
			VALUES (mbody, now(), FALSE, FALSE, u_id1, con_num);

		RETURN FOUND;
    END;
$$ LANGUAGE plpgsql;

SELECT send_message(1, 2, 'sss');

-- 6.2 open_conversation(u_id, con_id) -- открывает диалог с пользователем u_id и 
-- делает все сообщения диалога от собеседника прочитанными, 
-- возвращает количество изначально непрочитанных сообщений.


CREATE OR REPLACE FUNCTION open_conversation(u_id int, ccon_id int) RETURNS INT AS $$
	DECLARE
		cnt int;
	BEGIN
		cnt := (SELECT COUNT(messages.m_id) 
				FROM messages 
				WHERE (m_is_read = FALSE AND messages.con_id = ccon_id AND messages.u_from <> u_id)
				GROUP BY messages.u_from
				);
    	UPDATE messages SET m_is_read = TRUE WHERE messages.con_id = ccon_id AND messages.u_from <> u_id;    			

		RETURN cnt;
    END;
$$ LANGUAGE plpgsql;

SELECT open_conversation(1, 2);

-- 6.3 create_user(..) -- создает нового пользователя

CREATE OR REPLACE FUNCTION create_user(name varchar(100), phone varchar(50), passw varchar(500))
	RETURNS BOOLEAN AS $$
	BEGIN

    	INSERT INTO users (user_name, user_phone, user_last_visit, user_password)
			VALUES (name, phone, now(), passw);
		RETURN FOUND;

    END;
$$ LANGUAGE plpgsql;

SELECT create_user('Tanya', '3342233', 'qwert22');

-- 6.4 delete_useless_message() -- удаляет сообщения, помеченные удаленными

CREATE OR REPLACE FUNCTION delete_useless_message()
	RETURNS BOOLEAN AS $$
	BEGIN
		DELETE
		FROM messages
		WHERE messages.m_is_deleted = TRUE;
		RETURN FOUND;
    END;
$$ LANGUAGE plpgsql;

SELECT delete_useless_message();

-- END PROCEDURES

-- У каждого сообщение <= 1 attachments, <= 3 смайликов


CREATE OR REPLACE FUNCTION smiles_check() RETURNS TRIGGER AS $STrig$
	DECLARE
		smiles_cnt int;
    BEGIN
		smiles_cnt := (
			SELECT COUNT(smiles.s_id)
			FROM smiles
			WHERE smiles.m_id = NEW.m_id
			GROUP BY smiles.m_id
		);

    	IF (smiles_cnt < 3) THEN
    		BEGIN    			
    			RETURN NEW;
    		END;
		END IF;    				
    	RETURN NULL;
    END;
$STrig$ LANGUAGE plpgsql;

CREATE TRIGGER smiles_check
BEFORE INSERT ON smiles
FOR EACH ROW EXECUTE PROCEDURE smiles_check();



CREATE OR REPLACE FUNCTION attachment_check() RETURNS TRIGGER AS $ATrig$
	DECLARE
		att_cnt int;
    BEGIN
		att_cnt := (
			SELECT COUNT(attachments.at_id)
			FROM attachments
			WHERE attachments.m_id = NEW.m_id
			GROUP BY attachments.m_id
		);

    	IF (att_cnt = 0) THEN
    		BEGIN    			
    			RETURN NEW;
    		END;
		END IF;    				
    	RETURN NULL;
    END;
$ATrig$ LANGUAGE plpgsql;

CREATE TRIGGER attachment_check
BEFORE INSERT ON attachments
FOR EACH ROW EXECUTE PROCEDURE attachment_check();

CREATE ASSERTION MessageRestriction CHECK (
	NOT EXISTS (
		SELECT attachments.m_id
		FROM attachments
		GROUP BY attachments.m_id
		HAVING COUNT(attachments.at_id) > 1
	) AND NOT EXISTS (
		SELECT smiles.m_id
		FROM smiles
		GROUP BY smiles.m_id
		HAVING COUNT(smiles.s_id) > 3
	)
)
