from pydal import DAL, Field

db = DAL("mysql://root:root@localhost/sakila?set_encoding=utf8mb4", fake_migrate_all=True)

db.define_table('film', 
    Field('film_id', type='id'),
    Field('title'), 
    Field('description'),
    Field('release_year'),
    Field('language_id'),
    Field('original_language_id'),
    Field('rental_duration'),
    Field('rental_rate'),
    Field('length'),
    Field('replacement_cost'),
    Field('rating'),
    Field('special_features'),
    Field('last_update')
)

def select_star():
    film_rows = db(db.film.film_id > 0).select()
    return film_rows


def specific_select():
    film_rows = db(db.film.film_id > 0).select(db.film.title, db.film.description)
    return film_rows


if __name__ == '__main__':
    import timeit
    print(timeit.timeit("select_star()", setup="from __main__ import select_star", number=1000))
    print(timeit.timeit("()", setup="from __main__ import specific_select", number=1000))
