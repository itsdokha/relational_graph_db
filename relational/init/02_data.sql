-- =====================================================================
--  Наполнение данными "Кинобаза"
--  10 фильмов, 14 человек (актёры + режиссёры), 11 жанров.
--  Данные подобраны так, чтобы граф связей был насыщенным:
--  общие актёры, плодовитый режиссёр (Нолан), цепочки совместных съёмок.
-- =====================================================================

-- ---------- Люди ----------
INSERT INTO person (person_id, full_name, birth_year, country) VALUES
 (1,  'Leonardo DiCaprio',    1974, 'USA'),
 (2,  'Kate Winslet',         1975, 'UK'),
 (3,  'Tom Hardy',            1977, 'UK'),
 (4,  'Joseph Gordon-Levitt', 1981, 'USA'),
 (5,  'Elliot Page',          1987, 'Canada'),
 (6,  'Cillian Murphy',       1976, 'Ireland'),
 (7,  'Marion Cotillard',     1975, 'France'),
 (8,  'Brad Pitt',            1963, 'USA'),
 (9,  'Margot Robbie',        1990, 'Australia'),
 (10, 'Christopher Nolan',    1970, 'UK'),       -- режиссёр
 (11, 'Martin Scorsese',      1942, 'USA'),      -- режиссёр
 (12, 'Quentin Tarantino',    1963, 'USA'),      -- режиссёр И актёр (камео)
 (13, 'James Cameron',        1954, 'Canada'),   -- режиссёр
 (14, 'Alejandro Inarritu',   1963, 'Mexico');   -- режиссёр

-- ---------- Фильмы ----------
INSERT INTO movie (movie_id, title, release_year, rating, duration_min) VALUES
 (101, 'Titanic',                        1997, 7.9, 195),
 (102, 'Inception',                      2010, 8.8, 148),
 (103, 'The Revenant',                   2015, 8.0, 156),
 (104, 'The Wolf of Wall Street',        2013, 8.2, 180),
 (105, 'Once Upon a Time in Hollywood',  2019, 7.6, 161),
 (106, 'The Dark Knight',                2008, 9.0, 152),
 (107, 'Dunkirk',                        2017, 7.8, 106),
 (108, 'Oppenheimer',                    2023, 8.3, 180),
 (109, 'Django Unchained',               2012, 8.4, 165),
 (110, 'Inglourious Basterds',           2009, 8.3, 153);

-- ---------- Жанры ----------
INSERT INTO genre (genre_id, name) VALUES
 (201, 'Drama'),   (202, 'Sci-Fi'),  (203, 'Thriller'), (204, 'Adventure'),
 (205, 'Comedy'),  (206, 'Action'),  (207, 'War'),      (208, 'Western'),
 (209, 'History'), (210, 'Crime'),   (211, 'Romance');

-- ---------- Роли (ACTED_IN) ----------
INSERT INTO role (role_id, person_id, movie_id, character_name) VALUES
 (1,  1, 101, 'Jack Dawson'),
 (2,  1, 102, 'Dom Cobb'),
 (3,  1, 103, 'Hugh Glass'),
 (4,  1, 104, 'Jordan Belfort'),
 (5,  1, 105, 'Rick Dalton'),
 (6,  1, 109, 'Calvin Candie'),
 (7,  2, 101, 'Rose DeWitt'),
 (8,  3, 102, 'Eames'),
 (9,  3, 103, 'John Fitzgerald'),
 (10, 3, 107, 'Farrier'),
 (11, 4, 102, 'Arthur'),
 (12, 5, 102, 'Ariadne'),
 (13, 6, 102, 'Robert Fischer'),
 (14, 6, 106, 'Scarecrow'),
 (15, 6, 107, 'Shivering Soldier'),
 (16, 6, 108, 'J. R. Oppenheimer'),
 (17, 7, 102, 'Mal'),
 (18, 8, 105, 'Cliff Booth'),
 (19, 8, 110, 'Aldo Raine'),
 (20, 9, 104, 'Naomi Lapaglia'),
 (21, 9, 105, 'Sharon Tate'),
 (22, 12, 109, 'Frankie');   -- Тарантино играет камео в своём же фильме

-- ---------- Режиссура (DIRECTED) ----------
INSERT INTO direction (person_id, movie_id) VALUES
 (10, 102), (10, 106), (10, 107), (10, 108),   -- Нолан: 4 фильма
 (11, 104),                                     -- Скорсезе
 (12, 105), (12, 109), (12, 110),               -- Тарантино: 3 фильма
 (13, 101),                                     -- Кэмерон
 (14, 103);                                     -- Иньярриту

-- ---------- Жанры фильмов (HAS_GENRE) ----------
INSERT INTO movie_genre (movie_id, genre_id) VALUES
 (101, 201), (101, 211),                        -- Titanic: Drama, Romance
 (102, 202), (102, 203), (102, 206),            -- Inception: Sci-Fi, Thriller, Action
 (103, 201), (103, 204),                        -- Revenant: Drama, Adventure
 (104, 201), (104, 205), (104, 210),            -- Wolf: Drama, Comedy, Crime
 (105, 201), (105, 205),                        -- OUATIH: Drama, Comedy
 (106, 206), (106, 210), (106, 203),            -- Dark Knight: Action, Crime, Thriller
 (107, 207), (107, 201), (107, 206),            -- Dunkirk: War, Drama, Action
 (108, 201), (108, 209), (108, 203),            -- Oppenheimer: Drama, History, Thriller
 (109, 208), (109, 201), (109, 210),            -- Django: Western, Drama, Crime
 (110, 207), (110, 201);                        -- Inglourious: War, Drama
