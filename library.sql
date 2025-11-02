-- creating the database in order to use it 
--CREATE DATABASE library;  
--USE DATABASE library;



-- creating necessary tables
CREATE TABLE books(
    book_id NUMBER(10) primary key,
    book_title varchar2(30),
    author VARCHAR2(30),
    publisher VARCHAR2(30),
    year_publishes DATE,
    available_copies NUMBER(10) NOT NULL 
);

CREATE TABLE members(
    members_id number(10) primary KEY,
    member_name VARCHAR2(30),
    email VARCHAR2(50)
);

CREATE TABLE borrowings(
    borrow_id NUMBER(10) primary key,
    borrowed_date date NOT NULL,
    return_day date,
    book_id NUMBER(10),
    members_id NUMBER(10),
    FOREIGN key (book_id )  references books(book_id) ,
    FOREIGN key (members_id)  references members(members_id) 
);
--------------------------------------------------------------------------------------------------------------------------------------------------
 


INSERT INTO books (book_id, book_title, author, publisher, year_publishes, available_copies)
VALUES (1, 'The Alchemist', 'Paulo Coelho', 'HarperCollins', TO_DATE('1993-05-01', 'YYYY-MM-DD'), 5);

INSERT INTO books (book_id, book_title, author, publisher, year_publishes, available_copies)
VALUES (2, '1984', 'George Orwell', 'Secker and Warburg', TO_DATE('1949-06-08', 'YYYY-MM-DD'), 3);

INSERT INTO books (book_id, book_title, author, publisher, year_publishes, available_copies)
VALUES (3, 'Pride and Prejudice', 'Jane Austen', 'Penguin Books', TO_DATE('1813-01-28', 'YYYY-MM-DD'), 4);

INSERT INTO books (book_id, book_title, author, publisher, year_publishes, available_copies)
VALUES (4, 'To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott', TO_DATE('1960-07-11', 'YYYY-MM-DD'), 2);

