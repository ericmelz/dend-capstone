import psycopg2
import sys

"""
Usage: python3 quality_checks [<dbname>].  dbname is one of {postgres,unittest}
"""

def count_rows(conn, table):
    sql = f'SELECT COUNT(*) FROM {table}'
    cur = conn.cursor()
    cur.execute(sql)
    result = cur.fetchone()
    return result[0]

def collect_unique_sexcodes(conn):
    sql = 'SELECT DISTINCT SexCode FROM crime_fact'
    cur = conn.cursor()
    cur.execute(sql)
    result = cur.fetchone()
    sexcodes = []
    for row in result:
        sexcodes.append(row[0])
    return set(sexcodes)

def check_sexcodes(conn):
    actual_sexcodes = collect_unique_sexcodes(conn)
    legal_sexcodes = {'M', 'F'}
    illegal_sexcodes = actual_sexcodes - legal_sexcodes
    if illegal_sexcodes:
        raise ValueError(f'Detected illegal sex codes: {illegal_sexcodes}')

def connect(db):
    conn = psycopg2.connect(f'dbname={db} user=postgres')
    return conn
    
def check_has_rows(conn, table):
    print(f'Checking has_rows for "{table}"...')
    rows = count_rows(conn, table)
    if not rows:
        raise ValueError(f'has_rows check failed for {table}')

def main(db):
    conn = connect(db)
    check_has_rows(conn, 'crime_fact')
    check_has_rows(conn, 'datetime_dimension')
    check_sexcodes(conn)
    print('Quality checks passed!')


if __name__ == '__main__':
    if len(sys.argv) == 2 and (sys.argv[1] != 'postgres' and sys.argv[1] != 'unittest'):
        print('Usage: python3 quality_checks [<dbname>].  dbname is one of {postgres,unittest}')
        sys.exit(1)
        
    db = sys.argv[1] if len(sys.argv) > 1 else 'postgres'
    print('Running quality checks...')
    main(db)
