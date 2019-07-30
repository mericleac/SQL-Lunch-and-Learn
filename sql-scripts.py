import mysql.connector

cnx = mysql.connector.connect(user='root', password='root', host='localhost', database='sakila')

films = ["BENEATH RUSH", "CADDYSHACK JEDI", "REUNION WITCHES", "VOLCANO TEXAS", "SWARM GOLD"]


def query_in_a_loop():
    query = ("SELECT title, description FROM film WHERE title = %s")
    for film in films:
        cursor = cnx.cursor()
        cursor.execute(query, tuple([film]))
        cursor.fetchone()
        cursor.close()


def query_belongs():
    query = ("SELECT title, description FROM film WHERE title IN %s")
    cursor = cnx.cursor()
    cursor.execute(query, tuple([tuple(films)]))
    cursor.fetchall()
    cursor.close()

import timeit

query_in_a_loop()
query_belongs()

cnx.close()