INSERT INTO books (book_id, book_title, author, publisher, year_publishes, available_copies)
VALUES (5, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Scribner', TO_DATE('1925-04-10', 'YYYY-MM-DD'), 6);




INSERT INTO members (members_id, member_name, email)
VALUES (1, 'Alice Johnson', 'alice@example.com');

INSERT INTO members (members_id, member_name, email)
VALUES (2, 'Bob Smith', 'bob.smith@example.com');

INSERT INTO members (members_id, member_name, email)
VALUES (3, 'Carol Davis', 'carol.davis@example.com');

INSERT INTO members (members_id, member_name, email)
VALUES (4, 'David Wilson', 'david.w@example.com');

INSERT INTO members (members_id, member_name, email)
VALUES (5, 'Eva Martinez', 'eva.m@example.com');




INSERT INTO borrowings (borrow_id, book_id, members_id, borrowed_date, return_day)
VALUES (1, 1, 1, TO_DATE('2025-10-20', 'YYYY-MM-DD'), TO_DATE('2025-11-03', 'YYYY-MM-DD'));

INSERT INTO borrowings (borrow_id, book_id, members_id, borrowed_date, return_day)
VALUES (2, 2, 2, TO_DATE('2025-10-21', 'YYYY-MM-DD'), TO_DATE('2025-11-04', 'YYYY-MM-DD'));

INSERT INTO borrowings (borrow_id, book_id, members_id, borrowed_date, return_day)
VALUES (3, 3, 3, TO_DATE('2025-10-22', 'YYYY-MM-DD'), TO_DATE('2025-11-05', 'YYYY-MM-DD'));

INSERT INTO borrowings (borrow_id, book_id, members_id, borrowed_date, return_day)
VALUES (4, 1, 4, TO_DATE('2025-10-23', 'YYYY-MM-DD'), NULL);

INSERT INTO borrowings (borrow_id, book_id, members_id, borrowed_date, return_day)
VALUES (5, 5, 5, TO_DATE('2025-10-24', 'YYYY-MM-DD'), NULL);

-- check if everything is created

SELECT * from BOOKS ;
SELECT * FROM MEMBERS;
SELECT * from BORROWINGS;



--------------------------------------------------------------------------------------------------------------------------------------------------
--- add book

CREATE OR REPLACE FUNCTION add_book(
    p_book_id          IN book.book_id%TYPE, 
    p_title            IN book.book_title%TYPE,
    p_author           IN book.author%TYPE,
    p_publisher        IN book.publisher%TYPE,
    p_year_published   IN book.year_publishes%TYPE,
    p_available_copies IN book.available_copies%TYPE
)
RETURN VARCHAR2
IS
    v_message VARCHAR2(100);
BEGIN
    -- Check if the book already exists
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM books
        WHERE book_id = p_book_id;

        IF v_count > 0 THEN
            v_message := 'Book with ID ' || p_book_id || ' already exists.';
            RETURN v_message;
        END IF;
    END;

    -- Insert new book
    INSERT INTO books (book_id, book_title, author, publisher, year_publishes, available_copies)
    VALUES (p_book_id, p_title, p_author, p_publisher, p_year_published, p_available_copies);

    v_message := 'Book "' || p_title || '" added successfully.';
    RETURN v_message;

EXCEPTION
    WHEN OTHERS THEN
        v_message := 'Error: ' || SQLERRM;
        RETURN v_message;
END;
/



--------------------------------------------------------------------------------------------------------------------------------------------------
--update book
    
CREATE OR REPLACE FUNCTION update_book(
    p_book_id          IN book.book_id%TYPE, 
    p_title            IN book.book_title%TYPE,
    p_author           IN book.author%TYPE,
    p_publisher        IN book.publisher%TYPE,
    p_year_published   IN book.year_publishes%TYPE,
    p_available_copies IN book.available_copies%TYPE
)
RETURN VARCHAR2
IS
    v_message VARCHAR2(100);
BEGIN
    -- Check if the book exists
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM books
        WHERE book_id = p_book_id;

        IF v_count = 0 THEN
            v_message := 'Book with ID ' || p_book_id || ' does not exist.';
            RETURN v_message;
        END IF;
    END;

    -- Update the existing book
    UPDATE books
    SET 
        book_title       = p_title,
        author           = p_author,
        publisher        = p_publisher,
        year_publishes   = p_year_published,
        available_copies = p_available_copies
    WHERE book_id = p_book_id;

    v_message := 'Book with ID ' || p_book_id || ' updated successfully.';
    RETURN v_message;

EXCEPTION
    WHEN OTHERS THEN
        v_message := 'Error: ' || SQLERRM;
        RETURN v_message;
END;
/

--------------------------------------------------------------------------------------------------------------------------------------------------
--delete book 


CREATE OR REPLACE FUNCTION delete_book(
    p_book_id IN book.book_id%TYPE
)
RETURN VARCHAR2
IS
    v_message VARCHAR2(100);
    v_count   NUMBER;
BEGIN
    -- Check if the book exists
    SELECT COUNT(*) INTO v_count
    FROM books
    WHERE book_id = p_book_id;

    IF v_count = 0 THEN
        v_message := 'Book with ID ' || p_book_id || ' does not exist.';
        RETURN v_message;
    END IF;

    -- Delete the book if it exists
    DELETE FROM books
    WHERE book_id = p_book_id;

    v_message := 'Book with ID ' || p_book_id || ' deleted successfully.';
    RETURN v_message;

EXCEPTION
    WHEN OTHERS THEN
        v_message := 'Error deleting book: ' || SQLERRM;
        RETURN v_message;
END;
/


--------------------------------------------------------------------------------------------------------------------------------------------------
-- search book 
CREATE OR REPLACE PROCEDURE search_book(
    p_keyword IN VARCHAR2
)
IS
    v_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Search Results for "' || p_keyword || '" ---');
    DBMS_OUTPUT.PUT_LINE('ID | Title | Author | Publisher | Year | Copies');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');

    FOR rec IN (
        SELECT book_id, book_title, author, publisher, 
               TO_CHAR(year_publishes, 'YYYY') AS pub_year,
               available_copies
        FROM books
        WHERE LOWER(book_title) LIKE '%' || LOWER(p_keyword) || '%'
           OR LOWER(author) LIKE '%' || LOWER(p_keyword) || '%'
           OR LOWER(publisher) LIKE '%' || LOWER(p_keyword) || '%'
        ORDER BY book_id
    )
    LOOP
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE(
            rec.book_id || ' | ' ||
            rec.book_title || ' | ' ||
            rec.author || ' | ' ||
            rec.publisher || ' | ' ||
            rec.pub_year || ' | ' ||
            rec.available_copies
        );
    END LOOP;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No books found matching "' || p_keyword || '".');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error searching books: ' || SQLERRM);
END;
/


--------------------------------------------------------------------------------------------------------------------------------------------------
-- add member

CREATE OR REPLACE FUNCTION add_member(
    p_member_id   IN members.member_id%TYPE,
    p_member_name IN members.member_name%TYPE,
    p_email       IN members.email%TYPE
)
RETURN VARCHAR2
IS
    v_message VARCHAR2(100);
    v_count   NUMBER;
