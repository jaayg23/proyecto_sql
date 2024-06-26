--SQL MySQL

/*
Una buena practica es denominar las tablas 
en plural e ingles.

Fijese que author_id de la tabla books
es un INTEGER
*/
CREATE TABLE  IF NOT EXISTS libraries (
    library_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    university VARCHAR(100) NOT NULL
);

/*
Variable role:
1: estudiante
0: profesor
by default: estudiante
*/
CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS books (
    book_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    editorial VARCHAR(100) NOT NULL,
    year INTEGER UNSIGNED NOT NULL DEFAULT 1900,
    genre VARCHAR(100) NOT NULL,
    theme TEXT,
    reading_level INTEGER UNSIGNED NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS authors (
    author_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS books_authors (
    book_id INTEGER UNSIGNED,
    author_id INTEGER UNSIGNED,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE NO ACTION ON UPDATE CASCADE
);

/*
Revisar en la foreign key el primer book_id
hace referencia al book_id de la propia tabla
*/
CREATE TABLE IF NOT EXISTS exemplars (
    call_number INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    book_id INTEGER UNSIGNED,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS loans (
    loan_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    loan_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS loans_users (
    loan_id INTEGER UNSIGNED,
    user_id INTEGER UNSIGNED,
    PRIMARY KEY (loan_id, user_id),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS detail_loans (
    detail_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    return_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
); 

CREATE TABLE IF NOT EXISTS detail_loans_loans (
    detail_id INTEGER UNSIGNED,
    loan_id INTEGER UNSIGNED,
    PRIMARY KEY (detail_id, loan_id),
    FOREIGN KEY (detail_id) REFERENCES detail_loans(detail_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS libraries_loans (
    library_id INTEGER UNSIGNED,
    loan_id INTEGER UNSIGNED,
    PRIMARY KEY (library_id, loan_id),
    FOREIGN KEY (library_id) REFERENCES libraries(library_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS libraries_books (
    library_id INTEGER UNSIGNED,
    book_id INTEGER UNSIGNED,
    PRIMARY KEY (library_id, book_id),
    FOREIGN KEY (library_id) REFERENCES libraries(library_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS libraries_users (
    library_id INTEGER UNSIGNED,
    user_id INTEGER UNSIGNED,
    PRIMARY KEY (library_id, user_id),
    FOREIGN KEY (library_id) REFERENCES libraries(library_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS books_loans (
    book_id INTEGER UNSIGNED,
    loan_id INTEGER UNSIGNED,
    PRIMARY KEY (book_id, loan_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE NO ACTION ON UPDATE CASCADE
);

--TO APPLICATE
--INSERTS

INSERT INTO libraries (name, location, university) VALUES ('Biblioteca Central', 'Calle 100', 'Universidad Nacional');
INSERT INTO libraries (name, location, university) VALUES ('Biblioteca de Ingenieria', 'Calle 22', 'Universidad Autonoma');

INSERT INTO users (name, last_name, email, role) VALUES ('Juan', 'Perez', 'jperez@hotmail.com',1);
INSERT INTO users (name, last_name, email, role) VALUES ('Maria', 'Gomez', 'mgomez@hotmail.com',0);

INSERT INTO books (title, editorial, year, genre, theme, reading_level) VALUES ('El principito', 'Santillana', 1943, 'Infantil', 'Fantasia', 1);
INSERT INTO books (title, editorial, year, genre, theme, reading_level) VALUES ('Cien años de soledad', 'Norma', 1967, 'Realismo Magico', 'Ficcion', 2);

INSERT INTO authors (name) VALUES ('Gabriel Garcia Marquez');
INSERT INTO authors (name) VALUES ('Antoine de Saint-Exupery');

INSERT INTO books_authors (book_id, author_id) VALUES (1, 2);
INSERT INTO books_authors (book_id, author_id) VALUES (2, 1);

INSERT INTO exemplars (book_id) VALUES (1);
INSERT INTO exemplars (book_id) VALUES (1);

INSERT INTO loans (loan_date) VALUES (NOW());
INSERT INTO loans (loan_date) VALUES ('2024-05-01 14:30:00');

INSERT INTO detail_loans (return_date) VALUES ('2024-11-01 14:30:00');
INSERT INTO detail_loans (return_date) VALUES ('2024-12-03 14:30:00');

INSERT INTO loans_users (loan_id, user_id) VALUES (1, 1);
INSERT INTO loans_users (loan_id, user_id) VALUES (2, 2);

INSERT INTO detail_loans_loans (detail_id, loan_id) VALUES (1, 1);
INSERT INTO detail_loans_loans (detail_id, loan_id) VALUES (2, 2);

INSERT INTO libraries_loans (library_id, loan_id) VALUES (1, 1);
INSERT INTO libraries_loans (library_id, loan_id) VALUES (2, 2);

INSERT INTO libraries_books (library_id, book_id) VALUES (1, 1);
INSERT INTO libraries_books (library_id, book_id) VALUES (2, 2);

INSERT INTO libraries_users (library_id, user_id) VALUES (1, 1);
INSERT INTO libraries_users (library_id, user_id) VALUES (2, 2);

INSERT INTO books_loans (book_id, loan_id) VALUES (1, 1);
INSERT INTO books_loans (book_id, loan_id) VALUES (2, 2);

--DROP
DROP TABLE IF EXISTS libraries_loans;

--ALTER
ALTER TABLE loans ADD COLUMN book_id INTEGER UNSIGNED;
ALTER TABLE ADD FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE NO ACTION ON UPDATE CASCADE;

--SELECT 1.
SELECT books.title
FROM books
WHERE books.book_id IN(
    SELECT books_loans.book_id
    FROM books_loans
    WHERE books_loans.loan_id IN (
        SELECT loans.loan_id
        FROM loans
        WHERE loans.loan_date BETWEEN '2024-01-01 00:00:00' AND '2024-12-31 23:59:59'
        )
    );

--SELECT 3. Get the rankig of the most borrowed books
SELECT books.title, COUNT(books_loans.book_id) AS total
FROM books
JOIN books_loans ON books.book_id = books_loans.book_id
GROUP BY books.title
ORDER BY total DESC;

--SELECT 4.Get the count of books borrowed by each library
SELECT libraries.name, COUNT(libraries_books.book_id) AS total
FROM libraries
JOIN libraries_books ON libraries.library_id = libraries_books.library_id   
GROUP BY libraries.name;

--SELECT 5. Search books by author, theme or editorial
SELECT books.title, authors.name, books.theme, books.editorial 
FROM books
JOIN books_authors ON books.book_id = books_authors.book_id
JOIN authors ON books_authors.author_id = authors.author_id
WHERE authors.name = 'Gabriel Garcia Marquez' OR books.theme = 'Fantasia' OR books.editorial = 'Santillana';

--SELECT 6. Search books by specific genre
SELECT books.title, books.genre\
FROM books
WHERE books.genre = 'Infantil';