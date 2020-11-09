import psycopg2
import sys

"""
Usage: python3 check_fact_rows <expected_count>
"""

def connect(db):
    conn = psycopg2.connect(f'dbname={db} user=postgres')
    return conn

def count_rows(conn):
    sql = f'SELECT COUNT(*) FROM crime_fact'
    cur = conn.cursor()
    cur.execute(sql)
    result = cur.fetchone()
    return result[0]

def check_fact_rows(conn, expected_count):
    print(f'Checking crime_fact "{expected_count}" rows...')
    rows = count_rows(conn)
    if rows != expected_count:
        raise ValueError(f'check_fact_rows failed.  expected {expected_count}, got {rows} ')

def main(expected_count):
    conn = connect('unittest')
    check_fact_rows(conn, expected_count)
    print(f'fact_rows={expected_count} checks passed!')


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print('Usage: python3 check_fact_rows <expected_count>')
        sys.exit(1)
        
    expected_count = int(sys.argv[1])
    main(expected_count)