BEGIN
    -- Check if member already exists
    SELECT COUNT(*) INTO v_count
    FROM members
    WHERE members_id = p_member_id;

    IF v_count > 0 THEN
        v_message := 'Member with ID ' || p_member_id || ' already exists.';
        RETURN v_message;
    END IF;

    -- Insert new member
    INSERT INTO members (members_id, member_name, email)
    VALUES (p_member_id, p_member_name, p_email);

    v_message := 'Member "' || p_member_name || '" added successfully.';
    RETURN v_message;

EXCEPTION
    WHEN OTHERS THEN
        v_message := 'Error adding member: ' || SQLERRM;
        RETURN v_message;
END;
/



--------------------------------------------------------------------------------------------------------------------------------------------------
-- update member

CREATE OR REPLACE FUNCTION update_member(
   p_member_id   IN members.member_id%TYPE,
    p_member_name IN members.member_name%TYPE,
    p_email       IN members.email%TYPE
)
RETURN VARCHAR2
IS
    v_message VARCHAR2(100);
    v_count   NUMBER;
BEGIN
    -- Check if member exists
    SELECT COUNT(*) INTO v_count
    FROM members
    WHERE members_id = p_member_id;

    IF v_count = 0 THEN
        v_message := 'Member with ID ' || p_member_id || ' does not exist.';
        RETURN v_message;
    END IF;

    -- Update member info
    UPDATE members
    SET member_name = p_member_name,
        email       = p_email
    WHERE members_id = p_member_id;

    v_message := 'Member with ID ' || p_member_id || ' updated successfully.';
    RETURN v_message;

EXCEPTION
    WHEN OTHERS THEN
        v_message := 'Error updating member: ' || SQLERRM;
        RETURN v_message;
END;
/



--------------------------------------------------------------------------------------------------------------------------------------------------
-- delete member

CREATE OR REPLACE FUNCTION delete_member(
    p_member_id IN memebrs.member.id%TYPE
)
RETURN VARCHAR2
IS
    v_message VARCHAR2(100);
    v_count   NUMBER;
BEGIN
    -- Check if member exists
    SELECT COUNT(*) INTO v_count
    FROM members
    WHERE members_id = p_member_id;

    IF v_count = 0 THEN
        v_message := 'Member with ID ' || p_member_id || ' does not exist.';
        RETURN v_message;
    END IF;

    -- Delete member
    DELETE FROM members
    WHERE members_id = p_member_id;

    v_message := 'Member with ID ' || p_member_id || ' deleted successfully.';
    RETURN v_message;

EXCEPTION
    WHEN OTHERS THEN
        v_message := 'Error deleting member: ' || SQLERRM;
        RETURN v_message;
END;
/



--------------------------------------------------------------------------------------------------------------------------------------------------
--borrow book 


CREATE OR REPLACE FUNCTION borrow_book(
    p_borrow_id IN borrowings.borrow_id%TYPE,
    p_book_id IN borrowings.book_id%TYPE,
    p_members_id IN borrowings.members_id%TYPE,
    p_borrowed_date IN borrowings.borrowed_date%TYPE
)
RETURN varchar2
AS
    v_message VARCHAR2(100);
    v_count   NUMBER;
    v_copies NUMBER;
BEGIN
    -- check if book exists
    SELECT COUNT(*) INTO v_count
    FROM books
    WHERE book_id = p_book_id;

    IF v_count = 0 THEN
        v_message := 'Book with ID ' || p_book_id || ' does not exist.';
        RETURN v_message;
    END IF;

    -- check available copies 

    SELECT available_copies INTO v_copies
    FROM books
    WHERE book_id = p_book_id;

    IF v_copies = 0 THEN
        v_message := 'No copies available for this book.';
        RETURN v_message;
    END IF;

    -- check if memebr exists

    SELECT COUNT(*) INTO v_count
    FROM members
    WHERE members_id = p_members_id;

    IF v_count = 0 THEN
        v_message := 'Member with ID ' || p_members_id || ' does not exist.';
        RETURN v_message;
    END IF;


    -- borrow a book 
    INSERT INTO borrowings (borrow_id, book_id, members_id, borrowed_date)
    VALUES (borrow_seq.NEXTVAL, p_book_id, p_members_id, SYSDATE);

    UPDATE books
    SET available_copies = available_copies - 1
    WHERE book_id = p_book_id;

    v_message := 'Book borrowed successfully.';
    RETURN v_message;

EXCEPTION
    WHEN OTHERS THEN
        v_message := 'Error borrowing book: ' || SQLERRM;
        RETURN v_message;

END;
/




















commit;

