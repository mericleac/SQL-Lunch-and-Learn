from pydal import DAL, Field

db = DAL("mysql://root:root@localhost/sakila?set_encoding=utf8mb4", fake_migrate_all=True)

db.define_table('film', Field('title'), Field('description'))

films = ["BENEATH RUSH", "CADDYSHACK JEDI", "REUNION WITCHES", "VOLCANO TEXAS", "SWARM GOLD"]


def query_in_a_loop():
    rows = []
    for film in films:
        film_row = db(db.film.title == film).select(db.film.title, db.film.description).first()
        rows.append(film_row)
    return rows


def query_belongs():
    film_rows = db(db.film.title.belongs(films)).select(db.film.title, db.film.description).first()
    return film_rows


if __name__ == '__main__':
    import timeit
    print(timeit.timeit("query_in_a_loop()", setup="from __main__ import query_in_a_loop", number=10000))
    print(timeit.timeit("query_belongs()", setup="from __main__ import query_belongs", number=10000))
