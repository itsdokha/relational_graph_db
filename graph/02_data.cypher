// =====================================================================
//  Шаг 2: наполнение графа данными (те же данные, что и в реляционной БД).
//  Вершины создаём через UNWIND по списку, рёбра — через MATCH + MERGE.
//  MERGE делает загрузку идемпотентной: повторный запуск не задвоит данные.
// =====================================================================

// ---------- Вершины: Person ----------
UNWIND [
  {id:1,  name:'Leonardo DiCaprio',    born:1974, country:'USA'},
  {id:2,  name:'Kate Winslet',         born:1975, country:'UK'},
  {id:3,  name:'Tom Hardy',            born:1977, country:'UK'},
  {id:4,  name:'Joseph Gordon-Levitt', born:1981, country:'USA'},
  {id:5,  name:'Elliot Page',          born:1987, country:'Canada'},
  {id:6,  name:'Cillian Murphy',       born:1976, country:'Ireland'},
  {id:7,  name:'Marion Cotillard',     born:1975, country:'France'},
  {id:8,  name:'Brad Pitt',            born:1963, country:'USA'},
  {id:9,  name:'Margot Robbie',        born:1990, country:'Australia'},
  {id:10, name:'Christopher Nolan',    born:1970, country:'UK'},
  {id:11, name:'Martin Scorsese',      born:1942, country:'USA'},
  {id:12, name:'Quentin Tarantino',    born:1963, country:'USA'},
  {id:13, name:'James Cameron',        born:1954, country:'Canada'},
  {id:14, name:'Alejandro Inarritu',   born:1963, country:'Mexico'}
] AS row
MERGE (p:Person {person_id: row.id})
SET p.full_name = row.name, p.birth_year = row.born, p.country = row.country;

// ---------- Вершины: Movie ----------
UNWIND [
  {id:101, title:'Titanic',                       year:1997, rating:7.9, dur:195},
  {id:102, title:'Inception',                     year:2010, rating:8.8, dur:148},
  {id:103, title:'The Revenant',                  year:2015, rating:8.0, dur:156},
  {id:104, title:'The Wolf of Wall Street',       year:2013, rating:8.2, dur:180},
  {id:105, title:'Once Upon a Time in Hollywood', year:2019, rating:7.6, dur:161},
  {id:106, title:'The Dark Knight',               year:2008, rating:9.0, dur:152},
  {id:107, title:'Dunkirk',                       year:2017, rating:7.8, dur:106},
  {id:108, title:'Oppenheimer',                   year:2023, rating:8.3, dur:180},
  {id:109, title:'Django Unchained',              year:2012, rating:8.4, dur:165},
  {id:110, title:'Inglourious Basterds',          year:2009, rating:8.3, dur:153}
] AS row
MERGE (m:Movie {movie_id: row.id})
SET m.title = row.title, m.release_year = row.year,
    m.rating = row.rating, m.duration_min = row.dur;

// ---------- Вершины: Genre ----------
UNWIND [
  {id:201, name:'Drama'},   {id:202, name:'Sci-Fi'},  {id:203, name:'Thriller'},
  {id:204, name:'Adventure'},{id:205, name:'Comedy'}, {id:206, name:'Action'},
  {id:207, name:'War'},     {id:208, name:'Western'}, {id:209, name:'History'},
  {id:210, name:'Crime'},   {id:211, name:'Romance'}
] AS row
MERGE (g:Genre {genre_id: row.id})
SET g.name = row.name;

// ---------- Рёбра: (:Person)-[:ACTED_IN {character}]->(:Movie) ----------
UNWIND [
  {pid:1, mid:101, ch:'Jack Dawson'},     {pid:1, mid:102, ch:'Dom Cobb'},
  {pid:1, mid:103, ch:'Hugh Glass'},      {pid:1, mid:104, ch:'Jordan Belfort'},
  {pid:1, mid:105, ch:'Rick Dalton'},     {pid:1, mid:109, ch:'Calvin Candie'},
  {pid:2, mid:101, ch:'Rose DeWitt'},
  {pid:3, mid:102, ch:'Eames'},           {pid:3, mid:103, ch:'John Fitzgerald'},
  {pid:3, mid:107, ch:'Farrier'},
  {pid:4, mid:102, ch:'Arthur'},          {pid:5, mid:102, ch:'Ariadne'},
  {pid:6, mid:102, ch:'Robert Fischer'},  {pid:6, mid:106, ch:'Scarecrow'},
  {pid:6, mid:107, ch:'Shivering Soldier'},{pid:6, mid:108, ch:'J. R. Oppenheimer'},
  {pid:7, mid:102, ch:'Mal'},
  {pid:8, mid:105, ch:'Cliff Booth'},     {pid:8, mid:110, ch:'Aldo Raine'},
  {pid:9, mid:104, ch:'Naomi Lapaglia'},  {pid:9, mid:105, ch:'Sharon Tate'},
  {pid:12, mid:109, ch:'Frankie'}
] AS row
MATCH (p:Person {person_id: row.pid}), (m:Movie {movie_id: row.mid})
MERGE (p)-[r:ACTED_IN]->(m)
SET r.character = row.ch;

// ---------- Рёбра: (:Person)-[:DIRECTED]->(:Movie) ----------
UNWIND [
  {pid:10, mid:102}, {pid:10, mid:106}, {pid:10, mid:107}, {pid:10, mid:108},
  {pid:11, mid:104},
  {pid:12, mid:105}, {pid:12, mid:109}, {pid:12, mid:110},
  {pid:13, mid:101},
  {pid:14, mid:103}
] AS row
MATCH (p:Person {person_id: row.pid}), (m:Movie {movie_id: row.mid})
MERGE (p)-[:DIRECTED]->(m);

// ---------- Рёбра: (:Movie)-[:HAS_GENRE]->(:Genre) ----------
UNWIND [
  {mid:101, gid:201}, {mid:101, gid:211},
  {mid:102, gid:202}, {mid:102, gid:203}, {mid:102, gid:206},
  {mid:103, gid:201}, {mid:103, gid:204},
  {mid:104, gid:201}, {mid:104, gid:205}, {mid:104, gid:210},
  {mid:105, gid:201}, {mid:105, gid:205},
  {mid:106, gid:206}, {mid:106, gid:210}, {mid:106, gid:203},
  {mid:107, gid:207}, {mid:107, gid:201}, {mid:107, gid:206},
  {mid:108, gid:201}, {mid:108, gid:209}, {mid:108, gid:203},
  {mid:109, gid:208}, {mid:109, gid:201}, {mid:109, gid:210},
  {mid:110, gid:207}, {mid:110, gid:201}
] AS row
MATCH (m:Movie {movie_id: row.mid}), (g:Genre {genre_id: row.gid})
MERGE (m)-[:HAS_GENRE]->(g);
