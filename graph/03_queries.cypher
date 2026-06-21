// =====================================================================
//  ЗАПРОСЫ К ГРАФОВОЙ БД — ответы на те же вопросы предметной области.
//  Запуск по одному в Neo4j Browser (http://localhost:7474)
//  или целиком: cypher-shell -u neo4j -p moviesmovies -f graph/03_queries.cypher
// =====================================================================

// --- Вопрос 1: В каких фильмах снимался Leonardo DiCaprio? ---
MATCH (p:Person {full_name:'Leonardo DiCaprio'})-[r:ACTED_IN]->(m:Movie)
RETURN m.title AS movie, m.release_year AS year, r.character AS character
ORDER BY m.release_year;

// --- Вопрос 2: С кем DiCaprio чаще всего снимался вместе? ---
// Сам шаблон (актёр)->(фильм)<-(другой актёр) и есть ответ — обход без JOIN-ов.
MATCH (p:Person {full_name:'Leonardo DiCaprio'})-[:ACTED_IN]->(:Movie)<-[:ACTED_IN]-(co:Person)
RETURN co.full_name AS co_actor, count(*) AS movies_together
ORDER BY movies_together DESC, co_actor;

// --- Вопрос 3: Какой жанр самый популярный? ---
MATCH (:Movie)-[:HAS_GENRE]->(g:Genre)
RETURN g.name AS genre, count(*) AS film_count
ORDER BY film_count DESC, genre;

// --- Вопрос 4: Что порекомендовать любителю Inception (по общим жанрам)? ---
MATCH (m1:Movie {title:'Inception'})-[:HAS_GENRE]->(:Genre)<-[:HAS_GENRE]-(m2:Movie)
WHERE m2 <> m1
RETURN m2.title AS recommended, count(*) AS shared_genres
ORDER BY shared_genres DESC, recommended
LIMIT 5;

// --- Вопрос 5: Кратчайшая цепочка совместных съёмок (число Бэйкона) ---
// от Kate Winslet до Cillian Murphy.
// В графе это ОДИН вызов shortestPath — никакой рекурсии вручную.
MATCH path = shortestPath(
  (a:Person {full_name:'Kate Winslet'})-[:ACTED_IN*..10]-(b:Person {full_name:'Cillian Murphy'})
)
RETURN [n IN nodes(path) WHERE 'Person' IN labels(n) | n.full_name] AS chain,
       (length(path)/2) AS degrees;

// --- Вопрос 6: Самый плодовитый режиссёр? ---
MATCH (p:Person)-[:DIRECTED]->(m:Movie)
RETURN p.full_name AS director, count(*) AS films_directed
ORDER BY films_directed DESC, director;

// --- Вопрос 7a: Фильмы без единого жанра ---
MATCH (m:Movie)
WHERE NOT (m)-[:HAS_GENRE]->(:Genre)
RETURN m.title AS movie_without_genre;

// --- Вопрос 7b: Одна и та же роль человека в одном фильме дважды ---
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WITH p, m, r.character AS character, count(*) AS cnt
WHERE cnt > 1
RETURN p.full_name, m.title, character, cnt;
