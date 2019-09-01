from pydal import DAL, Field

db = DAL("mysql://root:root@localhost/sakila?set_encoding=utf8mb4", fake_migrate_all=True)

db.define_table('film', Field('film_id'), Field('title'), Field('description'), Field('rental_rate'))

films = ["BENEATH RUSH", "CADDYSHACK JEDI", "REUNION WITCHES", "VOLCANO TEXAS", "SWARM GOLD"]


def using_a_list_of_ids():
    film_ids = [
        row.film_id for row in 
        db(db.film.rental_rate < 1.0).select(
            db.film.film_id,
        )
    ]

    film_rows = db(db.film.rental_rate.belongs(film_ids)).select(
        db.film.title,
        db.film.description,
        db.film.rental_rate,
        orderby=db.film.rental_rate
    )
    return film_rows


def using_a_subquery():
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
        "using_a_list_of_ids()", setup="from __main__ import using_a_list_of_ids", number=1000
    ))
    print(timeit.timeit(
        "using_a_subquery()", setup="from __main__ import using_a_subquery", number=1000
    ))
