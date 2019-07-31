from pydal import DAL, Field

db = DAL("mysql://root:root@localhost/sakila?set_encoding=utf8mb4", fake_migrate_all=True)

db.define_table('film', Field('title'), Field('description'), Field('rental_rate'))

films = ["BENEATH RUSH", "CADDYSHACK JEDI", "REUNION WITCHES", "VOLCANO TEXAS", "SWARM GOLD"]


def query_leaving_relational_space():
    sub_query = db(db.film.rental_rate < 1.0)._select(
        db.film.rental_rate,
        groupby=db.film.rental_rate,
        orderby=db.film.rental_rate,
    )

    film_rows = db(db.film.rental_rate.belongs(sub_query)).select(
        db.film.title,
        db.film.description,
        db.film.rental_rate,
        orderby=db.film.rental_rate
    )
    return film_rows


def query_in_relational_space():
    sub_query = db(db.film.rental_rate < 1.0)._select(
        db.film.rental_rate,
    )

    film_rows = db(db.film.rental_rate.belongs(sub_query)).select(
        db.film.title,
        db.film.description,
        db.film.rental_rate,
        orderby=db.film.rental_rate
    )

    return film_rows


if __name__ == '__main__':
    import timeit

    print(timeit.timeit(
        "query_leaving_relational_space()", setup="from __main__ import query_leaving_relational_space", number=1000
    ))
    print(timeit.timeit(
        "query_in_relational_space()", setup="from __main__ import query_in_relational_space", number=1000
    ))
