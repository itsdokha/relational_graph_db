-- =====================================================================
--  ЗАПРОСЫ К РЕЛЯЦИОННОЙ БД — ответы на вопросы предметной области
--  Запуск:  psql -h localhost -U movies -d movies -f relational/queries.sql
--  (пароль: movies)
-- =====================================================================

\echo '== Вопрос 1: В каких фильмах снимался Leonardo DiCaprio? =='
SELECT m.title, m.release_year, r.character_name
FROM person p
JOIN role  r ON r.person_id = p.person_id
JOIN movie m ON m.movie_id  = r.movie_id
WHERE p.full_name = 'Leonardo DiCaprio'
ORDER BY m.release_year;

\echo '== Вопрос 2: С кем DiCaprio чаще всего снимался вместе? =='
SELECT co.full_name AS co_actor, COUNT(*) AS movies_together
FROM person p
JOIN role r1 ON r1.person_id = p.person_id
JOIN role r2 ON r2.movie_id  = r1.movie_id
            AND r2.person_id <> p.person_id          -- другой человек в том же фильме
JOIN person co ON co.person_id = r2.person_id
WHERE p.full_name = 'Leonardo DiCaprio'
GROUP BY co.full_name
ORDER BY movies_together DESC, co_actor;

\echo '== Вопрос 3: Какой жанр самый популярный (по числу фильмов)? =='
SELECT g.name AS genre, COUNT(*) AS film_count
FROM genre g
JOIN movie_genre mg ON mg.genre_id = g.genre_id
GROUP BY g.name
ORDER BY film_count DESC, genre;

\echo '== Вопрос 4: Что порекомендовать зрителю, которому понравился Inception? =='
\echo '   (фильмы с наибольшим числом общих жанров)'
SELECT m2.title AS recommended, COUNT(*) AS shared_genres
FROM movie m1
JOIN movie_genre mg1 ON mg1.movie_id = m1.movie_id
JOIN movie_genre mg2 ON mg2.genre_id = mg1.genre_id
                    AND mg2.movie_id <> m1.movie_id
JOIN movie m2 ON m2.movie_id = mg2.movie_id
WHERE m1.title = 'Inception'
GROUP BY m2.title
ORDER BY shared_genres DESC, recommended
LIMIT 5;

\echo '== Вопрос 5: Кратчайшая цепочка совместных съёмок (число Бэйкона) =='
\echo '   от Kate Winslet до Cillian Murphy.'
\echo '   В SQL это требует РЕКУРСИВНОГО обхода графа со-актёров:'
WITH RECURSIVE
-- ребро графа: два человека снялись в одном фильме
coactor(a, b) AS (
    SELECT DISTINCT r1.person_id, r2.person_id
    FROM role r1
    JOIN role r2 ON r2.movie_id = r1.movie_id
                AND r1.person_id <> r2.person_id
),
-- поиск в ширину от стартового актёра
paths(start_id, curr_id, depth, path) AS (
    SELECT c.a, c.b, 1, ARRAY[c.a, c.b]
    FROM coactor c
    WHERE c.a = (SELECT person_id FROM person WHERE full_name = 'Kate Winslet')
  UNION ALL
    SELECT p.start_id, c.b, p.depth + 1, p.path || c.b
    FROM paths p
    JOIN coactor c ON c.a = p.curr_id
    WHERE c.b <> ALL(p.path)        -- не возвращаемся в уже пройденных
      AND p.depth < 6               -- ограничение глубины
)
SELECT depth AS degrees,
       (SELECT array_agg(full_name ORDER BY ord)
        FROM unnest(path) WITH ORDINALITY AS u(pid, ord)
        JOIN person ON person.person_id = u.pid) AS chain
FROM paths
WHERE curr_id = (SELECT person_id FROM person WHERE full_name = 'Cillian Murphy')
ORDER BY depth
LIMIT 1;

\echo '== Вопрос 6: Самый плодовитый режиссёр? =='
SELECT p.full_name AS director, COUNT(*) AS films_directed
FROM person p
JOIN direction d ON d.person_id = p.person_id
GROUP BY p.full_name
ORDER BY films_directed DESC, director;

\echo '== Вопрос 7: Контроль данных — фильмы без жанра и дубли ролей =='
\echo '   7a) фильмы без единого жанра:'
SELECT m.title
FROM movie m
LEFT JOIN movie_genre mg ON mg.movie_id = m.movie_id
WHERE mg.movie_id IS NULL;

\echo '   7b) одинаковая роль одного человека в одном фильме дважды:'
SELECT person_id, movie_id, character_name, COUNT(*) AS cnt
FROM role
GROUP BY person_id, movie_id, character_name
HAVING COUNT(*) > 1;
