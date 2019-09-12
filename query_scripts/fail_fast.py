from pydal import DAL, Field

db = DAL("mysql://root:root@localhost/sakila?set_encoding=utf8mb4", fake_migrate_all=True)

db.define_table('film', Field('film_id'), Field('title'), Field('description'), Field('rental_rate'), Field('rating'))
db.define_table('inventory', Field('film_id'), Field('inventory_id'))
db.define_table('rental', Field('customer_id'), Field('inventory_id'))
db.define_table('customer', Field('customer_id'), Field('first_name'), Field('last_name'))

films = ["BENEATH RUSH", "CADDYSHACK JEDI", "REUNION WITCHES", "VOLCANO TEXAS", "SWARM GOLD"]


def fail_slow():
    film_rows = db(db.film.rating == "G").select(
        db.customer.first_name,
        db.customer.last_name,
        db.film.title,
        db.film.description,
        db.film.rental_rate,
        join=[
            db.inventory.on(db.film.film_id == db.inventory.film_id),
            db.rental.on(db.inventory.inventory_id == db.rental.inventory_id),
            db.customer.on((db.rental.customer_id == db.customer.customer_id) & (db.customer.first_name.like("Alez%")))
        ]
    )
    return film_rows


def fail_fast():
    film_rows = db(db.customer.first_name.like("Alez%")).select(
        db.customer.first_name,
        db.customer.last_name,
        db.film.title,
        db.film.description,
        db.film.rental_rate,
        join=[
            db.rental.on(db.customer.customer_id == db.rental.customer_id),
            db.inventory.on(db.rental.inventory_id == db.inventory.inventory_id),
            db.film.on((db.inventory.film_id == db.customer.customer_id) & (db.film.rating == "G"))
        ]
    )

    return film_rows


if __name__ == '__main__':
    import timeit

    print(timeit.timeit(
        "fail_slow()", setup="from __main__ import fail_slow", number=10000
    ))
    print(timeit.timeit(
        "fail_fast()", setup="from __main__ import fail_fast", number=10000
    ))
