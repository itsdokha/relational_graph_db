-- =====================================================================
--  Реляционная схема "Кинобаза" (PostgreSQL)
--  Получена напрямую из ER-диаграммы в DBML (см. models/schema.dbml).
--  Все связи M:N нормализованы через ассоциативные таблицы,
--  поэтому в схеме остаются только связи вида 1:M.
-- =====================================================================

-- Чистый старт (удобно при пересоздании БД)
DROP TABLE IF EXISTS movie_genre CASCADE;
DROP TABLE IF EXISTS direction  CASCADE;
DROP TABLE IF EXISTS role       CASCADE;
DROP TABLE IF EXISTS movie      CASCADE;
DROP TABLE IF EXISTS genre      CASCADE;
DROP TABLE IF EXISTS person     CASCADE;

-- ---------- Сущности ----------

-- Человек: может быть актёром и/или режиссёром.
CREATE TABLE person (
    person_id   INTEGER     PRIMARY KEY,
    full_name   VARCHAR(120) NOT NULL,
    birth_year  INTEGER,
    country     VARCHAR(60)
);

-- Фильм.
CREATE TABLE movie (
    movie_id      INTEGER      PRIMARY KEY,
    title         VARCHAR(160) NOT NULL,
    release_year  INTEGER,
    rating        NUMERIC(3,1),          -- средний рейтинг, напр. 8.8
    duration_min  INTEGER
);

-- Жанр.
CREATE TABLE genre (
    genre_id  INTEGER     PRIMARY KEY,
    name      VARCHAR(60) NOT NULL UNIQUE
);

-- ---------- Ассоциативные таблицы (нормализация M:N) ----------

-- ACTED_IN: человек сыграл роль в фильме.
-- Один человек может играть несколько РАЗНЫХ ролей в одном фильме,
-- но не одну и ту же роль дважды -> уникальность тройки.
CREATE TABLE role (
    role_id        INTEGER PRIMARY KEY,
    person_id      INTEGER NOT NULL REFERENCES person(person_id),
    movie_id       INTEGER NOT NULL REFERENCES movie(movie_id),
    character_name VARCHAR(120),
    UNIQUE (person_id, movie_id, character_name)
);

-- DIRECTED: человек срежиссировал фильм (у фильма может быть >1 режиссёра).
CREATE TABLE direction (
    person_id INTEGER NOT NULL REFERENCES person(person_id),
    movie_id  INTEGER NOT NULL REFERENCES movie(movie_id),
    PRIMARY KEY (person_id, movie_id)
);

-- HAS_GENRE: фильм относится к жанру (фильм может иметь несколько жанров).
CREATE TABLE movie_genre (
    movie_id INTEGER NOT NULL REFERENCES movie(movie_id),
    genre_id INTEGER NOT NULL REFERENCES genre(genre_id),
    PRIMARY KEY (movie_id, genre_id)
);

-- ---------- Индексы под частые обходы связей ----------
CREATE INDEX idx_role_person   ON role(person_id);
CREATE INDEX idx_role_movie    ON role(movie_id);
CREATE INDEX idx_dir_person    ON direction(person_id);
CREATE INDEX idx_mg_genre      ON movie_genre(genre_id);
