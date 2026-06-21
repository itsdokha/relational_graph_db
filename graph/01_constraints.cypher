// =====================================================================
//  Графовая БД "Кинобаза" (Neo4j / Cypher)
//  Шаг 1: ограничения уникальности.
//  В Neo4j уникальное ограничение автоматически создаёт INDEX —
//  это аналог PRIMARY KEY из реляционной модели и позволяет быстро
//  доставать конкретную вершину по ключу.
// =====================================================================

CREATE CONSTRAINT person_id IF NOT EXISTS
    FOR (p:Person) REQUIRE p.person_id IS UNIQUE;

CREATE CONSTRAINT movie_id IF NOT EXISTS
    FOR (m:Movie) REQUIRE m.movie_id IS UNIQUE;

CREATE CONSTRAINT genre_id IF NOT EXISTS
    FOR (g:Genre) REQUIRE g.genre_id IS UNIQUE;
