DROP DATABASE messenger_db;
CREATE DATABASE messenger_db;

DROP TABLE smiles CASCADE;
DROP TABLE attachments CASCADE;
DROP TABLE messages CASCADE;
DROP TABLE contacts CASCADE;
DROP TABLE user_connects CASCADE;
DROP TABLE conversations CASCADE;
DROP TABLE settings CASCADE;
DROP TABLE devices CASCADE;
DROP TABLE users CASCADE;
DROP TABLE locations CASCADE;


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
	c_id int NOL NULL REFERENCES conversations (con_id) ON DELETE CASCADE ON UPDATE CASCADE
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
		   ('Russia', 'Tyumenskaya', 'Tyumen');

INSERT INTO settings (s_notifications, s_mes_preview, s_sound, s_language)
	VALUES (TRUE, TRUE, TRUE, 1),
		   (TRUE, FALSE, TRUE, 2),
		   (TRUE, TRUE, FALSE, 3);

INSERT INTO devices (dev_type, dev_number, u_id)
	VALUES (0, 'iMac', 1),
		   (1, 'iPhone', 1),
		   (2, 'iWatch', 1);

INSERT INTO users (user_name, user_gender, user_icon, user_phone, user_email, user_last_visit, 
	user_password, setting_id, loc_id, dev_id)
	VALUES ('Daria', 1, 'daria.jpg', '79110343466', 'dd@d.ru', timestamp '2016-11-28 13:38:10', '1234', 1, 1, 1),
		   ('Maria', 1, 'maria.jpg', '71234567890', 'mm@d.ru', timestamp '2016-12-28 13:38:10', '123', 1, 1, 1);

INSERT INTO contacts (c_user_id, u_id, in_black_list)
	VALUES (1, 2, FALSE),
		   (2, 1, FALSE);

INSERT INTO conversations (con_name, con_icon)
	VALUES ('Dialog1', 'dial.jpg');

INSERT INTO user_connects (u_id, c_id)
	VALUES (1, 1),
		   (2, 1);

INSERT INTO messages (m_text, m_time, m_is_read, m_is_deleted, u_from, con_id)	
	VALUES ('hi, Maria!', timestamp '2016-11-28 13:38:10', TRUE, FALSE, 1, 1),
		   ('hello, Daria!', timestamp '2017-01-02 13:38:10', TRUE, FALSE, 2, 1);

INSERT INTO attachments (at_link, at_date, at_type, m_id)
	VALUES ('att.doc', timestamp '2016-11-28 13:38:10', 2, 1),
		   ('att2.doc', timestamp '2016-11-28 13:38:10', 1, 2);


INSERT INTO smiles (s_link, s_type, m_id)
	VALUES ('smile1.jpg', 0, 1);

ALTER TABLE devices ADD FOREIGN KEY (u_id) REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE user_connects ADD FOREIGN KEY (c_id) REFERENCES conversations (con_id) ON DELETE CASCADE ON UPDATE CASCADE;

-- END INSERT VALUES

-- START ADD INDEXES
-- END ADD INDEXES

-- START ADD QUERIES

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

-- 4.1 ¬ывести все сообщени€ пользовател€ X

SELECT m_time, m_text
FROM messages
WHERE u_from IN (
	SELECT user_id 
	FROM users 
	WHERE user_name = 'Daria'
);

-- 4.2 ¬ывести сообщени€ в конференции X с указанием отправител€ и времени

SELECT m_time, user_name, m_text
FROM messages, users
WHERE user_id = u_from AND con_id IN (
	SELECT con_id 
	FROM conversations
	WHERE con_name = 'Dialog1'
);	

-- 4.3 ¬ывести контакты пользовател€ с ID = X, с которыми он переписывалс€

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
	
-- 4.4 ¬ывести контакты пользовател€ X и количество сообщений с каждым их них в пор€дке убывани€
-- TODOOOOO

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
GROUP BY contacts.c_user_id;--messages.con_id;

-- 4.5 ¬ывести всех пользователей из –оссии

SELECT users.user_name 
FROM users
WHERE users.loc_id IN (
	SELECT loc_id
	FROM locations
	WHERE loc_country = 'Russia'
);

-- 4.6 ƒл€ каждого пользовател€ вывести, включен ли у него звук в приложении

SELECT users.user_name, s_sound 
FROM users, settings
WHERE users.setting_id = settings.s_id;

-- 4.7 ƒл€ всех сообщений вывести список прикрепленных файлов

SELECT m_id, at_link, at_type, at_date
FROM messages
NATURAL JOIN attachments;

-- 4.9 ¬ывести всех пользователей, количество сообщений которых больше X

-- 4.10 ¬ывести пользователей, которые общались со всеми своими контактами.
-- TODO

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
);

-- 4.11 —реднее количество сообщений в день дл€ каждого пользовател€
-- 4.12 ¬ывести всех пользователей, которые были активны в течение последних п€ти дней
-- 4.13 ƒл€ каждого пользовател€ количество контактов, с которыми он переписывалс€ и количество контактов, с которыми нет
-- 4.14 ƒл€ пользовател€ ’ количество контактов из каждой страны


-- END ADD QUERIES

--START ADD PROCEDURES


-- 6.1 send_message(u_id1, u_id2) -- пытаетс€ отправить пользователю сообщение, 
-- возвращает TRUE, если пользователь-отправитель не в черном списке. ≈сли нет диалога, создает диалог.


CREATE VIEW Convers AS
SELECT c_id, u_id, users.user_id
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

SELECT * FROM Convers;


DROP FUNCTION send_message(u_id1 int, u_id2 int);
CREATE OR REPLACE FUNCTION send_message(u_id1 int, u_id2 int) RETURNS BOOLEAN AS $$
	DECLARE
		con_num int;
	BEGIN
    	con_num := (SELECT c_id FROM Convers WHERE ((u_id = u_id1) AND (user_id = u_id2));

		INSERT INTO messages (m_text, m_time, m_is_read, m_is_deleted, u_from, con_id)	
			VALUES ('how are you, Maria!', timestamp '2017-01-16 17:38:10', FALSE, FALSE, u_id1, con_num),
		RETURN FOUND;
    END;
$$ LANGUAGE plpgsql;

SELECT send_message(1, 2);
